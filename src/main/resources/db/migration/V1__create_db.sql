-- -----------------------------------------------------
-- Table `Source`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Source` (
  `source_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NULL,
  PRIMARY KEY (`source_id`),
  UNIQUE INDEX `source_id_UNIQUE` (`source_id` ASC) VISIBLE,
  UNIQUE INDEX `title_UNIQUE` (`title` ASC) VISIBLE);

-- -----------------------------------------------------
-- Table `Wind_direction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Wind_direction` (
  `wind_direction_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NULL,
  PRIMARY KEY (`wind_direction_id`),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC) VISIBLE,
  UNIQUE INDEX `wind_direction_id_UNIQUE` (`wind_direction_id` ASC) VISIBLE);

-- -----------------------------------------------------
-- Table `Administrative_area_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Administrative_area_type` (
  `administrative_area_type_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NULL,
  PRIMARY KEY (`administrative_area_type_id`),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC) VISIBLE);

-- -----------------------------------------------------
-- Table `Administrative_area`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Administrative_area` (
  `administrative_area_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `type_id` INT NOT NULL,
  `included_in_id` INT NULL,
  PRIMARY KEY (`administrative_area_id`),
  INDEX `included_in_fk_idx` (`included_in_id` ASC) VISIBLE,
  INDEX `administrative_area_type_fk_idx` (`type_id` ASC) INVISIBLE,
  UNIQUE INDEX `unique_title_and_incl_in` (`title` ASC, `included_in_id` ASC, `type_id` ASC) VISIBLE,
  CONSTRAINT `included_in_fk`
    FOREIGN KEY (`included_in_id`)
    REFERENCES `Administrative_area` (`administrative_area_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `administrative_area_type_fk`
    FOREIGN KEY (`type_id`)
    REFERENCES `Administrative_area_type` (`administrative_area_type_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

-- -----------------------------------------------------
-- Table `Location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Location` (
  `location_id` INT NOT NULL AUTO_INCREMENT,
  `coordinates` POINT NOT NULL,
  `administrative_area_id` INT NULL,
  PRIMARY KEY (`location_id`),
  INDEX `administrative_area_fk_idx` (`administrative_area_id` ASC) VISIBLE,
  UNIQUE INDEX `location_id_UNIQUE` (`location_id` ASC) VISIBLE,
  CONSTRAINT `administrative_area_fk`
    FOREIGN KEY (`administrative_area_id`)
    REFERENCES `Administrative_area` (`administrative_area_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE);

-- -----------------------------------------------------
-- Table `Weather`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Weather` (
  `weather_id` INT NOT NULL AUTO_INCREMENT,
  `time` TIMESTAMP NOT NULL,
  `source_id` INT NOT NULL,
  `height` INT NULL,
  `wind_direction_id` INT NULL,
  `wind_power_from` INT NULL,
  `wind_power_to` INT NULL,
  `rainfall` INT NULL,
  `cloudiness` INT NULL,
  `atm_pressure` INT NULL,
  `humidity` INT NULL,
  `location_id` INT NOT NULL,
  PRIMARY KEY (`weather_id`),
  INDEX `source_fk_idx` (`source_id` ASC) VISIBLE,
  INDEX `wind_direction_fk_idx` (`wind_direction_id` ASC) VISIBLE,
  INDEX `location_id_fk_idx` (`location_id` ASC) VISIBLE,
  CONSTRAINT `source_fk`
    FOREIGN KEY (`source_id`)
    REFERENCES `Source` (`source_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `wind_direction_fk`
    FOREIGN KEY (`wind_direction_id`)
    REFERENCES `Wind_direction` (`wind_direction_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `location_fk`
    FOREIGN KEY (`location_id`)
    REFERENCES `Location` (`location_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

ALTER TABLE `Weather`
ADD CHECK (`Weather`.`wind_power_from`>=0);

ALTER TABLE `Weather`
ADD CHECK (`Weather`.`wind_power_to`>=0);


ALTER TABLE `Weather`
ADD CHECK (`Weather`.`rainfall`>=0);


ALTER TABLE `Weather`
ADD CHECK (`Weather`.`cloudiness`>=0 && `Weather`.`cloudiness`<=10);


ALTER TABLE `Weather`
ADD CHECK (`Weather`.`humidity`>=0 && `Weather`.`humidity`<=100);


ALTER TABLE `Weather`
ADD CHECK (`Weather`.`wind_power_to` >= `Weather`.`wind_power_from`);





