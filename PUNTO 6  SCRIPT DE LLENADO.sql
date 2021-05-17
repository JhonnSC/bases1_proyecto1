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
    ('Like'),
    ('Super Like'),
    ('Quitar Like'),
    ('Descartar Persona');
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
    ('Contexts'),
    ('Categorias'),
    ('Intereses');
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

DROP PROCEDURE IF EXISTS InsertarInteresesXUsuario;
delimiter //

CREATE PROCEDURE InsertarInteresesXUsuario()
BEGIN
	DECLARE done TINYINT DEFAULT FALSE;
    DECLARE usuario INT;
    DECLARE inte1 INT;
    DECLARE inte2 INT;
    DECLARE inte3 INT;
	DECLARE RecorrerUsuarios_aux5 CURSOR FOR
    SELECT userid FROM UsersAccounts;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN RecorrerUsuarios_aux5;
    
    ciclo: LOOP
		FETCH RecorrerUsuarios_aux5 INTO usuario;
		IF done THEN
			LEAVE ciclo;
		END IF;

		SET inte1 = FLOOR(1 + RAND()*9);
        SET inte2 = FLOOR(1 + RAND()*9);
        SET inte3 = FLOOR(1 + RAND()*9);
        
        IF inte1 = inte2 OR inte3 = inte1 THEN
			SET inte1 = FLOOR(1 + RAND()*24);
		END IF;
        IF inte2 = inte1 OR inte3 = inte2 THEN
			SET inte2 = FLOOR(1 + RAND()*24);
		END IF;
        IF inte3 = inte2 OR inte3 = inte1 THEN
			SET inte3 = FLOOR(1 + RAND()*24);
		END IF;
	
        INSERT INTO UsersXIntereses(userid, interesusuarioid)
        VALUES
        (usuario, inte1),
        (usuario, inte2),
        (usuario, inte3);
    END LOOP;
	CLOSE RecorrerUsuarios_aux5;
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarRecurrences;
delimiter //

CREATE PROCEDURE InsertarRecurrences()
BEGIN
	INSERT INTO RecurrencesTypes(name_recurrence, periodoplan, datepart)
    VALUES
    ('Infinito', 0, 'null'),
    ('Mensual', 1, 'mm'),
    ('Anual', 1, 'yyyy'),
    ('Trimestral', 3, 'mm'),
    ('Semestral', '6', 'mm');
END //
delimiter ;


DROP PROCEDURE IF EXISTS InsertarPlanes;
delimiter //

CREATE PROCEDURE InsertarPlanes()
BEGIN
	INSERT INTO Planes(description_plan, amount, starttime, endtime, activo, titulo, recurrencetypeid)
    VALUES
    ('Incluye 10 likes diarios no incluye Super Likes, no puede deshacer likes, incluye 100 descartes diarios', 0, CURDATE(), '2099-12-31', 1, 'Plan_Gratis', 1),
    ('Incluye 15 likes y 5 Super Likes diarios, puede deshacer 3 Likes al día e incluye descartes ilimitados', 1000, CURDATE(), '2099-12-31', 1, 'Plan_Premium_1.0_(Mensual)', 2),
	('Incluye 15 likes y 5 Super Likes diarios, puede deshacer 3 Likes al día e incluye descartes ilimitados', 10000, CURDATE(), '2099-12-31', 1, 'Plan_Premium_1.0_(Anual)', 3),
    ('Incluye 20 likes y 10 Super Likes diarios, puede deshacer 5 likes al día e incluye descartes ilimitados', 5000, CURDATE(), '2099-12-31', 1, 'Plan_Premium_2.0_(Mensual)', 2),
    ('Incluye 20 likes y 10 Super Likes diarios, puede deshacer 5 likes al día e incluye descartes ilimitados', 50000, CURDATE(), '2099-12-31', 1, 'Plan_Premium_2.0_(Anual)', 3),
    ('Incluye Likes y Super Likes ilimitados, puede deshacer hasta 10 likes al día e incluye descartes ilimitados', 10000, CURDATE(), '2099-12-31', 1, 'Plan_Premium_3.0_(Mensual)', 2),
	('Incluye Likes y Super Likes ilimitados, puede deshacer hasta 10 likes al día e incluye descartes ilimitados', 100000, CURDATE(), '2099-12-31', 1,'Plan_Premium_3.0_(Anual)', 3),
	('Incluye 15 Likes y 10 Super Likes, puede deshacer 3 Likes al día e incluye descartes ilimitados (SOLO POR TIMEPO LIMITADO)', 2000, CURDATE(), '2021-06-01', 1, 'Plan_Oferta', 1);
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarBeneficios;
delimiter //

CREATE PROCEDURE InsertarBeneficios()
BEGIN
	INSERT INTO Beneficios(name_beneficio, descripcion_beneficio)
    VALUES
    ('Like', 'Permite hacerle like a otra persona'),
    ('Super Like', 'Permite darle like a un usuario y notificarle al correo de ese usuario quien le dió like'),
    ('Deshacer Like', 'Permite quitarle el like a una persona'),
    ('Descartar Persona', 'Permite descartar a una persona y pasar a la siguiente');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarLimites;
delimiter //

CREATE PROCEDURE InsertarLimites()
BEGIN 
	INSERT INTO Limites (name_limite, cantidad)
    VALUES
    ('Infinitos', 1000000000),
    ('Cero', -1),
    ('Tres', 3),
    ('Cinco', 5),
    ('Diez', 10),
    ('Quince', 15),
    ('Veinte', 20),
    ('Cincuenta', 50),
    ('Cien', 100);
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarPlanBase;
delimiter //

CREATE PROCEDURE InsertarPlanBase()
BEGIN
	DECLARE done TINYINT DEFAULT FALSE;
    DECLARE usuario INT;
	DECLARE RecorrerUsuarios_aux CURSOR FOR
    SELECT userid FROM UsersAccounts;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN RecorrerUsuarios_aux;
    
    
    ciclo: LOOP
    
		FETCH RecorrerUsuarios_aux INTO usuario;
		IF done THEN
			LEAVE ciclo;
		END IF;

		SET @nexttime = (SELECT endtime FROM Planes WHERE planid=1);
        INSERT INTO PlansxUser(PostTime, NextTime, actual, planid, userid)
        VALUES
        (CURDATE(), @nexttime, 1, 1, usuario);
        
    END LOOP;
	CLOSE RecorrerUsuarios_aux;
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarTransTypes;
delimiter //

CREATE PROCEDURE InsertarTransTypes()
BEGIN
	INSERT INTO TransTypes(name_transtype)
    VALUES
	('Pagos'),
    ('Acciones APP');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarContexts;
