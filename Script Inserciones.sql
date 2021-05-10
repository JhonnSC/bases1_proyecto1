use mydb;

DROP PROCEDURE IF EXISTS InsertarGeneros;
delimiter //

CREATE PROCEDURE InsertarGeneros()
BEGIN
	INSERT INTO Generos (nombre_genero)
    VALUES 
    ('Masculino'),
	('Femenino'),
	('No-binario');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarUsuarios;
delimiter //

CREATE PROCEDURE InsertarUsuarios()
BEGIN
	INSERT INTO UsersAccounts (nombre, segundonombre, apellido1, apellido2, username, email, fechanacimiento, summary, fechacreacion, activo, generoid) 
    VALUES 
    ('Manuel', 'Alejandro', 'Casasola', 'Mayorga', 'Manuel1410', 'mcasasolam@gmail.com','2001-10-14', 'Estudiante Universitario (TEC), 19 años', CURDATE() , 1, 1),
    ('Juan', 'José', 'Pérez', 'Campos', 'Juan0807', 'Juan0807@gmail.com', '1999-08-07','Descripción', CURDATE(), 1, 1), 
    ('Mónica', 'María', 'Guillamon', 'Oliviera', 'Mónica0927', 'Monica0927@gmail.com', '1983-09-27', 'Descripción', CURDATE(), 1, 2),
    ('Cristian', 'Andrés', 'Núñez', 'Mora', 'Cristian1020', 'Cristian1020@gmail.com', '1980-10-20', 'Descripción', CURDATE(), 1, 1), 
    ('Emilia', 'Carolina', 'Chinchilla', 'Quesada', 'Emilia1015', 'Emilia1015@gmail.com', '2000-10-15', 'Descripción', CURDATE(), 1, 2);
	
    INSERT INTO UsersAccounts (nombre, apellido1, username, email, fechanacimiento, summary, fechacreacion, activo, generoid) 
    VALUES 
    ('Miguel', 'Gómez', 'Miguel1127', 'Miguel1127@gmail.com', '1997-11-27', 'Descripción', CURDATE(), 1, 1),
    ('María', 'Espinoza', 'Maria0318', 'Maria0318@gmail.com', '1995-03-18', 'Descripción', CURDATE(), 1, 2),
    ('Victoria', 'Venegas', 'Victoria0113', 'Victoria0113@gmail.com', '1994-01-13', 'Descripción', CURDATE(), 1, 2),
    ('Alicia', 'Martín', 'Alicia0316', 'Alicia0316@gmail.com', '1985-03-16', 'Descripción', CURDATE(), 1, 2),
    ('Julián', 'Pineda', 'Julian0920','Julian0920@gmail.com', '1997-09-20', 'Descripción', CURDATE(), 1, 1),
    ('Clara', 'Cassasola', 'Clara0630','Clara0630@gmail.com', '1991-06-30', 'Descripción', CURDATE(), 1, 2),
    ('Karen', 'Fernández', 'Karen1017','Karen1017@gmail.com', '1996-10-17', 'Descripción', CURDATE(), 1, 2),
    ('Raúl', 'Abarca', 'Raul0927', 'Raul0927@gmail.com', '2001-09-27', 'Descripción', CURDATE(), 1, 1),
    ('Eugenio', 'Jiménez', 'Eugenio1204', 'Eugenio1204@gmail.com', '1993-12-04', 'Descripción', CURDATE(), 1, 1),
    ('Juan', 'Artavia', 'Juan0601', 'Juan0601@gmail.com', '1991-06-01', 'Descripción', CURDATE(), 1, 1),
	('Margarita', 'Barrientos', 'Margarita0412', 'Margarita0412@gmail.com', '1996-04-12', 'Descripción', CURDATE(), 1, 2),
    ('Elena', 'Mesa', 'Elena0324', 'Elena0324@gmail.com', '1984-03-24', 'Descripción', CURDATE(), 1, 2),
    ('César', 'Guevara', 'Cesar1219', 'Cesar1219@gmail.com', '1991-12-19', 'Descripción', CURDATE(), 1, 1),
    ('Alberto', 'Carrasco', 'Alberto0329', 'Alberto0329@gmail.com', '1985-03-29', 'Descripción', CURDATE(), 1, 1),
    ('Ramón', 'Gamboa', 'Ramon1231','Ramon1231@gmail.com', '2002-12-31', 'Descripción', CURDATE(), 1, 1),
    ('Sebastián', 'Ulloa', 'Sebastian0908', 'Sebastian0908@gmail.com', '1989-09-08', 'Descripción', CURDATE(), 1, 1),
    ('Marco', 'Ramírez', 'Marco1216', 'Marco1216@gmail.com', '1996-12-16', 'Descripción', CURDATE(), 1, 1),
    ('Milagros', 'Pazos', 'Milagros1202', 'Milagros1202@gmail.com', '1984-12-02', 'Descripción', CURDATE(), 1, 2),
    ('Pedro', 'Villalta', 'Pedro1010', 'Pedro1010@gmail.com', '1995-10-10', 'Descripción', CURDATE(), 1, 1),
    ('Javier', 'Correa', 'Javier0201', 'Javier0201@gmail.com', '1997-02-01', 'Descripción', CURDATE(), 1, 1),
    ('Mar', 'López', 'Mar1126', 'Mar1126@gmail.com', '1991-11-26', 'Descripción', CURDATE(), 1, 2),
    ('Sandra', 'Alvarado', 'Sandra0714', 'Sandra0714@gmail.com', '1983-07-14', 'Descripción', CURDATE(), 1, 2),
    ('Ricardo', 'Blanco', 'Ricardo0825', 'Ricardo0825@gmail.com', '1991-08-25', 'Descripción', CURDATE(), 1, 1),
    ('Cecilia', 'Román', 'Cecilia0416', 'Cecilia0416@gmail.com', '1988-04-16', 'Descripción', CURDATE(), 1, 2),
    ('Juana', 'Cabrera', 'Juana0118', 'Juana0118@gmail.com', '1989-01-18', 'Descripción', CURDATE(), 1, 2);
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarContrasenas;
delimiter //

