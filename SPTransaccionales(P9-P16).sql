USE mydb;

DROP PROCEDURE IF EXISTS obtenerPlan

DELIMITER //

CREATE PROCEDURE obtenerPlan(
	
    amount_pago FLOAT, 
    currencysymbol VARCHAR(50), 
    merchanttransnumber INT,
    referenciadePago VARCHAR(100),
    nombreUsuario VARCHAR(100),
    apellido varchar(100),
    merchant VARCHAR(100),
    nombretipopago VARCHAR(100)
    
)
	empezar:BEGIN
        
        DECLARE costoPlan FLOAT;  -- listo
        DECLARE chequeo VARBINARY(480);  -- listo
        DECLARE estadodepagoID_aux INT DEFAULT NULL; -- listo
        DECLARE IDMERCHANT INT DEFAULT NULL; -- listo
        DECLARE tipodepagoid_aux TINYINT DEFAULT NULL;
		DECLARE IDUSUARIO INT DEFAULT NULL;  -- listo
        DECLARE REFPAGOID INT DEFAULT NULL; -- listo
        DECLARE tiempoPlan INT;-- listo
        DECLARE tipoPlan INT;-- listo
        DECLARE transaction_aux TINYINT;
		-- para manejar los errores en las transacciones
        
		DECLARE INVALID_DATA INT DEFAULT(53000);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		error_aux:BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			IF (ISNULL(@message)) THEN -- para las excepciones forzadas
				SET @message = 'Acción denegada, los datos ingresados no son válidos';            
			ELSE
				SET @message = CONCAT('Internal error: Acción denegada, los datos ingresados no son válidos');
			END IF;
            
            IF transaction_aux > 0 THEN
				ROLLBACK; -- si se produjo un error se deben retroceder los datos que se guardaron en la transacción
			END IF;
			
			-- ROLLBACK;  -- si se produjo un error se deben retroceder los datos que se guardaron en la transacción
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;
        
		SET autocommit = 0;
        
        SET chequeo=SHA2(CONCAT(amount_pago, CURDATE(), nombreUsuario,referenciadePago), 256);

        SET estadodepagoID_aux=3;  -- indica que está en transacción

        SET IDUSUARIO = (SELECT userid FROM UsersAccounts  -- para saber el id del usuario
        WHERE nombre=nombreUsuario and apellido1=apellido);

        SET REFPAGOID = (SELECT planid FROM Planes  -- para saber el referenceid
        WHERE titulo=referenciadePago);

        SET IDMERCHANT = (SELECT merchantid FROM Merchants  -- para saber el merchantid
        WHERE name_merchant=merchant);

        SET tipodepagoid_aux = (SELECT tipopagoid FROM TiposPago  -- para saber el tipopagoid
        WHERE name_tipopago=nombretipopago);
		
        IF (ISNULL(IDUSUARIO) OR ISNULL(REFPAGOID) OR ISNULL(IDMERCHANT) OR ISNULL(tipodepagoid_aux) ) THEN
            SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
        END IF;
        -- SE INGRESAN LOS DATOS DEL INTENTO DE PAGO
        
        
        INSERT INTO Pagos(posttime, amount_pago, currencysymbol, merchanttransnumber,`description`,
        referenceid, `timestamp`,username,`checksum`, estadodepagoid,merchantid,tipopagoid,userid)
        VALUES
        (CURDATE() ,amount_pago, currencysymbol , merchanttransnumber,CONCAT('Pago del plan: ', referenciadePago), 
        REFPAGOID, CURDATE() ,nombreUsuario,chequeo, estadodepagoID_aux, IDMERCHANT, 
        tipodepagoid_aux, IDUSUARIO);
        
        
        SELECT amount INTO costoPlan FROM Planes   -- se busca el costo del plan, para poder compararlo con el monto a pagar
        WHERE planid=REFPAGOID;
        
        IF (costoPlan != amount_pago) THEN
				
			-- SE GENERA UN ERROR Y SE HACE UPDATE AL ESTADO DE PAGO
	
           UPDATE Pagos SET estadodepagoid=2  -- el id 2 en la tabla de estados de pago indica que el pago se rechazó
		   WHERE  userid=IDUSUARIO and estadodepagoid=3; -- actualizará el estado del último pago realizado

		   UPDATE Pagos SET errornumber=53000
		   WHERE  userid=IDUSUARIO and estadodepagoid=2; -- actualizará el registro indicando que se genero el error 53000
            
			SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;

            LEAVE empezar;
        END IF;
        
        -- SI NO SE GENERA ERROR, EL INTENTO DE PAGO FUE EXITOSO, SE GENERA LA TRANSACCION
        
         UPDATE Pagos SET estadodepagoid=1  -- el id 1 en la tabla de estados de pago indica que el pago se aceptó
		 WHERE  userid=IDUSUARIO and estadodepagoid=3; -- actualizará el estado del último pago realizado

         
        SET tiempoPlan = 80;  -- simula un plan infinito
        
        
        START TRANSACTION;
				SET transaction_aux = transaction_aux+1;
                -- SE INSERTAN LOS DATOS A LA TABLA DE TRANSACCIONES
                INSERT INTO Transactions(posttime,amount,`description`,merchanttransacction,
                computername,username,`checksum`,IP,refId1,contextid,transtypesid,userid)
                VALUES(
                CURDATE() ,amount_pago,CONCAT('TRANSACCION DEL PAGO POR EL PLAN: ', referenciadePago),
                merchanttransnumber, 'LENOVO' ,nombreUsuario,chequeo, '172.16.0.0', REFPAGOID, 
				1,1, IDUSUARIO);  -- los 1 en contextid y transtypesid indican pagos
                
                
                -- ACTUALIZA LA TABLA DE PLANES POR USUARIO PARA CAMBIAR EL PLAN ACTUAL
                UPDATE PlansxUser SET actual=0  -- se quita el plan actual
				WHERE userid=IDUSUARIO and actual=1; 
                
                -- SE INSERTA UN NUEVO PLAN A LA TABLA DE PLANES POR USUARIO
                INSERT INTO PlansxUser(PostTime,NextTime,actual,planid,userid)  -- el plan se inserta como si fuera infinito
                VALUES(CURDATE(),DATE_ADD(curdate(),INTERVAL 0 DAY),
                1,REFPAGOID,IDUSUARIO);
                
		COMMIT;
        SET transaction_aux = transaction_aux-1;
        
        SELECT periodoplan INTO  tiempoPlan  FROM Planes  -- Se debe definir el tiempo que va a tardar el plan, para utilizarlo en la tabla de planes x usuario
		INNER JOIN RecurrencesTypes 
		ON Planes.recurrencetypeid = RecurrencesTypes.recurrencetypeid
        WHERE planid= REFPAGOID;
		
        SELECT recurrencetypeid INTO  tipoPlan FROM Planes
        WHERE planid= REFPAGOID;
        
        -- se pregunta que tipo de plan era, para cambiarle el nextTime
        
        IF (tipoPlan=3) THEN  -- si es 3, se sabe que es anual
			
            UPDATE PlansxUser SET NextTime=DATE_ADD(curdate(),INTERVAL tiempoPlan YEAR)  
			WHERE userid=IDUSUARIO and actual=1; 
            
        ELSE   -- será mensual
			UPDATE PlansxUser SET NextTime=DATE_ADD(curdate(),INTERVAL tiempoPlan MONTH)  
			WHERE userid=IDUSUARIO and actual=1; 
            
        END IF;
       
		
	END //

