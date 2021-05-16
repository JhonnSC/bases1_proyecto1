use mydb;
-- consulta de 3 tablas

SELECT * FROM UsersAccounts;
SELECT * FROM Acciones;
SELECT * FROM Tipoacciones;

DROP PROCEDURE IF EXISTS Consulta3Tablas;
delimiter //

CREATE PROCEDURE Consulta3tablas()
BEGIN
	SELECT Tipoacciones.name_tipoaccion,COUNT(Acciones.accionid) AS 'Cantidad_Users'
    FROM UsersAccounts INNER JOIN Acciones ON UsersAccounts.userid = Acciones.userid
					   INNER JOIN Tipoacciones ON Acciones.tipoaccionid = Tipoacciones.tipoaccionid
                       
	GROUP BY Tipoacciones.name_tipoaccion;
END //

delimiter ;
call Consulta3Tablas();

-- columna dinámica
SELECT * FROM InteresesDeUsuario;
SELECT * FROM UsersXIntereses;
SELECT * FROM UsersAccounts;
SELECT * FROM Categorias;
SELECT * FROM UsersXCategorias;

SELECT userid FROM UsersAccounts;
SELECT categoryid FROM Categorias;
SELECT userid FROM UsersAccounts;

SELECT COUNT(*) FROM UsersXCategorias GROUP BY categoriaid;




-- volumen de uso 

SELECT SUM(Cantidad_Users) FROM (SELECT Tipoacciones.name_tipoaccion,COUNT(Acciones.accionid) AS 'Cantidad_Users'
FROM UsersAccounts INNER JOIN Acciones ON UsersAccounts.userid = Acciones.userid
INNER JOIN Tipoacciones ON Acciones.tipoaccionid = Tipoacciones.tipoaccionid
GROUP BY Tipoacciones.name_tipoaccion) AS Suma_cantidad_Users;





