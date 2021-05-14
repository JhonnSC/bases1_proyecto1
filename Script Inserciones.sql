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
    ('Quitar Like');
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
    ('Incluye 10 likes diarios no incluye Super Likes, no puede deshacer likes, incluye 100 descartes diarios', 0, CURDATE(), '2099-12-31', 1, 'Plan Gratis', 1),
    ('Incluye 15 likes y 5 Super Likes diarios, puede deshacer 3 Likes al día e incluye descartes ilimitados', 1000, CURDATE(), '2099-12-31', 1, 'Plan Premium 1.0 (Mensual)', 2),
	('Incluye 15 likes y 5 Super Likes diarios, puede deshacer 3 Likes al día e incluye descartes ilimitados', 10000, CURDATE(), '2099-12-31', 1, 'Plan Premium 1.0 (Anual)', 3),
    ('Incluye 20 likes y 10 Super Likes diarios, puede deshacer 5 likes al día e incluye descartes ilimitados', 5000, CURDATE(), '2099-12-31', 1, 'Plan Premium 2.0 (Mensual)', 2),
    ('Incluye 20 likes y 10 Super Likes diarios, puede deshacer 5 likes al día e incluye descartes ilimitados', 50000, CURDATE(), '2099-12-31', 1, 'Plan Premium 2.0 (Anual)', 3),
    ('Incluye Likes y Super Likes ilimitados, puede deshacer hasta 10 likes al día e incluye descartes ilimitados', 10000, CURDATE(), '2099-12-31', 1, 'Plan Premium 3.0 (Mensual)', 2),
	('Incluye Likes y Super Likes ilimitados, puede deshacer hasta 10 likes al día e incluye descartes ilimitados', 100000, CURDATE(), '2099-12-31', 1,'Plan Premium 3.0 (Anual)', 3),
	('Incluye 15 Likes y 10 Super Likes, puede deshacer 3 Likes al día e incluye descartes ilimitados (SOLO POR TIMEPO LIMITADO)', 2000, CURDATE(), '2021-06-01', 1, 'Plan Oferta', 1);
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
    ('Cero', 0),
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

    DECLARE beneficio INT;
    DECLARE maxbeneficio INT;
    DECLARE plan INT;
    
    SET beneficio = 1;
    SET plan = 1;
    SET maxbeneficio = (SELECT MAX(beneficioid) FROM Beneficios);
    ciclo: LOOP
    
		IF plan = (SELECT MAX(planid) FROM Planes)+1 THEN
			LEAVE ciclo;
		END IF;
    
		WHILE beneficio <= maxbeneficio DO
		INSERT INTO BeneficiosXPlanes(planid, beneficioid)
		VALUES 
		(plan, beneficio);
		SET beneficio = beneficio+1;
        END WHILE;
        
        SET beneficio = 1;
		SET plan = plan+1;
        
    END LOOP ciclo;
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarLimitesXBeneficio;
delimiter //

CREATE PROCEDURE InsertarLimitesXBeneficio()
BEGIN
	
    DECLARE beneficio INT;
    DECLARE maxbeneficio INT;
    DECLARE limite INT;
    
    SET beneficio = 1;
    SET limite = 1;
    SET maxbeneficio = (SELECT MAX(beneficioid) FROM Beneficios);
    ciclo: LOOP
    
		IF limite = (SELECT MAX(limiteid) FROM Limites)+1 THEN
			LEAVE ciclo;
		END IF;
    
		WHILE beneficio <= maxbeneficio DO
		INSERT INTO LimitesXBeneficio(beneficioid, limiteid)
		VALUES 
		(beneficio, limite);
		SET beneficio = beneficio+1;
        END WHILE;
        
        SET beneficio = 1;
		SET limite = limite+1;
        
    END LOOP ciclo;
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarTiposBitacora;
delimiter //

CREATE PROCEDURE InsertarTiposBitacora()
BEGIN
	INSERT INTO TiposBitacora(nombre_tipobitacora)
    VALUES
    ('Información'),
    ('Error'),
    ('Actualización');
END //
delimiter ;

DROP PROCEDURE IF EXISTS InsertarSeveridad;
delimiter //

CREATE PROCEDURE InsertarSeveridad()
BEGIN
	INSERT INTO Severidad(nombre_severidad)
    VALUES
    ('Leve'),
    ('Moderado'),
    ('Grave'),
    ('Muy Grave');
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
    ('Aplicación Web'),
    ('APlicación Móbil');
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
    CALL InsertarLimitesXBeneficio();
    CALL InsertarTiposBitacora();
    CALL InsertarSeveridad();
    CALL InsertarEntityTypes();
    CALL InsertarAplicaciones();
    
END //
delimiter ;

CALL Filldata();
