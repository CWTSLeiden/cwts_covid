-- MySQL Script generated by MySQL Workbench
-- Fri Mar 27 14:38:01 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema projectdb_covid
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `projectdb_covid` ;

-- -----------------------------------------------------
-- Schema projectdb_covid
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `projectdb_covid` DEFAULT CHARACTER SET utf8 ;
USE `projectdb_covid` ;

-- -----------------------------------------------------
-- Table `projectdb_covid`.`pub`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projectdb_covid`.`pub` ;

CREATE TABLE IF NOT EXISTS `projectdb_covid`.`pub` (
  `pub_id` INT NOT NULL,
  `title` VARCHAR(2048) NULL,
  `abstract` MEDIUMTEXT NULL,
  `publication_year` INT NULL,
  `publication_month` INT NULL,
  `journal` VARCHAR(500) NULL,
  `volume` VARCHAR(100) NULL,
  `issue` VARCHAR(100) NULL,
  `pages` VARCHAR(100) NULL,
  `doi` VARCHAR(255) NULL,
  `pmid` INT NULL,
  `pmcid` VARCHAR(100) NULL,
  `timestamp` DATETIME NULL,
  PRIMARY KEY (`pub_id`),
  FULLTEXT INDEX `title` (`title` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projectdb_covid`.`cord19_metadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projectdb_covid`.`cord19_metadata` ;

CREATE TABLE IF NOT EXISTS `projectdb_covid`.`cord19_metadata` (
  `cord19_metadata_id` INT NOT NULL,
  `source` VARCHAR(45) NULL,
  `license` VARCHAR(45) NULL,
  `full_text_file` VARCHAR(45) NULL,
  `ms_academic_id` VARCHAR(45) NULL,
  `who_covidence` VARCHAR(45) NULL,
  `sha` VARCHAR(500) NULL,
  `full_text` MEDIUMTEXT NULL,
  `pub_id` INT NOT NULL,
  INDEX `fk_cord19_metadata_pub_idx` (`pub_id` ASC),
  PRIMARY KEY (`cord19_metadata_id`),
  CONSTRAINT `fk_cord19_metadata_pub`
    FOREIGN KEY (`pub_id`)
    REFERENCES `projectdb_covid`.`pub` (`pub_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projectdb_covid`.`dimensions_metadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projectdb_covid`.`dimensions_metadata` ;

CREATE TABLE IF NOT EXISTS `projectdb_covid`.`dimensions_metadata` (
  `dimensions_metadata_id` INT NOT NULL,
  `publication_id` VARCHAR(45) NULL,
  `source_uid` VARCHAR(45) NULL,
  `open_access` VARCHAR(255) NULL,
  `publication_type` VARCHAR(100) NULL,
  `dimensions_url` VARCHAR(255) NULL,
  `mesh_terms` VARCHAR(1000) NULL,
  `pub_id` INT NOT NULL,
  PRIMARY KEY (`dimensions_metadata_id`),
  INDEX `fk_dimensions_metadata_pub1_idx` (`pub_id` ASC),
  INDEX `publication_id` (`publication_id` ASC),
  CONSTRAINT `fk_dimensions_metadata_pub1`
    FOREIGN KEY (`pub_id`)
    REFERENCES `projectdb_covid`.`pub` (`pub_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projectdb_covid`.`who_metadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projectdb_covid`.`who_metadata` ;

CREATE TABLE IF NOT EXISTS `projectdb_covid`.`who_metadata` (
  `who_metadata_id` INT NOT NULL,
  `accession_number` VARCHAR(255) NULL,
  `ref` VARCHAR(100) NULL,
  `covidence` VARCHAR(45) NULL,
  `study` VARCHAR(255) NULL,
  `notes` VARCHAR(255) NULL,
  `tags` VARCHAR(255) NULL,
  `pub_id` INT NOT NULL,
  PRIMARY KEY (`who_metadata_id`),
  INDEX `fk_who_metadata_pub1_idx` (`pub_id` ASC),
  CONSTRAINT `fk_who_metadata_pub1`
    FOREIGN KEY (`pub_id`)
    REFERENCES `projectdb_covid`.`pub` (`pub_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projectdb_covid`.`datasource`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projectdb_covid`.`datasource` ;

CREATE TABLE IF NOT EXISTS `projectdb_covid`.`datasource` (
  `datasource_id` INT NOT NULL,
  `source` VARCHAR(45) NULL,
  `url` VARCHAR(500) NULL,
  PRIMARY KEY (`datasource_id`),
  INDEX `source` (`source` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projectdb_covid`.`pub_datasource`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projectdb_covid`.`pub_datasource` ;

CREATE TABLE IF NOT EXISTS `projectdb_covid`.`pub_datasource` (
  `pub_id` INT NOT NULL,
  `datasource_id` INT NOT NULL,
  PRIMARY KEY (`pub_id`, `datasource_id`),
  INDEX `fk_pub_has_table1_table11_idx` (`datasource_id` ASC),
  INDEX `fk_pub_has_table1_pub1_idx` (`pub_id` ASC),
  CONSTRAINT `fk_pub_to_datasource_1`
    FOREIGN KEY (`pub_id`)
    REFERENCES `projectdb_covid`.`pub` (`pub_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pub_to_datasource_2`
    FOREIGN KEY (`datasource_id`)
    REFERENCES `projectdb_covid`.`datasource` (`datasource_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;