DELIMITER ;

-- Pruebas

CALL obtenerPlan(1000,'colones',1234,'Plan_Premium_1.0_(Mensual)','Juan','Pérez','Paypal','Débito');
CALL obtenerPlan(1000,'colones',1234,'Plan_Premium_1.0_(Mensual)','Juanmm','Pérez','Paypal','Débito');
CALL obtenerPlan(5000,'colones',1234,'Plan_Premium_1.0_(Mensual)','Mónica','Guillamon','Paypal','Débito');
CALL obtenerPlan(5000,'colones',1234,'Plan_Premium_2.0_(Mensual)','Mónica','Guillamon','Paypal','Débito');
CALL obtenerPlan(3000,'colones',1234,'Plan_Premium_2.0_(Mensual)','Mónica','Guillamon','Paypal','Débito');
CALL obtenerPlan(10000,'colones',1234,'Plan_Premium_1.0_(Anual)','Juan','Pérez','Paypal','Débito');

-- GENERAN ERROR POR MALA ESCRITURA DE LSO PARAMETROS
CALL obtenerPlan(10000,'colones',1234,'Plan_Premium_1.0_(Anual)','JuanA','Pérez','Paypal','Débito');
CALL obtenerPlan(10000,'colones',1234,'Plan_Premium_1.0_(Anual)2','Juan','Pérez','Paypal','Débito');
CALL obtenerPlan(10000,'colones',1234,'Plan_Premium_1.0_(Anual)','Juan','Pérez','Paypal','DébitAo');
CALL obtenerPlan(10000,'colones',1234,'Plan_Premium_1.0_(Anual)','Juan','Pérez','Paypal','Débito');
CALL obtenerPlan(10000,'colones',1234,'Plan_Premium_1.0_(Anual)','Juan','Pérez','PayYpal','Débito');