delimiter //

CREATE PROCEDURE InsertarContexts()
BEGIN
	INSERT INTO Contexts(name_context)
    VALUES
    ('Pagos'),
    ('Acciones'),
    ('Localizaciones'),
    ('Fotos'),
    ('Traducciones'),
    ('Bitacora'),
    ('Mensajes');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarCategorias;
delimiter //

CREATE PROCEDURE InsertarCategorias()
BEGIN
	INSERT INTO Categorias(name_categoria, deleted)
    VALUES
    ('Animales', 0),
    ('Viaje', 0),
    ('Atardecer', 0),
    ('Vida Nocturna', 0),
    ('Lujos', 0),
    ('Moda', 0),
    ('Arte', 0),
    ('Anime', 0),
    ('Abstracto', 0);
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarCategoriasXUsers;
delimiter //

CREATE PROCEDURE InsertarCategoriasXUsers()
BEGIN
	DECLARE done TINYINT DEFAULT FALSE;
    DECLARE usuario INT;
    DECLARE cat1 INT;
    DECLARE cat2 INT;
	DECLARE RecorrerUsuarios_aux2 CURSOR FOR
    SELECT userid FROM UsersAccounts;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN RecorrerUsuarios_aux2;
    
    
    ciclo: LOOP
    
		FETCH RecorrerUsuarios_aux2 INTO usuario;
		IF done THEN
			LEAVE ciclo;
		END IF;

		SET cat1 = FLOOR(1 + RAND()*9);
        SET cat2 = FLOOR(1 + RAND()*9);
        
        IF cat1 = cat2 THEN
			SET cat2 = FLOOR(1 + RAND()*9);
		END IF;
        
        IF cat1 = cat2 THEN
			SET cat1 = FLOOR(1 + RAND()*9);
		END IF;
	
        INSERT INTO UsersXCategorias(userid, categoriaid)
        VALUES
        (usuario, cat1),
        (usuario, cat2);
    END LOOP;
	CLOSE RecorrerUsuarios_aux2;

END //
delimiter ;


DROP PROCEDURE IF EXISTS InsertarPerfilesBusqueda;
delimiter //

CREATE PROCEDURE InsertarPerfilesBusqueda()
BEGIN
	DECLARE done TINYINT DEFAULT FALSE;
    DECLARE usuario INT;
    DECLARE genero TINYINT;
	DECLARE RecorrerUsuarios_aux3 CURSOR FOR
    SELECT userid, generoid FROM UsersAccounts;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN RecorrerUsuarios_aux3;
    
    ciclo: LOOP
    
		FETCH RecorrerUsuarios_aux3 INTO usuario, genero;
		IF done THEN
			LEAVE ciclo;
		END IF;
        
        SET @min = (FLOOR(18 + RAND()*(26-18)));
        SET @max = (FLOOR(45 + RAND()*(100-45)));
        
        IF genero = 1 THEN
			SET @genero = 2;
		END IF;
        
        IF genero = 2 THEN
			SET @genero = 1;
		END IF;
        
        INSERT INTO PerfilBusqueda(rangodeedadminimo, rangodedadmaximo, generoid, userid)
        VALUES
        (@min, @max, @genero, usuario);
        
    END LOOP;
	CLOSE RecorrerUsuarios_aux3;
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarFotos;
delimiter //

CREATE PROCEDURE InsertarFotos()
BEGIN
	DECLARE done TINYINT DEFAULT FALSE;
    DECLARE usuario INT;
    DECLARE lat FLOAT;
    DECLARE lon FLOAT;
    DECLARE contador TINYINT;
	DECLARE RecorrerUsuarios_aux4 CURSOR FOR
    SELECT userid FROM UsersAccounts;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    SET contador = 1;
    
    OPEN RecorrerUsuarios_aux4;
    
    ciclo: LOOP
    
		FETCH RecorrerUsuarios_aux4 INTO usuario;
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
        VALUES
        (CONCAT('www.Finder.com/FotosUsuarios/0', CAST(contador AS CHAR)), lat, lon, 0, CURDATE(), usuario);
        SET contador = contador+1;
        
    END LOOP;
	CLOSE RecorrerUsuarios_aux4;
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarPlanesXBeneficios;
delimiter //


CREATE PROCEDURE InsertarPlanesXBeneficios()
BEGIN 
		INSERT INTO BeneficiosXPlanes(planid, beneficioid, limiteid)
		VALUES 
		(1, 1, 5),
		(2, 1, 6),
        (3, 1, 6),
        (4, 1, 7),
        (5, 1, 7),
        (6, 1, 1),
        (7, 1, 1),
        (8, 1, 6),
        (1, 2, 2),
        (2, 2, 4),
        (3, 2, 4),
        (4, 2, 5),
        (5, 2, 5),
        (6, 2, 1),
        (7, 2, 1),
        (8, 2, 5),
        (1, 3, 2),
        (2, 3, 3),
        (3, 3, 3),
        (4, 3, 4),
        (5, 3, 4),
        (6, 3, 5),
        (7, 3, 5),
        (8, 3, 3),
        (1, 4, 9),
        (2, 4, 1),
        (3, 4, 1),
        (4, 4, 1),
        (5, 4, 1),
        (6, 4, 1),
        (7, 4, 1),
        (8, 4, 1);
       
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarTiposBitacora;
delimiter //

CREATE PROCEDURE InsertarTiposBitacora()
BEGIN
	INSERT INTO TiposBitacora(nombre_tipobitacora)
    VALUES
    ('Login Usuario'),
    ('Log out Usuario'),
    ('Cambio Contraseña'),
    ('Generación URL contraseña'),
    ('Creación Chats'),
    ('Mensaje'),
    ('Registrar localización'),
    ('Agregar Foto'),
    ('Quitar Foto'),
    ('Cambiar info Plan'),
    ('Ingresar Limite Plan'),
    ('Ingresar Beneficios Plan'),
    ('Ingresar recurrencias'),
    ('Registrar Pago'),
    ('Registrar Transacción'),
    ('Ingresar Merchant'),
    ('Traducir');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarSeveridad;
delimiter //

CREATE PROCEDURE InsertarSeveridad()
BEGIN
	INSERT INTO Severidad(nombre_severidad)
    VALUES
    ('Información'),
    ('Error'),
    ('Actualización'),
    ('Inserción'),
    ('Borrado');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarEntityTypes;
delimiter //

