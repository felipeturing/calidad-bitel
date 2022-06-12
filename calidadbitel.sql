-- felipeturing

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema calidadbitel
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema calidadbitel
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `calidadbitel` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `calidadbitel` ;

-- -----------------------------------------------------
-- Table `calidadbitel`.`Branch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `calidadbitel`.`Branch` (
  `identidad` INT NOT NULL AUTO_INCREMENT,
  `codigo` CHAR(6) NOT NULL,
  `descripcion` VARCHAR(100) NULL,
  PRIMARY KEY (`identidad`),
  UNIQUE INDEX `codigo_UNIQUE` (`codigo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `calidadbitel`.`Sucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `calidadbitel`.`Sucursal` (
  `identidad` INT NOT NULL AUTO_INCREMENT,
  `identidadBranch` INT NOT NULL,
  `codigo` CHAR(6) NOT NULL,
  `descripcion` VARCHAR(100) NULL,
  PRIMARY KEY (`identidad`),
  UNIQUE INDEX `codigo_UNIQUE` (`codigo` ASC) VISIBLE,
  INDEX `fk_Sucursal_Branch_idx` (`identidadBranch` ASC) VISIBLE,
  CONSTRAINT `fk_Sucursal_Branch`
    FOREIGN KEY (`identidadBranch`)
    REFERENCES `calidadbitel`.`Branch` (`identidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `calidadbitel`.`Tienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `calidadbitel`.`Tienda` (
  `identidad` INT NOT NULL AUTO_INCREMENT,
  `identidadSucursal` INT NOT NULL,
  `descripcion` VARCHAR(100) NULL,
  `codigo` CHAR(6) NOT NULL,
  `direccion` VARCHAR(150) NOT NULL,
  `tipo` INT NULL COMMENT 'Se entiendo por tipos de una \"tienda\".\n1. ST = Store\n2. CD = Cad Dealer',
  `configuracion` INT NULL,
  `instante` INT NOT NULL,
  INDEX `fk_Tienda_Sucursal1_idx` (`identidadSucursal` ASC) VISIBLE,
  UNIQUE INDEX `codigo_UNIQUE` (`codigo` ASC) VISIBLE,
  PRIMARY KEY (`identidad`),
  CONSTRAINT `fk_Tienda_Sucursal1`
    FOREIGN KEY (`identidadSucursal`)
    REFERENCES `calidadbitel`.`Sucursal` (`identidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Tienda de Bitel.';


-- -----------------------------------------------------
-- Table `calidadbitel`.`Bloque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `calidadbitel`.`Bloque` (
  `identidad` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`identidad`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `calidadbitel`.`Requerimiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `calidadbitel`.`Requerimiento` (
  `identidad` INT NOT NULL AUTO_INCREMENT,
  `identidadBloque` INT NULL,
  `codigo` VARCHAR(6) NOT NULL COMMENT 'R<indentidad>',
  `criterio` VARCHAR(500) NOT NULL,
  `apertura` INT NULL COMMENT '1 = Desde la apertura del público.\n2= Previa al apertura al público. \n3= Después de la apertura al público.\n',
  `regulador` INT NULL,
  `instante` INT NOT NULL,
  PRIMARY KEY (`identidad`),
  INDEX `fk_Requerimiento_Bloque1_idx` (`identidadBloque` ASC) VISIBLE,
  CONSTRAINT `fk_Requerimiento_Bloque1`
    FOREIGN KEY (`identidadBloque`)
    REFERENCES `calidadbitel`.`Bloque` (`identidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `calidadbitel`.`Analista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `calidadbitel`.`Analista` (
  `identidad` INT NOT NULL AUTO_INCREMENT,
  `usuario` VARCHAR(45) NOT NULL,
  `hash` CHAR(64) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`identidad`),
  UNIQUE INDEX `usuario_UNIQUE` (`usuario` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `calidadbitel`.`EvaluacionTienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `calidadbitel`.`EvaluacionTienda` (
  `identidad` INT NOT NULL AUTO_INCREMENT,
  `identidadTienda` INT NOT NULL,
  `identidadAnalista` INT NOT NULL,
  `instante` INT NOT NULL,
  `tiempo` INT NOT NULL,
  `configuracion` INT NULL,
  `ticketera` VARCHAR(100) NOT NULL,
  `revistero` INT NULL,
  `evidencia` VARCHAR(200) NULL,
  `observacion` VARCHAR(100) NULL,
  PRIMARY KEY (`identidad`),
  INDEX `fk_EvaluacionTienda_Tienda1_idx` (`identidadTienda` ASC) VISIBLE,
  INDEX `fk_EvaluacionTienda_Analista1_idx` (`identidadAnalista` ASC) VISIBLE,
  CONSTRAINT `fk_EvaluacionTienda_Tienda1`
    FOREIGN KEY (`identidadTienda`)
    REFERENCES `calidadbitel`.`Tienda` (`identidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EvaluacionTienda_Analista1`
    FOREIGN KEY (`identidadAnalista`)
    REFERENCES `calidadbitel`.`Analista` (`identidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `calidadbitel`.`DetalleEvaluacionTienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `calidadbitel`.`DetalleEvaluacionTienda` (
  `identidad` INT NOT NULL AUTO_INCREMENT,
  `identidadEvaluacionTienda` INT NOT NULL,
  `identidadRequerimiento` INT NOT NULL,
  `calificacion` INT NOT NULL COMMENT 'Puede ser 1 = OK o  0 = NOK o 2 = NA. \nNA = No aplica. \nNOK = No ok. ',
  `observacion` VARCHAR(200) NULL,
  INDEX `fk_EvaluacionTienda_has_Requerimiento_Requerimiento1_idx` (`identidadRequerimiento` ASC) VISIBLE,
  INDEX `fk_EvaluacionTienda_has_Requerimiento_EvaluacionTienda1_idx` (`identidadEvaluacionTienda` ASC) VISIBLE,
  PRIMARY KEY (`identidad`),
  CONSTRAINT `fk_EvaluacionTienda_has_Requerimiento_EvaluacionTienda1`
    FOREIGN KEY (`identidadEvaluacionTienda`)
    REFERENCES `calidadbitel`.`EvaluacionTienda` (`identidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EvaluacionTienda_has_Requerimiento_Requerimiento1`
    FOREIGN KEY (`identidadRequerimiento`)
    REFERENCES `calidadbitel`.`Requerimiento` (`identidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
