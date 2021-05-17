use mydb;
-- trigger para insertar fotos de acciones en la bitacora
DROP TRIGGER IF EXISTS actualizarUsername;
DELIMITER //
CREATE TRIGGER actualizarUsername
AFTER INSERT ON Fotos 
FOR EACH ROW 
BEGIN
	SELECT fotoid INTO @fotoid_aux FROM Fotos WHERE Fotos.fotoid=NEW.fotoid LIMIT 1;
	SET @fecha_aux = (SELECT Fecha FROM Fotos WHERE Fotos.fotoid=@fotoid_aux);
	SET @usuario= (SELECT userid FROM Fotos WHERE Fotos.fotoid=@fotoid_aux);
	SET @nombreusuario=(SELECT username FROM UsersAccounts WHERE userid=@usuario);
    
    SET @checksuma = SHA2(@nombreusuario, 224);

    INSERT INTO Bitacoras(fecha,Descripcion,devicename,username,IP, refId1, oldValue,newValue,
                cheksum,SeveridadId,EntityTypesId,TiposBitacoraId,AplicacionFuenteId)
                VALUES
                (@fecha_aux,'Inserción de Foto','Dispositivo Mobil',@nombreusuario,'172.16.0.0', @fotoid_aux,
                0,0,@checksuma,4,1,8,8);
END //
DELIMITER ;

select * from Bitacoras;

select * from Fotos;

CALL InsertarFotosUsuarios(5, 'Manuel1410');

-- substring para crear usernames automaticamente
DROP PROCEDURE IF EXISTS RegistrarUsuario;
delimiter //
CREATE PROCEDURE RegistrarUsuario(nombre varchar(100),segundonombre varchar(100),apellido1 varchar(100),apellido2 varchar(100),email varchar(100),fechanacimiento datetime,summary varchar(100),fechacreacion datetime,activo BIT,generoid tinyint)
BEGIN 
	
    DECLARE fechaformat varchar(100);
    DECLARE concatenado varchar(100);
    DECLARE num int;
    SET fechaformat = (substring(fechanacimiento,6,6)); 
	
    SET @mesdia = (SELECT(substring(fechanacimiento, 6,5)));

	SET @dia = (SELECT(substring(@mesdia, 4,2)));

	SET @mes = (SELECT(substring(@mesdia, 1,2)));

	SET num = (SELECT CONCAT(@mes, @dia));
    
    SET concatenado = CONCAT(nombre,num);

	
		
	INSERT INTO UsersAccounts(nombre, segundonombre, apellido1, apellido2, username, email, fechanacimiento, summary, fechacreacion, activo, generoid) 
    VALUES 
	(nombre,segundonombre,apellido1,apellido2,concatenado,email,fechanacimiento,summary,fechacreacion,activo,generoid);
    
    SELECT * FROM UsersAccounts;
    
END //
delimiter ;
CALL RegistrarUsuario('Sara', 'Catalina', 'Pandoja', 'Araya', 'Emilia1015@gmail.com', '2000-11-14', 'Descripción', CURDATE(), 1, 2);
