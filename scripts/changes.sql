-- MySQL Workbench Synchronization

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `mydb` ;

ALTER TABLE `game_of_thrones`.`AreaConnections` 
DROP FOREIGN KEY `fk_AreaConnections_nMainAreaID_Areas_nAreaID`,
DROP FOREIGN KEY `fk_AreaConnections_nSurroundingAreaID_Areas_nAreaID`;

ALTER TABLE `game_of_thrones`.`HouseAreaUnits` 
DROP FOREIGN KEY `fk_HouseAreaUnits_HouseAreas_nHouseAreaID`,
DROP FOREIGN KEY `fk_HouseAreaUnits_Units_nUnitID`;

ALTER TABLE `game_of_thrones`.`HouseAreas` 
DROP FOREIGN KEY `fk_HouseAreas_Areas_nAreaID`,
DROP FOREIGN KEY `fk_HouseAreas_Houses_nHouseID`;

CREATE TABLE IF NOT EXISTS `game_of_thrones`.`HouseCards` (
  `nHouseCardID` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `cPersonName` VARCHAR(70) NOT NULL COMMENT '',
  `nHouseID` INT(11) NOT NULL COMMENT '',
  `nCombatStrength` INT(11) NOT NULL COMMENT '',
  PRIMARY KEY (`cPersonName`)  COMMENT '',
  UNIQUE INDEX `uc_HouseCards_nHouseCardID` (`nHouseCardID` ASC)  COMMENT '',
  INDEX `fk_HouseCards_Houses_nHouseID` (`nHouseID` ASC)  COMMENT '',
  CONSTRAINT `fk_HouseCards_Houses_nHouseID`
    FOREIGN KEY (`nHouseID`)
    REFERENCES `game_of_thrones`.`Houses` (`nHouseID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 64
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

ALTER TABLE `game_of_thrones`.`AreaConnections` 
ADD CONSTRAINT `fk_AreaConnections_nMainAreaID_Areas_nAreaID`
  FOREIGN KEY (`nMainAreaID`)
  REFERENCES `game_of_thrones`.`Areas` (`nAreaID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_AreaConnections_nSurroundingAreaID_Areas_nAreaID`
  FOREIGN KEY (`nSurroundingAreaID`)
  REFERENCES `game_of_thrones`.`Areas` (`nAreaID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `game_of_thrones`.`HouseAreaUnits` 
ADD CONSTRAINT `fk_HouseAreaUnits_HouseAreas_nHouseAreaID`
  FOREIGN KEY (`nHouseAreaID`)
  REFERENCES `game_of_thrones`.`HouseAreas` (`nHouseAreaID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_HouseAreaUnits_Units_nUnitID`
  FOREIGN KEY (`nUnitID`)
  REFERENCES `game_of_thrones`.`Units` (`nUnitID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `game_of_thrones`.`HouseAreas` 
ADD CONSTRAINT `fk_HouseAreas_Areas_nAreaID`
  FOREIGN KEY (`nAreaID`)
  REFERENCES `game_of_thrones`.`Areas` (`nAreaID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_HouseAreas_Houses_nHouseID`
  FOREIGN KEY (`nHouseID`)
  REFERENCES `game_of_thrones`.`Houses` (`nHouseID`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;


USE `game_of_thrones`;
DROP procedure IF EXISTS `game_of_thrones`.`Utils_generateClass`;

DELIMITER $$
USE `game_of_thrones`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Utils_generateClass`(IN `@table` TEXT, IN `@singular` TEXT, IN `@plural` TEXT)
BEGIN
	DECLARE sel TEXT;
    DECLARE class TEXT;
    DROP TABLE IF EXISTS myCols;
    DROP TABLE IF EXISTS myClass;
    CREATE TEMPORARY TABLE myClass(
        nID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        myLine text,
        group_index int default 0
    );
    CREATE TEMPORARY TABLE myCols(
        nID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        col_name text,
        col_type text,
        col_index int,
        group_index int default 0
    );

    INSERT INTO myCols(col_name, col_type, col_index)
    SELECT
        COLUMN_NAME,
        CASE
            WHEN DATA_TYPE = 'tinyint' THEN
                'bool'
            WHEN DATA_TYPE IN ('text', 'varchar') THEN
                'string'
            ELSE
                DATA_TYPE
        END,
        ORDINAL_POSITION - 1
    FROM
        information_schema.COLUMNS
    WHERE
        table_schema = 'game_of_thrones' AND
        table_name = `@table`;

    INSERT INTO myClass(myLine)
    VALUES
      (CONCAT('module db_generated.', LCASE(`@plural`),';'))
     ,('import std.stdio;')
     ,('import db_generated.base;')
     ,('import std.variant;')
     ,('import std.conv;')
     ,('import mysql.connection;')
     ,('import mysql.protocol.commands;')
     ,('import mysql.result;')
     ,('import std.signals;\n')
     ,(CONCAT('class ', `@singular`, ' : ACBaseObject'))
     ,('{');

    INSERT INTO myClass(myLine)
	SELECT
        CONCAT(
        REPEAT(' ', 4), 'private ', col_type, ' _', col_name, ';\n',
        REPEAT(' ', 4), 'public @property ', col_type, ' ', col_name, '()\n',
        REPEAT(' ', 4), '{\n',
        REPEAT(' ', 8), 'return _', col_name, ';\n',
        REPEAT(' ', 4), '}\n',
        REPEAT(' ', 4), 'public @property void ', col_name, '(', col_type, ' value)\n',
        REPEAT(' ', 4), '{\n',
        REPEAT(' ', 8), 'if (value != _', col_name, ')\n',
        REPEAT(' ', 8), '{\n',
        REPEAT(' ', 12), '_', col_name, ' = value;\n',
        REPEAT(' ', 12), 'notify("', col_name, '");\n',
        REPEAT(' ', 8), '}\n',
        REPEAT(' ', 4), '}'
        ) AS property
	FROM
        myCols;

	INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 4), 'this(Row p', `@singular`, ')'))
	,(CONCAT(REPEAT(' ', 4), '{'));

    INSERT INTO myClass(myLine)
    SELECT
		CONCAT(
        REPEAT(' ', 8), '_', col_name, ' = ',
        CASE
            WHEN col_type = 'bool' THEN
                CONCAT('to!(bool)','(p',`@singular`,'[',col_index,'].get!(byte));')
			ELSE
                CONCAT('p', `@singular`, '[', col_index, '].get!(', col_type, ');')
			END
        )
	FROM
        myCols;

    INSERT INTO myClass(myLine)
    VALUES
	 (CONCAT(REPEAT(' ', 4), '}'))
	,(CONCAT(REPEAT(' ', 4), 'override bool isValid()'))
    ,(CONCAT(REPEAT(' ', 4), '{'))
    ,(CONCAT(REPEAT(' ', 8), 'return true;'))
    ,(CONCAT(REPEAT(' ', 4), '}'))
    ,(CONCAT(REPEAT(' ', 4), 'override void printInfo()'))
    ,(CONCAT(REPEAT(' ', 4), '{'))
    ,(CONCAT(REPEAT(' ', 8), 'writeln('));

    INSERT INTO myClass(myLine)
    SELECT
		CONCAT(
        REPEAT(' ', 16), '" ', col_name, ' = ", ', col_name, ','
        )
	FROM
        myCols;

    INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 16), '"");'))
	,(CONCAT(REPEAT(' ', 4), '}'))
	,('}')
    ,(CONCAT('class ', `@plural`, ' : ACBaseCollection!(', `@singular`, ')'))
    ,('{')
    ,('public:')
    ,(CONCAT(REPEAT(' ', 4), 'override string selectStatement()'))
    ,(CONCAT(REPEAT(' ', 4), '{'));

    -- this is where I need to figure out the select statement
	-- DECLARE sel TEXT;
    SET sel := '';

    SELECT
		GROUP_CONCAT(col_name SEPARATOR ', ')
	FROM
		myCols
	GROUP BY
		group_index
	INTO
		sel;

    -- SET sel = SUBSTRING(sel, 2);

    INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 8), 'return "SELECT ', sel, ' FROM ', `@table`, '";'))
    ,(CONCAT(REPEAT(' ', 4), '}'))
    ,(CONCAT(REPEAT(' ', 4), 'this(Command command)'))
    ,(CONCAT(REPEAT(' ', 4), '{'))
    ,(CONCAT(REPEAT(' ', 8), 'super(command);'))
    ,(CONCAT(REPEAT(' ', 4), '}'))
    ,('}');

    SELECT myLine FROM myClass ORDER BY nID;

--    SET class := '';

--     SELECT
-- 		GROUP_CONCAT(myLine SEPARATOR '\n')
-- 	FROM
-- 		myClass
-- 	GROUP BY
-- 		group_index
-- 	ORDER BY
-- 		nID
-- 	INTO
-- 		class;
--
--     SELECT class;

    DROP TABLE IF EXISTS myCols;
    DROP TABLE IF EXISTS myClass;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
