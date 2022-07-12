-- MySQL dump 10.19  Distrib 10.3.31-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: calidadbitel
-- ------------------------------------------------------
-- Server version	10.3.31-MariaDB-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `calidadbitel`
--

DROP DATABASE IF EXISTS `calidadbitel`;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `calidadbitel` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `calidadbitel`;

--
-- Table structure for table `analista`
--

DROP TABLE IF EXISTS `analista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analista` (
  `identidad` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(45) NOT NULL,
  `hash` char(64) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`identidad`),
  UNIQUE KEY `usuario_UNIQUE` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analista`
--

LOCK TABLES `analista` WRITE;
/*!40000 ALTER TABLE `analista` DISABLE KEYS */;
INSERT INTO `analista` VALUES (1,'c.bautista@bitel.com.pe','$2y$10$yUZnuSgefrWPM3226OeLVeo8RFFlIFfcWcM8CUB032KwimeJqpKzO','C. Bautista'),(2,'felipe@bitel.com.pe','$2y$10$yYMjh1T6yaS1QKTJSXDXduH5PkPRE/JSLT/pL.Bi9AK5539BD/Z2u','Felipe Turing'),(3,'ggm@bitel.com.pe','$2y$10$r69b70YvV6bMo0HE3kvAZe7/6BFWJFnRNRyQ6gIDaX64b9sEg9Nbu','Mr. GGM'),(4,'demonio@bitel.com.pe','$2y$10$ZCnKNS5O36aoqnDHz2080OemI/5lKII5ld99SmjCyeMtRjciJcrBO','Sr. Demo');
/*!40000 ALTER TABLE `analista` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bloque`
--

