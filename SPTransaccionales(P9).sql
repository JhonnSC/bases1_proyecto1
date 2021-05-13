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
	BEGIN
		
        DECLARE costoPlan FLOAT;  -- listo
        DECLARE chequeo VARBINARY(480);  -- listo
        DECLARE estadodepagoID INT; -- listo
        DECLARE IDMERCHANT INT; -- listo
        DECLARE tipodepagoid TINYINT;
		DECLARE IDUSUARIO INT;  -- listo
        DECLARE REFPAGOID INT; -- listo
        DECLARE tiempoPlan INT;-- listo
        DECLARE tipoPlan INT;-- listo
		-- para manejar los errores en las transacciones
        
		DECLARE INVALID_DATA INT DEFAULT(53000);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			IF (ISNULL(@message)) THEN -- para las excepciones forzadas
				SET @message = 'Acción denegada, los datos ingresados no son válidos';            
			ELSE
				SET @message = CONCAT('Internal error: Acción denegada, los datos ingresados no son válidos');
			END IF;
			
			ROLLBACK;  -- si se produjo un error se deben retroceder los datos que se guardaron en la transacción
			
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;

		SET autocommit = 0;
        
        SET chequeo=SHA2(CONCAT(amount_pago, CURDATE(), nombreUsuario,referenciadePago), 256);
		
        SET estadodepagoID=3;  -- indica que está en transacción
        
        SELECT userid INTO IDUSUARIO FROM UsersAccounts  -- para saber el id del usuario
        WHERE nombre=nombreUsuario and apellido1=apellido;
        
        SELECT planid INTO REFPAGOID FROM Planes  -- para saber el referenceid
        WHERE titulo=referenciadePago;
        
        SELECT merchantid into IDMERCHANT FROM Merchants  -- para saber el merchantid
        WHERE name_merchant=merchant;
        
        SELECT tipopagoid INTO tipodepagoid FROM TiposPago  -- para saber el tipopagoid
        WHERE name_tipopago=nombretipopago ;
        
        
        -- SE INGRESAN LOS DATOS DEL INTENTO DE PAGO
        
        INSERT INTO Pagos(posttime, amount_pago, currencysymbol, merchanttransnumber,`description`,
        referenceid, `timestamp`,username,`checksum`, estadodepagoid,merchantid,tipopagoid,userid)
        VALUES
        (CURDATE() ,amount_pago, currencysymbol , merchanttransnumber,CONCAT('Pago del plan: ', referenciadePago), 
        REFPAGOID, CURDATE() ,nombreUsuario,chequeo, estadodepagoID, IDMERCHANT, 
        tipodepagoid, IDUSUARIO);
        
        
        
        SELECT amount INTO costoPlan FROM Planes   -- se busca el costo del plan, para poder compararlo con el monto a pagar
        WHERE planid=REFPAGOID;
        
        IF (costoPlan != amount_pago) THEN
				
			-- SE GENERA UN ERROR Y SE HACE UPDATE AL ESTADO DE PAGO
            
           UPDATE Pagos SET estadodepagoid=2  -- el id 2 en la tabla de estados de pago indica que el pago se rechazó
		   WHERE  userid=IDUSUARIO and estadodepagoid=3; -- actualizará el estado del último pago realizado

			UPDATE Pagos SET errornumber=53000
            WHERE  userid=IDUSUARIO and estadodepagoid=3; -- actualizará el registro indicando que se genero el error 53000
            
			SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;

        END IF;
        
        -- SI NO SE GENERA ERROR, EL INTENTO DE PAGO FUE EXITOSO, SE GENERA LA TRANSACCION
        
         UPDATE Pagos SET estadodepagoid=1  -- el id 1 en la tabla de estados de pago indica que el pago se aceptó
		 WHERE  userid=IDUSUARIO and estadodepagoid=3; -- actualizará el estado del último pago realizado

         
        SET tiempoPlan = 80;  -- simula un plan infinito
        
        
        START TRANSACTION;
				
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

select * from Pagos;