-- VERIFICACION DE ACCIONES EN LAS TABLAS
 select * from PlansxUser;
 select * from Pagos;
 select * from Transactions;


-- -----------------------------------------------------------------------------------------------------
-- SP TRANSACCIONAL DE ESCRITURA #2
-- SE CREA UN SP TRANSACCIONAL QUE PERMITE REALIZAR CAMBIOS EN EL PERFIL,
-- EL USUARIO PUEDE GENERAR UNA NUEVA CONTRASEÑA Y ACTUALIZARLA
-- ADEMÁS, PERMITE QUE EL USUARIO  GENERE UNA NUEVA UBICACION 
-- GUARDA LOS CAMBIOS EN BITACORA


DROP PROCEDURE IF EXISTS CambiosCuenta

DELIMITER //

CREATE PROCEDURE CambiosCuenta(
	
    nomUsuario VARCHAR(100),
    apellidoUsuario VARCHAR(100),
    contraseña_AUX VARCHAR(100)
    
)
	BEGIN
		
         DECLARE ID_USUARIO INT DEFAULT NULL;
         DECLARE entraURL INT;  -- para saber si el URL para cambiar la contraseña sirve o no
         DECLARE URLcreado VARCHAR(128);
         DECLARE antiguaContraseña varbinary(300);
         DECLARE correoUsuario varchar(100);
         DECLARE nuevaContraseña varbinary(300);
         DECLARE refURL int;  -- guarda el id del URL insertado
         DECLARE refCont int;  -- guarda el id de la ultima contrasena insertada
         DECLARE chequeo1 VARBINARY(480); 
         DECLARE chequeo2 VARBINARY(480); 
         DECLARE transaction_aux TINYINT;
		
       -- para manejar los errores 
        
		DECLARE INVALID_DATA INT DEFAULT(54000);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			IF (ISNULL(@message)) THEN -- para las excepciones forzadas
				SET @message = 'La acción no se ha completado exitosamente';            
			ELSE
				SET @message = CONCAT('Internal error: ',@message);
			END IF;
			
			IF transaction_aux > 0 THEN
				ROLLBACK; -- si se produjo un error se deben retroceder los datos que se guardaron en la transacción
			END IF;
            
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;

		SET autocommit = 0;
       

        SELECT userid INTO ID_USUARIO FROM UsersAccounts
        WHERE nombre=nomUsuario and apellido1= apellidoUsuario;
        
        SELECT email INTO correoUsuario FROM UsersAccounts  -- obtiene el correo del usuario
        WHERE nombre=nomUsuario and apellido1= apellidoUsuario;
        
        IF (ISNULL(ID_USUARIO) ) THEN
            
            SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
        END IF;
        
       -- se crea un URL para que el usuario pueda cambiar la contraseña
        SET URLcreado=CONCAT('www.cambioContra',nomUsuario,(RAND()*180));
        
        INSERT INTO URLContraseñas(URL,posttime,userid)
        VALUES(URLcreado, CURDATE(),ID_USUARIO);
        
        SELECT urlcontraseñaid INTO refURL FROM URLContraseñas -- obtiene el id del registro insertado
        WHERE URL=URLcreado and userid=ID_USUARIO;
        
        SET chequeo1=SHA2(CONCAT(correoUsuario, CURDATE(), nomUsuario, refURL), 256);

        -- se revisa si el usuario logró ingresar al URL
        -- (la simulacion se hará con un random, 1 indica que entró,0 indica que no)
        
        SET entraURL= round(rand());
        SELECT entraURL;
        IF (entraURL=0) THEN  -- indica que no entro, entonces no permite cambiar la contraseña(se sale)
            
            SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;

        END IF;
        
        
        -- se guarda el valor de la antigua contraseña
        SELECT contraseña INTO antiguaContraseña FROM Contrasenas  -- obtiene la actual contrasena del usuario
        WHERE userid=ID_USUARIO and actual=1; 
        
        -- se modifica la contrase;a a cambiar, usando lo que el usuario ingresa
         SET nuevaContraseña=CONCAT(correoUsuario,contraseña_AUX );
        
        -- si el URL entró, se procede a cambiar la contraseña
        
        START TRANSACTION;
				SET transaction_aux = transaction_aux+1;
                -- Quito la contraseña actual
                UPDATE Contrasenas SET actual=0  -- se quita la contrasena actual
				WHERE userid=ID_USUARIO and actual=1; 
                
                -- Agrego la nueva contraseña
				INSERT INTO Contrasenas(contraseña,datetimecontraseña,actual,userid)
                VALUES(SHA2(nuevaContraseña, 224) , CURDATE(), 1, ID_USUARIO);
            
                SELECT contraseña INTO nuevaContraseña FROM Contrasenas  -- obtiene la actual contrasena del usuario
				WHERE userid=ID_USUARIO and actual=1; 
                
                SELECT contraseñaid INTO refCont FROM Contrasenas  -- obtiene el id del cambio de contrasena
				WHERE userid=ID_USUARIO and actual=1; 
                
                SET chequeo2=SHA2(CONCAT(correoUsuario, CURDATE(), nomUsuario, refCont), 256);

                -- Registro la generacion del URL y el cambio en bitácora
                INSERT INTO Bitacoras(fecha,Descripcion,devicename,username,IP,refId1,oldValue,newValue,
                cheksum,SeveridadId,EntityTypesId,TiposBitacoraId,AplicacionFuenteId)
                VALUES
                (CURDATE(),'Se genera URL de contraseña','Galaxi',nomUsuario,'172.16.0.0',refURL,
                antiguaContraseña,nuevaContraseña,chequeo1,4,1,4,3), -- se inserta la accion realizada del URL
                (CURDATE(),'Se modifica contraseña actual','Galaxi',nomUsuario,'172.16.0.0',refCont,
                antiguaContraseña,nuevaContraseña,chequeo2,4,1,3,2), -- se inserta la accion de actualizacion en tabla contrasena
                (CURDATE(),'Se cambia contraseña','Galaxi',nomUsuario,'172.16.0.0',refCont,
                antiguaContraseña,nuevaContraseña,chequeo2,3,1,3,2);  -- se inserta la accion de cambio de contrasena
                    
		COMMIT;
        
   
	END //

