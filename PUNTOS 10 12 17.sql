use mydb;
-- consulta de 3 tablas CantidadUsersXAccion

DROP PROCEDURE IF EXISTS CantidadUsersXAccion;
delimiter //

CREATE PROCEDURE CantidadUsersXAccion()
BEGIN
	SELECT Tipoacciones.name_tipoaccion,COUNT(Acciones.accionid) AS 'Cantidad_Users'
    FROM UsersAccounts INNER JOIN Acciones ON UsersAccounts.userid = Acciones.userid
					   INNER JOIN Tipoacciones ON Acciones.tipoaccionid = Tipoacciones.tipoaccionid
                       
	GROUP BY Tipoacciones.name_tipoaccion;
    
END //

delimiter ;
call CantidadUsersXAccion();


-- columna dinámica agrupar grupos de datos


-- frecuencia de uso de categorias
SELECT UsersXCategorias.categoriaid,Categorias.name_categoria,
CASE
   WHEN 350 < count(*)  THEN 'Muy usada'
WHEN 300 < count(*) AND count(*) < 350 THEN 'Medio usada'
ELSE 'Poco usada'
END AS 'Frecuencia'
,COUNT(*)
FROM UsersXCategorias INNER JOIN Categorias ON UsersXCategorias.categoriaid = Categorias.categoriaid
GROUP BY UsersXCategorias.categoriaid, Categorias.name_categoria;
-- 2 usuarios agrupados
SELECT distinct UsersXCategorias.categoriaid,Categorias.name_categoria,UsersAccounts.nombre
FROM UsersXCategorias INNER JOIN Categorias ON UsersXCategorias.categoriaid = Categorias.categoriaid
INNER JOIN UsersAccounts ON UsersXCategorias.userid =  UsersAccounts.userid
ORDER BY 2, 3;
-- 3 compatibilidad
SELECT
t0.nombre, t1.nombre,
(
    SELECT count(*)
    FROM UsersXCategorias c0
    WHERE c0.categoriaid in (
        SELECT c1.categoriaid
        FROM UsersXCategorias c1
        WHERE c1.userid = t1.userid 
    )
) AS 'Compatible'
FROM
    UsersAccounts t0, UsersAccounts t1 
WHERE t0.userid <> t1.userid;

-- volumen de uso 
DROP PROCEDURE IF EXISTS Volumen;
delimiter //

CREATE PROCEDURE Volumen()
BEGIN
	DECLARE cant int;
    DECLARE vol varchar(100);
    SET cant = (SELECT SUM(Cantidad_Users) FROM (SELECT Tipoacciones.name_tipoaccion,COUNT(Acciones.accionid) AS 'Cantidad_Users'
	FROM UsersAccounts INNER JOIN Acciones ON UsersAccounts.userid = Acciones.userid
	INNER JOIN Tipoacciones ON Acciones.tipoaccionid = Tipoacciones.tipoaccionid
	GROUP BY Tipoacciones.name_tipoaccion) AS Suma_cantidad_Users);
    
    SET vol = 'bajo';
	IF cant < 30
	THEN 
	SET vol = 'bajo';
	END IF;
	IF cant > 30 THEN SET vol = 'alto';
    END IF;
        
        
	
	IF cant = 30 THEN SET vol = 'medio';
	END IF;
    
    SELECT vol;

	
END //
delimiter ;
CALL Volumen();


