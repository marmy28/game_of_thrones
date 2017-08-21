USE game_of_thrones;

DROP PROCEDURE IF EXISTS `Utils_generateClass`;

DELIMITER $$
CREATE PROCEDURE `Utils_generateClass` 
(
	 IN `@table` TEXT
    ,IN `@singular` TEXT
    ,IN `@plural` TEXT
)
BEGIN
	DECLARE sel TEXT;
    DECLARE class TEXT;
    DECLARE tablecomment TEXT;
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
        col_descript text,
        col_null enum('YES', 'NO'),
        max_length int,
        col_UDAs TEXT,
        group_index int default 0
    );

	-- converting mysql types to dlang types...for the most part
    INSERT INTO myCols(col_name, col_type, col_index, col_descript, col_null, max_length, col_UDAs)
    SELECT
        C.COLUMN_NAME,
        CASE
            WHEN C.COLUMN_TYPE = 'tinyint(1)' THEN
                'bool'
			WHEN C.DATA_TYPE = 'tinyint' THEN
				'byte'
			WHEN C.DATA_TYPE = 'decimal' THEN
				'double'
			WHEN C.DATA_TYPE = 'smallint' THEN
				'short'
			WHEN C.DATA_TYPE IN ('timestamp', 'datetime') THEN
				'DateTime'
			WHEN C.DATA_TYPE = 'date' THEN
				'Date'
			WHEN C.DATA_TYPE = 'time' THEN
				'TimeOfDay'
            WHEN C.DATA_TYPE IN ('text', 'varchar', 'char', 'enum', 'set') THEN
                'string'
            ELSE
                C.DATA_TYPE
        END,
        C.ORDINAL_POSITION - 1,
		TRIM(CONCAT(C.COLUMN_COMMENT, ' ', C.EXTRA)),
        C.IS_NULLABLE,
        C.CHARACTER_MAXIMUM_LENGTH,
        CONCAT(
        CASE
			WHEN TC.CONSTRAINT_NAME IS NOT NULL THEN
				CONCAT('@UniqueConstraintColumn!("', TC.CONSTRAINT_NAME, '") ')
			ELSE
				''
		END,
        CASE
			WHEN C.IS_NULLABLE = 'NO' THEN
				'@NotNull '
			ELSE
				''
		END,
        CASE
			WHEN C.DATA_TYPE = 'SET' THEN
				CONCAT('@SetConstraint!', SUBSTRING(replace(C.COLUMN_TYPE, '\'', '"') FROM 4))
			WHEN C.DATA_TYPE = 'ENUM' THEN
				CONCAT('@EnumConstraint!', SUBSTRING(replace(C.COLUMN_TYPE, '\'', '"') FROM 5))
			ELSE
				''
		 END
        ) -- may add in foreign keys and auto increments here
    FROM
        information_schema.COLUMNS C
	LEFT JOIN
		information_schema.KEY_COLUMN_USAGE TC
		ON
			C.table_schema = TC.table_schema AND
			C.table_name = TC.table_name AND
			C.column_name = TC.column_name AND
			TC.referenced_table_name IS NULL
    WHERE
        C.table_schema = database() AND
        C.table_name = `@table`;

	/*
     * Starting the initial comments at the top 
     * of the file. This includes comments put on
     * the mysql table along with the date the class
     * is generated and the command used.
     */
    INSERT INTO myClass(myLine)
    VALUES
      ('/**');
	
    SELECT 
		TABLE_COMMENT
	FROM
		information_schema.TABLES
	WHERE
		table_schema = database() AND
        table_name = `@table`
	INTO
		tablecomment;
	
    IF tablecomment <> '' THEN
		INSERT INTO myClass(myLine)
        VALUES
          (CONCAT(' * ', tablecomment))
		 ,(' * ');
	END IF;
    
    /*
     * continuing comments and starting imports
     */
    INSERT INTO myClass(myLine)
    VALUES
	 (CONCAT(' * Date: ', DATE_FORMAT(CURDATE(), '%M %d, %Y')))
    ,(CONCAT(' * Regenerate: CALL `', DATABASE(),'`.`Utils_generateClass`(\'', `@table`,'\', \'', `@singular`, '\', \'', `@plural`, '\');'))
    ,(' */')
	,(CONCAT('module db_generated.', LCASE(`@plural`),';'))
    ,('import db_constraints;')
    ,('import mysql.result;\n');
    
    INSERT INTO myClass(myLine)
    SELECT DISTINCT
		CONCAT('import db_generated.', LCASE(TC.referenced_table_name), ';')
	FROM
		information_schema.COLUMNS C
	JOIN
		information_schema.KEY_COLUMN_USAGE TC
		ON
			C.table_schema = TC.table_schema AND
			C.table_name = TC.table_name AND
			C.column_name = TC.column_name
	WHERE
		C.table_schema = database() AND
		C.table_name = `@table` AND
		TC.REFERENCED_TABLE_NAME IS NOT NULL;

	INSERT INTO myClass(myLine)
	SELECT
		CONCAT('@ForeignKeyConstraint!(\n',
		REPEAT(' ', 4), '"', TC.CONSTRAINT_NAME, '",\n',
		REPEAT(' ', 4), '["', C.COLUMN_NAME, '"],\n',
		REPEAT(' ', 4), '"', TC.referenced_table_name, '",\n',
		REPEAT(' ', 4), '["', TC.REFERENCED_COLUMN_NAME, '"],\n',
		REPEAT(' ', 4), 'Rule.', LCASE(RC.UPDATE_RULE), ',\n',
		REPEAT(' ', 4), 'Rule.', LCASE(RC.DELETE_RULE), ')')
	FROM
		information_schema.COLUMNS C
	JOIN
		information_schema.KEY_COLUMN_USAGE TC
		ON
			C.table_schema = TC.table_schema AND
			C.table_name = TC.table_name AND
			C.column_name = TC.column_name
	JOIN
		information_schema.REFERENTIAL_CONSTRAINTS RC
		ON
			RC.table_name = TC.table_name AND
			TC.REFERENCED_TABLE_NAME = RC.REFERENCED_TABLE_NAME AND
			TC.CONSTRAINT_NAME = RC.CONSTRAINT_NAME AND
			TC.TABLE_SCHEMA = RC.CONSTRAINT_SCHEMA
	WHERE
		C.table_schema = database() AND
 		C.table_name = `@table`;

	INSERT INTO myClass(myLine)
    VALUES
     (CONCAT('class ', `@singular`))
    ,('{');
        

	/*
     * Private and public properties
     * This deals with getters and setters
     * along with nulls. This also takes comments
     * from mysql columns.
     */
    INSERT INTO myClass(myLine)
	SELECT
        CONCAT(
        REPEAT(' ', 4), 'private ', 
        CASE
			WHEN col_null = 'YES' AND col_type <> 'string' THEN
				'Nullable!'
			ELSE
				''
		END,
        col_type, ' _', col_name, ';\n',
        CASE
			WHEN col_descript = '' THEN
				''
			ELSE
				CONCAT(REPEAT(' ', 4), '/// ', col_descript, '\n')
		END,
        CASE
			WHEN TRIM(col_UDAs) <> '' THEN
				CONCAT(REPEAT(' ', 4), TRIM(col_UDAs), '\n')
			ELSE
				''
		END,
        REPEAT(' ', 4), 'final @property ',
        CASE
			WHEN col_null = 'YES' AND col_type <> 'string' THEN
				'Nullable!'
			ELSE
				''
		END,
        col_type, ' ', col_name, '() const pure nothrow @safe @nogc\n',
        REPEAT(' ', 4), '{\n',
        REPEAT(' ', 8), 'return _', col_name, ';\n',
        REPEAT(' ', 4), '}\n',
        CASE
			WHEN col_descript = '' THEN
				''
			ELSE
				CONCAT(REPEAT(' ', 4), '/// ditto\n')
		END,
        REPEAT(' ', 4), 'final @property void ', col_name, '(', col_type, ' value)\n',
        REPEAT(' ', 4), '{\n',
        REPEAT(' ', 8), 'setter(_', col_name, ', value);\n',
        REPEAT(' ', 4), '}'
        ) AS property
	FROM
        myCols;

	INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 4), 'mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));'));
    
	/*
     * Constructor from each item
     */
    INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 4), 'this('));
     
    SET sel := '';

    SELECT
		GROUP_CONCAT(
        CONCAT(
        REPEAT(' ', 9), 
        CASE
			WHEN col_null = 'YES' AND col_type <> 'string' THEN
				CONCAT('Nullable!(', col_type,')')
			ELSE
				col_type
		END,
        ' ', col_name, '_') SEPARATOR ',\n')
	FROM
		myCols
	GROUP BY
		group_index
	INTO
		sel;
        
    INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(sel, ')'))
	,(CONCAT(REPEAT(' ', 4), '{'));
    
    INSERT INTO myClass(myLine)
    SELECT
		CONCAT(
        REPEAT(' ', 8), 'this._', col_name, ' = ', col_name, '_;'
        )
    FROM
		myCols;
	
    INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 8), 'initializeKeyedItem();'))
	,(CONCAT(REPEAT(' ', 4), '}'));

	/*
     * Constructor from Row, which is what you get back from querying
     * the database.
     */
	INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 4), 'this(Row ', `@singular`, '_)'))
	,(CONCAT(REPEAT(' ', 4), '{'));

    INSERT INTO myClass(myLine)
    SELECT
		CONCAT(
        CASE
			WHEN col_null = 'YES' THEN
				CONCAT(
                REPEAT(' ', 8), 'if (', `@singular`, '_.isNull(', col_index, '))\n',
                REPEAT(' ', 8), '{\n',
                REPEAT(' ', 12), '_', col_name, 
                CASE
                    WHEN col_type = 'string' THEN
						' = null'
                    ELSE
						'.nullify()'
				END,
                ';\n',
                REPEAT(' ', 8), '}\n',
                REPEAT(' ', 8), 'else\n',
                REPEAT(' ', 8), '{\n',
                REPEAT(' ', 4)
                )
			ELSE
				''
		END,
        REPEAT(' ', 8), '_', col_name, ' = ',
        CASE
            WHEN col_type = 'bool' THEN
                CONCAT('to!(bool)','(',`@singular`,'_[',col_index,'].get!(byte));')
			ELSE
                CONCAT(`@singular`, '_[', col_index, '].get!(', col_type, ');')
		END,
        CASE
			WHEN col_null = 'YES' THEN
				CONCAT('\n', REPEAT(' ', 8), '}')
			ELSE
				''
		END
        )
	FROM
        myCols;

	INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 8), 'initializeKeyedItem();'))
	,(CONCAT(REPEAT(' ', 4), '}'));
    
    
	/*
     * Setting up print statement
     */
    INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 4), 'final void printInfo()'))
    ,(CONCAT(REPEAT(' ', 4), '{'))
    ,(CONCAT(REPEAT(' ', 8), 'std.stdio.writeln('));

    INSERT INTO myClass(myLine)
    SELECT
		CONCAT(
        REPEAT(' ', 16), '" ', col_name, ' = ", ', 
        CASE
			WHEN col_null = 'YES' AND col_type <> 'string' THEN
				CONCAT(col_name, '.isNull ? to!string(null) : to!string(', col_name, '.get)')
			ELSE
				col_name
		END,
        ','
        )
	FROM
        myCols;

    INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 16), '"");'))
	,(CONCAT(REPEAT(' ', 4), '}'))
	,('}')
    ,(CONCAT('class ', `@plural`))
    ,('{')
    ,(CONCAT(REPEAT(' ', 4), 'final string selectStatement() const nothrow @nogc @safe'))
    ,(CONCAT(REPEAT(' ', 4), '{'));

    /*
     * Setting up the select statement
     */
    SET sel := '';

    SELECT
		GROUP_CONCAT(col_name SEPARATOR ', ')
	FROM
		myCols
	GROUP BY
		group_index
	INTO
		sel;

    INSERT INTO myClass(myLine)
    VALUES
     (CONCAT(REPEAT(' ', 8), 'return "SELECT ', sel, ' FROM ', `@table`, '";'))
    ,(CONCAT(REPEAT(' ', 4), '}'))
    ,(CONCAT(REPEAT(' ', 4), 'mixin KeyedCollection!(', `@singular`, ');'))
    ,('}');


	/*
     * Outputs class to results.
     */
    SELECT myLine FROM myClass ORDER BY nID;

    DROP TABLE IF EXISTS myCols;
    DROP TABLE IF EXISTS myClass;
END$$
DELIMITER ;