DELIMITER ;

CALL CambiosCuenta('Juan','Pérez',13098);

CALL CambiosCuenta('JuanA','Pérez',13098);  -- ERROR POR DATOS INCORRECTOS

SELECT * from URLContraseñas ;

SELECT * from Contrasenas ;

SELECT * from Bitacoras ;
-- --------------------------------------------------------------------------------------
-- QUERY LISTADO DE MONTOS Y PERSONAS (P16)

-- HACER UN SELECT QUE BUSQUE LOS MONTOS QUE NO SE PUDIERON PAGAR, IMPRIMA EL NOMBRE Y EL MONTO, ADEMAS
-- DEBE IMPRIMIR LA CATEGORIA(MES Y AÑO) 

-- inserto un pago de prueba, con una fecha en otro mes
INSERT INTO Pagos(posttime, amount_pago, currencysymbol, merchanttransnumber,`description`,
referenceid, `timestamp`,username,`checksum`, estadodepagoid,merchantid,tipopagoid,userid)
VALUES
('2020-03-14 00:00:00' ,2000, 'colones' , 123,CONCAT('Pago del plan: ', 2), 
2, CURDATE() ,'Cristian','a98s7d6s8f', 2, 1, 
1, 4);

INSERT INTO Pagos(posttime, amount_pago, currencysymbol, merchanttransnumber,`description`,
referenceid, `timestamp`,username,`checksum`, estadodepagoid,merchantid,tipopagoid,userid)
VALUES
('2019-03-14 00:00:00' ,2000, 'colones' , 123,CONCAT('Pago del plan: ', 2), 
2, CURDATE() ,'Cristian','a98s7d6s8f', 2, 1, 
1, 4);

INSERT INTO Pagos(posttime, amount_pago, currencysymbol, merchanttransnumber,`description`,
referenceid, `timestamp`,username,`checksum`, estadodepagoid,merchantid,tipopagoid,userid)
VALUES
('2020-02-14 00:00:00' ,2000, 'colones' , 123,CONCAT('Pago del plan: ', 2), 
2, CURDATE() ,'Cristian','a98s7d6s8f', 2, 1, 
1, 4);
        
-- CATEGORIZA POR AÑO Y MES
SELECT amount_pago Monto,username Usuario,posttime Fecha,YEAR(posttime) Año,MONTHNAME(posttime) Mes 
FROM Pagos WHERE estadodepagoid=2
ORDER BY año,MONTH(posttime);
























