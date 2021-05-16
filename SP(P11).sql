-- SE CREA UN SP DE DOS NIVELES
-- PRIMERO SE REGISTRARÁ LA ACCION(LIKES O DESCARTES) Y EL PROCESO DE MATCH
-- LUEGO SE HABILITARÁ O CERRARÁ EL CHAT Y SE ENVIARÁ UN MENSAJE AL CHAT CREADO
-- FINALMENTE, SE GUARDARÁN LOS PROCESOS REALIZADOS BITÁCORA(CREACIÓN DEL CHAT Y ENVIO DEL PRIMER MENSAJE)

USE mydb;

-- PRIMER SP --> SE REALIZA LA ACCION Y SE REGISTRA

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
		DECLARE otroUsuarioId INT DEFAULT NULL;
        DECLARE ID_USUARIO INT DEFAULT NULL;
        DECLARE typeAccionId TINYINT DEFAULT NULL;
        DECLARE chequeo VARBINARY(480) DEFAULT NULL;
        DECLARE hayMatch INT DEFAULT NULL;  -- PARA SABER SI HAY MATCH ENTRE LOS USUARIOS
        DECLARE hayChat INT DEFAULT NULL;  
        DECLARE nomUser1 varchar(100);
        DECLARE ApUser1 varchar(100);
        DECLARE nomUser2 varchar(100);
        DECLARE ApUser2 varchar(100);
        DECLARE TAccion varchar(50);
        DECLARE plan_actual INT;
        
      
        DECLARE cuenta_v INT;
        
        DECLARE beneficio_aux INT;
        DECLARE bandera_error TINYINT;
        
       -- para manejar los errores 
        
		DECLARE INVALID_DATA INT DEFAULT(54000);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			IF (ISNULL(@message)) THEN -- para las excepciones forzadas
				SET @message = 'Error al realizar la accion';  
            ELSE
				SET @message = CONCAT('Internal error: ',@message);
			END IF;
            
            IF bandera_error=1 THEN
				SET @message = 'Ya se ha alcanzado el límite diario de esta acción';
			END IF;
			IF bandera_error=2 THEN
				SET @message = 'Los datos ingresados son incorrectos';
                
            END IF;
			
			ROLLBACK;  -- si se produjo un error se deben retroceder los datos que se guardaron en la transacción
			
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;

		SET autocommit = 0;
       
        SET nomUser1=Nusuariobase;
        SET ApUser1=Ausuariobase;
        SET nomUser2=NOtroUsuario;
        SET ApUser2=AOtroUsuario;
        SET TAccion=tipoAccion;
        
        -- se averigua el ID del usuario que realiza el like(u otra accion)
        SELECT userid INTO ID_USUARIO FROM UsersAccounts
        WHERE nombre=Nusuariobase and apellido1= Ausuariobase ;
       
       -- se averigua el ID del usuario al que se le da el like(u otra accion)
        SELECT userid INTO otroUsuarioId FROM UsersAccounts
        WHERE nombre=NOtroUsuario and apellido1= AOtroUsuario ;
       
       -- se averigua el ID del tipo de accion a realizar
       SELECT tipoaccionid INTO typeAccionId FROM Tipoacciones
       WHERE name_tipoaccion=tipoAccion;
	   
       IF (ISNULL(ID_USUARIO) OR ISNULL(otroUsuarioId) OR ISNULL(typeAccionId) ) THEN
            SET bandera_error = 2;
            SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
        END IF;
        
       SET chequeo=SHA2(CONCAT(Nusuariobase, CURDATE(), NOtroUsuario, typeAccionId), 256);
		
	   SET plan_actual = (SELECT Planes.planid FROM Planes INNER JOIN PlansxUser ON Planes.planid=PlansxUser.planid WHERE (PlansxUser.userid=ID_USUARIO AND PlansxUser.actual=1));
       
       
        SET cuenta_v = (SELECT COUNT(userid) FROM Acciones WHERE Acciones.userid=ID_USUARIO AND Acciones.tipoaccionid=typeAccionId AND (posttime BETWEEN (SELECT (CURDATE() - INTERVAL 1 DAY)) AND CURDATE()));
        
        IF cuenta_v > (SELECT cantidad FROM Limites INNER JOIN BeneficiosXPlanes ON Limites.limiteid=BeneficiosXPlanes.limiteid WHERE planid=plan_actual AND beneficioid=typeAccionId) THEN
            SET bandera_error = 1;
            SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
        END IF;
        
        
        
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

			-- PROCESO DE MATCH Y CHAT
			SET hayMatch=(SELECT accionid FROM Acciones WHERE userid=otroUsuarioId and otrousuario=ID_USUARIO);
			SET hayChat=(SELECT chatid FROM Chats WHERE userid=otroUsuarioId and otrousuario_chat=ID_USUARIO);
			
			IF (ISNULL(hayMatch)=FALSE) THEN  -- INDICA QUE HAY MATCH ENTRE LOS DOS USUARIOS, ENTONCES SE REALIZA LA ACCION
				  
				  CALL AccionChat(nomUser1, ApUser1,nomUser2, ApUser2,
				  hayChat, TAccion);
				  
			END  IF;
		COMMIT;

	END //