DROP TABLE IF EXISTS `bloque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bloque` (
  `identidad` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`identidad`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bloque`
--

LOCK TABLES `bloque` WRITE;
/*!40000 ALTER TABLE `bloque` DISABLE KEYS */;
INSERT INTO `bloque` VALUES (1,'Letrero'),(2,'Pared exterior'),(3,'Puerta y ventana'),(4,'Puerta enrollable'),(5,'Acera'),(6,'Parante de standee publicitario'),(7,'Techo'),(8,'Pared interior'),(9,'Módulo de atención'),(10,'Pisos'),(11,'Pantalla de TV'),(12,'Cesto de basura'),(13,'Publicidad y decoración'),(14,'Backdrop - cartel corpóreo dentro de la tienda'),(15,'Impresora y fotocopiadora'),(16,'Lector biométrico'),(17,'Mesa de experiencia o vitrina de exhibición'),(18,'Pin pad o POS'),(19,'Iluminación y electricidad'),(20,'SSHH'),(21,'Ventilación y aire acondicionado'),(22,'Personal en tienda');
/*!40000 ALTER TABLE `bloque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branch` (
  `identidad` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` char(6) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`identidad`),
  UNIQUE KEY `codigo_UNIQUE` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,'ANCBR','Ancash'),(2,'AREBR','Arequipa'),(3,'AYABR','Ayacucho'),(4,'CAJBR','Cajamarca'),(5,'CUSBR','Cusco'),(6,'HUNBR','Huanuco'),(7,'ICABR','Ica'),(8,'JUNBR','Junin'),(9,'LALBR','La Libertad'),(10,'LAMBR','Lambayeque'),(11,'LI1BR','Lima 1'),(12,'LI2BR','Lima 2'),(13,'LI3BR','Lima 3'),(14,'LI4BR','Lima 4'),(15,'LORBR','Loreto'),(16,'PIUBR','Piura'),(17,'PUNBR','Puno'),(18,'SANBR','San Martin'),(19,'TACBR','Tacna');
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalleevaluaciontienda`
--

DROP TABLE IF EXISTS `detalleevaluaciontienda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `detalleevaluaciontienda` (
  `identidad` int(11) NOT NULL AUTO_INCREMENT,
  `identidadEvaluacionTienda` int(11) NOT NULL,
  `identidadRequerimiento` int(11) NOT NULL,
  `calificacion` int(11) NOT NULL COMMENT 'Puede ser 1 = OK o  0 = NOK o 2 = NA. \nNA = No aplica. \nNOK = No ok. ',
  `observacion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`identidad`),
  KEY `fk_EvaluacionTienda_has_Requerimiento_Requerimiento1_idx` (`identidadRequerimiento`),
  KEY `fk_EvaluacionTienda_has_Requerimiento_EvaluacionTienda1_idx` (`identidadEvaluacionTienda`),
  CONSTRAINT `fk_EvaluacionTienda_has_Requerimiento_EvaluacionTienda1` FOREIGN KEY (`identidadEvaluacionTienda`) REFERENCES `evaluaciontienda` (`identidad`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_EvaluacionTienda_has_Requerimiento_Requerimiento1` FOREIGN KEY (`identidadRequerimiento`) REFERENCES `requerimiento` (`identidad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalleevaluaciontienda`
--

LOCK TABLES `detalleevaluaciontienda` WRITE;
/*!40000 ALTER TABLE `detalleevaluaciontienda` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalleevaluaciontienda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluaciontienda`
--

DROP TABLE IF EXISTS `evaluaciontienda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `evaluaciontienda` (
  `identidad` int(11) NOT NULL AUTO_INCREMENT,
  `identidadTienda` int(11) NOT NULL,
  `identidadAnalista` int(11) NOT NULL,
  `instante` int(11) NOT NULL,
  `tiempo` int(11) NOT NULL,
  `configuracion` int(11) DEFAULT NULL,
  `ticketera` varchar(100) NOT NULL,
  `revistero` int(11) DEFAULT NULL,
  `evidencia` varchar(200) DEFAULT NULL,
  `observacion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`identidad`),
  KEY `fk_EvaluacionTienda_Tienda1_idx` (`identidadTienda`),
  KEY `fk_EvaluacionTienda_Analista1_idx` (`identidadAnalista`),
  CONSTRAINT `fk_EvaluacionTienda_Analista1` FOREIGN KEY (`identidadAnalista`) REFERENCES `analista` (`identidad`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_EvaluacionTienda_Tienda1` FOREIGN KEY (`identidadTienda`) REFERENCES `tienda` (`identidad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluaciontienda`
--

LOCK TABLES `evaluaciontienda` WRITE;
/*!40000 ALTER TABLE `evaluaciontienda` DISABLE KEYS */;
/*!40000 ALTER TABLE `evaluaciontienda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requerimiento`
--

DROP TABLE IF EXISTS `requerimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requerimiento` (
  `identidad` int(11) NOT NULL AUTO_INCREMENT,
  `identidadBloque` int(11) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `criterio` varchar(500) NOT NULL,
  `apertura` int(11) DEFAULT NULL COMMENT '1 = Desde la apertura del p├║blico.\n2= Previa al apertura al p├║blico. \n3= Despu├®s de la apertura al p├║blico.\n',
  `regulador` int(11) DEFAULT NULL,
  `instante` int(11) NOT NULL,
  `imagen` int(11) DEFAULT NULL,
  PRIMARY KEY (`identidad`),
  KEY `fk_Requerimiento_Bloque1_idx` (`identidadBloque`),
  CONSTRAINT `fk_Requerimiento_Bloque1` FOREIGN KEY (`identidadBloque`) REFERENCES `bloque` (`identidad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requerimiento`
--

LOCK TABLES `requerimiento` WRITE;
/*!40000 ALTER TABLE `requerimiento` DISABLE KEYS */;
INSERT INTO `requerimiento` VALUES (1,1,'Letrero exterior','Sin Luz, Luz averiada, Se enciende de acuerdo con el tiempo regulado.Sin Grietas, Cables sueltos, tiene riesgo de accidente. Limpio, sin manchas y/o suciedad.',1,5,1656127194,0),(2,2,'Color y diseño correcto en pared exterior','Color de acuerdo a la regla de identificación Bitel, excepto por disposición de Municipalidad.',1,3,1656127194,0),(3,2,'No debe haber Avería y/o  Desperfecto de Letrero Exterior','Sin Luz, Luz averiada, Se enciende de acuerdo con el tiempo regulado.Sin Grietas, Cables sueltos, Riesgo de accidente.',1,5,1656127194,0),(4,2,'Sin Anuncios No Permitidos en Pared Exterior','No debe tener Anuncios no permitidos.',1,2,1656127194,0),(5,7,'Techo sin desperfecto','No debe haber Grietas, Rotos, Desgastado.',1,3,1656127194,1),(6,7,'Techo sin suciedad','No debe haber Suciedad, Manchas, Polvo, Huellas de Pegamento, Despintado, Grasa, etc.',1,5,1656127194,1);
/*!40000 ALTER TABLE `requerimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sucursal`
--

DROP TABLE IF EXISTS `sucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sucursal` (
  `identidad` int(11) NOT NULL AUTO_INCREMENT,
  `identidadBranch` int(11) NOT NULL,
  `codigo` char(6) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`identidad`),
  UNIQUE KEY `codigo_UNIQUE` (`codigo`),
  KEY `fk_Sucursal_Branch_idx` (`identidadBranch`),
  CONSTRAINT `fk_Sucursal_Branch` FOREIGN KEY (`identidadBranch`) REFERENCES `branch` (`identidad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursal`
--

LOCK TABLES `sucursal` WRITE;
/*!40000 ALTER TABLE `sucursal` DISABLE KEYS */;
INSERT INTO `sucursal` VALUES (1,1,'SANCBR','Ancash'),(2,2,'SAREBR','Arequipa'),(3,3,'SAYABR','Ayacucho'),(4,4,'SCAJBR','Cajamarca'),(5,5,'SCUSBR','Cusco'),(6,6,'SHUNBR','Huanuco'),(7,7,'SICABR','Ica'),(8,8,'SJUNBR','Junin'),(9,9,'SLALBR','La Libertad'),(10,10,'SLAMBR','Lambayeque'),(11,11,'SLI1BR','Lima 1'),(12,12,'SLI2BR','Lima 2'),(13,13,'SLI3BR','Lima 3'),(14,14,'SLI4BR','Lima 4'),(15,15,'SLORBR','Loreto'),(16,16,'SPIUBR','Piura'),(17,17,'SPUNBR','Puno'),(18,18,'SSANBR','San Martin'),(19,19,'STACBR','Tacna');
/*!40000 ALTER TABLE `sucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda`
--

DROP TABLE IF EXISTS `tienda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda` (
  `identidad` int(11) NOT NULL AUTO_INCREMENT,
  `identidadSucursal` int(11) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `codigo` char(7) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `tipo` int(11) DEFAULT NULL COMMENT 'Se entiendo por tipos de una "tienda".\n1. ST = Store\n2. CD = Cad Dealer',
  `configuracion` int(11) DEFAULT NULL,
  `instante` int(11) NOT NULL,
  PRIMARY KEY (`identidad`),
  UNIQUE KEY `codigo_UNIQUE` (`codigo`),
  KEY `fk_Tienda_Sucursal1_idx` (`identidadSucursal`),
  CONSTRAINT `fk_Tienda_Sucursal1` FOREIGN KEY (`identidadSucursal`) REFERENCES `sucursal` (`identidad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COMMENT='Tienda de Bitel.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda`
--

LOCK TABLES `tienda` WRITE;
/*!40000 ALTER TABLE `tienda` DISABLE KEYS */;
INSERT INTO `tienda` VALUES (1,1,'La zona es de clase baja','ANCCD01','Jr. Daniel Villar 23, Haylas',0,0,1656126421),(2,1,NULL,'ANCCD03',NULL,0,0,1656126421),(3,1,NULL,'ANCCD04',NULL,0,0,1656126421),(4,1,NULL,'ANCCD05',NULL,0,0,1656126421),(5,1,NULL,'HUACD01',NULL,0,0,1656126421),(6,1,NULL,'HUACD02',NULL,0,0,1656126421),(7,1,NULL,'ANCST08',NULL,1,0,1656126421),(8,2,'La supuesta ciudad blanca','ARECD12','Calle Pte. Bolognesi 143 A',0,0,1656126421),(9,2,NULL,'ARECD13',NULL,0,0,1656126421),(10,2,NULL,'ARECD14',NULL,0,0,1656126421),(11,2,NULL,'ARECD16',NULL,0,0,1656126421),(12,2,NULL,'ARECD17',NULL,0,0,1656126421),(13,2,NULL,'ARECD18',NULL,0,0,1656126421),(14,2,NULL,'ARECD19',NULL,0,0,1656126421),(15,2,NULL,'ARECD20',NULL,0,0,1656126421),(16,2,NULL,'AREST05',NULL,1,0,1656126421),(17,2,NULL,'AREST06',NULL,1,0,1656126421),(18,2,NULL,'AREST07',NULL,1,0,1656126421),(19,3,'La primera tienda','AYACD02','Av. Mariscal Cáceres 1255',0,0,1656126421),(20,3,NULL,'AYACD03',NULL,0,0,1656126421),(21,3,NULL,'AYACD04',NULL,0,0,1656126421),(22,3,NULL,'AYACD05',NULL,0,0,1656126421),(23,3,NULL,'AYACD06',NULL,0,0,1656126421),(24,3,NULL,'AYACD07',NULL,0,0,1656126421),(25,3,NULL,'AYACD08',NULL,0,0,1656126421),(26,3,NULL,'AYACD09',NULL,0,0,1656126421),(27,4,NULL,'CAJCD02',NULL,0,0,1656126421),(28,4,NULL,'CAJST04',NULL,1,0,1656126421),(29,4,NULL,'CAJST06',NULL,1,0,1656126421),(30,4,NULL,'CAJST07',NULL,1,0,1656126421),(31,5,NULL,'APUCD03',NULL,0,0,1656126421),(32,5,NULL,'APUCD04',NULL,0,0,1656126421),(33,5,NULL,'CUSCD04',NULL,0,0,1656126421),(34,5,NULL,'CUSCD08',NULL,0,0,1656126421),(35,5,NULL,'CUSCD09',NULL,0,0,1656126421),(36,5,NULL,'CUSCD10',NULL,0,0,1656126421),(37,5,NULL,'CUSCD12',NULL,0,0,1656126421),(38,5,NULL,'CUSCD13',NULL,0,0,1656126421),(39,5,NULL,'CUSCD14',NULL,0,0,1656126421),(40,5,NULL,'CUSCD15',NULL,0,0,1656126421),(41,5,NULL,'CUSCD16',NULL,0,0,1656126421),(42,5,NULL,'CUSCD17',NULL,0,0,1656126421),(43,5,NULL,'CUSST08',NULL,1,0,1656126421);
/*!40000 ALTER TABLE `tienda` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-24 22:27:11