CREATE PROCEDURE InsertarEntityTypes()
BEGIN
	INSERT INTO EntityTypes(nombre_entity)
    VALUES 
    ('Usuario'),
    ('Administrador'),
    ('Desconocido');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarAplicaciones;
delimiter //

CREATE PROCEDURE InsertarAplicaciones()
BEGIN 
	INSERT INTO AplicacionFuente(nombre_aplicacion)
    VALUES
    ('Usuarios'),
    ('Contraeñas'),
    ('URL Contraseñas'),
    ('Chats'),
    ('Mensajes'),
    ('Acciones'),
    ('Localizaciones'),
    ('Fotos'),
    ('Planes'),
    ('Limites'),
    ('Beneficios'),
    ('Recurrencias'),
    ('Pagos'),
    ('Transacciones'),
    ('Merchants'),
    ('Traducciones');
    
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarTraducciones;
delimiter //

CREATE PROCEDURE InsertarTraducciones()
BEGIN select * from Idiomas;
	INSERT INTO Traducciones(traduccioncodigo, caption, referenciaid, idiomaid, contextoid)
	VALUES -- INGLES USA
	('TRD-ENUS-01', 'English', 1, 1, 1),
    ('TRD-ENUS-02', 'Spanish', 2, 1, 1),
    ('TRD-ENUS-03', 'Spanish', 3, 1, 1),
    ('TRD-ENUS-04', 'French', 4, 1, 1),
    ('TRD-ENUS-05', 'Male', 1, 1, 2),
    ('TRD-ENUS-06', 'Female', 2, 1, 2),
    ('TRD-ENUS-07', 'Non Binary', 3, 1, 2),
    ('TRD-ENUS-08', 'Discard', 4, 1, 3),
    ('TRD-ENUS-09', 'Like', 1, 1, 3),
    ('TRD-ENUS-10', 'Super Like', 2, 1, 3),
    ('TRD-ENUS-11', 'Remove Like', 3, 1, 3),
    ('TRD-ENUS-12', 'Accepted', 1, 1, 4),
    ('TRD-ENUS-13', 'Rejected', 2, 1, 4),
    ('TRD-ENUS-14', 'In progress', 3, 1, 4),
    ('TRD-ENUS-15', 'Credit', 1, 1, 5),
    ('TRD-ENUS-16', 'Debit', 2, 1, 5),
    ('TRD-ENUS-17', 'Free Plan', 1, 1, 6),
    ('TRD-ENUS-18', 'Premium Plan 1.0 (Monthly)', 2, 1, 6),
    ('TRD-ENUS-19', 'Premium Plan 1.0 (Annual)', 3, 1, 6),
    ('TRD-ENUS-20', 'Premium Plan 2.0 (Monthly)', 4, 1, 6),
    ('TRD-ENUS-21', 'Premium Plan 2.0 (Annual)', 5, 1, 6),
    ('TRD-ENUS-22', 'Premium Plan 3.0 (Monthly)', 6, 1, 6),
    ('TRD-ENUS-23', 'Premium Plan 3.0 (Annual)', 7, 1, 6),
    ('TRD-ENUS-24', 'Limited Offer Plan', 8, 1, 6),
	('TRD-ENUS-25', 'infinite', 1, 1, 7),
    ('TRD-ENUS-26', 'Monthly', 2, 1, 7),
    ('TRD-ENUS-27', 'Annual', 3, 1, 7),
    ('TRD-ENUS-28', 'Quarterly', 4, 1, 7),
    ('TRD-ENUS-29', 'Semiannual', 5, 1, 7),
	('TRD-ENUS-30', 'Like', 1, 1, 8),
    ('TRD-ENUS-31', 'Super Like', 2, 1, 8),
    ('TRD-ENUS-32', 'Remove Like', 3, 1, 8),
    ('TRD-ENUS-33', 'Discard person', 4, 1, 8),
    ('TRD-ENUS-34', 'Infinite', 1, 1, 9),
    ('TRD-ENUS-35', 'Zero', 2, 1, 9),
    ('TRD-ENUS-36', 'Three', 3, 1, 9),
    ('TRD-ENUS-37', 'Five', 4, 1, 9),
    ('TRD-ENUS-38', 'Ten', 5, 1, 9),
    ('TRD-ENUS-39', 'Fifteen', 6, 1, 9),
    ('TRD-ENUS-40', 'Twenty', 7, 1, 9),
    ('TRD-ENUS-41', 'Fifty', 8, 1, 9),
    ('TRD-ENUS-42', 'One Hundred', 9, 1, 9),
	('TRD-ENUS-43', 'User Log in', 1, 1, 10),
	('TRD-ENUS-44', 'User Log out', 2, 1, 10),
    ('TRD-ENUS-45', 'Password Change', 3, 1, 10),
    ('TRD-ENUS-46', 'URL generation', 4, 1, 10),
    ('TRD-ENUS-47', 'Chat creation', 5, 1, 10),
    ('TRD-ENUS-48', 'Message', 6, 1, 10),
    ('TRD-ENUS-49', 'Register Location', 7, 1, 10),
    ('TRD-ENUS-50', 'Add photo', 8, 1, 10),
    ('TRD-ENUS-51', 'Delete photo', 9, 1, 10),
    ('TRD-ENUS-52', 'Change Plan Information', 10, 1, 10),
	('TRD-ENUS-53', 'Payments', 1, 1, 13),
    ('TRD-ENUS-54', 'APP Payments', 2, 1, 13),
    ('TRD-ENUS-55', 'Payments', 1, 1, 14),
    ('TRD-ENUS-56', 'Actions', 2, 1, 14),
    ('TRD-ENUS-57', 'Locations', 3, 1, 14),
    ('TRD-ENUS-58', 'Photos', 4, 1, 14),
    ('TRD-ENUS-59', 'Translations', 5, 1, 14),
    ('TRD-ENUS-60', 'Binnacle', 6, 1, 14),
    ('TRD-ENUS-61', 'Messages', 7, 1, 14),
	('TRD-ENUS-62', 'Animals', 1, 1, 15),
    ('TRD-ENUS-63', 'Travel', 2, 1, 15),
    ('TRD-ENUS-64', 'Sunsets', 3, 1, 15),
    ('TRD-ENUS-65', 'Night Life', 4, 1, 15),
    ('TRD-ENUS-66', 'Luxary', 5, 1, 15),
    ('TRD-ENUS-67', 'Fashion', 6, 1, 15),
    ('TRD-ENUS-68', 'Art', 7, 1, 15),
    ('TRD-ENUS-69', 'Anime', 8, 1, 15),
    ('TRD-ENUS-70', 'Abstract', 9, 1, 15),
    ('TRD-ENUS-71', 'Music', 1, 1, 16),
    ('TRD-ENUS-72', 'Movies', 2, 1, 16),
    ('TRD-ENUS-73', 'Anime', 3, 1, 16),
    ('TRD-ENUS-74', 'Hand Craft', 4, 1, 16),
    ('TRD-ENUS-75', 'Fitness', 5, 1, 16),
    ('TRD-ENUS-76', 'Mountaineering', 6, 1, 16),
    ('TRD-ENUS-77', 'Travel', 7, 1, 16),
    ('TRD-ENUS-78', 'Culture', 8, 1, 16),
    ('TRD-ENUS-79', 'History', 9, 1, 16),
    ('TRD-ENUS-80', 'Videogames', 10, 1, 16),
    ('TRD-ENUS-81', 'Food', 11, 1, 16),
    ('TRD-ENUS-82', 'Design', 12, 1, 16),
    ('TRD-ENUS-83', 'Books', 13, 1, 16),
    ('TRD-ENUS-84', 'DIY', 14, 1, 16),
    ('TRD-ENUS-85', 'Cars', 15, 1, 16),
    ('TRD-ENUS-86', 'TV', 16, 1, 16),
    ('TRD-ENUS-87', 'Play Music', 17, 1, 16),
    ('TRD-ENUS-88', 'Sew', 18, 1, 16),
    ('TRD-ENUS-89', 'Write', 19, 1, 16),
    ('TRD-ENUS-90', 'Dance', 20, 1, 16),
    ('TRD-ENUS-91', 'Paint', 21, 1, 16),
    ('TRD-ENUS-92', 'Theatre', 22, 1, 16),
    ('TRD-ENUS-93', 'Beach', 23, 1, 16),
    ('TRD-ENUS-94', 'Cook', 24, 1, 16),
	('TRD-ENUS-95', 'Add limit to plan', 11, 1, 10),
    ('TRD-ENUS-96', 'Add benefit to plan', 12, 1, 10),
    ('TRD-ENUS-97', 'Add recurrence', 13, 1, 10),
    ('TRD-ENUS-98', 'Register Payment', 14, 1, 10),
    ('TRD-ENUS-99', 'Register Transaction', 15, 1, 10),
    ('TRD-ENUS-100', 'Add Merchant', 16, 1, 10),
    ('TRD-ENUS-101', 'Translate', 17, 1, 10),
    ('TRD-ENUS-102', 'Information', 1, 1, 11),
    ('TRD-ENUS-103', 'Error', 2, 1, 11),
    ('TRD-ENUS-104', 'Update', 3, 1, 11),
    ('TRD-ENUS-105', 'Insertion', 4, 1, 11),
    ('TRD-ENUS-106', 'Delete', 5, 1, 11),
    ('TRD-ENUS-107', 'User', 1, 1, 12),
    ('TRD-ENUS-108', 'Administrator', 2, 1, 12),
    ('TRD-ENUS-109', 'Unknown', 3, 1, 12),
    -- ESPAÑOL ESPAÑA
	('TRD-ESESP-01', 'Inglés', 1, 2, 1),
    ('TRD-ESESP-02', 'Español', 2, 2, 1),
    ('TRD-ESESP-03', 'Español', 3, 2, 1),
    ('TRD-ESESP-04', 'Fránces', 4, 2, 1),
    ('TRD-ESESP-05', 'Masculino', 1, 2, 2),
    ('TRD-ESESP-06', 'Femenino', 2, 2, 2),
    ('TRD-ESESP-07', 'No Binario', 3, 2, 2),
    ('TRD-ESESP-08', 'Descarte', 4, 2, 3),
    ('TRD-ESESP-09', 'Me flipa', 1, 2, 3),
    ('TRD-ESESP-10', 'Me super flipa', 2, 2, 3),
    ('TRD-ESESP-11', 'Ya no me flipa', 3, 2, 3),
    ('TRD-ESESP-12', 'Aceptado', 1, 2, 4),
    ('TRD-ESESP-13', 'Rechazado', 2, 2, 4),
    ('TRD-ESESP-14', 'En Tránsito', 3, 2, 4),
    ('TRD-ESESP-15', 'Crédito', 1, 2, 5),
    ('TRD-ESESP-16', 'Débito', 2, 2, 5),
    ('TRD-ESESP-17', 'Plan Gratis', 1, 2, 6),
    ('TRD-ESESP-18', 'Plan Pagado 1.0 (Mensual)', 2, 2, 6),
    ('TRD-ESESP-19', 'Plan Pagado 1.0 (Anual)', 3, 2, 6),
    ('TRD-ESESP-20', 'Plan Pagado 2.0 (Mensual)', 4, 2, 6),
    ('TRD-ESESP-21', 'Plan Pagado 2.0 (Anual)', 5, 2, 6),
    ('TRD-ESESP-22', 'Plan Pagado 3.0 (Mensual)', 6, 2, 6),
    ('TRD-ESESP-23', 'Plan Pagado 3.0 (Anual)', 7, 2, 6),
    ('TRD-ESESP-24', 'Plan Oferta', 8, 2, 6),
	('TRD-ESESP-25', 'Infinito', 1, 2, 7),
    ('TRD-ESESP-26', 'Mensual', 2, 2, 7),
    ('TRD-ESESP-27', 'Anual', 3, 2, 7),
    ('TRD-ESESP-28', 'Trimestral', 4, 2, 7),
    ('TRD-ESESP-29', 'Semestral', 5, 2, 7),
	('TRD-ESESP-30', 'Me flipa', 1, 2, 8),
    ('TRD-ESESP-31', 'Me super flipa', 2, 2, 8),
    ('TRD-ESESP-32', 'Deshacer me flipa', 3, 2, 8),
    ('TRD-ESESP-33', 'Descartar persona', 4, 2, 8),
    ('TRD-ESESP-34', 'Infinito', 1, 2, 9),
    ('TRD-ESESP-35', 'Cero', 2, 2, 9),
    ('TRD-ESESP-36', 'Tres', 3, 2, 9),
    ('TRD-ESESP-37', 'Cinco', 4, 2, 9),
    ('TRD-ESESP-38', 'Diez', 5, 2, 9),
    ('TRD-ESESP-39', 'Quince', 6, 2, 9),
    ('TRD-ESESP-40', 'Veinte', 7, 2, 9),
    ('TRD-ESESP-41', 'Cincuenta', 8, 2, 9),
    ('TRD-ESESP-42', 'Cien', 9, 2, 9),
	('TRD-ESESP-43', 'Incio Sesión Usuario', 1, 2, 10),
	('TRD-ESESP-44', 'Cerrar Sesión Usuario', 2, 2, 10),
    ('TRD-ESESP-45', 'Cambio Contraseña', 3, 2, 10),
    ('TRD-ESESP-46', 'Generación URL', 4, 2, 10),
    ('TRD-ESESP-47', 'Cración Chats', 5, 2, 10),
    ('TRD-ESESP-48', 'Mensaje', 6, 2, 10),
    ('TRD-ESESP-49', 'Registrar Localización', 7, 2, 10),
    ('TRD-ESESP-50', 'Agregar Foto', 8, 2, 10),
    ('TRD-ESESP-51', 'Quitar Foto', 9, 2, 10),
    ('TRD-ESESP-52', 'Cambiar Información de Plan', 10, 2, 10),
	('TRD-ESESP-53', 'Pagos', 1, 2, 13),
    ('TRD-ESESP-54', 'Pagos APP', 2, 2, 13),
    ('TRD-ESESP-55', 'Pagos', 1, 2, 14),
    ('TRD-ESESP-56', 'Acciones', 2, 2, 14),
    ('TRD-ESESP-57', 'Localizaciones', 3, 2, 14),
    ('TRD-ESESP-58', 'Fotos', 4, 2, 14),
    ('TRD-ESESP-59', 'Traducciones', 5, 2, 14),
    ('TRD-ESESP-60', 'Bitacora', 6, 2, 14),
    ('TRD-ESESP-61', 'Mensajes', 7, 2, 14),
	('TRD-ESESP-62', 'Animales', 1, 2, 15),
    ('TRD-ESESP-63', 'Viaje', 2, 2, 15),
    ('TRD-ESESP-64', 'Atardecer', 3, 2, 15),
    ('TRD-ESESP-65', 'Vida Nocturna', 4, 2, 15),
    ('TRD-ESESP-66', 'Lujos', 5, 2, 15),
    ('TRD-ESESP-67', 'Moda', 6, 2, 15),
    ('TRD-ESESP-68', 'Arte', 7, 2, 15),
    ('TRD-ESESP-69', 'Anime', 8, 2, 15),
    ('TRD-ESESP-70', 'Abstracto', 9, 2, 15),
    ('TRD-ESESP-71', 'Música', 1, 2, 16),
    ('TRD-ESESP-72', 'Películas', 2, 2, 16),
    ('TRD-ESESP-73', 'Anime', 3, 2, 16),
    ('TRD-ESESP-74', 'Manualidades', 4, 2, 16),
    ('TRD-ESESP-75', 'Ejercicio', 5, 2, 16),
    ('TRD-ESESP-76', 'Montañismo', 6, 2, 16),
    ('TRD-ESESP-77', 'Viajes', 7, 2, 16),
    ('TRD-ESESP-78', 'Cultura', 8, 2, 16),
    ('TRD-ESESP-79', 'Historia', 9, 2, 16),
    ('TRD-ESESP-80', 'Video Juegos', 10, 2, 16),
    ('TRD-ESESP-81', 'Comida', 11, 2, 16),
    ('TRD-ESESP-82', 'Diseño', 12, 2, 16),
    ('TRD-ESESP-83', 'Libros', 13, 2, 16),
    ('TRD-ESESP-84', 'DIY', 14, 2, 16),
    ('TRD-ESESP-85', 'Carros', 15, 2, 16),
    ('TRD-ESESP-86', 'TV', 16, 2, 16),
    ('TRD-ESESP-87', 'Tocar Música', 17, 2, 16),
    ('TRD-ESESP-88', 'Coser', 18, 2, 16),
    ('TRD-ESESP-89', 'Escribir', 19, 2, 16),
    ('TRD-ESESP-90', 'Bailar', 20, 2, 16),
    ('TRD-ESESP-91', 'Pintar', 21, 2, 16),
    ('TRD-ESESP-92', 'Teatro', 22, 2, 16),
    ('TRD-ESESP-93', 'Playa', 23, 2, 16),
    ('TRD-ESESP-94', 'Cocinar', 24, 2, 16),
	('TRD-ESESP-95', 'Ingresar Limite de Plan', 11, 2, 10),
    ('TRD-ESESP-96', 'Ingresar Beneficio de Plan', 12, 2, 10),
    ('TRD-ESESP-97', 'Ingresar Recurrencias', 13, 2, 10),
    ('TRD-ESESP-98', 'Registrar Pago', 14, 2, 10),
    ('TRD-ESESP-99', 'Registrar Transacción', 15, 2, 10),
    ('TRD-ESESP-100', 'Ingresar Merchant', 16, 2, 10),
    ('TRD-ESESP-101', 'Traducir', 17, 2, 10),
    ('TRD-ESESP-102', 'Información', 1, 2, 11),
    ('TRD-ESESP-103', 'Error', 2, 2, 11),
    ('TRD-ESESP-104', 'Actualización', 3, 2, 11),
    ('TRD-ESESP-105', 'Inserción', 4, 2, 11),
    ('TRD-ESESP-106', 'Borrado', 5, 2, 11),
    ('TRD-ESESP-107', 'Usuario', 1, 2, 12),
    ('TRD-ESESP-108', 'Adminitrador', 2, 2, 12),
    ('TRD-ESESP-109', 'Desconocido', 3, 2, 12),
    -- ESPAÑOL COSTA RICA 
    ('TRD-ESCRC-01', 'Inglés', 1, 3, 1),
    ('TRD-ESCRC-02', 'Español', 2, 3, 1),
    ('TRD-ESCRC-03', 'Español', 3, 3, 1),
    ('TRD-ESCRC-04', 'Fránces', 4, 3, 1),
    ('TRD-ESCRC-05', 'Masculino', 1, 3, 2),
    ('TRD-ESCRC-06', 'Femenino', 2, 3, 2),
    ('TRD-ESCRC-07', 'No Binario', 3, 3, 2),
    ('TRD-ESCRC-08', 'Descarte', 4, 3, 3),
    ('TRD-ESCRC-09', 'Me gusta', 1, 3, 3),
    ('TRD-ESCRC-10', 'Me super gusta', 2, 3, 3),
    ('TRD-ESCRC-11', 'Ya no me gusta', 3, 3, 3),
    ('TRD-ESCRC-12', 'Aceptado', 1, 3, 4),
    ('TRD-ESCRC-13', 'Rechazado', 2, 3, 4),
    ('TRD-ESCRC-14', 'En Tránsito', 3, 3, 4),
    ('TRD-ESCRC-15', 'Crédito', 1, 3, 5),
    ('TRD-ESCRC-16', 'Débito', 2, 3, 5),
    ('TRD-ESCRC-17', 'Plan Gratis', 1, 3, 6),
    ('TRD-ESCRC-18', 'Plan Pagado 1.0 (Mensual)', 2, 3, 6),
    ('TRD-ESCRC-19', 'Plan Pagado 1.0 (Anual)', 3, 3, 6),
    ('TRD-ESCRC-20', 'Plan Pagado 2.0 (Mensual)', 4, 3, 6),
    ('TRD-ESCRC-21', 'Plan Pagado 2.0 (Anual)', 5, 3, 6),
    ('TRD-ESCRC-22', 'Plan Pagado 3.0 (Mensual)', 6, 3, 6),
    ('TRD-ESCRC-23', 'Plan Pagado 3.0 (Anual)', 7, 3, 6),
    ('TRD-ESCRC-24', 'Plan Oferta', 8, 3, 6),
	('TRD-ESCRC-25', 'Infinito', 1, 3, 7),
    ('TRD-ESCRC-26', 'Mensual', 2, 3, 7),
    ('TRD-ESCRC-27', 'Anual', 3, 3, 7),
    ('TRD-ESCRC-28', 'Trimestral', 4, 3, 7),
    ('TRD-ESCRC-29', 'Semestral', 5, 3, 7),
	('TRD-ESCRC-30', 'Me gusta', 1, 3, 8),
    ('TRD-ESCRC-31', 'Me super gusta', 2, 3, 8),
    ('TRD-ESCRC-32', 'Deshacer me gusta', 3, 3, 8),
    ('TRD-ESCRC-33', 'Descartar persona', 4, 3, 8),
    ('TRD-ESCRC-34', 'Infinito', 1, 3, 9),
    ('TRD-ESCRC-35', 'Cero', 2, 3, 9),
    ('TRD-ESCRC-36', 'Tres', 3, 3, 9),
    ('TRD-ESCRC-37', 'Cinco', 4, 3, 9),
    ('TRD-ESCRC-38', 'Diez', 5, 3, 9),
    ('TRD-ESCRC-39', 'Quince', 6, 3, 9),
    ('TRD-ESCRC-40', 'Veinte', 7, 3, 9),
    ('TRD-ESCRC-41', 'Cincuenta', 8, 3, 9),
    ('TRD-ESCRC-42', 'Cien', 9, 3, 9),
	('TRD-ESCRC-43', 'Incio Sesión Usuario', 1, 3, 10),
	('TRD-ESCRC-44', 'Cerrar Sesión Usuario', 2, 3, 10),
    ('TRD-ESCRC-45', 'Cambio Contraseña', 3, 3, 10),
    ('TRD-ESCRC-46', 'Generación URL', 4, 3, 10),
    ('TRD-ESCRC-47', 'Cración Chats', 5, 3, 10),
    ('TRD-ESCRC-48', 'Mensaje', 6, 3, 10),
    ('TRD-ESCRC-49', 'Registrar Localización', 7, 3, 10),
    ('TRD-ESCRC-50', 'Agregar Foto', 8, 3, 10),
    ('TRD-ESCRC-51', 'Quitar Foto', 9, 3, 10),
    ('TRD-ESCRC-52', 'Cambiar Información de Plan', 10, 3, 10),
	('TRD-ESCRC-53', 'Pagos', 1, 3, 13),
    ('TRD-ESCRC-54', 'Pagos APP', 2, 3, 13),
    ('TRD-ESCRC-55', 'Pagos', 1, 3, 14),
    ('TRD-ESCRC-56', 'Acciones', 2, 3, 14),
    ('TRD-ESCRC-57', 'Localizaciones', 3, 3, 14),
    ('TRD-ESCRC-58', 'Fotos', 4, 3, 14),
    ('TRD-ESCRC-59', 'Traducciones', 5, 3, 14),
    ('TRD-ESCRC-60', 'Bitacora', 6, 3, 14),
    ('TRD-ESCRC-61', 'Mensajes', 7, 3, 14),
    ('TRD-ESCRC-62', 'Animales', 1, 3, 15),
    ('TRD-ESCRC-63', 'Viaje', 2, 3, 15),
    ('TRD-ESCRC-64', 'Atardecer', 3, 3, 15),
    ('TRD-ESCRC-65', 'Vida Nocturna', 4, 3, 15),
    ('TRD-ESCRC-66', 'Lujos', 5, 3, 15),
    ('TRD-ESCRC-67', 'Moda', 6, 3, 15),
    ('TRD-ESCRC-68', 'Arte', 7, 3, 15),
    ('TRD-ESCRC-69', 'Anime', 8, 3, 15),
    ('TRD-ESCRC-70', 'Abstracto', 9, 3, 15),
    ('TRD-ESCRC-71', 'Música', 1, 3, 16),
    ('TRD-ESCRC-72', 'Películas', 2, 3, 16),
    ('TRD-ESCRC-73', 'Anime', 3, 3, 16),
    ('TRD-ESCRC-74', 'Manualidades', 4, 3, 16),
    ('TRD-ESCRC-75', 'Ejercicio', 5, 3, 16),
    ('TRD-ESCRC-76', 'Montañismo', 6, 3, 16),
    ('TRD-ESCRC-77', 'Viajes', 7, 3, 16),
    ('TRD-ESCRC-78', 'Cultura', 8, 3, 16),
    ('TRD-ESCRC-79', 'Historia', 9, 3, 16),
    ('TRD-ESCRC-80', 'Video Juegos', 10, 3, 16),
    ('TRD-ESCRC-81', 'Comida', 11, 3, 16),
    ('TRD-ESCRC-82', 'Diseño', 12, 3, 16),
    ('TRD-ESCRC-83', 'Libros', 13, 3, 16),
    ('TRD-ESCRC-84', 'DIY', 14, 3, 16),
    ('TRD-ESCRC-85', 'Carros', 15, 3, 16),
    ('TRD-ESCRC-86', 'TV', 16, 3, 16),
    ('TRD-ESCRC-87', 'Tocar Música', 17, 3, 16),
    ('TRD-ESCRC-88', 'Coser', 18, 3, 16),
    ('TRD-ESCRC-89', 'Escribir', 19, 3, 16),
    ('TRD-ESCRC-90', 'Bailar', 20, 3, 16),
    ('TRD-ESCRC-91', 'Pintar', 21, 3, 16),
    ('TRD-ESCRC-92', 'Teatro', 22, 3, 16),
    ('TRD-ESCRC-93', 'Playa', 23, 3, 16),
    ('TRD-ESCRC-94', 'Cocinar', 24, 3, 16),
    ('TRD-ESCRC-95', 'Ingresar Limite de Plan', 11, 3, 10),
    ('TRD-ESCRC-96', 'Ingresar Beneficio de Plan', 12, 3, 10),
    ('TRD-ESCRC-97', 'Ingresar Recurrencias', 13, 3, 10),
    ('TRD-ESCRC-98', 'Registrar Pago', 14, 3, 10),
    ('TRD-ESCRC-99', 'Registrar Transacción', 15, 3, 10),
    ('TRD-ESCRC-100', 'Ingresar Merchant', 16, 3, 10),
    ('TRD-ESCRC-101', 'Traducir', 17, 3, 10),
    ('TRD-ESCRC-102', 'Información', 1, 3, 11),
    ('TRD-ESCRC-103', 'Error', 2, 3, 11),
    ('TRD-ESCRC-104', 'Actualización', 3, 3, 11),
    ('TRD-ESCRC-105', 'Inserción', 4, 3, 11),
    ('TRD-ESCRC-106', 'Borrado', 5, 3, 11),
    ('TRD-ESCRC-107', 'Usuario', 1, 3, 12),
    ('TRD-ESCRC-108', 'Adminitrador', 2, 3, 12),
    ('TRD-ESCRC-109', 'Desconocido', 3, 3, 12),
	-- FRANCÉS FRANCIA
	('TRD-FRFR-01', 'Anglais', 1, 4, 1),
    ('TRD-FRFR-02', 'Espanol', 2, 4, 1),
    ('TRD-FRFR-03', 'Espanol', 3, 4, 1),
    ('TRD-FRFR-04', 'Français', 4, 4, 1),
    ('TRD-FRFR-05', 'Masculin', 1, 4, 2),
    ('TRD-FRFR-06', 'Féminin', 2, 4, 2),
    ('TRD-FRFR-07', 'Pas Binaire', 3, 4, 2),
    ('TRD-FRFR-08', 'Jeter', 4, 4, 3),
    ('TRD-FRFR-09', 'Aimer', 1, 4, 3),
    ('TRD-FRFR-10', 'Super Aimer', 2, 4, 3),
    ('TRD-FRFR-11', 'Supprimer Aimer', 3, 4, 3),
    ('TRD-FRFR-12', 'Accepté', 1, 4, 4),
    ('TRD-FRFR-13', 'Rejeté', 2, 4, 4),
    ('TRD-FRFR-14', 'En Transit', 3, 4, 4),
    ('TRD-FRFR-15', 'Crédit', 1, 4, 5),
    ('TRD-FRFR-16', 'Débit', 2, 4, 5),
    ('TRD-FRFR-17', 'Plan Gratuit', 1, 4, 6),
    ('TRD-FRFR-18', 'Plan Payant 1.0 (Mensuel)', 2, 4, 6),
    ('TRD-FRFR-19', 'Plan Payant 1.0 (Annuel)', 3, 4, 6),
    ('TRD-FRFR-20', 'Plan Payant 2.0 (Mensuel)', 4, 4, 6),
    ('TRD-FRFR-21', 'Plan Payant 2.0 (Annuel)', 5, 4, 6),
    ('TRD-FRFR-22', 'Plan Payant 3.0 (Mensuel)', 6, 4, 6),
    ('TRD-FRFR-23', 'Plan Payant 3.0 (Annuel)', 7, 4, 6),
    ('TRD-FRFR-24', 'Plan Offrir', 8, 4, 6),
	('TRD-FRFR-25', 'Infini', 1, 4, 7),
    ('TRD-FRFR-26', 'Mensuel', 2, 4, 7),
    ('TRD-FRFR-27', 'Annuel', 3, 4, 7),
    ('TRD-FRFR-28', 'Trimestriel', 4, 4, 7),
    ('TRD-FRFR-29', 'Semestriel', 5, 4, 7),
	('TRD-FRFR-30', 'Aimer', 1, 4, 8),
    ('TRD-FRFR-31', 'Super Aimer', 2, 4, 8),
    ('TRD-FRFR-32', 'Supprimer Aimer', 3, 4, 8),
    ('TRD-FRFR-33', 'Jeter', 4, 4, 8),
    ('TRD-FRFR-34', 'Infini', 1, 4, 9),
    ('TRD-FRFR-35', 'Zéro', 2, 4, 9),
    ('TRD-FRFR-36', 'Trois', 3, 4, 9),
    ('TRD-FRFR-37', 'Cinq', 4, 4, 9),
    ('TRD-FRFR-38', 'Dix', 5, 4, 9),
    ('TRD-FRFR-39', 'Quinze', 6, 4, 9),
    ('TRD-FRFR-40', 'Vingt', 7, 4, 9),
    ('TRD-FRFR-41', 'Cinquante', 8, 4, 9),
    ('TRD-FRFR-42', 'Cent', 9, 4, 9),
	('TRD-FRFR-43', 'Commencer la session', 1, 4, 10),
	('TRD-FRFR-44', 'Fermer la session', 2, 4, 10),
    ('TRD-FRFR-45', 'Changer le mot de passe', 3, 4, 10),
    ('TRD-FRFR-46', 'Générer une URL', 4, 4, 10),
    ('TRD-FRFR-47', 'Création de chat', 5, 4, 10),
    ('TRD-FRFR-48', 'Message', 6, 4, 10),
    ('TRD-FRFR-49', 'Enregistrer l`emplacement', 7, 4, 10),
    ('TRD-FRFR-50', 'Ajouter une photo', 8, 4, 10),
    ('TRD-FRFR-51', 'Retirer photo', 9, 4, 10),
    ('TRD-FRFR-52', 'Modifier les informations du plan', 10, 4, 10),
	('TRD-FRFR-53', 'Paiements', 1, 4, 13),
    ('TRD-FRFR-54', 'Paiements APP', 2, 4, 13),
    ('TRD-FRFR-55', 'Paiements', 1, 4, 14),
    ('TRD-FRFR-56', 'Actions', 2, 4, 14),
    ('TRD-FRFR-57', 'Emplacements', 3, 4, 14),
    ('TRD-FRFR-58', 'Photos', 4, 4, 14),
    ('TRD-FRFR-59', 'Traductions', 5, 4, 14),
    ('TRD-FRFR-60', 'Habitacle', 6, 4, 14),
    ('TRD-FRFR-61', 'Messages', 7, 4, 14),
    ('TRD-FRFR-62', 'Animaux', 1, 4, 15),
    ('TRD-FRFR-63', 'Voyage', 2, 4, 15),
    ('TRD-FRFR-64', 'Coucher du Soleil', 3, 4, 15),
    ('TRD-FRFR-65', 'Vie Nocturne', 4, 4, 15),
    ('TRD-FRFR-66', 'Luxe', 5, 4, 15),
    ('TRD-FRFR-67', 'Mode', 6, 4, 15),
    ('TRD-FRFR-68', 'Art', 7, 4, 15),
    ('TRD-FRFR-69', 'Anime', 8, 4, 15),
    ('TRD-FRFR-70', 'Abstrait', 9, 4, 15),
    ('TRD-FRFR-71', 'Musique', 1, 4, 16),
    ('TRD-FRFR-72', 'Films', 2, 4, 16),
    ('TRD-FRFR-73', 'Anime', 3, 4, 16),
    ('TRD-FRFR-74', 'Artisanat', 4, 4, 16),
    ('TRD-FRFR-75', 'Exercer', 5, 4, 16),
    ('TRD-FRFR-76', 'Alpinisme', 6, 4, 16),
    ('TRD-FRFR-77', 'Voyage', 7, 4, 16),
    ('TRD-FRFR-78', 'Culture', 8, 4, 16),
    ('TRD-FRFR-79', 'Histoire', 9, 4, 16),
    ('TRD-FRFR-80', 'Jeux Video', 10, 4, 16),
    ('TRD-FRFR-81', 'Aliments', 11, 4, 16),
    ('TRD-FRFR-82', 'Conception', 12, 4, 16),
    ('TRD-FRFR-83', 'Livres', 13, 4, 16),
    ('TRD-FRFR-84', 'DIY', 14, 4, 16),
    ('TRD-FRFR-85', 'Voitures', 15, 4, 16),
    ('TRD-FRFR-86', 'TV', 16, 4, 16),
    ('TRD-FRFR-87', 'Jouer de la Musique', 17, 4, 16),
    ('TRD-FRFR-88', 'Coudre', 18, 4, 16),
    ('TRD-FRFR-89', 'Écrire', 19, 4, 16),
    ('TRD-FRFR-90', 'Danser', 20, 4, 16),
    ('TRD-FRFR-91', 'Peindre', 21, 4, 16),
    ('TRD-FRFR-92', 'Théâtre', 22, 4, 16),
    ('TRD-FRFR-93', 'Plage', 23, 4, 16),
    ('TRD-FRFR-94', 'Cuisiner', 24, 4, 16),
	('TRD-FRFR-95', 'Entrez la limite du plan', 11, 4, 10),
    ('TRD-FRFR-96', 'Entrez la prestation du plan', 12, 4, 10),
    ('TRD-FRFR-97', 'Entrer une récurrence ', 13, 4, 10),
    ('TRD-FRFR-98', 'Enregistrer le paiement', 14, 4, 10),
    ('TRD-FRFR-99', 'Enregistrer une transaction', 15, 4, 10),
    ('TRD-FRFR-100', 'Entrez le marchand', 16, 4, 10),
    ('TRD-FRFR-101', 'Traduire', 17, 4, 10),
    ('TRD-FRFR-102', 'Informations', 1, 4, 11),
    ('TRD-FRFR-103', 'Erreur', 2, 4, 11),
    ('TRD-FRFR-104', 'Actualisation', 3, 4, 11),
    ('TRD-FRFR-105', 'Insertion', 4, 4, 11),
    ('TRD-FRFR-106', 'Effacé', 5, 4, 11),
    ('TRD-FRFR-107', 'Utilisateur', 1, 4, 12),
    ('TRD-FRFR-108', 'Administrateur', 2, 4, 12),
    ('TRD-FRFR-109', 'étranger', 3, 4, 12);
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
    CALL InsertarInteresesXUsuario();
    CALL InsertarRecurrences();
    CALL InsertarPlanes();
    CALL InsertarBeneficios();
    CALL InsertarLimites();
    CALL InsertarPlanBase();
    CALL InsertarTransTypes();
    CALL InsertarContexts();
    CALL InsertarCategorias();
    CALL InsertarCategoriasXUsers();
    CALL InsertarPerfilesBusqueda();
    CALL InsertarFotos();
    CALL InsertarPlanesXBeneficios();
    CALL InsertarTiposBitacora();
    CALL InsertarSeveridad();
    CALL InsertarEntityTypes();
    CALL InsertarAplicaciones();
    CALL InsertarTraducciones();
