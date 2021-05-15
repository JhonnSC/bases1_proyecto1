-- MySQL Workbench Synchronization
-- Generated: 2021-05-15 15:52
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Grupo Proyecto

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `mydb`.`UsersAccounts` (
  `userid` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `segundonombre` VARCHAR(100) NULL DEFAULT NULL,
  `apellido1` VARCHAR(100) NOT NULL,
  `apellido2` VARCHAR(100) NULL DEFAULT NULL,
  `username` VARCHAR(30) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `fechanacimiento` DATETIME NOT NULL,
  `summary` VARCHAR(100) NULL DEFAULT NULL,
  `fechacreacion` DATETIME NOT NULL,
  `activo` BIT(1) NOT NULL,
  `generoid` TINYINT(4) NOT NULL,
  INDEX `fk_UsersAccount_género1_idx` (`generoid` ASC),
  PRIMARY KEY (`userid`),
  CONSTRAINT `fk_UsersAccount_género1`
    FOREIGN KEY (`generoid`)
    REFERENCES `mydb`.`Generos` (`generoid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`PerfilBusqueda` (
  `perfilbusquedaid` INT(11) NOT NULL AUTO_INCREMENT,
  `rangodeedadminimo` INT(11) NOT NULL,
  `rangodedadmaximo` INT(11) NOT NULL,
  `generoid` TINYINT(4) NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`perfilbusquedaid`),
  INDEX `fk_PerfilBusqueda_géneros1_idx` (`generoid` ASC),
  INDEX `fk_PerfilBusqueda_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_PerfilBusqueda_géneros1`
    FOREIGN KEY (`generoid`)
    REFERENCES `mydb`.`Generos` (`generoid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PerfilBusqueda_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Fotos` (
  `fotoid` INT(11) NOT NULL AUTO_INCREMENT,
  `URL` VARCHAR(128) NOT NULL,
  `latitud_foto` FLOAT(11) NULL DEFAULT NULL,
  `longitud_foto` FLOAT(11) NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL,
  `Fecha` DATETIME NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`fotoid`),
  INDEX `fk_Fotos_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_Fotos_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Categorias` (
  `categoriaid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_categoria` VARCHAR(100) NOT NULL,
  `deleted` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`categoriaid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`InteresesDeUsuario` (
  `interesusuarioid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_interes` VARCHAR(100) NOT NULL,
  `deleted` BIT(1) NOT NULL,
  PRIMARY KEY (`interesusuarioid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`UsersXIntereses` (
  `userid` INT(11) NOT NULL,
  `interesusuarioid` INT(11) NOT NULL,
  INDEX `fk_UsersXIntereses_InteresesDeUsuario1_idx` (`interesusuarioid` ASC),
  INDEX `fk_UsersXIntereses_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_UsersXIntereses_InteresesDeUsuario1`
    FOREIGN KEY (`interesusuarioid`)
    REFERENCES `mydb`.`InteresesDeUsuario` (`interesusuarioid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsersXIntereses_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`UsersXCategorias` (
  `userid` INT(11) NOT NULL,
  `categoriaid` INT(11) NOT NULL,
  INDEX `fk_UsersXCategorias_Categorias1_idx` (`categoriaid` ASC),
  INDEX `fk_UsersXCategorias_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_UsersXCategorias_Categorias1`
    FOREIGN KEY (`categoriaid`)
    REFERENCES `mydb`.`Categorias` (`categoriaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsersXCategorias_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Planes` (
  `planid` INT(11) NOT NULL AUTO_INCREMENT,
  `description_plan` VARCHAR(200) NOT NULL,
  `amount` FLOAT(11) NOT NULL,
  `starttime` DATETIME NOT NULL,
  `endtime` DATETIME NOT NULL,
  `activo` BIT(1) NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `recurrencetypeid` INT(11) NOT NULL,
  PRIMARY KEY (`planid`),
  INDEX `fk_Planes_RecurrencesTypes1_idx` (`recurrencetypeid` ASC),
  CONSTRAINT `fk_Planes_RecurrencesTypes1`
    FOREIGN KEY (`recurrencetypeid`)
    REFERENCES `mydb`.`RecurrencesTypes` (`recurrencetypeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Beneficios` (
  `beneficioid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_beneficio` VARCHAR(100) NOT NULL,
  `descripcion_beneficio` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`beneficioid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`RecurrencesTypes` (
  `recurrencetypeid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_recurrence` VARCHAR(100) NOT NULL,
  `periodoplan` INT(11) NOT NULL,
  `datepart` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`recurrencetypeid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`PlansxUser` (
  `planxuserid` INT(11) NOT NULL AUTO_INCREMENT,
  `PostTime` DATETIME NOT NULL,
  `NextTime` DATETIME NOT NULL,
  `actual` BIT(1) NOT NULL,
  `planid` INT(11) NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`planxuserid`),
  INDEX `fk_PlansxUser_Planes1_idx` (`planid` ASC),
  INDEX `fk_PlansxUser_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_PlansxUser_Planes1`
    FOREIGN KEY (`planid`)
    REFERENCES `mydb`.`Planes` (`planid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PlansxUser_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Pagos` (
  `pagoid` INT(11) NOT NULL AUTO_INCREMENT,
  `posttime` DATETIME NOT NULL,
  `amount_pago` FLOAT(11) NOT NULL,
  `currencysymbol` VARCHAR(50) NOT NULL,
  `errornumber` INT(11) NULL DEFAULT NULL,
  `merchanttransnumber` INT(11) NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  `referenceid` BIGINT(20) NULL DEFAULT NULL,
  `timestamp` TIMESTAMP NOT NULL,
  `username` VARCHAR(100) NOT NULL,
  `checksum` VARBINARY(480) NOT NULL,
  `estadodepagoid` INT(11) NOT NULL,
  `merchantid` INT(11) NOT NULL,
  `tipopagoid` TINYINT(4) NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`pagoid`),
  INDEX `fk_Pagos_EstadosDePagos1_idx` (`estadodepagoid` ASC),
  INDEX `fk_Pagos_Merchants1_idx` (`merchantid` ASC),
  INDEX `fk_Pagos_TiposPago1_idx` (`tipopagoid` ASC),
  INDEX `fk_Pagos_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_Pagos_EstadosDePagos1`
    FOREIGN KEY (`estadodepagoid`)
    REFERENCES `mydb`.`EstadosDePago` (`estadodepagoid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pagos_Merchants1`
    FOREIGN KEY (`merchantid`)
    REFERENCES `mydb`.`Merchants` (`merchantid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pagos_TiposPago1`
    FOREIGN KEY (`tipopagoid`)
    REFERENCES `mydb`.`TiposPago` (`tipopagoid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pagos_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`EstadosDePago` (
  `estadodepagoid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_estado` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`estadodepagoid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Merchants` (
  `merchantid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_merchant` VARCHAR(100) NOT NULL,
  `URL` VARCHAR(128) NOT NULL,
  `habilitado` BIT(1) NOT NULL,
  `iconoURL` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`merchantid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Idiomas` (
  `idiomaid` SMALLINT(6) NOT NULL AUTO_INCREMENT,
  `name_idioma` VARCHAR(30) NOT NULL,
  `cultura` VARCHAR(6) NULL DEFAULT NULL,
  PRIMARY KEY (`idiomaid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Contexto` (
  `contextoid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_contexto` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`contextoid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Traducciones` (
  `traduccionid` INT(11) NOT NULL AUTO_INCREMENT,
  `traduccioncodigo` VARCHAR(30) NOT NULL,
  `caption` VARCHAR(100) NOT NULL,
  `referenciaid` BIGINT(20) NOT NULL,
  `idiomaid` SMALLINT(6) NOT NULL,
  `contextoid` INT(11) NOT NULL,
  PRIMARY KEY (`traduccionid`),
  INDEX `fk_Traducciones_Idiomas1_idx` (`idiomaid` ASC),
  INDEX `fk_Traducciones_Contexto1_idx` (`contextoid` ASC),
  CONSTRAINT `fk_Traducciones_Idiomas1`
    FOREIGN KEY (`idiomaid`)
    REFERENCES `mydb`.`Idiomas` (`idiomaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traducciones_Contexto1`
    FOREIGN KEY (`contextoid`)
    REFERENCES `mydb`.`Contexto` (`contextoid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Bitacoras` (
  `BitacoraId` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `fecha` DATETIME NOT NULL,
  `Descripcion` VARCHAR(60) NOT NULL,
  `devicename` VARCHAR(60) NOT NULL,
  `username` VARCHAR(100) NOT NULL,
  `IP` VARCHAR(16) NOT NULL,
  `refId1` BIGINT(20) NULL DEFAULT NULL,
  `refId2` BIGINT(20) NULL DEFAULT NULL,
  `oldValue` NVARCHAR(200) NOT NULL,
  `newValue` NVARCHAR(200) NOT NULL,
  `cheksum` VARBINARY(480) NOT NULL,
  `SeveridadId` TINYINT(4) NOT NULL,
  `EntityTypesId` TINYINT(4) NOT NULL,
  `TiposBitacoraId` TINYINT(4) NOT NULL,
  `AplicacionFuenteId` SMALLINT(6) NOT NULL,
  PRIMARY KEY (`BitacoraId`),
  INDEX `fk_Bitacora_Severidad1_idx` (`SeveridadId` ASC),
  INDEX `fk_Bitacora_EntityTypes1_idx` (`EntityTypesId` ASC),
  INDEX `fk_Bitacora_TiposBitacora1_idx` (`TiposBitacoraId` ASC),
  INDEX `fk_Bitacoras_AplicacionFuente1_idx` (`AplicacionFuenteId` ASC),
  CONSTRAINT `fk_Bitacora_Severidad1`
    FOREIGN KEY (`SeveridadId`)
    REFERENCES `mydb`.`Severidad` (`SeveridadId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bitacora_EntityTypes1`
    FOREIGN KEY (`EntityTypesId`)
    REFERENCES `mydb`.`EntityTypes` (`EntityTypesId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bitacora_TiposBitacora1`
    FOREIGN KEY (`TiposBitacoraId`)
    REFERENCES `mydb`.`TiposBitacora` (`TiposBitacoraId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bitacoras_AplicacionFuente1`
    FOREIGN KEY (`AplicacionFuenteId`)
    REFERENCES `mydb`.`AplicacionFuente` (`AplicacionFuenteId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Severidad` (
  `SeveridadId` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `nombre_severidad` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`SeveridadId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`EntityTypes` (
  `EntityTypesId` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `nombre_entity` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`EntityTypesId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`TiposBitacora` (
  `TiposBitacoraId` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `nombre_tipobitacora` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`TiposBitacoraId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`location` (
  `locationid` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `latitud` FLOAT(11) NOT NULL,
  `longitud` FLOAT(11) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `actual` BIT(1) NOT NULL,
  `posttime` DATETIME NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`locationid`),
  INDEX `fk_location_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_location_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Generos` (
  `generoid` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `nombre_genero` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`generoid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Contrasenas` (
  `contraseñaid` INT(11) NOT NULL AUTO_INCREMENT,
  `contraseña` VARBINARY(300) NOT NULL,
  `datetimecontraseña` DATETIME NOT NULL,
  `actual` BIT(1) NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`contraseñaid`),
  INDEX `fk_Contraseñas_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_Contraseñas_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Transactions` (
  `Transactionid` INT(11) NOT NULL AUTO_INCREMENT,
  `posttime` DATETIME NOT NULL,
  `amount` FLOAT(11) NOT NULL DEFAULT 0,
  `description` VARCHAR(100) NOT NULL,
  `merchanttransacction` INT(11) NOT NULL,
  `computername` VARCHAR(100) NOT NULL,
  `username` VARCHAR(100) NOT NULL,
  `checksum` VARBINARY(480) NOT NULL,
  `IP` VARCHAR(16) NOT NULL,
  `refId1` BIGINT(20) NULL DEFAULT NULL,
  `refId2` BIGINT(20) NULL DEFAULT NULL,
  `contextid` INT(11) NOT NULL,
  `transtypesid` INT(11) NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`Transactionid`),
  INDEX `fk_Transactions_contexts1_idx` (`contextid` ASC),
  INDEX `fk_Transactions_TransTypes1_idx` (`transtypesid` ASC),
  INDEX `fk_Transactions_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_Transactions_contexts1`
    FOREIGN KEY (`contextid`)
    REFERENCES `mydb`.`Contexts` (`contextid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transactions_TransTypes1`
    FOREIGN KEY (`transtypesid`)
    REFERENCES `mydb`.`TransTypes` (`transtypesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transactions_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Acciones` (
  `accionid` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `otrousuario` INT(11) NOT NULL,
  `posttime` DATETIME NOT NULL,
  `IP` VARCHAR(16) NOT NULL,
  `checksum` VARBINARY(480) NOT NULL,
  `tipoaccionid` TINYINT(4) NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`accionid`),
  INDEX `fk_Acciones_Tipoacciones1_idx` (`tipoaccionid` ASC),
  INDEX `fk_Acciones_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_Acciones_Tipoacciones1`
    FOREIGN KEY (`tipoaccionid`)
    REFERENCES `mydb`.`Tipoacciones` (`tipoaccionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Acciones_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Tipoacciones` (
  `tipoaccionid` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `name_tipoaccion` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`tipoaccionid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`TransTypes` (
  `transtypesid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_transtype` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`transtypesid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Limites` (
  `limiteid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_limite` VARCHAR(100) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  PRIMARY KEY (`limiteid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`LimitesXBeneficio` (
  `beneficioid` INT(11) NOT NULL,
  `limiteid` INT(11) NOT NULL,
  INDEX `fk_LimitesXBeneficio_Beneficios1_idx` (`beneficioid` ASC),
  INDEX `fk_LimitesXBeneficio_Limites1_idx` (`limiteid` ASC),
  CONSTRAINT `fk_LimitesXBeneficio_Beneficios1`
    FOREIGN KEY (`beneficioid`)
    REFERENCES `mydb`.`Beneficios` (`beneficioid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LimitesXBeneficio_Limites1`
    FOREIGN KEY (`limiteid`)
    REFERENCES `mydb`.`Limites` (`limiteid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Contexts` (
  `contextid` INT(11) NOT NULL AUTO_INCREMENT,
  `name_context` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`contextid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`URLContraseñas` (
  `urlcontraseñaid` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `URL` VARCHAR(128) NOT NULL,
  `posttime` DATETIME NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`urlcontraseñaid`),
  INDEX `fk_URLContraseñas_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_URLContraseñas_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`CategoriasXBusquedas` (
  `categoriaid` INT(11) NOT NULL,
  `perfilbusquedaid` INT(11) NOT NULL,
  INDEX `fk_CategoriasXBusquedas_Categorias1_idx` (`categoriaid` ASC),
  INDEX `fk_CategoriasXBusquedas_PerfilBusqueda1_idx` (`perfilbusquedaid` ASC),
  CONSTRAINT `fk_CategoriasXBusquedas_Categorias1`
    FOREIGN KEY (`categoriaid`)
    REFERENCES `mydb`.`Categorias` (`categoriaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CategoriasXBusquedas_PerfilBusqueda1`
    FOREIGN KEY (`perfilbusquedaid`)
    REFERENCES `mydb`.`PerfilBusqueda` (`perfilbusquedaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Chats` (
  `chatid` INT(11) NOT NULL AUTO_INCREMENT,
  `otrousuario_chat` INT(11) NOT NULL,
  `enable` BIT(1) NOT NULL,
  `userid` INT(11) NOT NULL,
  PRIMARY KEY (`chatid`),
  INDEX `fk_Chats_UsersAccounts1_idx` (`userid` ASC),
  CONSTRAINT `fk_Chats_UsersAccounts1`
    FOREIGN KEY (`userid`)
    REFERENCES `mydb`.`UsersAccounts` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`Mensajes` (
  `mensajeid` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `caption` VARCHAR(200) NOT NULL,
  `posttime` DATETIME NOT NULL,
  `chatid` INT(11) NOT NULL,
  PRIMARY KEY (`mensajeid`),
  INDEX `fk_Mensajes_Chats1_idx` (`chatid` ASC),
  CONSTRAINT `fk_Mensajes_Chats1`
    FOREIGN KEY (`chatid`)
    REFERENCES `mydb`.`Chats` (`chatid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`TiposPago` (
  `tipopagoid` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `name_tipopago` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`tipopagoid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`AplicacionFuente` (
  `AplicacionFuenteId` SMALLINT(6) NOT NULL AUTO_INCREMENT,
  `nombre_aplicacion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`AplicacionFuenteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mydb`.`BeneficiosXPlanes` (
  `planid` INT(11) NOT NULL,
  `beneficioid` INT(11) NOT NULL,
  INDEX `fk_BeneficiosXPlanes_Planes1_idx` (`planid` ASC),
  INDEX `fk_BeneficiosXPlanes_Beneficios1_idx` (`beneficioid` ASC),
  CONSTRAINT `fk_BeneficiosXPlanes_Planes1`
    FOREIGN KEY (`planid`)
    REFERENCES `mydb`.`Planes` (`planid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BeneficiosXPlanes_Beneficios1`
    FOREIGN KEY (`beneficioid`)
    REFERENCES `mydb`.`Beneficios` (`beneficioid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
