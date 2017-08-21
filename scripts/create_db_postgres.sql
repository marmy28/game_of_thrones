
DROP SCHEMA IF EXISTS LookUp CASCADE;
CREATE SCHEMA LookUp;

DROP TABLE IF EXISTS TempHouseAreaUnits;
DROP TABLE IF EXISTS TempConnectedAreas;
DROP TABLE IF EXISTS TempHouseAreas;
DROP TABLE IF EXISTS TempHouseCards;
DROP TABLE IF EXISTS TempCardAbilities;
DROP TABLE IF EXISTS TempOrderTokens;
DROP TABLE IF EXISTS TempWesterosDecks;
DROP TABLE IF EXISTS TidesOfBattleCards;

CREATE DOMAIN 
    LookUp.playerrange int4range NOT NULL 
    CONSTRAINT chk_playerrange 
    CHECK(VALUE <@ int4range(3,6, '[]'));

CREATE TABLE LookUp.Versions
(
    nVersionID smallserial,
    cName VARCHAR(25) NOT NULL,
    nNumPlayers LookUp.playerrange,
    CONSTRAINT pk_LookUp_Versions PRIMARY KEY (cName),
    CONSTRAINT uc_CLIDX_LookUp_Versions UNIQUE (nVersionID)
);

CLUSTER LookUp.Versions USING uc_CLIDX_LookUp_Versions;

INSERT INTO LookUp.Versions (cName, nNumPlayers)
VALUES
 ('Original', '[3,6]')
,('A Feast for Crows', '[4,4]')
,('A Dance with Dragons', '[6,6]');

CREATE TABLE LookUp.Areas 
(
    nAreaID smallserial,
    cName VARCHAR(25) NOT NULL,
    nSupply INT NOT NULL,
    nPower INT NOT NULL,
    nMusteringPoints INT NOT NULL,
    lIsSea BOOLEAN NOT NULL,
    CONSTRAINT pk_LookUp_Areas PRIMARY KEY (cName),
    CONSTRAINT uc_CLIDX_LookUp_Areas UNIQUE (nAreaID)
);

COMMENT ON TABLE LookUp.Areas IS 'Holds all the information about the areas.';
COMMENT ON COLUMN LookUp.Areas.nSupply IS 'How many barrels are on the area';
COMMENT ON COLUMN LookUp.Areas.nPower IS 'How many crowns are on the area';
COMMENT ON COLUMN LookUp.Areas.nMusteringPoints IS 'whether there is a castle, stronghold, or nothing on this area';

CLUSTER LookUp.Areas USING uc_CLIDX_LookUp_Areas;

INSERT INTO LookUp.Areas(cName, nSupply, nPower, nMusteringPoints, lIsSea)
VALUES
 ('Bay Of Ice',0,0,0,TRUE)
,('Sunset Sea',0,0,0,TRUE)
,('Ironmans Bay',0,0,0,TRUE)
,('The Golden Sound',0,0,0,TRUE)
,('Redwyne Straights',0,0,0,TRUE)
,('West Summer Sea',0,0,0,TRUE)
,('East Summer Sea',0,0,0,TRUE)
,('Sea of Dorne',0,0,0,TRUE)
,('Shipbreaker Bay',0,0,0,TRUE)
,('Blackwater Bay',0,0,0,TRUE)
,('The Narrow Sea',0,0,0,TRUE)
,('The Shivering Sea',0,0,0,TRUE)
,('Port at Winterfell',0,0,0,TRUE)
,('Winterfell',1,1,2,FALSE)
,('Port at White Harbor',0,0,0,TRUE)
,('White Harbor',0,0,1,FALSE)
,('Port at Pyke',0,0,0,TRUE)
,('Pyke',1,1,2,FALSE)
,('Greywater Watch',1,0,0,FALSE)
,('Port at Lannisport',0,0,0,TRUE)
,('Lannisport',2,0,2,FALSE)
,('Stoney Sept',0,1,0,FALSE)
,('Port at Sunspear',0,0,0,TRUE)
,('Sunspear',1,1,2,FALSE)
,('Salt Shore',1,0,0,FALSE)
,('Highgarden',2,0,2,FALSE)
,('Dornish Marches',0,1,0,FALSE)
,('Port at Dragonstone',0,0,0,TRUE)
,('Dragonstone',1,1,2,FALSE)
,('Kingswood',1,1,0,FALSE)
,('The Eyrie',1,1,1,FALSE)
,('Kings Landing',0,2,2,FALSE)
,('Castle Black',0,1,0,FALSE)
,('Karhold',0,1,0,FALSE)
,('The Stoney Shore',1,0,0,FALSE)
,('Widows Watch',1,0,0,FALSE)
,('Flints Finger',0,0,1,FALSE)
,('Moat Calin',0,0,1,FALSE)
,('Seagard',1,1,2,FALSE)
,('The Twins',0,1,0,FALSE)
,('The Fingers',1,0,0,FALSE)
,('The Mountains of the Moon',1,0,0,FALSE)
,('Riverrun',1,1,2,FALSE)
,('Harrenhal',0,1,1,FALSE)
,('Crackclaw Point',0,0,1,FALSE)
,('Searoad Marches',1,0,0,FALSE)
,('Blackwater',2,0,0,FALSE)
,('The Reach',0,0,1,FALSE)
,('The Boneway',0,1,0,FALSE)
,('Port at Storms End',0,0,0,TRUE)
,('Storms End',0,0,1,FALSE)
,('Port at Oldtown',0,0,0,TRUE)
,('Oldtown',0,0,2,FALSE)
,('Three Towers',1,0,0,FALSE)
,('The Arbor',0,1,0,FALSE)
,('Princes Pass',1,1,0,FALSE)
,('Starfall',1,0,1,FALSE)
,('Yronwood',0,0,1,FALSE);


CREATE TABLE LookUp.Units 
(
    nUnitID smallserial,
    cName VARCHAR(13) NOT NULL,
    nAttack INT NOT NULL,
    nDefense INT NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_Units UNIQUE (nUnitID),
    CONSTRAINT pk_LookUp_Units PRIMARY KEY (cName)
);
COMMENT ON TABLE LookUp.Units IS 'Holds information about units.';
CLUSTER LookUp.Units USING uc_CLIDX_LookUp_Units;


INSERT INTO LookUp.Units(cName, nAttack, nDefense)
VALUES
 ('Footman',1,1)
,('Knight',2,2)
,('Ship',1,1)
,('Siege Engine',4,0)
,('Neutral Force',0,1)
,('Garrison',0,2);

CREATE TEMPORARY TABLE TempConnectedAreas
(
	cMain VARCHAR(25),
	cSurround VARCHAR(25)
);

INSERT INTO TempConnectedAreas(cMain, cSurround)
VALUES
 ( 'Bay Of Ice','Castle Black')