DELIMITER ;


-- SEGUNDO SP --> SE ANALIZA SI EL CHAT SE ABRE(ENVIA MENSAJE) O SE CIERRA
DROP PROCEDURE IF EXISTS AccionChat

DELIMITER //

CREATE PROCEDURE AccionChat(
	
    Nusuariobase varchar(100),  -- nombre del usuario 1
    Ausuariobase  varchar(100),  -- apellido1 del usuario 1
    
    NOtroUsuario varchar(100),   -- nombre del usuario 2
    AOtroUsuario varchar(100),    -- apellido del usuario 2
    hayChat INT,
    tipoAccion varchar(50)
)
	BEGIN
		DECLARE otroUsuarioId INT;
        DECLARE ID_USUARIO INT;
        DECLARE typeAccionId TINYINT;
        DECLARE chequeo VARBINARY(480);
        DECLARE chatid1 INT;
        DECLARE chatid2 INT;
        DECLARE nomUser1 varchar(100);
        DECLARE ApUser1 varchar(100);
        DECLARE nomUser2 varchar(100);
        DECLARE ApUser2 varchar(100);
        DECLARE TAccion varchar(50);
        
       -- para manejar los errores 
        
		DECLARE INVALID_DATA INT DEFAULT(54000);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			IF (ISNULL(@message)) THEN -- para las excepciones forzadas
				SET @message = 'Error al realizar la accion';            
			ELSE
				SET @message = CONCAT('Internal error: ',@message);
			END IF;
			
			ROLLBACK;  -- si se produjo un error se deben retroceder los datos que se guardaron en la transacción
			
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;

		SET autocommit = 0;
       
        SET nomUser1=Nusuariobase;
        SET ApUser1=Ausuariobase;
        SET nomUser2=NOtroUsuario;
        SET ApUser2=AOtroUsuario;
        SET TAccion=tipoAccion;
       
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
            
			-- SE PREGUNTA POR EL TIPO DE ACCION A REALIZAR
				IF (tipoAccion='Like' OR tipoAccion='Super Like') THEN   -- SI ES UNA DE ESAS DOS ACCIONES, SE DEBE REVISAR SI HAY MATCH
					
                    IF (ISNULL(hayChat)=FALSE) THEN
							UPDATE Chats SET `enable`=1 
							WHERE otrousuario_chat=otroUsuarioId AND userid=ID_USUARIO;
							
							UPDATE Chats SET `enable`=1 
							WHERE otrousuario_chat=ID_USUARIO AND userid=otroUsuarioId;
                            
                            SET chatid1= (SELECT chatid FROM Chats WHERE otrousuario_chat=otroUsuarioId AND userid=ID_USUARIO);
							SET chatid2= (SELECT chatid FROM Chats WHERE otrousuario_chat=ID_USUARIO AND userid=otroUsuarioId);
		
						
					ELSE
							INSERT INTO Chats(otrousuario_chat,`enable`,userid)
							VALUES
							(otroUsuarioId,1,ID_USUARIO),
							(ID_USUARIO,1,otroUsuarioId);
                            
                            SET chatid1= (SELECT chatid FROM Chats WHERE otrousuario_chat=otroUsuarioId AND userid=ID_USUARIO);
							SET chatid2= (SELECT chatid FROM Chats WHERE otrousuario_chat=ID_USUARIO AND userid=otroUsuarioId);
		
                            
					END IF;
                    
				END  IF;
				
				IF (tipoAccion='Quitar Like' ) THEN    -- modifica el chat y lo desactiva para ambos usuarios
						UPDATE Chats SET `enable`=0 
						WHERE otrousuario_chat=otroUsuarioId AND userid=ID_USUARIO;
						
						UPDATE Chats SET `enable`=0 
						WHERE otrousuario_chat=ID_USUARIO AND userid=otroUsuarioId;
						SET chatid1= (SELECT chatid FROM Chats WHERE otrousuario_chat=otroUsuarioId AND userid=ID_USUARIO);
						SET chatid2= (SELECT chatid FROM Chats WHERE otrousuario_chat=ID_USUARIO AND userid=otroUsuarioId);
			
			   END IF;
               
			
              CALL REGISTRO(nomUser1, ApUser1,nomUser2, ApUser2,TAccion);
               
		COMMIT;
        
        
        INSERT INTO Mensajes(caption,posttime,chatid)
		VALUES
		(CONCAT('Chat habilitado con',Nusuariobase),CURDATE(),chatid1),
		(CONCAT('Chat habilitado con',NOtroUsuario),CURDATE(),chatid2);
        
        
	END //

DELIMITER ;


