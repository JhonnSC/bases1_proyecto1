use mydb;
-- Vistas PUNTO 7 DEL MANUAL

CREATE VIEW InteresesUsuariosInglés AS 
SELECT caption FROM Traducciones INNER JOIN InteresesDeUsuario ON Traducciones.referenciaid=InteresesDeUsuario.interesusuarioid WHERE contextoid=16 AND idiomaid=1;

CREATE VIEW InteresesUsuariosFrances AS 
SELECT caption FROM Traducciones INNER JOIN InteresesDeUsuario ON Traducciones.referenciaid=InteresesDeUsuario.interesusuarioid WHERE contextoid=16 AND idiomaid=4;

CREATE VIEW PlanesXUsuarioActuales AS 
SELECT nombre, email, titulo FROM PlansxUser INNER JOIN UsersAccounts ON PlansxUser.userid=UsersAccounts.userid INNER JOIN Planes ON PlansxUser.planid=Planes.planid WHERE PlansxUser.actual=1;

CREATE VIEW LikesUsers AS 
SELECT userid, otrousuario, posttime FROM Acciones WHERE tipoaccionid=2;

CREATE VIEW SuperLikesUsers AS 
SELECT userid, otrousuario, posttime FROM Acciones WHERE tipoaccionid=3;

CREATE VIEW LikesRemoves AS
SELECT userid, otrousuario, posttime FROM Acciones WHERE (tipoaccionid=4);

