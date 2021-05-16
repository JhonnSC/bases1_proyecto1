use mydb;
-- Vistas

CREATE VIEW InteresesUsuariosInglés AS 
SELECT caption FROM Traducciones INNER JOIN InteresesDeUsuario ON Traducciones.referenciaid=InteresesDeUsuario.interesusuarioid WHERE contextoid=16 AND idiomaid=1;

CREATE VIEW InteresesUsuariosFrances AS 
SELECT caption FROM Traducciones INNER JOIN InteresesDeUsuario ON Traducciones.referenciaid=InteresesDeUsuario.interesusuarioid WHERE contextoid=16 AND idiomaid=4;

CREATE VIEW PlanesXUsuarioActuales AS 
SELECT nombre, email, titulo FROM PlansxUser INNER JOIN UsersAccounts 
ON PlansxUser.userid=UsersAccounts.userid INNER JOIN Planes ON PlansxUser.planid=Planes.planid WHERE PlansxUser.actual=1;

CREATE VIEW PlanesXUsuarioUsados AS 
SELECT nombre, email, titulo FROM PlansxUser INNER JOIN UsersAccounts 
ON PlansxUser.userid=UsersAccounts.userid INNER JOIN Planes ON PlansxUser.planid=Planes.planid WHERE PlansxUser.actual=0;


CREATE VIEW PlanesInglés AS 
SELECT caption FROM Traducciones INNER JOIN Planes ON
Traducciones.referenciaid=Planes.planid WHERE contextoid=6 AND idiomaid=2;

CREATE VIEW PlanesFrances AS 
SELECT caption FROM Traducciones INNER JOIN Planes ON
Traducciones.referenciaid=Planes.planid WHERE contextoid=6 AND idiomaid=4;

CREATE VIEW PagosAceptados AS
SELECT amount_pago Cantidad_a_Pagar,`description`,name_tipopago Tipo_de_pago
FROM Pagos  INNER JOIN TiposPago ON Pagos.tipopagoid=TiposPago.tipopagoid 
WHERE estadodepagoid=1;

CREATE VIEW PagosRechazados AS
SELECT amount_pago Cantidad_a_Pagar,`description`,name_tipopago Tipo_de_pago
FROM Pagos  INNER JOIN TiposPago ON Pagos.tipopagoid=TiposPago.tipopagoid 
WHERE estadodepagoid=2;

Select * from PagosAceptados