,( 'Bay Of Ice','Port at Winterfell')
,( 'Bay Of Ice','Winterfell')
,( 'Bay Of Ice','The Stoney Shore')
,( 'Bay Of Ice','Sunset Sea')
,( 'Bay Of Ice','Flints Finger')
,( 'Bay Of Ice','Greywater Watch')
,( 'Sunset Sea','Flints Finger')
,( 'Sunset Sea','Ironmans Bay')
,( 'Sunset Sea','The Golden Sound')
,( 'Sunset Sea','West Summer Sea')
,( 'Sunset Sea','Searoad Marches')
,( 'Sunset Sea','Bay Of Ice')
,( 'Ironmans Bay','Flints Finger')
,( 'Ironmans Bay','Port at Pyke')
,( 'Ironmans Bay','Pyke')
,( 'Ironmans Bay','Greywater Watch')
,( 'Ironmans Bay','The Golden Sound')
,( 'Ironmans Bay','Seagard')
,( 'Ironmans Bay','Riverrun')
,( 'Ironmans Bay','Sunset Sea')
,( 'The Golden Sound','Riverrun')
,( 'The Golden Sound','Port at Lannisport')
,( 'The Golden Sound','Lannisport')
,( 'The Golden Sound','Searoad Marches')
,( 'The Golden Sound','Sunset Sea')
,( 'The Golden Sound','Ironmans Bay')
,( 'Redwyne Straights','West Summer Sea')
,( 'Redwyne Straights','The Arbor')
,( 'Redwyne Straights','Highgarden')
,( 'Redwyne Straights','Port at Oldtown')
,( 'Redwyne Straights','Oldtown')
,( 'Redwyne Straights','Three Towers')
,( 'West Summer Sea','East Summer Sea')
,( 'West Summer Sea','The Arbor')
,( 'West Summer Sea','Searoad Marches')
,( 'West Summer Sea','Highgarden')
,( 'West Summer Sea','Three Towers')
,( 'West Summer Sea','Starfall')
,( 'West Summer Sea','Sunset Sea')
,( 'West Summer Sea','Redwyne Straights')
,( 'East Summer Sea','Starfall')
,( 'East Summer Sea','Salt Shore')
,( 'East Summer Sea','Port at Sunspear')
,( 'East Summer Sea','Sunspear')
,( 'East Summer Sea','Sea of Dorne')
,( 'East Summer Sea','Storms End')
,( 'East Summer Sea','Shipbreaker Bay')
,( 'East Summer Sea','West Summer Sea')
,( 'Sea of Dorne','Sunspear')
,( 'Sea of Dorne','Yronwood')
,( 'Sea of Dorne','The Boneway')
,( 'Sea of Dorne','Storms End')
,( 'Sea of Dorne','East Summer Sea')
,( 'Shipbreaker Bay','Port at Storms End')
,( 'Shipbreaker Bay','Storms End')
,( 'Shipbreaker Bay','Kingswood')
,( 'Shipbreaker Bay','Blackwater Bay')
,( 'Shipbreaker Bay','Crackclaw Point')
,( 'Shipbreaker Bay','The Narrow Sea')
,( 'Shipbreaker Bay','Port at Dragonstone')
,( 'Shipbreaker Bay','Dragonstone')
,( 'Shipbreaker Bay','East Summer Sea')
,( 'Blackwater Bay','Kingswood')
,( 'Blackwater Bay','Kings Landing')
,( 'Blackwater Bay','Crackclaw Point')
,( 'Blackwater Bay','Shipbreaker Bay')
,( 'The Narrow Sea','Crackclaw Point')
,( 'The Narrow Sea','The Mountains of the Moon')
,( 'The Narrow Sea','The Eyrie')
,( 'The Narrow Sea','The Twins')
,( 'The Narrow Sea','The Fingers')
,( 'The Narrow Sea','Moat Calin')
,( 'The Narrow Sea','Port at White Harbor')
,( 'The Narrow Sea','White Harbor')
,( 'The Narrow Sea','Widows Watch')
,( 'The Narrow Sea','The Shivering Sea')
,( 'The Narrow Sea','Shipbreaker Bay')
,( 'The Shivering Sea','Widows Watch')
,( 'The Shivering Sea','White Harbor')
,( 'The Shivering Sea','Winterfell')
,( 'The Shivering Sea','Karhold')
,( 'The Shivering Sea','Castle Black')
,( 'The Shivering Sea','The Narrow Sea')
,( 'Port at Winterfell','Winterfell')
,( 'Port at Winterfell','Bay Of Ice')
,( 'Winterfell','Castle Black')
,( 'Winterfell','Karhold')
,( 'Winterfell','The Stoney Shore')
,( 'Winterfell','White Harbor')
,( 'Winterfell','Moat Calin')
,( 'Winterfell','Bay Of Ice')
,( 'Winterfell','The Shivering Sea')
,( 'Winterfell','Port at Winterfell')
,( 'Port at White Harbor','White Harbor')
,( 'Port at White Harbor','The Narrow Sea')
,( 'White Harbor','Moat Calin')
,( 'White Harbor','Widows Watch')
,( 'White Harbor','The Narrow Sea')
,( 'White Harbor','The Shivering Sea')
,( 'White Harbor','Winterfell')
,( 'White Harbor','Port at White Harbor')
,( 'Port at Pyke','Pyke')
,( 'Port at Pyke','Ironmans Bay')
,( 'Pyke','Ironmans Bay')
,( 'Pyke','Port at Pyke')
,( 'Greywater Watch','Flints Finger')
,( 'Greywater Watch','Moat Calin')
,( 'Greywater Watch','Seagard')
,( 'Greywater Watch','Bay Of Ice')
,( 'Greywater Watch','Ironmans Bay')
,( 'Port at Lannisport','Lannisport')
,( 'Port at Lannisport','The Golden Sound')
,( 'Lannisport','Riverrun')
,( 'Lannisport','Stoney Sept')
,( 'Lannisport','Searoad Marches')
,( 'Lannisport','The Golden Sound')
,( 'Lannisport','Port at Lannisport')
,( 'Stoney Sept','Searoad Marches')
,( 'Stoney Sept','Riverrun')
,( 'Stoney Sept','Harrenhal')
,( 'Stoney Sept','Blackwater')
,( 'Stoney Sept','Lannisport')
,( 'Port at Sunspear','Sunspear')
,( 'Port at Sunspear','East Summer Sea')
,( 'Sunspear','Yronwood')
,( 'Sunspear','Salt Shore')
,( 'Sunspear','East Summer Sea')
,( 'Sunspear','Sea of Dorne')
,( 'Sunspear','Port at Sunspear')
,( 'Salt Shore','Yronwood')
,( 'Salt Shore','Starfall')
,( 'Salt Shore','East Summer Sea')
,( 'Salt Shore','Sunspear')
,( 'Highgarden','Searoad Marches')
,( 'Highgarden','The Reach')
,( 'Highgarden','Dornish Marches')
,( 'Highgarden','Oldtown')
,( 'Highgarden','Redwyne Straights')
,( 'Highgarden','West Summer Sea')
,( 'Dornish Marches','The Reach')
,( 'Dornish Marches','The Boneway')
,( 'Dornish Marches','Princes Pass')
,( 'Dornish Marches','Three Towers')
,( 'Dornish Marches','Oldtown')
,( 'Dornish Marches','Highgarden')
,( 'Port at Dragonstone','Dragonstone')
,( 'Port at Dragonstone','Shipbreaker Bay')
,( 'Dragonstone','Shipbreaker Bay')
,( 'Dragonstone','Port at Dragonstone')
,( 'Kingswood','Storms End')
,( 'Kingswood','The Boneway')
,( 'Kingswood','The Reach')
,( 'Kingswood','Kings Landing')
,( 'Kingswood','Shipbreaker Bay')
,( 'Kingswood','Blackwater Bay')
,( 'The Eyrie','The Mountains of the Moon')
,( 'The Eyrie','The Narrow Sea')
,( 'Kings Landing','The Reach')
,( 'Kings Landing','Blackwater')
,( 'Kings Landing','Crackclaw Point')
,( 'Kings Landing','Blackwater Bay')
,( 'Kings Landing','Kingswood')
,( 'Castle Black','Karhold')
,( 'Castle Black','Bay Of Ice')
,( 'Castle Black','The Shivering Sea')
,( 'Castle Black','Winterfell')
,( 'Karhold','The Shivering Sea')
,( 'Karhold','Winterfell')
,( 'Karhold','Castle Black')
,( 'The Stoney Shore','Bay Of Ice')
,( 'The Stoney Shore','Winterfell')
,( 'Widows Watch','The Narrow Sea')
,( 'Widows Watch','The Shivering Sea')
,( 'Widows Watch','White Harbor')
,( 'Flints Finger','Bay Of Ice')
,( 'Flints Finger','Sunset Sea')
,( 'Flints Finger','Ironmans Bay')
,( 'Flints Finger','Greywater Watch')
,( 'Moat Calin','Seagard')
,( 'Moat Calin','The Twins')
,( 'Moat Calin','The Narrow Sea')
,( 'Moat Calin','Winterfell')
,( 'Moat Calin','White Harbor')
,( 'Moat Calin','Greywater Watch')
,( 'Seagard','Riverrun')
,( 'Seagard','The Twins')
,( 'Seagard','Ironmans Bay')
,( 'Seagard','Greywater Watch')
,( 'Seagard','Moat Calin')
,( 'The Twins','The Fingers')
,( 'The Twins','The Mountains of the Moon')
,( 'The Twins','The Narrow Sea')
,( 'The Twins','Moat Calin')
,( 'The Twins','Seagard')
,( 'The Fingers','The Mountains of the Moon')
,( 'The Fingers','The Narrow Sea')
,( 'The Fingers','The Twins')
,( 'The Mountains of the Moon','Crackclaw Point')
,( 'The Mountains of the Moon','The Narrow Sea')
,( 'The Mountains of the Moon','The Eyrie')
,( 'The Mountains of the Moon','The Twins')
,( 'The Mountains of the Moon','The Fingers')
,( 'Riverrun','Harrenhal')
,( 'Riverrun','Ironmans Bay')
,( 'Riverrun','The Golden Sound')
,( 'Riverrun','Lannisport')
,( 'Riverrun','Stoney Sept')
,( 'Riverrun','Seagard')
,( 'Harrenhal','Crackclaw Point')
,( 'Harrenhal','Blackwater')
,( 'Harrenhal','Stoney Sept')
,( 'Harrenhal','Riverrun')
,( 'Crackclaw Point','Blackwater')
,( 'Crackclaw Point','Shipbreaker Bay')
,( 'Crackclaw Point','Blackwater Bay')
,( 'Crackclaw Point','The Narrow Sea')
,( 'Crackclaw Point','Kings Landing')
,( 'Crackclaw Point','The Mountains of the Moon')
,( 'Crackclaw Point','Harrenhal')
,( 'Searoad Marches','Blackwater')
,( 'Searoad Marches','The Reach')
,( 'Searoad Marches','Sunset Sea')
,( 'Searoad Marches','The Golden Sound')
,( 'Searoad Marches','West Summer Sea')
,( 'Searoad Marches','Lannisport')
,( 'Searoad Marches','Stoney Sept')
,( 'Searoad Marches','Highgarden')
,( 'Blackwater','The Reach')
,( 'Blackwater','Stoney Sept')
,( 'Blackwater','Kings Landing')
,( 'Blackwater','Harrenhal')
,( 'Blackwater','Crackclaw Point')
,( 'Blackwater','Searoad Marches')
,( 'The Reach','The Boneway')
,( 'The Reach','Highgarden')
,( 'The Reach','Dornish Marches')
,( 'The Reach','Kingswood')
,( 'The Reach','Kings Landing')
,( 'The Reach','Searoad Marches')
,( 'The Reach','Blackwater')
,( 'The Boneway','Storms End')
,( 'The Boneway','Yronwood')
,( 'The Boneway','Princes Pass')
,( 'The Boneway','Sea of Dorne')
,( 'The Boneway','Dornish Marches')
,( 'The Boneway','Kingswood')
,( 'The Boneway','The Reach')
,( 'Port at Storms End','Storms End')
,( 'Port at Storms End','Shipbreaker Bay')
,( 'Storms End','East Summer Sea')
,( 'Storms End','Sea of Dorne')
,( 'Storms End','Shipbreaker Bay')
,( 'Storms End','Kingswood')
,( 'Storms End','The Boneway')
,( 'Storms End','Port at Storms End')
,( 'Port at Oldtown','Oldtown')
,( 'Port at Oldtown','Redwyne Straights')
,( 'Oldtown','Three Towers')
,( 'Oldtown','Redwyne Straights')
,( 'Oldtown','Highgarden')
,( 'Oldtown','Dornish Marches')
,( 'Oldtown','Port at Oldtown')
,( 'Three Towers','Princes Pass')
,( 'Three Towers','Redwyne Straights')
,( 'Three Towers','West Summer Sea')
,( 'Three Towers','Dornish Marches')
,( 'Three Towers','Oldtown')
,( 'The Arbor','Redwyne Straights')
,( 'The Arbor','West Summer Sea')
,( 'Princes Pass','Yronwood')
,( 'Princes Pass','Starfall')
,( 'Princes Pass','Dornish Marches')
,( 'Princes Pass','The Boneway')
,( 'Princes Pass','Three Towers')
,( 'Starfall','Yronwood')
,( 'Starfall','West Summer Sea')
,( 'Starfall','East Summer Sea')
,( 'Starfall','Salt Shore')
,( 'Starfall','Princes Pass')
,( 'Yronwood','Sea of Dorne')
,( 'Yronwood','Sunspear')
,( 'Yronwood','Salt Shore')
,( 'Yronwood','The Boneway')
,( 'Yronwood','Princes Pass')
,( 'Yronwood','Starfall');