CREATE PROCEDURE InsertarContrasenas()
BEGIN
	DECLARE done TINYINT DEFAULT FALSE;
	DECLARE correo varchar(100);
    DECLARE usuario INT;
    DECLARE contraseña_aux varchar(150);
    
	DECLARE RecorrerContrasenas CURSOR FOR
    SELECT email, userid FROM UsersAccounts;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN RecorrerContrasenas;
    
    ciclo: LOOP
    
		FETCH RecorrerContrasenas INTO correo, usuario;
		IF done THEN
			LEAVE ciclo;
		END IF;

        SET contraseña_aux = CONCAT(correo, '123456');

        INSERT INTO Contrasenas (contraseña, datetimecontraseña, actual, userid)
        VALUES ( SHA2(contraseña_aux, 224) , CURDATE(), 1, usuario);
        
    END LOOP;
    
	CLOSE RecorrerContrasenas;

END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarTiposAcciones;
delimiter //

CREATE PROCEDURE InsertarTiposAcciones()
BEGIN
	INSERT INTO Tipoacciones (name_tipoaccion)
    VALUES 
    ('Descarte'),
    ('Like'),
    ('Super Like'),
    ('Mega Like');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarIdiomas;
delimiter //

CREATE PROCEDURE InsertarIdiomas()
BEGIN
	INSERT INTO Idiomas (name_idioma, cultura)
    VALUES 
    ('English', 'EN-US'),
    ('Español', 'ESP-ES'),
    ('Español', 'ESP-CR'),
    ('Français', 'FR-FR');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarContextos;
delimiter //

