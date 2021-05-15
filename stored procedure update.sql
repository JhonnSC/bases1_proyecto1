use mydb;
-- consulta de 3 tablas

SELECT * FROM UsersAccounts;
SELECT * FROM Acciones;
SELECT * FROM Tipoacciones;

DROP PROCEDURE IF EXISTS Consulta3Tablas;
delimiter //

CREATE PROCEDURE Consulta3tablas()
BEGIN
	SELECT Tipoacciones.name_tipoaccion,COUNT(Acciones.accionid) AS 'Cantidad Users'
    FROM UsersAccounts INNER JOIN Acciones ON UsersAccounts.userid = Acciones.userid
					   INNER JOIN Tipoacciones ON Acciones.tipoaccionid = Tipoacciones.tipoaccionid
                       
	GROUP BY Tipoacciones.name_tipoaccion;
END //

delimiter ;
call Consulta3Tablas();

-- cursor,trigger,substring 