CREATE TABLE LookUp.AreaConnections 
(
    nAreaConnectionID smallserial,
    nMainAreaID INT NOT NULL,
    nSurroundingAreaID INT NOT NULL,
    CONSTRAINT pk_LookUp_AreaConnections PRIMARY KEY (nMainAreaID , nSurroundingAreaID),
    CONSTRAINT uc_CLIDX_LookUp_AreaConnections UNIQUE (nAreaConnectionID),
    CONSTRAINT fk_LookUp_AreaConnections_nMainAreaID_Areas_nAreaID FOREIGN KEY (nMainAreaID)
        REFERENCES LookUp.Areas (nAreaID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_AreaConnections_nSurroundingAreaID_Areas_nAreaID FOREIGN KEY (nSurroundingAreaID)
        REFERENCES LookUp.Areas (nAreaID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CLUSTER LookUp.AreaConnections USING uc_CLIDX_LookUp_AreaConnections;

INSERT INTO LookUp.AreaConnections(nMainAreaID, nSurroundingAreaID)
SELECT
     A1.nAreaID
    ,A2.nAreaID
FROM
    TempConnectedAreas TCA
JOIN 
	LookUp.Areas A1
	ON 
		A1.cName = TCA.cMain
JOIN 
	LookUp.Areas A2
	ON
		A2.cName = TCA.cSurround;

CREATE TABLE LookUp.CardIcons
(
	nCardIconID smallserial,
    cIconName VARCHAR(20) NOT NULL,
    cDescription VARCHAR(500) NULL,
    CONSTRAINT uc_CLIDX_LookUp_CardIcons UNIQUE (nCardIconID),
    CONSTRAINT pk_LookUp_CardIcons PRIMARY KEY (cIconName)
);

CLUSTER LookUp.CardIcons USING uc_CLIDX_LookUp_CardIcons;

INSERT INTO LookUp.CardIcons (cIconName, cDescription)
VALUES
 ('Sword', 'Causes one casualty to the defeated player at the end of combat (if icon is present on victor''s House card).')
,('Fortification', 'Prevents one casualty to the defeated player at the end of combat (if icon is present on defeated player''s House card).')
,('Skull', 'Causes one casualty to the opposing combatant at the end of combat. This casualty cannot be prevented by fortification icons.')
,('Wildling', 'Advance the Wildling Threat token one space on the Wildlings track when this icon appears on a Westeros card.')
,('Text', 'Text on the card.');

CREATE TABLE LookUp.CardAbilitySets
(
	nCardAbilitySetID INT NOT NULL,
    CONSTRAINT pk_CLIDX_LookUp_CardAbilitySets PRIMARY KEY (nCardAbilitySetID)
);
CLUSTER LookUp.CardAbilitySets USING pk_CLIDX_LookUp_CardAbilitySets;

CREATE TEMPORARY TABLE TempCardAbilities
(
    nCardAbilitySetID INT,
    cIconName VARCHAR(20),
    nTimes INT
);

INSERT INTO TempCardAbilities(nCardAbilitySetID, cIconName, nTimes)
VALUES
 (1, 'Text', 1)
,(2, 'Sword', 1)
,(2, 'Fortification', 1)
,(3, 'Sword', 1)
,(4, 'Sword', 3)
,(5, 'Fortification', 2)
,(6, 'Sword', 2)
,(7, 'Fortification', 1)
,(7, 'Sword', 2)
,(8, 'Fortification', 1)
,(9, 'Wildling', 1)
,(10, 'Wildling', 1)
,(10, 'Text', 1)
,(11, 'Skull', 1);

INSERT INTO LookUp.CardAbilitySets (nCardAbilitySetID)
SELECT DISTINCT
	nCardAbilitySetID
FROM
	TempCardAbilities;

CREATE TABLE LookUp.CardAbilities
(
	nCardAbilityID smallserial,
    nCardAbilitySetID INT NOT NULL,
    nTimes INT NOT NULL,
    nCardIconID INT NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_CardAbilities UNIQUE (nCardAbilityID),
    CONSTRAINT pk_LookUp_CardAbilities PRIMARY KEY (nCardAbilitySetID, nCardIconID),
    CONSTRAINT fk_LookUp_CardAbilities_CardAbilitiesSets_nCardAbilitySetID FOREIGN KEY (nCardAbilitySetID)
		REFERENCES LookUp.CardAbilitySets (nCardAbilitySetID) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_LookUp_CardAbilities_CardIcons_nCardIconID FOREIGN KEY (nCardIconID)
		REFERENCES LookUp.CardIcons (nCardIconID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.CardAbilities USING uc_CLIDX_LookUp_CardAbilities;

INSERT INTO LookUp.CardAbilities (nCardAbilitySetID, nTimes, nCardIconID)
SELECT
	 TCA.nCardAbilitySetID
    ,TCA.nTimes
    ,CI.nCardIconID
FROM
	TempCardAbilities TCA
JOIN
	LookUp.CardIcons CI
	ON
		CI.cIconName = TCA.cIconName;

CREATE TABLE LookUp.Houses (
    nHouseID smallserial,
    cName VARCHAR(9) NOT NULL,
    nIronThrone INT NOT NULL,
    nFiefdom INT NOT NULL,
    nKingsCourt INT NOT NULL,
    nSupply INT NOT NULL,
    nVictory INT NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_Houses UNIQUE (nHouseID),
    CONSTRAINT pk_LookUp_Houses PRIMARY KEY (cName)
);
CLUSTER LookUp.Houses USING uc_CLIDX_LookUp_Houses;

INSERT INTO LookUp.Houses(cName, nIronThrone, nFiefdom, nKingsCourt, nSupply, nVictory)
VALUES
 ('Stark',3,4,2,1,2)
,('Lannister',2,6,1,2,1)
,('Baratheon',1,5,4,2,1)
,('Greyjoy',5,1,6,2,1)
,('Tyrell',6,2,5,2,1)
,('Martell',4,3,3,2,1)
,('Neutral',0,0,0,0,0);

CREATE TABLE LookUp.HouseCards 
(
	nHouseCardID smallserial,
	cPersonName VARCHAR(70) NOT NULL,
	nHouseID INT NOT NULL,
	nCombatStrength INT NOT NULL,
	nCardAbilitySetID INT NOT NULL,
	CONSTRAINT uc_CLIDX_LookUp_HouseCards UNIQUE (nHouseCardID),
	CONSTRAINT pk_LookUp_HouseCards PRIMARY KEY (cPersonName),
	CONSTRAINT fk_LookUp_HouseCards_Houses_nHouseID FOREIGN KEY (nHouseID)
	REFERENCES LookUp.Houses (nHouseID) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_LookUp_HouseCards_CardAbilitiesSets_nCardAbilitySetID FOREIGN KEY (nCardAbilitySetID)
		REFERENCES LookUp.CardAbilitySets (nCardAbilitySetID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

COMMENT ON TABLE LookUp.HouseCards IS 'The number on the upper left side of the card';
CLUSTER LookUp.HouseCards USING uc_CLIDX_LookUp_HouseCards;

CREATE TEMPORARY TABLE TempHouseCards
(
	cHouse VARCHAR(9),
	cPersonName VARCHAR(70),
	nCombatStrength INT,
	nAbility INT
);

INSERT INTO TempHouseCards(cHouse, cPersonName, nCombatStrength, nAbility)
VALUES
 ('Greyjoy', 'Euron Crows Eye', 4, 3)
,('Greyjoy', 'Theon Greyjoy', 2, 1)
,('Greyjoy', 'Victarion Greyjoy', 3, 1)
,('Greyjoy', 'Balon Greyjoy', 2, 1)
,('Greyjoy', 'Asha Greyjoy', 1, 1)
,('Greyjoy', 'Dagmar Cleftjaw', 1, 2)
,('Greyjoy', 'Aeron Damphair', 0, 1)
,('Tyrell', 'Mace Tyrell', 4, 1)
,('Tyrell', 'Ser Loras Tyrell', 3, 1)
,('Tyrell', 'Ser Garlan Tyrell', 2, 6)
,('Tyrell', 'Randyll Tarly', 2, 3)
,('Tyrell', 'Alester Florent', 1, 8)
,('Tyrell', 'Margaery Tyrell', 1, 8)
,('Tyrell', 'Queen of Thorns', 0, 1)
,('Martell', 'The Red Viper', 4, 7)
,('Martell', 'Areo Hotah', 3, 8)
,('Martell', 'Obara Sand', 2, 3)
,('Martell', 'Darkstar', 2, 3)
,('Martell', 'Nymeria Sand', 1, 1)
,('Martell', 'Arianne Martell', 1, 1)
,('Martell', 'Doran Martell', 0, 1)
,('Baratheon', 'Stannis Baratheon', 4, 1)
,('Baratheon', 'Renly Baratheon', 3, 1)
,('Baratheon', 'Ser Davos Seaworth', 2, 1)
,('Baratheon', 'Brienne of Tarth', 2, 2)
,('Baratheon', 'Melisandre', 1, 3)
,('Baratheon', 'Salladhor Saan', 1, 1)
,('Baratheon', 'Patchface', 0, 1)
,('Lannister', 'Tywin Lannister', 4, 1)
,('Lannister', 'Ser Gregor Clegane', 3, 4)
,('Lannister', 'The Hound', 2, 5)
,('Lannister', 'Ser Jaime Lannister', 2, 3)
,('Lannister', 'Tyrion Lannister', 1, 1)
,('Lannister', 'Ser Kevan Lannister', 1, 1)
,('Lannister', 'Cersei Lannister', 0, 1)
,('Stark', 'Eddard Stark', 4, 6)
,('Stark', 'Robb Stark', 3, 1)
,('Stark', 'Roose Bolton', 2, 1)
,('Stark', 'Greatjon Umber', 2, 3)
,('Stark', 'Ser Rodrick Cassel', 1, 5)
,('Stark', 'The Blackfish', 1, 1)
,('Stark', 'Catelyn Stark', 0, 1);

INSERT INTO LookUp.HouseCards(cPersonName, nHouseID, nCombatStrength, nCardAbilitySetID)
SELECT 
	 THC.cPersonName
    ,H.nHouseID
    ,THC.nCombatStrength
    ,THC.nAbility
FROM 
	TempHouseCards THC
JOIN 
	LookUp.Houses H
	ON 
		H.cName = THC.cHouse;


CREATE TABLE LookUp.HouseAreas 
(
    nHouseAreaID smallserial,
    nHouseID INT NOT NULL,
    nAreaID INT NOT NULL,
    nNumPlayers INT NOT NULL,
    CONSTRAINT pk_LookUp_HouseAreas PRIMARY KEY (nHouseID , nAreaID , nNumPlayers),
    CONSTRAINT uc_CLIDX_LookUp_HouseAreas UNIQUE (nHouseAreaID),
    CONSTRAINT fk_LookUp_HouseAreas_Houses_nHouseID FOREIGN KEY (nHouseID)
        REFERENCES LookUp.Houses (nHouseID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_HouseAreas_Areas_nAreaID FOREIGN KEY (nAreaID)
        REFERENCES LookUp.Areas (nAreaID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.HouseAreas USING uc_CLIDX_LookUp_HouseAreas;

CREATE TEMPORARY TABLE TempHouseAreas
(
	cHouse VARCHAR(9),
	cArea VARCHAR(25),
	nNumPlayers INT
);

INSERT INTO TempHouseAreas(cHouse, cArea, nNumPlayers)
VALUES
 ('Neutral', 'The Eyrie',3)
,('Neutral', 'Kings Landing',3)
,('Neutral', 'The Eyrie',4)
,('Neutral', 'Kings Landing',4)
,('Neutral', 'The Eyrie',5)
,('Neutral', 'Kings Landing',5)
,('Neutral', 'The Eyrie',6)
,('Neutral', 'Kings Landing',6)
,('Neutral', 'Starfall',3)
,('Neutral', 'Starfall',4)
,('Neutral', 'Starfall',5)
,('Neutral', 'Storms End',3)
,('Neutral', 'Storms End',4)
,('Neutral', 'Three Towers',3)
,('Neutral', 'Three Towers',4)
,('Neutral', 'Three Towers',5)
,('Neutral', 'Yronwood',3)
,('Neutral', 'Yronwood',4)
,('Neutral', 'Yronwood',5)
,('Neutral', 'Oldtown',3)
,('Neutral', 'Oldtown',4)
,('Neutral', 'Princes Pass',3)
,('Neutral', 'Princes Pass',4)
,('Neutral', 'Princes Pass',5)
,('Neutral', 'Pyke',3)
,('Neutral', 'Sunspear',3)
,('Neutral', 'Sunspear',4)
,('Neutral', 'Sunspear',5)
,('Neutral', 'Highgarden',3)
,('Neutral', 'The Boneway',3)
,('Neutral', 'The Boneway',4)
,('Neutral', 'The Boneway',5)
,('Neutral', 'Salt Shore',3)
,('Neutral', 'Salt Shore',4)
,('Neutral', 'Salt Shore',5)
,('Neutral', 'Dornish Marches',3)
,('Neutral', 'Dornish Marches',4)
,('Stark', 'The Shivering Sea',3)
,('Stark', 'Winterfell',3)
,('Stark', 'White Harbor',3)
,('Stark', 'The Shivering Sea',4)
,('Stark', 'Winterfell',4)
,('Stark', 'White Harbor',4)
,('Stark', 'The Shivering Sea',5)
,('Stark', 'Winterfell',5)
,('Stark', 'White Harbor',5)
,('Stark', 'The Shivering Sea',6)
,('Stark', 'Winterfell',6)
,('Stark', 'White Harbor',6)
,('Greyjoy', 'Ironmans Bay',4)
,('Greyjoy', 'Pyke',4)
,('Greyjoy', 'Greywater Watch',4)
,('Greyjoy', 'Ironmans Bay',5)
,('Greyjoy', 'Pyke',5)
,('Greyjoy', 'Greywater Watch',5)
,('Greyjoy', 'Ironmans Bay',6)
,('Greyjoy', 'Pyke',6)
,('Greyjoy', 'Greywater Watch',6)
,('Lannister', 'The Golden Sound',3)
,('Lannister', 'Lannisport',3)
,('Lannister', 'Stoney Sept',3)
,('Lannister', 'The Golden Sound',4)
,('Lannister', 'Lannisport',4)
,('Lannister', 'Stoney Sept',4)
,('Lannister', 'The Golden Sound',5)
,('Lannister', 'Lannisport',5)
,('Lannister', 'Stoney Sept',5)
,('Lannister', 'The Golden Sound',6)
,('Lannister', 'Lannisport',6)
,('Lannister', 'Stoney Sept',6)
,('Martell', 'Sea of Dorne',6)
,('Martell', 'Sunspear',6)
,('Martell', 'Salt Shore',6)
,('Tyrell', 'Highgarden',5)
,('Tyrell', 'Dornish Marches',5)
,('Tyrell', 'Redwyne Straights',5)
,('Tyrell', 'Highgarden',6)
,('Tyrell', 'Dornish Marches',6)
,('Tyrell', 'Redwyne Straights',6)
,('Baratheon', 'Shipbreaker Bay',3)
,('Baratheon', 'Dragonstone',3)
,('Baratheon', 'Kingswood',3)
,('Baratheon', 'Shipbreaker Bay',4)
,('Baratheon', 'Dragonstone',4)
,('Baratheon', 'Kingswood',4)
,('Baratheon', 'Shipbreaker Bay',5)
,('Baratheon', 'Dragonstone',5)
,('Baratheon', 'Kingswood',5)
,('Baratheon', 'Shipbreaker Bay',6)
,('Baratheon', 'Dragonstone',6)
,('Baratheon', 'Kingswood',6);

INSERT INTO LookUp.HouseAreas(nHouseID, nAreaID, nNumPlayers)
SELECT 
	 H.nHouseID
    ,A.nAreaID
    ,THA.nNumPlayers
FROM 
	TempHouseAreas THA
JOIN 
	LookUp.Houses H
	ON
		H.cName = THA.cHouse
JOIN 
	LookUp.Areas A
	ON 
		A.cName = THA.cArea;


CREATE TABLE LookUp.HouseAreaUnits 
(
    nHouseAreaUnitID smallserial,
    nHouseAreaID INT NOT NULL,
    nUnitID INT NOT NULL,
    nNumUnits INT NOT NULL,
    CONSTRAINT pk_LookUp_HouseAreaUnits PRIMARY KEY (nHouseAreaID , nUnitID),
    CONSTRAINT uc_CLIDX_LookUp_HouseAreaUnits UNIQUE (nHouseAreaUnitID),
    CONSTRAINT fk_LookUp_HouseAreaUnits_HouseAreas_nHouseAreaID FOREIGN KEY (nHouseAreaID)
        REFERENCES LookUp.HouseAreas (nHouseAreaID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_HouseAreaUnits_Units_nUnitID FOREIGN KEY (nUnitID)
        REFERENCES LookUp.Units (nUnitID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CLUSTER LookUp.HouseAreaUnits USING uc_CLIDX_LookUp_HouseAreaUnits;

CREATE TEMPORARY TABLE TempHouseAreaUnits
(
	cHouse VARCHAR(9),
	cArea VARCHAR(25),
	nNumPlayers INT,
	cUnit VARCHAR(13),
	nUnit INT
);

INSERT INTO TempHouseAreaUnits(cHouse, cArea, nNumPlayers, cUnit, nUnit)
VALUES
 ('Baratheon', 'Dragonstone', 3, 'Footman', 1)
,('Baratheon', 'Dragonstone', 3, 'Garrison', 2)
,('Baratheon', 'Dragonstone', 3, 'Knight', 1)
,('Baratheon', 'Dragonstone', 4, 'Footman', 1)
,('Baratheon', 'Dragonstone', 4, 'Garrison', 2)
,('Baratheon', 'Dragonstone', 4, 'Knight', 1)
,('Baratheon', 'Dragonstone', 5, 'Footman', 1)
,('Baratheon', 'Dragonstone', 5, 'Garrison', 2)
,('Baratheon', 'Dragonstone', 5, 'Knight', 1)
,('Baratheon', 'Dragonstone', 6, 'Footman', 1)
,('Baratheon', 'Dragonstone', 6, 'Garrison', 2)
,('Baratheon', 'Dragonstone', 6, 'Knight', 1)
,('Baratheon', 'Kingswood', 3, 'Footman', 1)
,('Baratheon', 'Kingswood', 4, 'Footman', 1)
,('Baratheon', 'Kingswood', 5, 'Footman', 1)
,('Baratheon', 'Kingswood', 6, 'Footman', 1)
,('Baratheon', 'Shipbreaker Bay', 3, 'Ship', 2)
,('Baratheon', 'Shipbreaker Bay', 4, 'Ship', 2)
,('Baratheon', 'Shipbreaker Bay', 5, 'Ship', 2)
,('Baratheon', 'Shipbreaker Bay', 6, 'Ship', 2)
,('Greyjoy', 'Greywater Watch', 4, 'Footman', 1)
,('Greyjoy', 'Greywater Watch', 5, 'Footman', 1)
,('Greyjoy', 'Greywater Watch', 6, 'Footman', 1)
,('Greyjoy', 'Ironmans Bay', 4, 'Ship', 1)
,('Greyjoy', 'Ironmans Bay', 5, 'Ship', 1)
,('Greyjoy', 'Ironmans Bay', 6, 'Ship', 1)
,('Greyjoy', 'Pyke', 4, 'Footman', 1)
,('Greyjoy', 'Pyke', 4, 'Garrison', 2)
,('Greyjoy', 'Pyke', 4, 'Knight', 1)
,('Greyjoy', 'Pyke', 4, 'Ship', 1)
,('Greyjoy', 'Pyke', 5, 'Footman', 1)
,('Greyjoy', 'Pyke', 5, 'Garrison', 2)
,('Greyjoy', 'Pyke', 5, 'Knight', 1)
,('Greyjoy', 'Pyke', 5, 'Ship', 1)
,('Greyjoy', 'Pyke', 6, 'Footman', 1)
,('Greyjoy', 'Pyke', 6, 'Garrison', 2)
,('Greyjoy', 'Pyke', 6, 'Knight', 1)
,('Greyjoy', 'Pyke', 6, 'Ship', 1)
,('Lannister', 'Lannisport', 3, 'Footman', 1)
,('Lannister', 'Lannisport', 3, 'Garrison', 2)
,('Lannister', 'Lannisport', 3, 'Knight', 1)
,('Lannister', 'Lannisport', 4, 'Footman', 1)
,('Lannister', 'Lannisport', 4, 'Garrison', 2)
,('Lannister', 'Lannisport', 4, 'Knight', 1)
,('Lannister', 'Lannisport', 5, 'Footman', 1)
,('Lannister', 'Lannisport', 5, 'Garrison', 2)
,('Lannister', 'Lannisport', 5, 'Knight', 1)
,('Lannister', 'Lannisport', 6, 'Footman', 1)
,('Lannister', 'Lannisport', 6, 'Garrison', 2)
,('Lannister', 'Lannisport', 6, 'Knight', 1)
,('Lannister', 'Stoney Sept', 3, 'Footman', 1)
,('Lannister', 'Stoney Sept', 4, 'Footman', 1)
,('Lannister', 'Stoney Sept', 5, 'Footman', 1)
,('Lannister', 'Stoney Sept', 6, 'Footman', 1)
,('Lannister', 'The Golden Sound', 3, 'Ship', 1)
,('Lannister', 'The Golden Sound', 4, 'Ship', 1)
,('Lannister', 'The Golden Sound', 5, 'Ship', 1)
,('Lannister', 'The Golden Sound', 6, 'Ship', 1)
,('Martell', 'Salt Shore', 6, 'Footman', 1)
,('Martell', 'Sea of Dorne', 6, 'Ship', 1)
,('Martell', 'Sunspear', 6, 'Footman', 1)
,('Martell', 'Sunspear', 6, 'Garrison', 2)
,('Martell', 'Sunspear', 6, 'Knight', 1)
,('Neutral', 'Dornish Marches', 3, 'Garrison', 99)
,('Neutral', 'Dornish Marches', 4, 'Garrison', 3)
,('Neutral', 'Highgarden', 3, 'Garrison', 99)
,('Neutral', 'Kings Landing', 3, 'Garrison', 5)
,('Neutral', 'Kings Landing', 4, 'Garrison', 5)
,('Neutral', 'Kings Landing', 5, 'Garrison', 5)
,('Neutral', 'Kings Landing', 6, 'Garrison', 5)
,('Neutral', 'Oldtown', 3, 'Garrison', 99)
,('Neutral', 'Oldtown', 4, 'Garrison', 3)
,('Neutral', 'Princes Pass', 3, 'Garrison', 99)
,('Neutral', 'Princes Pass', 4, 'Garrison', 3)
,('Neutral', 'Princes Pass', 5, 'Garrison', 3)
,('Neutral', 'Pyke', 3, 'Garrison', 99)
,('Neutral', 'Salt Shore', 3, 'Garrison', 99)
,('Neutral', 'Salt Shore', 4, 'Garrison', 3)
,('Neutral', 'Salt Shore', 5, 'Garrison', 3)
,('Neutral', 'Starfall', 3, 'Garrison', 99)
,('Neutral', 'Starfall', 4, 'Garrison', 3)
,('Neutral', 'Starfall', 5, 'Garrison', 3)
,('Neutral', 'Storms End', 3, 'Garrison', 99)
,('Neutral', 'Storms End', 4, 'Garrison', 4)
,('Neutral', 'Sunspear', 3, 'Garrison', 99)
,('Neutral', 'Sunspear', 4, 'Garrison', 5)
,('Neutral', 'Sunspear', 5, 'Garrison', 5)
,('Neutral', 'The Boneway', 3, 'Garrison', 99)
,('Neutral', 'The Boneway', 4, 'Garrison', 3)
,('Neutral', 'The Boneway', 5, 'Garrison', 3)
,('Neutral', 'The Eyrie', 3, 'Garrison', 6)
,('Neutral', 'The Eyrie', 4, 'Garrison', 6)
,('Neutral', 'The Eyrie', 5, 'Garrison', 6)
,('Neutral', 'The Eyrie', 6, 'Garrison', 6)
,('Neutral', 'Three Towers', 3, 'Garrison', 99)
,('Neutral', 'Three Towers', 4, 'Garrison', 3)
,('Neutral', 'Three Towers', 5, 'Garrison', 3)
,('Neutral', 'Yronwood', 3, 'Garrison', 99)
,('Neutral', 'Yronwood', 4, 'Garrison', 3)
,('Neutral', 'Yronwood', 5, 'Garrison', 3)
,('Stark', 'The Shivering Sea', 3, 'Ship', 1)
,('Stark', 'The Shivering Sea', 4, 'Ship', 1)
,('Stark', 'The Shivering Sea', 5, 'Ship', 1)
,('Stark', 'The Shivering Sea', 6, 'Ship', 1)
,('Stark', 'White Harbor', 3, 'Footman', 1)
,('Stark', 'White Harbor', 4, 'Footman', 1)
,('Stark', 'White Harbor', 5, 'Footman', 1)
,('Stark', 'White Harbor', 6, 'Footman', 1)
,('Stark', 'Winterfell', 3, 'Footman', 1)
,('Stark', 'Winterfell', 3, 'Garrison', 2)
,('Stark', 'Winterfell', 3, 'Knight', 1)
,('Stark', 'Winterfell', 4, 'Footman', 1)
,('Stark', 'Winterfell', 4, 'Garrison', 2)
,('Stark', 'Winterfell', 4, 'Knight', 1)
,('Stark', 'Winterfell', 5, 'Footman', 1)
,('Stark', 'Winterfell', 5, 'Garrison', 2)
,('Stark', 'Winterfell', 5, 'Knight', 1)
,('Stark', 'Winterfell', 6, 'Footman', 1)
,('Stark', 'Winterfell', 6, 'Garrison', 2)
,('Stark', 'Winterfell', 6, 'Knight', 1)
,('Tyrell', 'Dornish Marches', 5, 'Footman', 1)
,('Tyrell', 'Dornish Marches', 6, 'Footman', 1)
,('Tyrell', 'Highgarden', 5, 'Footman', 1)
,('Tyrell', 'Highgarden', 5, 'Garrison', 2)
,('Tyrell', 'Highgarden', 5, 'Knight', 1)
,('Tyrell', 'Highgarden', 6, 'Footman', 1)
,('Tyrell', 'Highgarden', 6, 'Garrison', 2)
,('Tyrell', 'Highgarden', 6, 'Knight', 1)
,('Tyrell', 'Redwyne Straights', 5, 'Ship', 1)
,('Tyrell', 'Redwyne Straights', 6, 'Ship', 1);


INSERT INTO LookUp.HouseAreaUnits(nHouseAreaID, nUnitID, nNumUnits)
SELECT 
	 HA.nHouseAreaID
    ,U.nUnitID
    ,THAU.nUnit
FROM 
	TempHouseAreaUnits THAU
JOIN 
	LookUp.Houses H
	ON
		H.cName = THAU.cHouse
JOIN 
	LookUp.Areas A
	ON 
		A.cName = THAU.cArea
JOIN 
	LookUp.Units U
	ON 
		U.cName = THAU.cUnit
JOIN 
	LookUp.HouseAreas HA
	ON 
		HA.nNumPlayers = THAU.nNumPlayers AND
		HA.nAreaID = A.nAreaID AND
		HA.nHouseID = H.nHouseID;


CREATE TABLE LookUp.Orders
(
	nOrderID smallserial,
    cOrderName VARCHAR(20) NOT NULL,
    CONSTRAINT pk_LookUp_Orders PRIMARY KEY (cOrderName),
    CONSTRAINT uc_CLIDX_LookUp_Orders UNIQUE (nOrderID)
);
CLUSTER LookUp.Orders USING uc_CLIDX_LookUp_Orders;

CREATE TABLE LookUp.OrderTokens
(
	nOrderTokenID smallserial,
    nOrderID INT NOT NULL,
    nCombatStrength INT NOT NULL,
    lSpecial BOOL NOT NULL,
    CONSTRAINT pk_CLIDX_LookUp_OrderTokens PRIMARY KEY (nOrderTokenID),
    CONSTRAINT fk_LookUp_OrderTokens_Orders_nOrderID FOREIGN KEY (nOrderID)
        REFERENCES LookUp.Orders (nOrderID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.OrderTokens USING pk_CLIDX_LookUp_OrderTokens;

CREATE TEMPORARY TABLE TempOrderTokens
(
    cOrderName VARCHAR(20),
    nCombatStrength INT,
    lSpecial BOOL
);

INSERT INTO TempOrderTokens(cOrderName, nCombatStrength, lSpecial)
VALUES
 ('March', 1, TRUE)
,('March', 0, FALSE)
,('March', -1, FALSE)
,('Defense', 2, TRUE)
,('Defense', 1, FALSE)
,('Defense', 1, FALSE)
,('Support', 1, TRUE)
,('Support', 0, FALSE)
,('Support', 0, FALSE)
,('Raid', 0, TRUE)
,('Raid', 0, FALSE)
,('Raid', 0, FALSE)
,('Consolidate Power', 0, TRUE)
,('Consolidate Power', 0, FALSE)
,('Consolidate Power', 0, FALSE);

INSERT INTO LookUp.Orders (cOrderName)
SELECT DISTINCT
	cOrderName
FROM
	TempOrderTokens;

INSERT INTO LookUp.OrderTokens (nOrderID, nCombatStrength, lSpecial)
SELECT
	 O.nOrderID
    ,TOT.nCombatStrength
    ,TOT.lSpecial
FROM
	TempOrderTokens TOT
JOIN
	Lookup.Orders O
    ON
		O.cOrderName = TOT.cOrderName;

CREATE TABLE LookUp.WesterosCards
(
	nWesterosCardID smallserial,
    cName VARCHAR(25) NOT NULL,
    nCardAbilitySetID INT NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_WesterosCards UNIQUE (nWesterosCardID),
    CONSTRAINT pk_LookUp_WesterosCards PRIMARY KEY (cName),
    CONSTRAINT fk_LookUp_WesterosCards_CardAbilitiesSets_nCardAbilitySetID FOREIGN KEY (nCardAbilitySetID)
		REFERENCES LookUp.CardAbilitySets (nCardAbilitySetID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.WesterosCards USING uc_CLIDX_LookUp_WesterosCards;

INSERT INTO LookUp.WesterosCards (cName, nCardAbilitySetID)
VALUES
 ('Winter Is Coming', 1)
,('Last Days of Summer', 9)
,('Mustering', 1)
,('Supply', 1)
,('A Throne of Blades', 10)
,('Game of Thrones', 1)
,('Clash of Kings', 1)
,('Dark Wings, Dark Words', 10)
,('Wildlings Attack', 1)
,('Rains of Autumn', 10)
,('Storm of Swords', 10)
,('Sea of Storms', 10)
,('Feast for Crows', 10)
,('Web of Lies', 10)
,('Put To the Sword', 1);

CREATE TABLE LookUp.WesterosDecks
(
	nWesterosDeckID smallserial,
    nWesterosCardID INT NOT NULL,
    nDeckNumber INT NOT NULL,
    CONSTRAINT pk_CLIDX_LookUp_WesterosCards PRIMARY KEY (nWesterosDeckID),
    CONSTRAINT fk_LookUp_WesterosDecks_WesterosCards_nWesterosCardID FOREIGN KEY (nWesterosCardID)
		REFERENCES LookUp.WesterosCards (nWesterosCardID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.WesterosDecks USING pk_CLIDX_LookUp_WesterosCards;

CREATE TEMPORARY TABLE TempWesterosDecks
(
    cName VARCHAR(25),
    nDeckNumber INT
);

INSERT INTO TempWesterosDecks (cName, nDeckNumber)
VALUES
 ('Winter Is Coming', 1)
,('A Throne of Blades', 1)
,('A Throne of Blades', 1)
,('Mustering', 1)
,('Mustering', 1)
,('Mustering', 1)
,('Last Days of Summer', 1)
,('Supply', 1)
,('Supply', 1)
,('Supply', 1)
,('Last Days of Summer', 2)
,('Winter Is Coming', 2)
,('Dark Wings, Dark Words', 2)
,('Dark Wings, Dark Words', 2)
,('Game of Thrones', 2)
,('Game of Thrones', 2)
,('Game of Thrones', 2)
,('Clash of Kings', 2)
,('Clash of Kings', 2)
,('Clash of Kings', 2)
,('Put To the Sword', 3)
,('Put To the Sword', 3)
,('Feast for Crows', 3)
,('Wildlings Attack', 3)
,('Wildlings Attack', 3)
,('Wildlings Attack', 3)
,('Storm of Swords', 3)
,('Sea of Storms', 3)
,('Rains of Autumn', 3)
,('Web of Lies', 3);

INSERT INTO LookUp.WesterosDecks (nWesterosCardID, nDeckNumber)
SELECT
	 WC.nWesterosCardID
    ,TWD.nDeckNumber
FROM
	TempWesterosDecks TWD
JOIN
	LookUp.WesterosCards WC
    ON
		WC.cName = TWD.cName;

CREATE TABLE LookUp.WildlingCards
(
	nWildlingCardID smallserial,
    cName VARCHAR(36) NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_WildlingCards UNIQUE (nWildlingCardID),
    CONSTRAINT pk_LookUp_WildlingCards PRIMARY KEY (cName)
);
CLUSTER LookUp.WildlingCards USING uc_CLIDX_LookUp_WildlingCards;

INSERT INTO LookUp.WildlingCards (cName)
VALUES
 ('Massing on the Milkwater')
,('Preemptive Raid')
,('Crow Killers')
,('The Horde Descends')
,('Silence at the Wall')
,('Mammoth Riders')
,('A King Beyond the Wall')
,('Rattleshirt''s Raiders')
,('Skinchanger Scout');

CREATE TABLE LookUp.TidesOfBattleCards
(
	nTidesOfBattleCardID smallserial,
    nCombatStrength INT NOT NULL,
    nCardAbilitySetID INT NULL,
    CONSTRAINT pk_CLIDX_LookUp_TidesOfBattleCards PRIMARY KEY (nTidesOfBattleCardID),
    CONSTRAINT fk_LookUp_TidesOBattleCards_CardAbilitiesSets_nCardAbilitySetID FOREIGN KEY (nCardAbilitySetID)
		REFERENCES LookUp.CardAbilitySets (nCardAbilitySetID) ON DELETE SET NULL ON UPDATE SET NULL
);
CLUSTER LookUp.TidesOfBattleCards USING pk_CLIDX_LookUp_TidesOfBattleCards;

INSERT INTO LookUp.TidesOfBattleCards (nCombatStrength, nCardAbilitySetID)
VALUES
 (0, NULL)
,(0, NULL)
,(0, NULL)
,(0, NULL)
,(0, NULL)
,(0, NULL)
,(0, NULL)
,(0, NULL)
,(2, NULL)
,(2, NULL)
,(2, NULL)
,(2, NULL)
,(3, NULL)
,(3, NULL)
,(1, 8)
,(1, 8)
,(1, 8)
,(1, 8)
,(1, 3)
,(1, 3)
,(1, 3)
,(1, 3)
,(0, 11)
,(0, 11);


DROP TABLE IF EXISTS TempHouseAreaUnits;
DROP TABLE IF EXISTS TempConnectedAreas;
DROP TABLE IF EXISTS TempHouseAreas;
DROP TABLE IF EXISTS TempHouseCards;
DROP TABLE IF EXISTS TempCardAbilities;
DROP TABLE IF EXISTS TempOrderTokens;
DROP TABLE IF EXISTS TempWesterosDecks;
