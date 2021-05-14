use mydb;

SELECT * FROM UsersAccounts;
SELECT * FROM Acciones;
SELECT * FROM Tipoacciones;

DELIMITER &&
CREATE PROCEDURE sp3tablas();
BEGIN
	SELECT Tipoacciones.name_tipoaccion, COUNT(Acciones.accionid) AS 'Cant Users'
    FROM UsersAccounts INNER JOIN Acciones ON UsersAccounts.userid = Acciones.userid
					   INNER JOIN Tipoacciones ON Acciones.tipoaccionid = Tipoacciones.tipoaccionid
                       
	GROUP BY Tipoacciones.name_tipoaccion
    END
$$
DELIMITER ;
call sp3tablas;






