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


select UsersXCategorias.categoriaid,Categorias.name_categoria,
case
   when 350 < count(*)  then 'Muy usada'
when 300 < count(*) and count(*) < 350 then 'Medio usada'
else 'Poco usada'
end AS 'Frecuencia'
,count(*)
FROM UsersXCategorias INNER JOIN Categorias ON UsersXCategorias.categoriaid = Categorias.categoriaid
Group by UsersXCategorias.categoriaid, Categorias.name_categoria;

select distinct UsersXCategorias.categoriaid,Categorias.name_categoria,UsersAccounts.nombre
FROM UsersXCategorias INNER JOIN Categorias ON UsersXCategorias.categoriaid = Categorias.categoriaid
inner join UsersAccounts on UsersXCategorias.userid =  UsersAccounts.userid
order by 2, 3;

select
t0.nombre, t1.nombre,
(
    select count(*)
    from UsersXCategorias c0
    where c0.categoriaid in (
        select c1.categoriaid
        from UsersXCategorias c1
        where c1.userid = t1.userid 
    )
) AS 'Compatible'
from
    UsersAccounts t0, UsersAccounts t1 
where t0.userid <> t1.userid;

-- volumen de uso 

SELECT SUM(Cantidad_Users) FROM (SELECT Tipoacciones.name_tipoaccion,COUNT(Acciones.accionid) AS 'Cantidad_Users'
FROM UsersAccounts INNER JOIN Acciones ON UsersAccounts.userid = Acciones.userid
INNER JOIN Tipoacciones ON Acciones.tipoaccionid = Tipoacciones.tipoaccionid
GROUP BY Tipoacciones.name_tipoaccion) AS Suma_cantidad_Users WHERE Accciones.posttime BETWEEN;

SELECT posttime FROM Acciones;
SET @volumen = 'bajo'
IF 