END //
delimiter ;

CALL Filldata();

DROP PROCEDURE IF EXISTS InsertarGeneros;
DROP PROCEDURE IF EXISTS InsertarUsuarios;
DROP PROCEDURE IF EXISTS InsertarContrasenas;
DROP PROCEDURE IF EXISTS InsertarTiposAcciones;
DROP PROCEDURE IF EXISTS InsertarIdiomas;
DROP PROCEDURE IF EXISTS InsertarContextos;
DROP PROCEDURE IF EXISTS InsertarLocalizaciones;
DROP PROCEDURE IF EXISTS InsertarEstadosPago;
DROP PROCEDURE IF EXISTS InsertarTipoPagos;
DROP PROCEDURE IF EXISTS InsertarMerchants;
DROP PROCEDURE IF EXISTS InsertarIntereses;
DROP PROCEDURE IF EXISTS InsertarInteresesXUsuario;
DROP PROCEDURE IF EXISTS InsertarRecurrences;
DROP PROCEDURE IF EXISTS InsertarPlanes;
DROP PROCEDURE IF EXISTS InsertarBeneficios;
DROP PROCEDURE IF EXISTS InsertarLimites;
DROP PROCEDURE IF EXISTS InsertarPlanBase;
DROP PROCEDURE IF EXISTS InsertarTransTypes;
DROP PROCEDURE IF EXISTS InsertarContexts;
DROP PROCEDURE IF EXISTS InsertarCategorias;
DROP PROCEDURE IF EXISTS InsertarCategoriasXUsers;
DROP PROCEDURE IF EXISTS InsertarPerfilesBusqueda;
DROP PROCEDURE IF EXISTS InsertarFotos;
DROP PROCEDURE IF EXISTS InsertarPlanesXBeneficios;
DROP PROCEDURE IF EXISTS InsertarTiposBitacora;
DROP PROCEDURE IF EXISTS InsertarSeveridad;
DROP PROCEDURE IF EXISTS InsertarEntityTypes;
DROP PROCEDURE IF EXISTS InsertarAplicaciones;
DROP PROCEDURE IF EXISTS InsertarTraducciones;

