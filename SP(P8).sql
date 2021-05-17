-- SOLUCION DEL PUNTO 8

USE mydb;

-- SP1 --> se ingresa el idioma en el que se quieren ver los planes
DROP PROCEDURE IF EXISTS IdiomaPlanes
DELIMITER //

CREATE PROCEDURE IdiomaPlanes(
      idioma varchar(30))
BEGIN

	DECLARE id_Idioma_aux smallint DEFAULT NULL;
    
    DECLARE INVALID_DATA INT DEFAULT(54500);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			
            SET @message = 'ERROR, el dato ingresado no existe';            
			
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;
        
    IF (idioma='Español') THEN
		  SET id_Idioma_aux=0;
          SELECT titulo  FROM Planes;
    ELSE
		  SELECT idiomaid INTO id_Idioma_aux FROM Idiomas WHERE name_idioma=idioma;
    
    END IF;
    
    IF (id_Idioma_aux=1 OR id_Idioma_aux=0 OR id_Idioma_aux=4) THEN
			IF (id_Idioma_aux=1) THEN
				
				SELECT caption FROM PlanesInglés;
			
			END IF;
			
			IF (id_Idioma_aux=4) THEN
				select caption from PlanesFrances;
			
			END IF;
	
    ELSE    -- se genera un error
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
    END IF;
END//

DELIMITER ;

CALL IdiomaPlanes('English');
CALL IdiomaPlanes('Français');
CALL IdiomaPlanes('Español');
CALL IdiomaPlanes('Aleman');

-- SP2 --> se ingresa el idioma en el que se quieren ver los intereses de cada usuario
DROP PROCEDURE IF EXISTS IdiomaIntereses
DELIMITER //

CREATE PROCEDURE IdiomaIntereses(
			idioma varchar(30))
BEGIN

	DECLARE id_Idioma_aux smallint DEFAULT NULL;
    
    DECLARE INVALID_DATA INT DEFAULT(54500);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			
            SET @message = 'ERROR, el dato ingresado no existe';            
			
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;
        
    IF (idioma='Español') THEN
		  SET id_Idioma_aux=0;
          SELECT name_interes  FROM InteresesDeUsuario;
    ELSE
		  SELECT idiomaid INTO id_Idioma_aux FROM Idiomas WHERE name_idioma=idioma;
    
    END IF;
    
    IF (id_Idioma_aux=1 OR id_Idioma_aux=0 OR id_Idioma_aux=4) THEN
			IF (id_Idioma_aux=1) THEN
				
				SELECT caption FROM InteresesUsuariosInglés;
			
			END IF;
			
			IF (id_Idioma_aux=4) THEN
				SELECT caption FROM InteresesUsuariosFrances;
			
			END IF;
	
    ELSE    -- se genera un error
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
    END IF;

END//

DELIMITER ;

CALL IdiomaIntereses('English');
CALL IdiomaIntereses('Français');
CALL IdiomaIntereses('Español');
CALL IdiomaIntereses('Aleman');


-- SP3 --> revisa los planes actuales o los planes utilizados en el pasado. 
-- Recibe por parametro Actual o Usados
DROP PROCEDURE IF EXISTS VerUsoPlanes
DELIMITER //

CREATE PROCEDURE VerUsoPlanes( ESTADO varchar(100))
BEGIN
	
    DECLARE INVALID_DATA INT DEFAULT(54500);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			
            SET @message = 'ERROR, el dato ingresado no existe';            
			
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;
        
    IF ( ESTADO='Actual' or ESTADO='Usados') THEN 
		
        IF ( ESTADO='Actual') THEN 
			SELECT nombre, email, titulo FROM PlanesXUsuarioActuales;
        ELSE
			SELECT nombre, email, titulo FROM PlanesXUsuarioUsados;
		END IF;
        
    ELSE
         -- se genera un error
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
        
	END IF;

END//

DELIMITER ;

CALL VerUsoPlanes( 'TODO');
CALL VerUsoPlanes( 'Actual');
CALL VerUsoPlanes( 'Usados');




DROP PROCEDURE IF EXISTS VerPagos
DELIMITER //

CREATE PROCEDURE VerPagos( estado varchar(100))
BEGIN
	
    DECLARE INVALID_DATA INT DEFAULT(54500);
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS CONDITION 1 @err_no = MYSQL_ERRNO, @message = MESSAGE_TEXT;
			
            SET @message = 'ERROR, el dato ingresado no existe';            
			
			RESIGNAL SET MESSAGE_TEXT = @message;
		END;
        
	IF ( ESTADO='Aceptado' or ESTADO='Rechazado') THEN 
		
        IF ( ESTADO='Aceptado') THEN 
			SELECT Cantidad_a_Pagar,`description`,Tipo_de_pago
            FROM PagosAceptados;
        ELSE
			SELECT Cantidad_a_Pagar,`description`,Tipo_de_pago
            FROM PagosRechazados;
		END IF;
        
    ELSE
         -- se genera un error
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = INVALID_DATA;
        
	END IF;
    
END//

DELIMITER ;

CALL VerPagos( 'Aceptado');
CALL VerPagos( 'Rechazado');
CALL VerPagos( 'Todo');