-- TERCER SP --> SE REGISTRA LA CREACION DEL CHAT Y EL ENVIO DEL PRIMER MENSAJE EN BITACORA/ CREA UNA FOTO PARA EL CHAT

DROP PROCEDURE IF EXISTS REGISTRO

DELIMITER //

CREATE PROCEDURE REGISTRO(
	
     Nusuariobase varchar(100),  -- nombre del usuario que da el like
     Ausuariobase  varchar(100),  -- apellido1 del usuario que da el like
    
     NOtroUsuario varchar(100),   -- nombre del usuario al que se le da like
     AOtroUsuario varchar(100),    -- apellido del usuario al que se le da like

     tipoAccion varchar(50)
)
	BEGIN
    
		DECLARE otroUsuarioId INT DEFAULT NULL;
        DECLARE ID_USUARIO INT DEFAULT NULL;
        DECLARE typeAccionId TINYINT DEFAULT NULL;
        DECLARE chequeo VARBINARY(480) DEFAULT NULL;
        DECLARE chat1 INT;
        DECLARE chat2 INT;
        DECLARE lat FLOAT;
        DECLARE lon FLOAT;
        
       -- para manejar los errores 
        
		DECLARE INVALID_DATA INT DEFAULT(54000);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
        
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			IF (ISNULL(@message)) THEN -- para las excepciones forzadas
				SET @message = 'Error al realizar la accion';            
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
	    
        SELECT chatid INTO chat1 FROM Chats
		WHERE otrousuario_chat=otroUsuarioId AND userid=ID_USUARIO;
		
        SELECT chatid INTO chat2 FROM Chats
		WHERE otrousuario_chat=ID_USUARIO AND userid=otroUsuarioId;
		
        SET lat = (RAND()*90);
		SET lon = (RAND()*180);
        
        
        
        START TRANSACTION;
			   
               -- Se agrega una foto para el chat de ambos usuarios
               INSERT INTO Fotos(URL,latitud_foto,longitud_foto,deleted,Fecha,userid)
               VALUES(CONCAT('www.fotochat',Nusuariobase),lat,lon,0,CURDATE(),ID_USUARIO); 
                
                -- Registro la creacion del chat y la notificacion del primer mensaje 
                INSERT INTO Bitacoras(fecha,Descripcion,devicename,username,IP,refId1,refId2,oldValue,newValue,
                cheksum,SeveridadId,EntityTypesId,TiposBitacoraId,AplicacionFuenteId)
                VALUES
                (CURDATE(),'Accion en un chat','SAMSUNG',Nusuariobase,'172.16.0.0',chat1,otroUsuarioId,
                0,0,chequeo,4,1,5,4), -- se inserta la creacion de un chat
                (CURDATE(),'Accion en un chat','SAMSUNG',NOtroUsuario,'172.16.0.1',chat2,ID_USUARIO,
                0,0,chequeo,4,1,5,4); -- se inserta la creacion de un chat
                
                INSERT INTO Bitacoras(fecha,Descripcion,devicename,username,IP,refId1,refId2,oldValue,newValue,
                cheksum,SeveridadId,EntityTypesId,TiposBitacoraId,AplicacionFuenteId)
                VALUES
                (CURDATE(),'Se agrega mensaje','SAMSUNG',Nusuariobase,'172.16.0.0',chat1,otroUsuarioId,
                0,0,chequeo,3,1,6,5),  -- se inserta el envio de un mensaje
                (CURDATE(),'Se agrega mensaje','SAMSUNG',NOtroUsuario,'172.16.0.1',chat2,ID_USUARIO,
                0,0,chequeo,3,1,6,5);  -- se inserta el envio de un mensaje
                
   
		COMMIT;
 
	END //

DELIMITER ;


CALL likes('Manuel','Casasola','Mónica','Guillamon','Like');
CALL likes('Mónica','Guillamon','Manuel','Casasola','Like');
CALL likes('Juan','Pérez','Mónica','Guillamon','Quitar Like');

CALL likes('Cristian','Núñez','Mónica','Guillamon','Like');
CALL likes('Mónica','Guillamon','Cristian','Núñez','Like');
CALL likes('Cristian','Núñez','Mónica','Guillamon','Quitar Like');


CALL likes('Emilia','Chinchilla','Mónica','Guillamon','Like');
CALL likes('Mónica','Guillamon','Emilia','Chinchilla','Like');

CALL likes('Miguel','Gómez','Victoria','Venegas','Like');
CALL likes('Victoria','Venegas','Miguel','Gómez','Like');

-- Pruebas
SELECT * FROM Acciones;
SELECT * FROM Transactions;
SELECT * FROM Chats;
SELECT * FROM Mensajes;
SELECT * FROM Bitacoras;
SELECT * FROM Fotos;

SELECT * FROM UsersAccounts;


CALL likes('Juan','Casasola','Mónica','Guillamon','Super Like');
CALL likes('Victoria','Venegas','Manuel','Casasola','jksdgbivSuper Like');






