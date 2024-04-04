-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP DATABASE IF EXISTS ArchaeoDB;
CREATE DATABASE IF NOT EXISTS ArchaeoDB;
USE ArchaeoDB;
-- -----------------------------------------------------
-- Table `site`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site` ;

CREATE TABLE IF NOT EXISTS `site` (
  `site_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `date_entered` TIMESTAMP(6) NULL,
  `date_updated` TIMESTAMP(6) NULL,
  PRIMARY KEY (`site_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record` ;

CREATE TABLE IF NOT EXISTS `site_record` (
  `site_record_id` SMALLINT(8) NOT NULL AUTO_INCREMENT,
  `privacy_setting` ENUM("Not for Publication", "Unrestricted") NOT NULL DEFAULT 'Not for Publication',
  `age_source` ENUM('Prehistoric', 'Historic', 'Both') NULL,
  PRIMARY KEY (`site_record_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_identifier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_identifier` ;

CREATE TABLE IF NOT EXISTS `site_identifier` (
  `site_identifier_id` SMALLINT(8) NOT NULL AUTO_INCREMENT,
  `site_identifier_name` VARCHAR(45) NULL,
  PRIMARY KEY (`site_identifier_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `address` ;

CREATE TABLE IF NOT EXISTS `address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `address_street` VARCHAR(90) NOT NULL,
  `address_city` VARCHAR(45) NOT NULL,
  `address_state` VARCHAR(2) NOT NULL,
  `address_zip` SMALLINT(6) NULL,
  PRIMARY KEY (`address_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `info_center`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `info_center` ;

CREATE TABLE IF NOT EXISTS `info_center` (
  `info_center_id` TINYINT(2) NOT NULL AUTO_INCREMENT,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`info_center_id`),
  INDEX `fk_info_center_address1_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_info_center_address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `county`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `county` ;

CREATE TABLE IF NOT EXISTS `county` (
  `county_id` TINYINT(2) NOT NULL AUTO_INCREMENT,
  `county_name` VARCHAR(45) NOT NULL,
  `county_seat` VARCHAR(45) NOT NULL,
  `info_center_id` TINYINT(2) NULL,
  PRIMARY KEY (`county_id`),
  INDEX `fk_county_info_center1_idx` (`info_center_id` ASC) VISIBLE,
  CONSTRAINT `fk_county_info_center1`
    FOREIGN KEY (`info_center_id`)
    REFERENCES `info_center` (`info_center_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `usgs_quad`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `usgs_quad` ;

CREATE TABLE IF NOT EXISTS `usgs_quad` (
  `usgs_quad_id` SMALLINT(4) NOT NULL AUTO_INCREMENT,
  `usgs_quad_name` VARCHAR(45) NULL,
  PRIMARY KEY (`usgs_quad_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_desc`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_desc` ;

CREATE TABLE IF NOT EXISTS `site_desc` (
  `site_desc_id` INT NOT NULL AUTO_INCREMENT,
  `site_desc_text` VARCHAR(450) NULL,
  `site_desc_entered` TIMESTAMP(6) NOT NULL,
  `site_record_id` SMALLINT(8) NOT NULL,
  PRIMARY KEY (`site_desc_id`, `site_record_id`),
  INDEX `fk_site_desc_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_desc_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `res_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `res_code` ;

CREATE TABLE IF NOT EXISTS `res_code` (
  `res_code_id` INT NOT NULL AUTO_INCREMENT,
  `res_code_text` VARCHAR(45) NOT NULL,
  `res_code_class` VARCHAR(45) NULL,
  PRIMARY KEY (`res_code_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `res_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `res_type` ;

CREATE TABLE IF NOT EXISTS `res_type` (
  `res_type_id` INT NOT NULL AUTO_INCREMENT,
  `res_type_name` VARCHAR(45) NULL,
  `res_type_desc` VARCHAR(45) NULL,
  PRIMARY KEY (`res_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `owner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `owner` ;

CREATE TABLE IF NOT EXISTS `owner` (
  `owner_id` SMALLINT(4) NOT NULL AUTO_INCREMENT,
  `owner_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`owner_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `affiliation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `affiliation` ;

CREATE TABLE IF NOT EXISTS `affiliation` (
  `affiliation_id` SMALLINT(4) NOT NULL AUTO_INCREMENT,
  `affiliation_org` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`affiliation_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recorder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recorder` ;

CREATE TABLE IF NOT EXISTS `recorder` (
  `recorder_id` SMALLINT(4) NOT NULL AUTO_INCREMENT,
  `recorder_name` VARCHAR(45) NOT NULL,
  `affiliation_id` SMALLINT(4) NOT NULL,
  PRIMARY KEY (`recorder_id`),
  INDEX `fk_recorder_affiliation1_idx` (`affiliation_id` ASC) VISIBLE,
  CONSTRAINT `fk_recorder_affiliation1`
    FOREIGN KEY (`affiliation_id`)
    REFERENCES `affiliation` (`affiliation_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `survey_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `survey_type` ;

CREATE TABLE IF NOT EXISTS `survey_type` (
  `survey_type_id` TINYINT(2) NOT NULL AUTO_INCREMENT,
  `survey_type_text` VARCHAR(45) NOT NULL,
  `survey_type_intensity` TINYINT(2) NULL,
  PRIMARY KEY (`survey_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `citations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `citations` ;

CREATE TABLE IF NOT EXISTS `citations` (
  `citations_id` INT NOT NULL AUTO_INCREMENT,
  `citations_text` VARCHAR(255) NULL,
  PRIMARY KEY (`citations_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `attachment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `attachment` ;

CREATE TABLE IF NOT EXISTS `attachment` (
  `attachment_id` TINYINT(2) NOT NULL AUTO_INCREMENT,
  `attachment_type` VARCHAR(45) NULL,
  PRIMARY KEY (`attachment_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `map` ;

CREATE TABLE IF NOT EXISTS `map` (
  `map_id` INT NOT NULL AUTO_INCREMENT,
  `map_type` ENUM("Location", "Sketch") NOT NULL,
  PRIMARY KEY (`map_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `loc_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `loc_map` ;

CREATE TABLE IF NOT EXISTS `loc_map` (
  `loc_map_id` INT NOT NULL AUTO_INCREMENT,
  `loc_map_quad` VARCHAR(45) NULL,
  `loc_map_scale` VARCHAR(45) NULL,
  `map_id` INT NOT NULL,
  PRIMARY KEY (`loc_map_id`, `map_id`),
  INDEX `fk_loc_map_map1_idx` (`map_id` ASC) VISIBLE,
  CONSTRAINT `fk_loc_map_map1`
    FOREIGN KEY (`map_id`)
    REFERENCES `map` (`map_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sketch_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sketch_map` ;

CREATE TABLE IF NOT EXISTS `sketch_map` (
  `sketch_map_id` INT NOT NULL AUTO_INCREMENT,
  `sketch_map_quad` VARCHAR(45) NULL,
  `sketch_map_scale` VARCHAR(45) NULL,
  `map_id` INT NOT NULL,
  PRIMARY KEY (`sketch_map_id`, `map_id`),
  INDEX `fk_sketch_map_map1_idx` (`map_id` ASC) VISIBLE,
  CONSTRAINT `fk_sketch_map_map1`
    FOREIGN KEY (`map_id`)
    REFERENCES `map` (`map_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `photo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `photo` ;

CREATE TABLE IF NOT EXISTS `photo` (
  `photo_id` INT NOT NULL AUTO_INCREMENT,
  `photo_path` VARCHAR(45) NOT NULL,
  `photo_size` VARCHAR(45) NULL,
  `site_record_id` SMALLINT(8) NULL,
  PRIMARY KEY (`photo_id`),
  INDEX `fk_photo_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_photo_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shape_file`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shape_file` ;

CREATE TABLE IF NOT EXISTS `shape_file` (
  `shape_file_id` INT NOT NULL AUTO_INCREMENT,
  `shape_file_path` VARCHAR(45) NOT NULL,
  `site_record_id` SMALLINT(8) NOT NULL,
  PRIMARY KEY (`shape_file_id`, `site_record_id`),
  INDEX `fk_shape_file_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_shape_file_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NOT NULL,
  `info_center_id` TINYINT(2) NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_user_info_center1_idx` (`info_center_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_info_center1`
    FOREIGN KEY (`info_center_id`)
    REFERENCES `info_center` (`info_center_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `account` ;

CREATE TABLE IF NOT EXISTS `account` (
  `account_id` INT NOT NULL AUTO_INCREMENT,
  `account_name` VARCHAR(45) NOT NULL,
  `account_password` VARCHAR(45) NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`account_id`, `user_id`),
  INDEX `fk_account_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_account_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `session` ;

CREATE TABLE IF NOT EXISTS `session` (
  `session_id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  PRIMARY KEY (`session_id`, `account_id`),
  INDEX `fk_session_account1_idx` (`account_id` ASC) VISIBLE,
  CONSTRAINT `fk_session_account1`
    FOREIGN KEY (`account_id`)
    REFERENCES `account` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_county`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_county` ;

CREATE TABLE IF NOT EXISTS `site_record_has_county` (
  `site_record_id` SMALLINT(8) NULL,
  `county_id` TINYINT(2) NOT NULL,
  INDEX `fk_site_record_has_county_county_id` (`county_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_county_site_record_id` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_county_site_record`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_site_record_has_county_county1`
    FOREIGN KEY (`county_id`)
    REFERENCES `county` (`county_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_has_site_identifier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_has_site_identifier` ;

CREATE TABLE IF NOT EXISTS `site_has_site_identifier` (
  `site_id` SMALLINT NULL,
  `site_identifier_id` SMALLINT(8) NULL,
  INDEX `fk_site_has_site_identifier_site_identifier_id` (`site_identifier_id` ASC) VISIBLE,
  INDEX `fk_site_has_site_identifier_site_id` (`site_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_has_site_identifier_site1`
    FOREIGN KEY (`site_id`)
    REFERENCES `site` (`site_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_has_site_identifier_site_identifier1`
    FOREIGN KEY (`site_identifier_id`)
    REFERENCES `site_identifier` (`site_identifier_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_identifier_has_site_record`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_identifier_has_site_record` ;

CREATE TABLE IF NOT EXISTS `site_identifier_has_site_record` (
  `site_identifier_id` SMALLINT(8) NOT NULL,
  `site_record_id` SMALLINT(8) NULL,
  INDEX `fk_site_identifier_has_site_record_site_record_id` (`site_record_id` ASC) VISIBLE,
  INDEX `fk_site_identifier_has_site_record_site_identifier_id` (`site_identifier_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_identifier_has_site_record_site_identifier`
    FOREIGN KEY (`site_identifier_id`)
    REFERENCES `site_identifier` (`site_identifier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_site_identifier_has_site_record_site_record`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `county_has_site`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `county_has_site` ;

CREATE TABLE IF NOT EXISTS `county_has_site` (
  `county_id` TINYINT(2) NULL,
  `site_id` SMALLINT NULL,
  INDEX `fk_county_has_site_site1_idx` (`site_id` ASC) VISIBLE,
  INDEX `fk_county_has_site_county1_idx` (`county_id` ASC) VISIBLE,
  CONSTRAINT `fk_county_has_site_county1`
    FOREIGN KEY (`county_id`)
    REFERENCES `county` (`county_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_county_has_site_site1`
    FOREIGN KEY (`site_id`)
    REFERENCES `site` (`site_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_usgs_quad`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_usgs_quad` ;

CREATE TABLE IF NOT EXISTS `site_record_has_usgs_quad` (
  `site_record_id` SMALLINT(8) NULL,
  `usgs_quad_id` SMALLINT(4) NULL,
  INDEX `fk_site_record_has_usgs_quad_usgs_quad1_idx` (`usgs_quad_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_usgs_quad_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_usgs_quad_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_usgs_quad_usgs_quad1`
    FOREIGN KEY (`usgs_quad_id`)
    REFERENCES `usgs_quad` (`usgs_quad_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_res_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_res_code` ;

CREATE TABLE IF NOT EXISTS `site_record_has_res_code` (
  `site_record_id` SMALLINT(8) NULL,
  `res_code_id` INT NULL,
  INDEX `fk_site_record_has_res_code_res_code1_idx` (`res_code_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_res_code_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_res_code_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_res_code_res_code1`
    FOREIGN KEY (`res_code_id`)
    REFERENCES `res_code` (`res_code_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_res_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_res_type` ;

CREATE TABLE IF NOT EXISTS `site_record_has_res_type` (
  `site_record_id` SMALLINT(8) NULL,
  `res_type_id` INT NULL,
  INDEX `fk_site_record_has_res_type_res_type1_idx` (`res_type_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_res_type_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_res_type_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_res_type_res_type1`
    FOREIGN KEY (`res_type_id`)
    REFERENCES `res_type` (`res_type_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_owner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_owner` ;

CREATE TABLE IF NOT EXISTS `site_record_has_owner` (
  `site_record_id` SMALLINT(8) NULL,
  `owner_id` SMALLINT(4) NULL,
  INDEX `fk_site_record_has_owner_owner1_idx` (`owner_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_owner_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_owner_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_owner_owner1`
    FOREIGN KEY (`owner_id`)
    REFERENCES `owner` (`owner_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `owner_has_address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `owner_has_address` ;

CREATE TABLE IF NOT EXISTS `owner_has_address` (
  `owner_id` SMALLINT(4) NULL,
  `address_id` INT NULL,
  INDEX `fk_owner_has_address_address1_idx` (`address_id` ASC) VISIBLE,
  INDEX `fk_owner_has_address_owner1_idx` (`owner_id` ASC) VISIBLE,
  CONSTRAINT `fk_owner_has_address_owner1`
    FOREIGN KEY (`owner_id`)
    REFERENCES `owner` (`owner_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_owner_has_address_address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_recorder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_recorder` ;

CREATE TABLE IF NOT EXISTS `site_record_has_recorder` (
  `site_record_id` SMALLINT(8) NULL,
  `recorder_id` SMALLINT(4) NULL,
  INDEX `fk_site_record_has_recorder_recorder1_idx` (`recorder_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_recorder_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_recorder_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_recorder_recorder1`
    FOREIGN KEY (`recorder_id`)
    REFERENCES `recorder` (`recorder_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recorder_has_address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recorder_has_address` ;

CREATE TABLE IF NOT EXISTS `recorder_has_address` (
  `recorder_id` SMALLINT(4) NULL,
  `address_id` INT NULL,
  INDEX `fk_recorder_has_address_address1_idx` (`address_id` ASC) VISIBLE,
  INDEX `fk_recorder_has_address_recorder1_idx` (`recorder_id` ASC) VISIBLE,
  CONSTRAINT `fk_recorder_has_address_recorder1`
    FOREIGN KEY (`recorder_id`)
    REFERENCES `recorder` (`recorder_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_recorder_has_address_address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user_has_affiliation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user_has_affiliation` ;

CREATE TABLE IF NOT EXISTS `user_has_affiliation` (
  `user_id` INT NULL,
  `affiliation_id` SMALLINT(4) NULL,
  `affiliation_id1` SMALLINT(4) NOT NULL,
  PRIMARY KEY (`affiliation_id1`),
  INDEX `fk_user_has_affiliation_affiliation1_idx` (`affiliation_id` ASC, `affiliation_id1` ASC) VISIBLE,
  INDEX `fk_user_has_affiliation_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_affiliation_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_affiliation_affiliation1`
    FOREIGN KEY (`affiliation_id`)
    REFERENCES `affiliation` (`affiliation_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_survey_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_survey_type` ;

CREATE TABLE IF NOT EXISTS `site_record_has_survey_type` (
  `site_record_id` SMALLINT(8) NULL,
  `survey_type_id` TINYINT(2) NULL,
  INDEX `fk_site_record_has_survey_type_survey_type1_idx` (`survey_type_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_survey_type_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_survey_type_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_survey_type_survey_type1`
    FOREIGN KEY (`survey_type_id`)
    REFERENCES `survey_type` (`survey_type_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_citations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_citations` ;

CREATE TABLE IF NOT EXISTS `site_record_has_citations` (
  `site_record_id` SMALLINT(8) NULL,
  `citations_id` INT NULL,
  INDEX `fk_site_record_has_citations_citations1_idx` (`citations_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_citations_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_citations_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_citations_citations1`
    FOREIGN KEY (`citations_id`)
    REFERENCES `citations` (`citations_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_attachment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_attachment` ;

CREATE TABLE IF NOT EXISTS `site_record_has_attachment` (
  `site_record_id` SMALLINT(8) NULL,
  `attachment_id` TINYINT(2) NULL,
  INDEX `fk_site_record_has_attachment_attachment1_idx` (`attachment_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_attachment_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_attachment_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_attachment_attachment1`
    FOREIGN KEY (`attachment_id`)
    REFERENCES `attachment` (`attachment_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `site_record_has_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `site_record_has_map` ;

CREATE TABLE IF NOT EXISTS `site_record_has_map` (
  `site_record_id` SMALLINT(8) NULL,
  `map_id` INT NULL,
  INDEX `fk_site_record_has_map_map1_idx` (`map_id` ASC) VISIBLE,
  INDEX `fk_site_record_has_map_site_record1_idx` (`site_record_id` ASC) VISIBLE,
  CONSTRAINT `fk_site_record_has_map_site_record1`
    FOREIGN KEY (`site_record_id`)
    REFERENCES `site_record` (`site_record_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_site_record_has_map_map1`
    FOREIGN KEY (`map_id`)
    REFERENCES `map` (`map_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