CREATE PROCEDURE InsertarContextos()
BEGIN
    INSERT INTO Contexto(name_contexto)
    VALUES 
    ('Idiomas'),
    ('Géneros'),
    ('Tipo de Acción'),
    ('Estados de Pago'),
    ('Tipo de Pago'),
    ('Planes'),
    ('Recurrencias'),
    ('Beneficios'),
    ('Límites'),
    ('Tipos de Bitácora'),
    ('Severidad'),
    ('Entity Types'),
    ('TransTypes'),
    ('TransSubTypes'),
    ('Contexts');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarLocalizaciones;
delimiter //

CREATE PROCEDURE InsertarLocalizaciones()
BEGIN
	DECLARE done TINYINT DEFAULT FALSE;
	DECLARE usuario INT;
	DECLARE lat FLOAT;
    DECLARE lon FLOAT;
    
	DECLARE RecorrerUsuarios CURSOR FOR
    SELECT userid FROM UsersAccounts;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN RecorrerUsuarios;
    
    ciclo: LOOP
		FETCH RecorrerUsuarios INTO usuario;
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
            
            INSERT INTO location (latitud, longitud, `name`, actual, posttime, userid)
            VALUES
			(lat, lon, 'nombre de lugar', 1, CURDATE(), usuario);
	END LOOP;
    CLOSE RecorrerUsuarios;
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarEstadosPago;
delimiter //

CREATE PROCEDURE InsertarEstadosPago()
BEGIN
	INSERT INTO EstadosDePago(name_estado)
    VALUES
    ('Aceptado'),
    ('Rechazado'),
    ('En Tránsito');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarTipoPagos;
delimiter //

CREATE PROCEDURE InsertarTipoPagos()
BEGIN
	INSERT INTO TiposPago(name_tipopago)
    VALUES
    ('Crédito'),
    ('Débito');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarMerchants;
delimiter //

CREATE PROCEDURE InsertarMerchants()
BEGIN
	INSERT INTO Merchants(name_merchant, URL, habilitado, iconoURL)
    VALUES 
    ('Paypal', 'www.paypal.com', 1, 'www.paypal.com/imageicon/'),
    ('Wink', 'www.wink.com', 1, 'www.wink.com/imageicon/'),
    ('ApplePay', 'www.ApplePay.com', 1, 'www.ApplePay.com/imageicon/'),
    ('GooglePay', 'www.GooglePay.com', 1, 'www.GooglePay.com/imageicon/'),
    ('BAC', 'www.Bac.com', 1, 'www.Bac.com/imageicon/'),
    ('BN', 'www.BancoNacional.com', 1, 'www.BancoNacional.com/imageicon/');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarIntereses;
delimiter //

CREATE PROCEDURE InsertarIntereses()
BEGIN
	INSERT INTO InteresesDeUsuario(name_interes, deleted)
    VALUES
    ('Música', 0),
    ('Películas', 0),
    ('Anime', 0),
    ('Manualidades', 0),
    ('Ejercicio', 0),
    ('Montañismo', 0),
    ('Viajes', 0),
    ('Cultura', 0),
    ('Historia', 0),
    ('Video Juegos', 0),
    ('Comida', 0),
    ('Diseño', 0),
    ('Libros', 0),
    ('DIY', 0),
    ('Carros', 0),
    ('TV', 0),
    ('Tocar Música', 0),
    ('Coser', 0),
    ('Escribir', 0),
    ('Bailar', 0),
    ('Pintar', 0),
    ('Teatro', 0),
    ('Playa', 0),
    ('Cocinar', 0);
END //
delimiter ;


DROP PROCEDURE IF EXISTS Filldata;
delimiter //

CREATE PROCEDURE Filldata()
BEGIN
	CALL InsertarGeneros();
    CALL InsertarUsuarios();
    CALL InsertarContrasenas();
	CALL InsertarTiposAcciones();
    CALL InsertarIdiomas();
	CALL InsertarContextos();
	CALL InsertarLocalizaciones();
    CALL InsertarEstadosPago();
    CALL InsertarTipoPagos();
    CALL InsertarMerchants();
    CALL InsertarIntereses();

END //
delimiter ;

CALL Filldata();
