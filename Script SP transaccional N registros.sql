use mydb;

DROP PROCEDURE IF EXISTS InsertarFotosUsuarios;  -- PUNTO 13 DEL MANUAL SP que inserta N registros
delimiter //

CREATE PROCEDURE InsertarFotosUsuarios(
	cantidad_fotos TINYINT,
    username_entrante VARCHAR(50)
)
BEGIN

	DECLARE contador INT;
    DECLARE contador2 INT;
    DECLARE maxid INT;
    DECLARE contador_str VARCHAR(11);
    DECLARE username_aux VARCHAR(50);
    DECLARE userid_aux INT;
    DECLARE validacion TINYINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			IF (ISNULL(@message)) THEN -- para las excepciones forzadas
				SET @message = 'Acción denegada, los datos ingresados no son válidos';            
			ELSE
				SET @message = CONCAT('Internal error: Acción denegada, los datos ingresados no son válidos');
			END IF;
			
			ROLLBACK;  -- si se produjo un error se deben retroceder los datos que se guardaron en la transacción
            
            If validacion=1 THEN
				DROP TABLE URLGenerados;
            END IF;
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;
    
    SET autocommit=0;

    SET userid_aux = (SELECT userid FROM UsersAccounts WHERE username=username_entrante);
    
    IF userid_aux=NULL THEN
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
    END IF;
    
    SET maxid=(SELECT MAX(fotoid) FROM Fotos);
    SET contador=maxid+1;
    SET contador2=1;

    SET validacion=1;
    CREATE TEMPORARY TABLE URLGenerados(
		URL_Insercion VARCHAR(128)
    );

    WHILE contador2<=cantidad_fotos DO
		SET contador_str=CONVERT(contador,CHAR(11));
		INSERT INTO URLGenerados(URL_Insercion)
        VALUES
        (CONCAT('www.Finder.com/FotosUsuarios/0', contador_str));
		SET contador2=contador2+1;
        SET contador=contador+1;
	END WHILE;
    
	START TRANSACTION; 
    BEGIN
    
		DECLARE URL_aux VARCHAR(128);
		DECLARE lat FLOAT;
		DECLARE lon FLOAT;
        DECLARE done TINYINT DEFAULT FALSE;
		DECLARE RecorrerURLSGenerados CURSOR FOR
		SELECT URL_Insercion FROM URLGenerados;
        
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        
        OPEN RecorrerURLSGenerados;
        
        ciclo: LOOP
            FETCH RecorrerURLSGenerados INTO URL_aux;
			IF done THEN
				LEAVE ciclo;
			END IF;
            
			SET lat = (RAND()*90);
			SET lon = (RAND()*180);
			
			IF RAND() < 0.5 THEN
				SET lat = (lat*-1);
			END IF;
			
			IF RAND() < 0.5 THEN
				SET lon = (lon*-1);
			END IF;

			INSERT INTO Fotos(URL, latitud_foto, longitud_foto, deleted, Fecha, userid)
			VALUES(URL_aux, lon, lat, 0, CURDATE(), userid_aux);
       END LOOP;
       CLOSE RecorrerURLSGenerados;
       DROP TABLE URLGenerados;
	END;
	COMMIT;

END //
delimiter ;

