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
        DECLARE estadodepagoID_aux INT; -- listo
        DECLARE IDMERCHANT INT; -- listo
        DECLARE tipodepagoid_aux TINYINT;
		DECLARE IDUSUARIO INT;  -- listo
        DECLARE REFPAGOID INT; -- listo
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
                VALUES(CURDATE(),DATE_ADD(curdate(),INTERVAL tiempoPlan YEAR),
                1,REFPAGOID,IDUSUARIO);
                
		COMMIT;
        SET transaction_aux = transaction_aux-1;
        
        SELECT periodoplan INTO  tipoPlan  FROM Planes  -- Se debe definir el tiempo que va a tardar el plan, para utilizarlo en la tabla de planes x usuario
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

CALL obtenerPlan(1000,'colones',1234,'Plan Premium 1.0 (Mensual)','Juan','Pérez','Paypal','Débito');
CALL obtenerPlan(5000,'colones',1234,'Plan Premium 1.0 (Mensual)','Juan','Pérez','Paypal','Débito');

 select * from Pagos;




-- -----------------------------------------------------------------------------------------------------
-- SP TRANSACCIONAL DE ESCRITURA #2
DROP PROCEDURE IF EXISTS likes

DELIMITER //

CREATE PROCEDURE likes(
	
    Nusuariobase varchar(100),  -- nombre del usuario que da el like
    Ausuariobase  varchar(100),  -- apellido1 del usuario que da el like
    
    NOtroUsuario varchar(100),   -- nombre del usuario al que se le da like
    AOtroUsuario varchar(100),    -- apellido del usuario al que se le da like

    tipoAccion varchar(50)
)
	BEGIN
		DECLARE otroUsuarioId INT;
        DECLARE ID_USUARIO INT;
        DECLARE typeAccionId TINYINT;
        DECLARE chequeo VARBINARY(480);
        DECLARE hayMatch INT DEFAULT NULL;  -- PARA SABER SI HAY MATCH ENTRE LOS USUARIOS
        
       -- para manejar los errores 
        
		DECLARE INVALID_DATA INT DEFAULT(54000);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			IF (ISNULL(@message)) THEN -- para las excepciones forzadas
				SET @message = 'Se ha producido un error al realizar la accion';            
			ELSE
				SET @message = CONCAT('Internal error: ',@message);
			END IF;
			
			ROLLBACK;  -- si se produjo un error se deben retroceder los datos que se guardaron en la transacción
			
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;

		SET autocommit = 0;
       
        -- se averigua el ID del usuario que realiza el like(u otra accion)
        SELECT userid INTO ID_USUARIO FROM UsersAccounts
        WHERE nombre=Nusuariobase and apellido1= Ausuariobase ;
       
       -- se averigua el ID del usuario al que se le da el like(u otra accion)
        SELECT userid INTO otroUsuarioId FROM UsersAccounts
        WHERE nombre=NOtroUsuario and apellido1= AOtroUsuario ;
       
       -- se averigua el ID del tipo de accion a realizar
       SELECT tipoaccionid INTO typeAccionId FROM Tipoacciones
       WHERE name_tipoaccion=tipoAccion;
	
       SET chequeo=SHA2(CONCAT(Nusuariobase, CURDATE(), NOtroUsuario, typeAccionId), 256);
		
        
        START TRANSACTION;
			
            -- se inserta la accion
            INSERT INTO Acciones(otrousuario,posttime,IP,`checksum`,tipoaccionid,userid)
            VALUES(otroUsuarioId,curdate(),'172.16.0.0',chequeo,typeAccionId,ID_USUARIO);
			
            -- Se registra en la tabla transactions
            INSERT INTO Transactions(posttime,amount,`description`,merchanttransacction,
			computername,username,`checksum`,IP,refId1,contextid,transtypesid,userid)
            VALUES(curdate() ,1,CONCAT('TRANSACCION DEL LA ACCION: ',tipoAccion ),
            0, 'LENOVO' ,Nusuariobase,chequeo, '172.16.0.0',otroUsuarioId , 
			2,2, ID_USUARIO);  -- los 2 en contextid y transtypesid indican ACCIONES

		COMMIT;
        
        -- PROCESO DE MATCH Y CHAT
        SET hayMatch=(SELECT accionid FROM Acciones WHERE userid=otroUsuarioId and otrousuario=ID_USUARIO);
        
        -- SE PREGUNTA POR EL TIPO DE ACCION A REALIZAR
        IF (tipoAccion='Like' OR tipoAccion='Super Like') THEN   -- SI ES UNA DE ESAS DOS ACCIONES, SE DEBE REVISAR SI HAY MATCH
			IF (ISNULL(hayMatch)=FALSE) THEN  -- INDICA QUE HAY MATCH ENTRE LOS DOS USUARIOS, ENTONCES SE CREA EL CHAT
			
				INSERT INTO Chats(otrousuario_chat,`enable`,userid)
				VALUES
                (otroUsuarioId,1,ID_USUARIO),
                (ID_USUARIO,1,otroUsuarioId);
	    
			END IF;
		END  IF;
        
        IF (tipoAccion='Quitar Like' ) THEN    -- modifica el chat y lo desactiva para ambos usuarios
			IF (ISNULL(hayMatch)=FALSE) THEN  -- INDICA QUE HAY MATCH ENTRE LOS DOS USUARIOS, ENTONCES SE CREA EL CHAT
			
				UPDATE Chats SET `enable`=0 
                WHERE otrousuario_chat=otroUsuarioId AND userid=ID_USUARIO;
				
                UPDATE Chats SET `enable`=0 
                WHERE otrousuario_chat=ID_USUARIO AND userid=otroUsuarioId;
	        END IF;
			
        END IF;
	END //

DELIMITER ;




CALL likes('Juan','Pérez','Mónica','Guillamon','Like');
CALL likes('Mónica','Guillamon','Juan','Pérez','Like');

CALL likes('Juan','Pérez','Mónica','Guillamon','Quitar Like');

CALL likes('Cristian','Núñez','Mónica','Guillamon','Like');
CALL likes('Mónica','Guillamon','Cristian','Núñez','Like');
-- Pruebas
SELECT * FROM Acciones;
SELECT * FROM Transactions;
SELECT * FROM Chats;

