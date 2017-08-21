
DROP SCHEMA IF EXISTS LookUp CASCADE;
CREATE SCHEMA LookUp;

DROP TABLE IF EXISTS TempHouseAreaUnits;
DROP TABLE IF EXISTS TempConnectedAreas;
DROP TABLE IF EXISTS TempHouseCards;
DROP TABLE IF EXISTS TempCardAbilities;
DROP TABLE IF EXISTS TempOrderTokens;
DROP TABLE IF EXISTS TempWesterosDecks;
DROP TABLE IF EXISTS TidesOfBattleCards;
DROP TABLE IF EXISTS TempHouseTrackPositions;
DROP TABLE IF EXISTS TempObjectives;

CREATE DOMAIN 
    LookUp.playerrange int4range NOT NULL 
    CONSTRAINT chk_playerrange 
    CHECK(VALUE <@ int4range(3,6, '[]'));

CREATE TABLE LookUp.Versions
(
    nVersionID SMALLSERIAL,
    cName VARCHAR(25) NOT NULL,
    nNumPlayers LookUp.playerrange,
    nRounds SMALLINT NULL,
    CONSTRAINT pk_LookUp_Versions PRIMARY KEY (cName),
    CONSTRAINT uc_CLIDX_LookUp_Versions UNIQUE (nVersionID)
);

CLUSTER LookUp.Versions USING uc_CLIDX_LookUp_Versions;

INSERT INTO LookUp.Versions (cName, nNumPlayers, nRounds)
VALUES
 ('Original', '[3,6]', 10)
,('A Feast for Crows', '[4,4]', 10)
,('A Dance with Dragons', '[6,6]', 6);

CREATE TABLE LookUp.AreaTypes
(
    cType VARCHAR(4) NOT NULL,
    CONSTRAINT pk_CLIDX_LookUp_AreaTypes PRIMARY KEY (cType)
);

CLUSTER LookUp.AreaTypes USING pk_CLIDX_LookUp_AreaTypes;

INSERT INTO LookUp.AreaTypes (cType)
VALUES
 ('Land')
,('Port')
,('Sea');

CREATE TABLE LookUp.Areas 
(
    nAreaID SMALLSERIAL,
    cName VARCHAR(25) NOT NULL,
    nSupply SMALLINT NOT NULL,
    nPower SMALLINT NOT NULL,
    nMusteringPoints SMALLINT NOT NULL,
    cType VARCHAR(4) NOT NULL,
    CONSTRAINT pk_LookUp_Areas PRIMARY KEY (cName),
    CONSTRAINT uc_CLIDX_LookUp_Areas UNIQUE (nAreaID),
    CONSTRAINT fk_LookUp_Areas_AreaTypes_cType FOREIGN KEY (cType)
        REFERENCES LookUp.AreaTypes (cType) ON DELETE RESTRICT ON UPDATE RESTRICT
);

COMMENT ON TABLE LookUp.Areas IS 'Holds all the information about the areas.';
COMMENT ON COLUMN LookUp.Areas.nSupply IS 'How many barrels are on the area';
COMMENT ON COLUMN LookUp.Areas.nPower IS 'How many crowns are on the area';
COMMENT ON COLUMN LookUp.Areas.nMusteringPoints IS 'whether there is a castle, stronghold, or nothing on this area';

CLUSTER LookUp.Areas USING uc_CLIDX_LookUp_Areas;

INSERT INTO LookUp.Areas(cName, nSupply, nPower, nMusteringPoints, cType)
VALUES
 ('Bay Of Ice',0,0,0,'Sea')
,('Sunset Sea',0,0,0,'Sea')
,('Ironmans Bay',0,0,0,'Sea')
,('The Golden Sound',0,0,0,'Sea')
,('Redwyne Straights',0,0,0,'Sea')
,('West Summer Sea',0,0,0,'Sea')
,('East Summer Sea',0,0,0,'Sea')
,('Sea of Dorne',0,0,0,'Sea')
,('Shipbreaker Bay',0,0,0,'Sea')
,('Blackwater Bay',0,0,0,'Sea')
,('The Narrow Sea',0,0,0,'Sea')
,('The Shivering Sea',0,0,0,'Sea')
,('Port at Winterfell',0,0,0,'Port')
,('Winterfell',1,1,2,'Land')
,('Port at White Harbor',0,0,0,'Port')
,('White Harbor',0,0,1,'Land')
,('Port at Pyke',0,0,0,'Port')
,('Pyke',1,1,2,'Land')
,('Greywater Watch',1,0,0,'Land')
,('Port at Lannisport',0,0,0,'Port')
,('Lannisport',2,0,2,'Land')
,('Stoney Sept',0,1,0,'Land')
,('Port at Sunspear',0,0,0,'Port')
,('Sunspear',1,1,2,'Land')
,('Salt Shore',1,0,0,'Land')
,('Highgarden',2,0,2,'Land')
,('Dornish Marches',0,1,0,'Land')
,('Port at Dragonstone',0,0,0,'Port')
,('Dragonstone',1,1,2,'Land')
,('Kingswood',1,1,0,'Land')
,('The Eyrie',1,1,1,'Land')
,('Kings Landing',0,2,2,'Land')
,('Castle Black',0,1,0,'Land')
,('Karhold',0,1,0,'Land')
,('The Stoney Shore',1,0,0,'Land')
,('Widows Watch',1,0,0,'Land')
,('Flints Finger',0,0,1,'Land')
,('Moat Calin',0,0,1,'Land')
,('Seagard',1,1,2,'Land')
,('The Twins',0,1,0,'Land')
,('The Fingers',1,0,0,'Land')
,('The Mountains of the Moon',1,0,0,'Land')
,('Riverrun',1,1,2,'Land')
,('Harrenhal',0,1,1,'Land')
,('Crackclaw Point',0,0,1,'Land')
,('Searoad Marches',1,0,0,'Land')
,('Blackwater',2,0,0,'Land')
,('The Reach',0,0,1,'Land')
,('The Boneway',0,1,0,'Land')
,('Port at Storms End',0,0,0,'Port')
,('Storms End',0,0,1,'Land')
,('Port at Oldtown',0,0,0,'Port')
,('Oldtown',0,0,2,'Land')
,('Three Towers',1,0,0,'Land')
,('The Arbor',0,1,0,'Land')
,('Princes Pass',1,1,0,'Land')
,('Starfall',1,0,1,'Land')
,('Yronwood',0,0,1,'Land');


CREATE TABLE LookUp.Units 
(
    nUnitID SMALLSERIAL,
    cName VARCHAR(13) NOT NULL,
    nAttack SMALLINT NOT NULL,
    nDefense SMALLINT NOT NULL,
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
,('Garrison',0,2)
,('Power token', 0, 0);

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
    nAreaConnectionID SMALLSERIAL,
    nMainAreaID SMALLINT NOT NULL,
    nSurroundingAreaID SMALLINT NOT NULL,
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
    nCardIconID SMALLSERIAL,
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
    nCardAbilitySetID SMALLINT NOT NULL,
    CONSTRAINT pk_CLIDX_LookUp_CardAbilitySets PRIMARY KEY (nCardAbilitySetID)
);
CLUSTER LookUp.CardAbilitySets USING pk_CLIDX_LookUp_CardAbilitySets;

CREATE TEMPORARY TABLE TempCardAbilities
(
    nCardAbilitySetID SMALLINT,
    cIconName VARCHAR(20),
    nTimes SMALLINT
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
	TempCardAbilities
ORDER BY
	nCardAbilitySetID;

CREATE TABLE LookUp.CardAbilities
(
	nCardAbilityID SMALLSERIAL,
    nCardAbilitySetID SMALLINT NOT NULL,
    nTimes SMALLINT NOT NULL,
    nCardIconID SMALLINT NOT NULL,
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
    nHouseID SMALLSERIAL,
    cName VARCHAR(9) NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_Houses UNIQUE (nHouseID),
    CONSTRAINT pk_LookUp_Houses PRIMARY KEY (cName)
);
CLUSTER LookUp.Houses USING uc_CLIDX_LookUp_Houses;

INSERT INTO LookUp.Houses(cName)
VALUES
 ('Stark')
,('Lannister')
,('Baratheon')
,('Greyjoy')
,('Tyrell')
,('Martell')
,('Arryn')
,('Neutral');


CREATE TABLE LookUp.HouseTrackPositions (
    nHouseTrackPositionID SMALLSERIAL,
    nHouseID SMALLINT NOT NULL,
    nVersionID SMALLINT NOT NULL,
    nIronThrone SMALLINT NOT NULL,
    nFiefdom SMALLINT NOT NULL,
    nKingsCourt SMALLINT NOT NULL,
    nSupply SMALLINT NOT NULL,
    nVictory SMALLINT NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_HouseTrackPositions UNIQUE (nHouseTrackPositionID),
    CONSTRAINT pk_LookUp_HouseTrackPositions PRIMARY KEY (nHouseID, nVersionID),
    CONSTRAINT fk_LookUp_HouseTrackPositions_Houses_nHouseID FOREIGN KEY (nHouseID)
    REFERENCES LookUp.Houses (nHouseID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_HouseTrackPositions_Versions_nVersionID FOREIGN KEY (nVersionID)
    REFERENCES LookUp.Versions (nVersionID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.HouseTrackPositions USING uc_CLIDX_LookUp_HouseTrackPositions;

CREATE TEMPORARY TABLE TempHouseTrackPositions
(
    cHouse VARCHAR(9),
    cName VARCHAR(25) NOT NULL,
    nIronThrone SMALLINT NOT NULL,
    nFiefdom SMALLINT NOT NULL,
    nKingsCourt SMALLINT NOT NULL,
    nSupply SMALLINT NOT NULL,
    nVictory SMALLINT NOT NULL
);

INSERT INTO TempHouseTrackPositions
	(cHouse, cName, nIronThrone, nFiefdom, nKingsCourt, nSupply, nVictory)
VALUES
 ('Stark', 'Original', 3, 4, 2, 1, 2)
,('Lannister', 'Original', 2, 6, 1, 2, 1)
,('Baratheon', 'Original', 1, 5, 4, 2, 1)
,('Greyjoy', 'Original', 5, 1, 6, 2, 1)
,('Tyrell', 'Original', 6, 2, 5, 2, 1)
,('Martell', 'Original', 4, 3, 3, 2, 1)
,('Arryn', 'A Feast for Crows', 3, 2, 1, 3, 0)
,('Baratheon', 'A Feast for Crows', 1, 3, 3, 2, 0)
,('Stark', 'A Feast for Crows', 4, 1, 4, 2, 0)
,('Lannister', 'A Feast for Crows', 2, 4, 2, 5, 0)
,('Stark', 'A Dance with Dragons', 4, 6, 3, 2, 3)
,('Lannister', 'A Dance with Dragons', 1, 5, 4, 5, 4)
,('Baratheon', 'A Dance with Dragons', 5, 3, 5, 1, 2)
,('Greyjoy', 'A Dance with Dragons', 3, 1, 6, 3, 1)
,('Tyrell', 'A Dance with Dragons', 2, 4, 1, 4, 4)
,('Martell', 'A Dance with Dragons', 6, 2, 2, 4, 3);

INSERT INTO LookUp.HouseTrackPositions(nHouseID, nVersionID, nIronThrone, nFiefdom, nKingsCourt, nSupply, nVictory)
SELECT 
     H.nHouseID
    ,V.nVersionID
    ,THTP.nIronThrone
    ,THTP.nFiefdom
    ,THTP.nKingsCourt
    ,THTP.nSupply
    ,THTP.nVictory
FROM 
	TempHouseTrackPositions THTP
JOIN 
	LookUp.Houses H
	ON 
		H.cName = THTP.cHouse
JOIN
	LookUp.Versions V
	ON
		V.cName = THTP.cName;


CREATE TABLE LookUp.HouseCards 
(
	nHouseCardID SMALLSERIAL,
	cPersonName VARCHAR(70) NOT NULL,
	nVersionID SMALLINT NOT NULL,
	nHouseID SMALLINT NOT NULL,
	nCombatStrength SMALLINT NOT NULL,
	nCardAbilitySetID SMALLINT NOT NULL,
	cDescription VARCHAR(255) NULL,
	CONSTRAINT uc_CLIDX_LookUp_HouseCards UNIQUE (nHouseCardID),
	CONSTRAINT pk_LookUp_HouseCards PRIMARY KEY (cPersonName, nVersionID),
	CONSTRAINT fk_LookUp_HouseCards_Houses_nHouseID FOREIGN KEY (nHouseID)
	REFERENCES LookUp.Houses (nHouseID) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_LookUp_HouseCards_CardAbilitiesSets_nCardAbilitySetID FOREIGN KEY (nCardAbilitySetID)
		REFERENCES LookUp.CardAbilitySets (nCardAbilitySetID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_HouseCards_Versions_nVersionID FOREIGN KEY (nVersionID)
    REFERENCES LookUp.Versions (nVersionID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

COMMENT ON COLUMN LookUp.HouseCards.nCombatStrength IS 'The number on the upper left side of the card';

CLUSTER LookUp.HouseCards USING uc_CLIDX_LookUp_HouseCards;

CREATE TEMPORARY TABLE TempHouseCards
(
	cHouse VARCHAR(9),
	cPersonName VARCHAR(70),
	nCombatStrength SMALLINT,
	nAbility SMALLINT,
	cVersionName VARCHAR(25),
	cDescription VARCHAR(255) NULL
);

INSERT INTO TempHouseCards(cHouse, cPersonName, nCombatStrength, nAbility, cVersionName, cDescription)
VALUES
 ('Greyjoy', 'Euron Crows Eye', 4, 3, 'Original', NULL)
,('Greyjoy', 'Theon Greyjoy', 2, 1, 'Original', 'If you are defending an area that contains either a Stronghold or a Castle, this card gains +1 combat strength and a sword icon.')
,('Greyjoy', 'Victarion Greyjoy', 3, 1, 'Original', 'If you are attacking, all of your participating Ships (including supporting Greyjoy Ships) add +2 to combat strength instead of +1.')
,('Greyjoy', 'Balon Greyjoy', 2, 1, 'Original', 'The printed combat strength of your opponent''s House card is reduced to 0.')
,('Greyjoy', 'Asha Greyjoy', 1, 1, 'Original', 'If you are not being supported in this combat, this card gains two sword icons and one fortification icon.')
,('Greyjoy', 'Dagmar Cleftjaw', 1, 2, 'Original', NULL)
,('Greyjoy', 'Aeron Damphair', 0, 1, 'Original', 'You may immediately discard two of your available Power tokens to discard Aeron Damphair and choose a different House Card from your hand (if able).')
,('Tyrell', 'Mace Tyrell', 4, 1, 'Original', 'Immediately destroy one of your opponent''s attacking or defending Footmen units.')
,('Tyrell', 'Ser Loras Tyrell', 3, 1, 'Original', 'If you are attacking and win this combat, move the March Order token into the conquered area (instead of discarding it). The March Order may be resolved again later this round.')
,('Tyrell', 'Ser Garlan Tyrell', 2, 6, 'Original', NULL)
,('Tyrell', 'Randyll Tarly', 2, 3, 'Original', NULL)
,('Tyrell', 'Alester Florent', 1, 8, 'Original', NULL)
,('Tyrell', 'Margaery Tyrell', 1, 8, 'Original', NULL)
,('Tyrell', 'Queen of Thorns', 0, 1, 'Original', 'Immediately remove one of your opponent''s Order tokens in any one area adjacent to the embattled area. You may not remove the March Order token used to start this combat.')
,('Martell', 'The Red Viper', 4, 7, 'Original', NULL)
,('Martell', 'Areo Hotah', 3, 8, 'Original', NULL)
,('Martell', 'Obara Sand', 2, 3, 'Original', NULL)
,('Martell', 'Darkstar', 2, 3, 'Original', NULL)
,('Martell', 'Nymeria Sand', 1, 1, 'Original', 'If you are defending, this card gains a fortification icon. If you are attacking, this card gains a sword icon.')
,('Martell', 'Arianne Martell', 1, 1, 'Original', 'If you are defending and lose this combat, your opponent may not move his units into the embattled area. They return to the area from which they marched. Your own units must still retreat.')
,('Martell', 'Doran Martell', 0, 1, 'Original', 'Immediately move your opponent to the bottom of one Influence track of your choice.')
,('Baratheon', 'Stannis Baratheon', 4, 1, 'Original', 'If your opponent has a higher position on the Iron Throne Influence track than you, this card gains +1 combat strength.')
,('Baratheon', 'Renly Baratheon', 3, 1, 'Original', 'If you win this combat, you may upgrade one of your participating Footmen (or one supporting Baratheon Footmen) to a Knight.')
,('Baratheon', 'Ser Davos Seaworth', 2, 1, 'Original', 'If your "Stannis Baratheon" House card is in your discard pile, this card gains +1 combat strength and a sword icon.')
,('Baratheon', 'Brienne of Tarth', 2, 2, 'Original', NULL)
,('Baratheon', 'Melisandre', 1, 3, 'Original', NULL)
,('Baratheon', 'Salladhor Saan', 1, 1, 'Original', 'If you are being supported in this combat, the combat strength of all non-Baratheon Ships is reduced to 0.')
,('Baratheon', 'Patchface', 0, 1, 'Original', 'At the end of combat, you may look at your opponent''s hand and discard one card of your choice.')
,('Lannister', 'Tywin Lannister', 4, 1, 'Original', 'If you win this combat, gain two Power tokens.')
,('Lannister', 'Ser Gregor Clegane', 3, 4, 'Original', NULL)
,('Lannister', 'The Hound', 2, 5, 'Original', NULL)
,('Lannister', 'Ser Jaime Lannister', 2, 3, 'Original', NULL)
,('Lannister', 'Tyrion Lannister', 1, 1, 'Original', 'You may cancel your opponent''s chosen House card and return it to his hand. He must then choose a different House card to reveal. If he has no other House cards in hand, he cannot use a House card this combat.')
,('Lannister', 'Ser Kevan Lannister', 1, 1, 'Original', 'If you are attacking, all of your participating Footmen (including supporting Lannister Footmen) add +2 combat strength instead of +1.')
,('Lannister', 'Cersei Lannister', 0, 1, 'Original', 'If you win this combat, you may remove one of the losing opponent''s Order tokens from anywhere on the board.')
,('Stark', 'Eddard Stark', 4, 6, 'Original', NULL)
,('Stark', 'Robb Stark', 3, 1, 'Original', 'If you win this combat, you may choose the area to which your opponent retreats. You must choose a legal area where your opponent loses the fewest units.')
,('Stark', 'Roose Bolton', 2, 1, 'Original', 'If you lose this combat, return your entire House card discard pile into your hand (including this card).')
,('Stark', 'Greatjon Umber', 2, 3, 'Original', NULL)
,('Stark', 'Ser Rodrick Cassel', 1, 5, 'Original', NULL)
,('Stark', 'The Blackfish', 1, 1, 'Original', 'You do not take casualties in this combat from House card abilities, Combat icons, or Tides of Battle cards.')
,('Stark', 'Catelyn Stark', 0, 1, 'Original', 'If you have a Defense Order token in the embattled area, its value is doubled.')
,('Baratheon', 'Stannis Baratheon', 4, 1, 'A Feast for Crows', 'If your opponent has a higher position on the Iron Throne Influence track than you, this card gains +1 combat strength.')
,('Baratheon', 'Renly Baratheon', 3, 1, 'A Feast for Crows', 'If you win this combat, you may upgrade one of your participating Footmen (or one supporting Baratheon Footmen) to a Knight.')
,('Baratheon', 'Ser Davos Seaworth', 2, 1, 'A Feast for Crows', 'If your "Stannis Baratheon" House card is in your discard pile, this card gains +1 combat strength and a sword icon.')
,('Baratheon', 'Brienne of Tarth', 2, 2, 'A Feast for Crows', NULL)
,('Baratheon', 'Melisandre', 1, 3, 'A Feast for Crows', NULL)
,('Baratheon', 'Salladhor Saan', 1, 1, 'A Feast for Crows', 'If you are being supported in this combat, the combat strength of all non-Baratheon Ships is reduced to 0.')
,('Baratheon', 'Patchface', 0, 1, 'A Feast for Crows', 'At the end of combat, you may look at your opponent''s hand and discard one card of your choice.')
,('Lannister', 'Tywin Lannister', 4, 1, 'A Feast for Crows', 'If you win this combat, gain two Power tokens.')
,('Lannister', 'Ser Gregor Clegane', 3, 4, 'A Feast for Crows', NULL)
,('Lannister', 'The Hound', 2, 5, 'A Feast for Crows', NULL)
,('Lannister', 'Ser Jaime Lannister', 2, 3, 'A Feast for Crows', NULL)
,('Lannister', 'Tyrion Lannister', 1, 1, 'A Feast for Crows', 'You may cancel your opponent''s chosen House card and return it to his hand. He must then choose a different House card to reveal. If he has no other House cards in hand, he cannot use a House card this combat.')
,('Lannister', 'Ser Kevan Lannister', 1, 1, 'A Feast for Crows', 'If you are attacking, all of your participating Footmen (including supporting Lannister Footmen) add +2 combat strength instead of +1.')
,('Lannister', 'Cersei Lannister', 0, 1, 'A Feast for Crows', 'If you win this combat, you may remove one of the losing opponent''s Order tokens from anywhere on the board.')
,('Stark', 'Eddard Stark', 4, 6, 'A Feast for Crows', NULL)
,('Stark', 'Robb Stark', 3, 1, 'A Feast for Crows', 'If you win this combat, you may choose the area to which your opponent retreats. You must choose a legal area where your opponent loses the fewest units.')
,('Stark', 'Roose Bolton', 2, 1, 'A Feast for Crows', 'If you lose this combat, return your entire House card discard pile into your hand (including this card).')
,('Stark', 'Greatjon Umber', 2, 3, 'A Feast for Crows', NULL)
,('Stark', 'Ser Rodrick Cassel', 1, 5, 'A Feast for Crows', NULL)
,('Stark', 'The Blackfish', 1, 1, 'A Feast for Crows', 'You do not take casualties in this combat from House card abilities, Combat icons, or Tides of Battle cards.')
,('Stark', 'Catelyn Stark', 0, 1, 'A Feast for Crows', 'If you have a Defense Order token in the embattled area, its value is doubled.')
,('Arryn', 'Littlefinger', 3, 1, 'A Feast for Crows', 'If you control The Eyrie after this combat, gain a number of Power tokens equal to twice the printed combat strength of your opponent''s played House card.')
,('Arryn', 'Lysa Arryn', 0, 1, 'A Feast for Crows', 'After this combat, if your opponent has more available Power tokens than you, gain 3 Power tokens.')
,('Arryn', 'Bronze Yohn Royce', 4, 1, 'A Feast for Crows', 'If you have more available Power tokens than your opponent, this card gains +1 combat strength.')
,('Arryn', 'Alayne Stone', 1, 1, 'A Feast for Crows', 'If you win this combat and control The Eyrie, you may discard 2 of your available Power tokens to force your opponent to discard all of his available Power tokens.')
,('Arryn', 'Lothor Brune', 1, 2, 'A Feast for Crows', NULL)
,('Arryn', 'Lyn Corbray', 2, 3, 'A Feast for Crows', NULL)
,('Arryn', 'Nestor Royce', 2, 5, 'A Feast for Crows', NULL)
,('Tyrell', 'Mace Tyrell', 4, 2, 'A Dance with Dragons', NULL)
,('Tyrell', 'Randyll Tarly', 3, 6, 'A Dance with Dragons', NULL)
,('Tyrell', 'Willas Tyrell', 2, 8, 'A Dance with Dragons', NULL)
,('Tyrell', 'Ser Jon Fossoway', 2, 1, 'A Dance with Dragons', NULL)
,('Tyrell', 'Paxter Redwyne', 1, 1, 'A Dance with Dragons', 'If the embattled area is a sea area, all of your participating Ships (including supporting Tyrell Ships) add +2 combat strength instead of +1.')
,('Tyrell', 'Queen of Thorns', 1, 1, 'A Dance with Dragons', 'Ignore all text abilities printed on your opponent''s House card.')
,('Tyrell', 'Margaery Tyrell', 0, 1, 'A Dance with Dragons', 'If you are defending your home area or an area that contains one of your Power tokens, your opponent''s final combat strength is 2.')
,('Stark', 'Roose Bolton', 4, 3, 'A Dance with Dragons', NULL)
,('Stark', 'Ramsay Bolton', 3, 1, 'A Dance with Dragons', 'If your "Reek" House card is still in your hand, this card gains +1 combat strength and three sword icons.')
,('Stark', 'Black Walder', 2, 3, 'A Dance with Dragons', NULL)
,('Stark', 'Steelshanks Walton', 2, 8, 'A Dance with Dragons', NULL)
,('Stark', 'Walder Frey', 1, 1, 'A Dance with Dragons', 'Any player (other than your opponent) who grants support to your opponent must grant that support to you instead.')
,('Stark', 'Damon Dance-For-Me', 1, 3, 'A Dance with Dragons', NULL)
,('Stark', 'Reek', 0, 1, 'A Dance with Dragons', 'If your "Ramsay Bolton" House card is in your discard pile, immediately return it to your hand. If you lose this combat, you may return Reek to your hand.')
,('Martell', 'Doran Martell', 4, 1, 'A Dance with Dragons', 'For each House card in your hand, this card gains a fortification icon and a sword icon, and suffers -1 combat strength (to a minimum of 0).')
,('Martell', 'Areo Hotah', 3, 5, 'A Dance with Dragons', NULL)
,('Martell', 'Bastard of Godsgrace', 2, 8, 'A Dance with Dragons', NULL)
,('Martell', 'Big Man', 2, 3, 'A Dance with Dragons', NULL)
,('Martell', 'Ser Gerris Drinkwater', 1, 1, 'A Dance with Dragons', 'If you win this combat, you may move one position higher on one Influence track of your choice.')
,('Martell', 'Quentyn Martell', 1, 1, 'A Dance with Dragons', 'For each House card in your discard pile, this card gains +1 combat strength.')
,('Martell', 'Nymeria Sand', 0, 2, 'A Dance with Dragons', NULL)
,('Lannister', 'Ser Jaime Lannister', 4, 2, 'A Dance with Dragons', NULL)
,('Lannister', 'Ser Kevan Lannister', 3, 8, 'A Dance with Dragons', NULL)
,('Lannister', 'Daven Lannister', 2, 3, 'A Dance with Dragons', NULL)
,('Lannister', 'Ser Ilyn Payne', 2, 1, 'A Dance with Dragons', 'If you win this combat, you may destroy one of your opponent''s Footmen in any area (in addition to normal casualties). If that unit is the last unit in its area, remove any Order token there as well.')
,('Lannister', 'Cersei Lannister', 1, 8, 'A Dance with Dragons', NULL)
,('Lannister', 'Ser Addam Marbrand', 1, 1, 'A Dance with Dragons', 'If you are attacking, all of your participating Knights (including supporting Lannister Knights) add +3 combat strength instead of +2.')
,('Lannister', 'Qyburn', 0, 1, 'A Dance with Dragons', 'You may discard two of your available Power tokens to choose a House card in any player''s discard pile. Qyburn gains the printed combat strength and combat icons of that card, ignoring its text ability.')
,('Baratheon', 'Stannis Baratheon', 4, 1, 'A Dance with Dragons', 'If you are not being supported in this combat, remove all Support orders (including your own) adjacent to the embattled area, canceling any supporting strength they may have been providing.')
,('Baratheon', 'Jon Snow', 3, 1, 'A Dance with Dragons', 'If you win this combat, you may decrease or increase the Wildling track by one space (to a minimum of 0 and a maximum of 10).')
,('Baratheon', 'Melisandre', 2, 1, 'A Dance with Dragons', 'After combat, you may return any House card in your discard pile (including this card) to your hand by discarding a number of your available Power tokens equal to the printed combat strength of that card.')
,('Baratheon', 'Bastard of Nightsong', 2, 8, 'A Dance with Dragons', NULL)
,('Baratheon', 'Ser Davos Seasworth', 1, 2, 'A Dance with Dragons', NULL)
,('Baratheon', 'Ser Axell Florent', 1, 3, 'A Dance with Dragons', NULL)
,('Baratheon', 'Mance Rayder', 0, 1, 'A Dance with Dragons', 'Your final combat strength is equal to the current position of the Wilding Threat token.')
,('Greyjoy', 'Euron Crow''s Eye', 4, 1, 'A Dance with Dragons', 'If your opponent has a higher position on the Fiefdoms Influence track than you, this card gains +1 combat strength.')
,('Greyjoy', 'Victarion Greyjoy', 3, 6, 'A Dance with Dragons', NULL)
,('Greyjoy', 'Asha Greyjon', 2, 8, 'A Dance with Dragons', NULL)
,('Greyjoy', 'Rodrick the Reader', 2, 1, 'A Dance with Dragons', 'If you win this combat, you may search any Westeros deck for a card of your choice. Shuffle the remaining cards and place the chosen card facedown on top of the deck.')
,('Greyjoy', 'Qarl the Maid', 1, 1, 'A Dance with Dragons', 'If you are attacking and lose this combat, gain three Power tokens.')
,('Greyjoy', 'Ser Harras Harlaw', 1, 3, 'A Dance with Dragons', NULL)
,('Greyjoy', 'Aeron Damphair', 0, 1, 'A Dance with Dragons', 'You may discard any number of your available Power tokens to increase the combat strength of this card by the number of Power tokens discarded.');

INSERT INTO LookUp.HouseCards(cPersonName, nHouseID, nVersionID, nCombatStrength, nCardAbilitySetID, cDescription)
SELECT 
	 THC.cPersonName
    ,H.nHouseID
    ,V.nVersionID
    ,THC.nCombatStrength
    ,THC.nAbility
    ,THC.cDescription
FROM 
	TempHouseCards THC
JOIN 
	LookUp.Houses H
	ON 
		H.cName = THC.cHouse
JOIN
	LookUp.Versions V
	ON
		V.cName = THC.cVersionName;


CREATE TABLE LookUp.HouseAreas 
(
    nHouseAreaID SMALLSERIAL,
    nHouseID SMALLINT NOT NULL,
    nAreaID SMALLINT NOT NULL,
    nVersionID SMALLINT NOT NULL,
    nNumPlayers LookUp.playerrange,
    CONSTRAINT pk_LookUp_HouseAreas PRIMARY KEY (nAreaID, nVersionID, nNumPlayers),
   CONSTRAINT exc_LookUp_HouseAreas EXCLUDE USING gist
       (nAreaID WITH =, nVersionID WITH =, nNumPlayers WITH &&),
    CONSTRAINT uc_CLIDX_LookUp_HouseAreas UNIQUE (nHouseAreaID),
    CONSTRAINT fk_LookUp_HouseAreas_Houses_nHouseID FOREIGN KEY (nHouseID)
        REFERENCES LookUp.Houses (nHouseID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_HouseAreas_Areas_nAreaID FOREIGN KEY (nAreaID)
        REFERENCES LookUp.Areas (nAreaID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_HouseAreas_Versions_nVersionID FOREIGN KEY (nVersionID)
        REFERENCES LookUp.Versions (nVersionID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.HouseAreas USING uc_CLIDX_LookUp_HouseAreas;

CREATE FUNCTION LookUp.fr_HouseAreas() RETURNS TRIGGER AS $tr_HouseAreas$
    BEGIN
        IF NOT EXISTS
        (
            SELECT
                nVersionID
            FROM
                LookUp.Versions
            WHERE
                nVersionID = NEW.nVersionID AND
                NEW.nNumPlayers <@ nNumPlayers
        ) THEN
            RAISE EXCEPTION 'No matching row in LookUp.Version';
        END IF;
    
        RETURN NEW;
    END;
$tr_HouseAreas$ LANGUAGE plpgsql;

CREATE TRIGGER tr_HouseAreas BEFORE INSERT OR UPDATE ON LookUp.HouseAreas
    FOR EACH ROW EXECUTE PROCEDURE LookUp.fr_HouseAreas();

CREATE TABLE LookUp.HouseAreaUnits 
(
    nHouseAreaUnitID SMALLSERIAL,
    nHouseAreaID SMALLINT NOT NULL,
    nUnitID SMALLINT NOT NULL,
    nNumUnits SMALLINT NOT NULL,
    CONSTRAINT pk_LookUp_HouseAreaUnits PRIMARY KEY (nHouseAreaID, nUnitID),
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
	nNumPlayers int4range,
	cUnit VARCHAR(13),
	nUnit SMALLINT,
	cVersionName VARCHAR(25)
);

INSERT INTO TempHouseAreaUnits(cHouse, cArea, nNumPlayers, cUnit, nUnit, cVersionName)
VALUES
 ('Baratheon', 'Dragonstone', '[3, 6]', 'Footman', 1, 'Original')
,('Baratheon', 'Dragonstone', '[3, 6]', 'Garrison', 2, 'Original')
,('Baratheon', 'Dragonstone', '[3, 6]', 'Knight', 1, 'Original')
,('Baratheon', 'Kingswood', '[3, 6]', 'Footman', 1, 'Original')
,('Baratheon', 'Shipbreaker Bay', '[3, 6]', 'Ship', 2, 'Original')
,('Greyjoy', 'Greywater Watch', '[4, 6]', 'Footman', 1, 'Original')
,('Greyjoy', 'Ironmans Bay', '[4, 6]', 'Ship', 1, 'Original')
,('Greyjoy', 'Pyke', '[4, 6]', 'Footman', 1, 'Original')
,('Greyjoy', 'Pyke', '[4, 6]', 'Garrison', 2, 'Original')
,('Greyjoy', 'Pyke', '[4, 6]', 'Knight', 1, 'Original')
,('Greyjoy', 'Pyke', '[4, 6]', 'Ship', 1, 'Original')
,('Lannister', 'Lannisport', '[3, 6]', 'Footman', 1, 'Original')
,('Lannister', 'Lannisport', '[3, 6]', 'Garrison', 2, 'Original')
,('Lannister', 'Lannisport', '[3, 6]', 'Knight', 1, 'Original')
,('Lannister', 'Stoney Sept', '[3, 6]', 'Footman', 1, 'Original')
,('Lannister', 'The Golden Sound', '[3, 6]', 'Ship', 1, 'Original')
,('Martell', 'Salt Shore', '[6, 6]', 'Footman', 1, 'Original')
,('Martell', 'Sea of Dorne', '[6, 6]', 'Ship', 1, 'Original')
,('Martell', 'Sunspear', '[6, 6]', 'Footman', 1, 'Original')
,('Martell', 'Sunspear', '[6, 6]', 'Garrison', 2, 'Original')
,('Martell', 'Sunspear', '[6, 6]', 'Knight', 1, 'Original')
,('Neutral', 'Dornish Marches', '[4, 4]', 'Garrison', 3, 'Original')
,('Neutral', 'Dornish Marches', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Highgarden', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Kings Landing', '[3, 6]', 'Garrison', 5, 'Original')
,('Neutral', 'Oldtown', '[4, 4]', 'Garrison', 3, 'Original')
,('Neutral', 'Oldtown', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Princes Pass', '[4, 5]', 'Garrison', 3, 'Original')
,('Neutral', 'Princes Pass', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Pyke', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Salt Shore', '[4, 5]', 'Garrison', 3, 'Original')
,('Neutral', 'Salt Shore', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Starfall', '[4, 5]', 'Garrison', 3, 'Original')
,('Neutral', 'Starfall', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Storms End', '[4, 4]', 'Garrison', 4, 'Original')
,('Neutral', 'Storms End', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Sunspear', '[4, 5]', 'Garrison', 5, 'Original')
,('Neutral', 'Sunspear', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'The Boneway', '[4, 5]', 'Garrison', 3, 'Original')
,('Neutral', 'The Boneway', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'The Eyrie', '[3, 6]', 'Garrison', 6, 'Original')
,('Neutral', 'Three Towers', '[4, 5]', 'Garrison', 3, 'Original')
,('Neutral', 'Three Towers', '[3, 3]', 'Garrison', 99, 'Original')
,('Neutral', 'Yronwood', '[4, 5]', 'Garrison', 3, 'Original')
,('Neutral', 'Yronwood', '[3, 3]', 'Garrison', 99, 'Original')
,('Stark', 'The Shivering Sea', '[3, 6]', 'Ship', 1, 'Original')
,('Stark', 'White Harbor', '[3, 6]', 'Footman', 1, 'Original')
,('Stark', 'Winterfell', '[3, 6]', 'Footman', 1, 'Original')
,('Stark', 'Winterfell', '[3, 6]', 'Garrison', 2, 'Original')
,('Stark', 'Winterfell', '[3, 6]', 'Knight', 1, 'Original')
,('Tyrell', 'Dornish Marches', '[5, 6]', 'Footman', 1, 'Original')
,('Tyrell', 'Highgarden', '[5, 6]', 'Footman', 1, 'Original')
,('Tyrell', 'Highgarden', '[5, 6]', 'Garrison', 2, 'Original')
,('Tyrell', 'Highgarden', '[5, 6]', 'Knight', 1, 'Original')
,('Tyrell', 'Redwyne Straights', '[5, 6]', 'Ship', 1, 'Original')
,('Greyjoy', 'Pyke', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Greyjoy', 'Pyke', '[6, 6]', 'Garrison', 2, 'A Dance with Dragons')
,('Greyjoy', 'Bay of Ice', '[6,6]', 'Ship', 1, 'A Dance with Dragons')
,('Greyjoy', 'Sunset Sea', '[6,6]', 'Ship', 1, 'A Dance with Dragons')
,('Greyjoy', 'Ironmans Bay', '[6,6]', 'Ship', 1, 'A Dance with Dragons')
,('Greyjoy', 'West Summer Sea', '[6,6]', 'Ship', 3, 'A Dance with Dragons')
,('Greyjoy', 'The Stony Shore', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Greyjoy', 'Searoad Marches', '[6,6]', 'Footman', 2, 'A Dance with Dragons')
,('Greyjoy', 'Searoad Marches', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Baratheon', 'Dragonstone', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Baratheon', 'Dragonstone', '[6, 6]', 'Garrison', 2, 'A Dance with Dragons')
,('Baratheon', 'The Shivering Sea', '[6,6]', 'Ship', 2, 'A Dance with Dragons')
,('Baratheon', 'Castle Black', '[6,6]', 'Footman', 2, 'A Dance with Dragons')
,('Baratheon', 'Castle Black', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Baratheon', 'Karhold', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Baratheon', 'Storms End', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Baratheon', 'Storms End', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Baratheon', 'Storms End', '[6,6]', 'Garrison', 4, 'A Dance with Dragons')
,('Martell', 'Sunspear', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Martell', 'Sunspear', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Martell', 'Sunspear', '[6, 6]', 'Garrison', 2, 'A Dance with Dragons')
,('Martell', 'Port at Sunspear', '[6,6]', 'Ship', 1, 'A Dance with Dragons')
,('Martell', 'Salt Shore', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Martell', 'Yronwood', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Martell', 'The Boneway', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Martell', 'Princes Pass', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Martell', 'Starfall', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Stark', 'Winterfell', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Stark', 'Winterfell', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Stark', 'Winterfell', '[6, 6]', 'Garrison', 2, 'A Dance with Dragons')
,('Stark', 'White Harbor', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Stark', 'Moat Cailin', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Stark', 'Moat Cailin', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Stark', 'Moat Cailin', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Stark', 'The Twins', '[6,6]', 'Footman', 2, 'A Dance with Dragons')
,('Stark', 'Widows Watch', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Tyrell', 'Highgarden', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Tyrell', 'Highgarden', '[6, 6]', 'Garrison', 2, 'A Dance with Dragons')
,('Tyrell', 'Oldtown', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Tyrell', 'Oldtown', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Tyrell', 'Oldtown', '[6,6]', 'Garrison', 3, 'A Dance with Dragons')
,('Tyrell', 'Kingswood', '[6,6]', 'Knight', 1, 'A Dance with Dragons')
,('Tyrell', 'The Reach', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Tyrell', 'The Reach', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Tyrell', 'Crackclaw Point', '[6,6]', 'Footman', 2, 'A Dance with Dragons')
,('Tyrell', 'Shipbreaker Bay', '[6,6]', 'Ships', 3, 'A Dance with Dragons')
,('Tyrell', 'Dornish Marches', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Tyrell', 'Three Towers', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Tyrell', 'The Arbor', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Lannister', 'Lannisport', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Lannister', 'Lannisport', '[6, 6]', 'Garrison', 2, 'A Dance with Dragons')
,('Lannister', 'The Golden Sound', '[6,6]', 'Ship', 1, 'A Dance with Dragons')
,('Lannister', 'Riverrun', '[6,6]', 'Footman', 2, 'A Dance with Dragons')
,('Lannister', 'Harrenhal', '[6,6]', 'Footman', 1, 'A Dance with Dragons')
,('Lannister', 'Kings Landing', '[6,6]', 'Footman', 2, 'A Dance with Dragons')
,('Lannister', 'Stoney Sept', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Lannister', 'Blackwater', '[6,6]', 'Power token', 1, 'A Dance with Dragons')
,('Neutral', 'The Eyrie', '[6, 6]', 'Garrison', 6, 'A Dance with Dragons')
,('Lannister', 'Lannisport', '[4, 4]', 'Footman', 2, 'A Feast for Crows')
,('Lannister', 'Lannisport', '[4, 4]', 'Garrison', 2, 'A Feast for Crows')
,('Lannister', 'The Golden Sound', '[4, 4]', 'Ship', 1, 'A Feast for Crows')
,('Lannister', 'Harrenhal', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Lannister', 'Harrenhal', '[4, 4]', 'Knight', 1, 'A Feast for Crows')
,('Lannister', 'Stoney Sept', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Lannister', 'Stoney Sept', '[4, 4]', 'Power token', 1, 'A Feast for Crows')
,('Lannister', 'Kings Landing', '[4, 4]', 'Footman', 2, 'A Feast for Crows')
,('Lannister', 'Kings Landing', '[4, 4]', 'Garrison', 5, 'A Feast for Crows')
,('Lannister', 'Kings Landing', '[4, 4]', 'Power token', 1, 'A Feast for Crows')
,('Lannister', 'Blackwater Bay', '[4, 4]', 'Ship', 1, 'A Feast for Crows')
,('Lannister', 'Searoad Marches', '[4, 4]', 'Power token', 1, 'A Feast for Crows')
,('Lannister', 'Blackwater', '[4, 4]', 'Power token', 1, 'A Feast for Crows')
,('Arryn', 'The Eyrie', '[4, 4]', 'Garrison', 6, 'A Feast for Crows')
,('Arryn', 'The Eyrie', '[4, 4]', 'Knight', 1, 'A Feast for Crows')
,('Arryn', 'The Eyrie', '[4, 4]', 'Power token', 1, 'A Feast for Crows')
,('Arryn', 'The Mountains of the Moon', '[4, 4]', 'Footman', 2, 'A Feast for Crows')
,('Arryn', 'The Mountains of the Moon', '[4, 4]', 'Knight', 1, 'A Feast for Crows')
,('Arryn', 'The Twins', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Arryn', 'The Fingers', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Arryn', 'The Narrow Sea', '[4, 4]', 'Ship', 1, 'A Feast for Crows')
,('Stark', 'Winterfell', '[4, 4]', 'Garrison', 2, 'A Feast for Crows')
,('Stark', 'Winterfell', '[4, 4]', 'Knight', 1, 'A Feast for Crows')
,('Stark', 'Winterfell', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Stark', 'Port at Winterfell', '[4, 4]', 'Ship', 1, 'A Feast for Crows')
,('Stark', 'White Harbor', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Stark', 'Moat Cailin', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Stark', 'Moat Cailin', '[4, 4]', 'Siege Engine', 1, 'A Feast for Crows')
,('Stark', 'Seagard', '[4, 4]', 'Knight', 1, 'A Feast for Crows')
,('Stark', 'The Shivering Sea', '[4, 4]', 'Ship', 1, 'A Feast for Crows')
,('Baratheon', 'Dragonstone', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Baratheon', 'Dragonstone', '[4, 4]', 'Garrison', 2, 'A Feast for Crows')
,('Baratheon', 'Storms End', '[4, 4]', 'Knight', 1, 'A Feast for Crows')
,('Baratheon', 'Kingswood', '[4, 4]', 'Footman', 1, 'A Feast for Crows')
,('Baratheon', 'Kingswood', '[4, 4]', 'Siege Engine', 1, 'A Feast for Crows')
,('Baratheon', 'Shipbreaker Bay', '[4, 4]', 'Ship', 2, 'A Feast for Crows')
,('Neutral', 'Dornish Marches', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Highgarden', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Oldtown', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Princes Pass', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Pyke', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Salt Shore', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Starfall', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Sunspear', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'The Boneway', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Three Towers', '[4, 4]', 'Garrison', 99, 'A Feast for Crows')
,('Neutral', 'Yronwood', '[4, 4]', 'Garrison', 99, 'A Feast for Crows');

INSERT INTO LookUp.HouseAreas(nHouseID, nAreaID, nNumPlayers, nVersionID)
SELECT DISTINCT
	 H.nHouseID
    ,A.nAreaID
    ,THAU.nNumPlayers
    ,V.nVersionID
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
    LookUp.Versions V
    ON
        V.cName = THAU.cVersionName;

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
	LookUp.Versions V
	ON
		V.cName = THAU.cVersionName
JOIN 
	LookUp.HouseAreas HA
	ON 
		HA.nNumPlayers = THAU.nNumPlayers AND
		HA.nAreaID = A.nAreaID AND
		HA.nHouseID = H.nHouseID AND
		HA.nVersionID = V.nVersionID;


CREATE TABLE LookUp.Orders
(
	nOrderID SMALLSERIAL,
    cOrderName VARCHAR(20) NOT NULL,
    CONSTRAINT pk_LookUp_Orders PRIMARY KEY (cOrderName),
    CONSTRAINT uc_CLIDX_LookUp_Orders UNIQUE (nOrderID)
);
CLUSTER LookUp.Orders USING uc_CLIDX_LookUp_Orders;

CREATE TABLE LookUp.OrderTokens
(
	nOrderTokenID SMALLSERIAL,
    nOrderID SMALLINT NOT NULL,
    nCombatStrength SMALLINT NOT NULL,
    lSpecial BOOL NOT NULL,
    CONSTRAINT pk_CLIDX_LookUp_OrderTokens PRIMARY KEY (nOrderTokenID),
    CONSTRAINT fk_LookUp_OrderTokens_Orders_nOrderID FOREIGN KEY (nOrderID)
        REFERENCES LookUp.Orders (nOrderID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.OrderTokens USING pk_CLIDX_LookUp_OrderTokens;

CREATE TEMPORARY TABLE TempOrderTokens
(
    cOrderName VARCHAR(20),
    nCombatStrength SMALLINT,
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
	nWesterosCardID SMALLSERIAL,
    cName VARCHAR(25) NOT NULL,
    nCardAbilitySetID SMALLINT NOT NULL,
    cDescription VARCHAR(255) NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_WesterosCards UNIQUE (nWesterosCardID),
    CONSTRAINT pk_LookUp_WesterosCards PRIMARY KEY (cName, nCardAbilitySetID),
    CONSTRAINT fk_LookUp_WesterosCards_CardAbilitiesSets_nCardAbilitySetID FOREIGN KEY (nCardAbilitySetID)
		REFERENCES LookUp.CardAbilitySets (nCardAbilitySetID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.WesterosCards USING uc_CLIDX_LookUp_WesterosCards;

INSERT INTO LookUp.WesterosCards (cName, nCardAbilitySetID, cDescription)
VALUES
 ('Winter Is Coming', 1, 'Immediately shuffle this deck. Then draw and resolve a new card.')
,('Last Days of Summer', 9, 'Nothing happens.')
,('Mustering', 1, 'Recruit new units in Strongholds and Castles.')
,('Supply', 1, 'Adjust Supply track. Reconcile armies.')
,('A Throne of Blades', 10, E'The holder of the Iron Throne token chooses whether\na) everyone updates their Supply then reconciles armies\nb) everyone musters units, or\nc) this card has no effect.')
,('Game of Thrones', 1, 'Each player collects one Power token for each power icon printed on areas he controls.')
,('Clash of Kings', 1, 'Bid on the three Influence tracks.')
,('Dark Wings, Dark Words', 10, E'The holder of the Messenger Raven token chooses whether\na) everyone bids on the three Influence tracks\nb) everyone collects one Power token for every power icon present in areas they control, or\nc) this card has no effect.')
,('Wildlings Attack', 1, 'The wildlings attack Westeros.')
,('Rains of Autumn', 10, 'March +1 Orders cannot be played this Planning Phase.')
,('Storm of Swords', 10, 'Defense Orders cannot be played during this Planning Phase.')
,('Sea of Storms', 10, 'Raid Orders cannot be played during this Planning Phase.')
,('Feast for Crows', 10, 'Consolidate Power Orders cannot be played during this Planning Phase.')
,('Web of Lies', 10, 'Support Orders cannot be played during this Planning Phase.')
,('Put To the Sword', 1, E'The holder of the Valyrian Steel Blade chooses one of the following conditions for this Planning Phase:\na) Defense Orders cannot be played\nb) March +1 Orders cannot be played, or\nc) no restrictions.')
,('Mustering', 10, 'Recruit new units in Strongholds and Castles.')
,('Famine', 10, 'Each player is reduced one position on the Supply track and then, in turn order, reconciles armies.')
,('Ironborn Raid', 10, 'Each player with at least 2 scored Objective cards in his play area is reduced one position on the Victory track.')
,('New Information', 10, 'In turn order, each player draws one Objective card. Then each player chooses one Objective card in his hand and shuffles it back into the objective deck.')
,('The Burden of Power', 1, E'The holder of the Iron Throne token chooses whether\na) the Wildling track is reduced to the "0" position, or\nb) everyone musters units in Strongholds and Castles.')
,('Shifting Ambitions', 10, 'Each player chooses 1 Objective card from his hand and places it facedown in a common area. Shuffle the facedown cards and flip them faceup. Then, in turn order, each player chooses 1 of these cards and places it into his hand.')
,('Rally the Men', 10, 'In turn order, players muster new units in every one of their areas containing a Castle.');

CREATE TABLE LookUp.WesterosDecks
(
	nWesterosDeckID SMALLSERIAL,
    nWesterosCardID SMALLINT NOT NULL,
    nDeckNumber SMALLINT NOT NULL,
    nVersionID SMALLINT NOT NULL,
    CONSTRAINT pk_CLIDX_LookUp_WesterosCards PRIMARY KEY (nWesterosDeckID),
    CONSTRAINT fk_LookUp_WesterosDecks_WesterosCards_nWesterosCardID FOREIGN KEY (nWesterosCardID)
		REFERENCES LookUp.WesterosCards (nWesterosCardID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_WesterosDecks_Versions_nVersionID FOREIGN KEY (nVersionID)
        REFERENCES LookUp.Versions (nVersionID) ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER LookUp.WesterosDecks USING pk_CLIDX_LookUp_WesterosCards;

CREATE TEMPORARY TABLE TempWesterosDecks
(
    cName VARCHAR(25),
    nCardAbilitySetID SMALLINT,
    nDeckNumber SMALLINT,
    cVersionName VARCHAR(25)
);

INSERT INTO TempWesterosDecks (cName, nDeckNumber, nCardAbilitySetID, cVersionName)
VALUES
 ('Winter Is Coming', 1, 1, 'Original')
,('A Throne of Blades', 1, 10, 'Original')
,('A Throne of Blades', 1, 10, 'Original')
,('Mustering', 1, 1, 'Original')
,('Mustering', 1, 1, 'Original')
,('Mustering', 1, 1, 'Original')
,('Last Days of Summer', 1, 9, 'Original')
,('Supply', 1, 1, 'Original')
,('Supply', 1, 1, 'Original')
,('Supply', 1, 1, 'Original')
,('Last Days of Summer', 2, 9, 'Original')
,('Winter Is Coming', 2, 1, 'Original')
,('Dark Wings, Dark Words', 2, 10, 'Original')
,('Dark Wings, Dark Words', 2, 10, 'Original')
,('Game of Thrones', 2, 1, 'Original')
,('Game of Thrones', 2, 1, 'Original')
,('Game of Thrones', 2, 1, 'Original')
,('Clash of Kings', 2, 1, 'Original')
,('Clash of Kings', 2, 1, 'Original')
,('Clash of Kings', 2, 1, 'Original')
,('Put To the Sword', 3, 1, 'Original')
,('Put To the Sword', 3, 1, 'Original')
,('Feast for Crows', 3, 10, 'Original')
,('Wildlings Attack', 3, 1, 'Original')
,('Wildlings Attack', 3, 1, 'Original')
,('Wildlings Attack', 3, 1, 'Original')
,('Storm of Swords', 3, 10, 'Original')
,('Sea of Storms', 3, 10, 'Original')
,('Rains of Autumn', 3, 10, 'Original')
,('Web of Lies', 3, 10, 'Original')
,('Winter Is Coming', 1, 1, 'A Dance with Dragons')
,('A Throne of Blades', 1, 10, 'A Dance with Dragons')
,('A Throne of Blades', 1, 10, 'A Dance with Dragons')
,('Mustering', 1, 1, 'A Dance with Dragons')
,('Mustering', 1, 1, 'A Dance with Dragons')
,('Mustering', 1, 1, 'A Dance with Dragons')
,('Last Days of Summer', 1, 9, 'A Dance with Dragons')
,('Supply', 1, 1, 'A Dance with Dragons')
,('Supply', 1, 1, 'A Dance with Dragons')
,('Supply', 1, 1, 'A Dance with Dragons')
,('Last Days of Summer', 2, 9, 'A Dance with Dragons')
,('Winter Is Coming', 2, 1, 'A Dance with Dragons')
,('Dark Wings, Dark Words', 2, 10, 'A Dance with Dragons')
,('Dark Wings, Dark Words', 2, 10, 'A Dance with Dragons')
,('Game of Thrones', 2, 1, 'A Dance with Dragons')
,('Game of Thrones', 2, 1, 'A Dance with Dragons')
,('Game of Thrones', 2, 1, 'A Dance with Dragons')
,('Clash of Kings', 2, 1, 'A Dance with Dragons')
,('Clash of Kings', 2, 1, 'A Dance with Dragons')
,('Clash of Kings', 2, 1, 'A Dance with Dragons')
,('Put To the Sword', 3, 1, 'A Dance with Dragons')
,('Put To the Sword', 3, 1, 'A Dance with Dragons')
,('Feast for Crows', 3, 10, 'A Dance with Dragons')
,('Wildlings Attack', 3, 1, 'A Dance with Dragons')
,('Wildlings Attack', 3, 1, 'A Dance with Dragons')
,('Wildlings Attack', 3, 1, 'A Dance with Dragons')
,('Storm of Swords', 3, 10, 'A Dance with Dragons')
,('Sea of Storms', 3, 10, 'A Dance with Dragons')
,('Rains of Autumn', 3, 10, 'A Dance with Dragons')
,('Web of Lies', 3, 10, 'A Dance with Dragons')
,('Last Days of Summer', 2, 9, 'A Feast for Crows')
,('Winter Is Coming', 2, 1, 'A Feast for Crows')
,('Dark Wings, Dark Words', 2, 10, 'A Feast for Crows')
,('Dark Wings, Dark Words', 2, 10, 'A Feast for Crows')
,('Game of Thrones', 2, 1, 'A Feast for Crows')
,('Game of Thrones', 2, 1, 'A Feast for Crows')
,('Game of Thrones', 2, 1, 'A Feast for Crows')
,('Clash of Kings', 2, 1, 'A Feast for Crows')
,('Clash of Kings', 2, 1, 'A Feast for Crows')
,('Clash of Kings', 2, 1, 'A Feast for Crows')
,('Put To the Sword', 3, 1, 'A Feast for Crows')
,('Put To the Sword', 3, 1, 'A Feast for Crows')
,('Feast for Crows', 3, 10, 'A Feast for Crows')
,('Wildlings Attack', 3, 1, 'A Feast for Crows')
,('Wildlings Attack', 3, 1, 'A Feast for Crows')
,('Wildlings Attack', 3, 1, 'A Feast for Crows')
,('Storm of Swords', 3, 10, 'A Feast for Crows')
,('Sea of Storms', 3, 10, 'A Feast for Crows')
,('Rains of Autumn', 3, 10, 'A Feast for Crows')
,('Web of Lies', 3, 10, 'A Feast for Crows')
,('Rally the Men', 1, 10, 'A Feast for Crows')
,('Rally the Men', 1, 10, 'A Feast for Crows')
,('Shifting Ambitions', 1, 10, 'A Feast for Crows')
,('Shifting Ambitions', 1, 10, 'A Feast for Crows')
,('The Burden of Power', 1, 1, 'A Feast for Crows')
,('The Burden of Power', 1, 1, 'A Feast for Crows')
,('New Information', 1, 10, 'A Feast for Crows')
,('Ironborn Raid', 1, 10, 'A Feast for Crows')
,('Famine', 1, 10, 'A Feast for Crows')
,('Mustering', 1, 10, 'A Feast for Crows');

INSERT INTO LookUp.WesterosDecks (nWesterosCardID, nDeckNumber, nVersionID)
SELECT
	 WC.nWesterosCardID
    ,TWD.nDeckNumber
    ,V.nVersionID
FROM
	TempWesterosDecks TWD
JOIN
	LookUp.WesterosCards WC
    ON
		WC.cName = TWD.cName AND
		WC.nCardAbilitySetID = TWD.nCardAbilitySetID
JOIN
	LookUp.Versions V
	ON
		V.cName = TWD.cVersionName;


CREATE TABLE LookUp.WildlingCards
(
	nWildlingCardID SMALLSERIAL,
    cName VARCHAR(36) NOT NULL,
    cWildlingVictoryLowestBidderDescription VARCHAR(255) NOT NULL,
    cWildlingVictoryEveryoneElseDescription VARCHAR(255) NOT NULL,
    cNightsWatchVictoryHighestBidderDescription VARCHAR(255) NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_WildlingCards UNIQUE (nWildlingCardID),
    CONSTRAINT pk_LookUp_WildlingCards PRIMARY KEY (cName)
);
CLUSTER LookUp.WildlingCards USING uc_CLIDX_LookUp_WildlingCards;

INSERT INTO LookUp.WildlingCards (cName, cWildlingVictoryLowestBidderDescription, cWildlingVictoryEveryoneElseDescription, cNightsWatchVictoryHighestBidderDescription)
VALUES
 ('Massing on the Milkwater', 'If he has more than one House card in his hand, he discards all cards with the highest combat strength.', 'If they have more than one House card in their hand, they must choose and discard one of those cards.', 'Returns his entire House card discard pile into his hand.')
,('Preemptive Raid', E'Chooses one of the following:\nA. Destroys 2 of his units anywhere.\nB. Is reduced 2 positions on his highest Influence track.', 'Nothing happens.', 'The wildling immediately attack again with a strength of 6. You do not participate in the bidding against this attack (nor do you receive any rewards or penalties).')
,('Crow Killers', 'Replaces all of his Knights with available Footmen. Any Knight unable to be replaced is destroyed.', 'Replaces 2 of their Knights with available Footmen. Any Knight unable to be replaced is destroyed.', 'May immediately replace up to 2 of his Footmen, anywhere, with available Knights.')
,('The Horde Descends', 'Destroys 2 of his units at one of his Castles or Strongholds. If unable, he destroys 2 of his units anywhere.', 'Destroys 1 of their units anywhere.', 'May muster forces (following normal mustering rules) in any one Castle or Stronghold area he controls.')
,('Silence at the Wall', 'Nothing happens.', 'Nothing happens.', 'Nothing happens.')
,('Mammoth Riders', 'Destroys 3 of his units anywhere.', 'Destroys 2 of their units anywhere.', 'May retrieve 1 House card of his choice from his House card discard pile.')
,('A King Beyond the Wall', 'Moves his tokens to the lowest position of every Influence track.', 'In turn order, each player chooses either the Fiefdoms or King''s Court Influence track and moves his token to the lowest position of that track.', 'Moves his token to the top of one Influence track of his choice, then takes the appropriate Dominance token.')
,('Rattleshirt''s Raiders', 'Is reduced 2 positions on the Supply track (to no lower than 0). Then reconcile armies to their new Supply limits.', 'Is reduced 1 position on the Supply track (to no lower than 0). Then reconcile armies to their new Supply limits.', 'Is increased 1 position on the Supply track (to no higher than 6).')
,('Skinchanger Scout', 'Discards all available Power tokens.', 'Discards 2 available Power tokens, or as many as they are able.', 'All Power tokens he bid on this attack are immediately returned to his available Power.');

CREATE TABLE LookUp.TidesOfBattleCards
(
	nTidesOfBattleCardID SMALLSERIAL,
    nCombatStrength SMALLINT NOT NULL,
    nCardAbilitySetID SMALLINT NULL,
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

--add in objective cards for feast for crows
CREATE TABLE LookUp.Objectives
(
    nObjectiveID SMALLSERIAL,
    cName VARCHAR(26) NOT NULL,
    cDescription VARCHAR(255) NOT NULL,
    nVersionID SMALLINT NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_Objectives UNIQUE (nObjectiveID),
    CONSTRAINT pk_LookUp_Objectives PRIMARY KEY (cName, nVersionID),
    CONSTRAINT fk_LookUp_Objectives_Versions_nVersionID FOREIGN KEY (nVersionID)
    REFERENCES LookUp.Versions (nVersionID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CLUSTER LookUp.Objectives USING uc_CLIDX_LookUp_Objectives;

CREATE TABLE LookUp.SpecialObjectives 
(
    nSpecialObjectiveID SMALLSERIAL,
    nHouseID SMALLINT NOT NULL,
    cDescription VARCHAR(255) NOT NULL,
    nVersionID SMALLINT NOT NULL,
    nPoints SMALLINT NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_SpecialObjectives UNIQUE (nSpecialObjectiveID),
    CONSTRAINT pk_LookUp_SpecialObjectives PRIMARY KEY (nHouseID, nVersionID),
    CONSTRAINT fk_LookUp_SpecialObjectives_Versions_nVersionID FOREIGN KEY (nVersionID)
    REFERENCES LookUp.Versions (nVersionID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_SpecialObjectives_Houses_nHouseID FOREIGN KEY (nHouseID )
    REFERENCES LookUp.Houses (nHouseID ) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CLUSTER LookUp.SpecialObjectives USING uc_CLIDX_LookUp_SpecialObjectives;

CREATE TABLE LookUp.ObjectiveHousePoints
(
    nObjectiveHousePointID SMALLSERIAL,
    nObjectiveID SMALLINT NOT NULL,
    nHouseID SMALLINT NOT NULL,
    nPoints SMALLINT NOT NULL,
    CONSTRAINT uc_CLIDX_LookUp_ObjectiveHousePoints UNIQUE (nObjectiveHousePointID),
    CONSTRAINT pk_LookUp_ObjectiveHousePoints PRIMARY KEY (nObjectiveID, nHouseID),
    CONSTRAINT fk_LookUp_ObjectiveHousePoints_Objectives_nObjectiveID FOREIGN KEY (nObjectiveID)
    REFERENCES LookUp.Objectives (nObjectiveID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_LookUp_ObjectiveHousePoints_Houses_nHouseID FOREIGN KEY (nHouseID )
    REFERENCES LookUp.Houses (nHouseID ) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CLUSTER LookUp.ObjectiveHousePoints USING uc_CLIDX_LookUp_ObjectiveHousePoints;



CREATE TEMPORARY TABLE TempObjectives
(
    title VARCHAR(26) NULL,
    description VARCHAR(255),
    house VARCHAR(26),
    points SMALLINT,
    version_name VARCHAR(26)
);
INSERT INTO TempObjectives (title, description, house, points, version_name)
VALUES
 (NULL, 'Control Winterfell and 5 or more areas with Castles or Strongholds.', 'Stark', 1, 'A Feast for Crows')
,(NULL, 'Control Lannisport and Kings Landing.', 'Lannister', 1, 'A Feast for Crows')
,(NULL, 'Control Dragonstone and Kings Landing.', 'Baratheon', 1, 'A Feast for Crows')
,(NULL, 'Control The Eyrie and have more available Power tokens than each other House.', 'Arryn', 1, 'A Feast for Crows')
,('The People''s Chosen', 'Control 4 or more areas with Power icons.',  'Arryn', 1, 'A Feast for Crows')
,('The People''s Chosen', 'Control 4 or more areas with Power icons.',  'Stark', 1, 'A Feast for Crows')
,('The People''s Chosen', 'Control 4 or more areas with Power icons.',  'Lannister', 1, 'A Feast for Crows')
,('The People''s Chosen', 'Control 4 or more areas with Power icons.',  'Baratheon', 1, 'A Feast for Crows')
,('The Final Hour', 'Have only 1 House card in your hand.',  'Arryn', 1, 'A Feast for Crows')
,('The Final Hour', 'Have only 1 House card in your hand.',  'Stark', 1, 'A Feast for Crows')
,('The Final Hour', 'Have only 1 House card in your hand.',  'Lannister', 1, 'A Feast for Crows')
,('The Final Hour', 'Have only 1 House card in your hand.',  'Baratheon', 1, 'A Feast for Crows')
,('Home Invasion', 'Control the home area of another House.',  'Arryn', 1, 'A Feast for Crows')
,('Home Invasion', 'Control the home area of another House.',  'Stark', 1, 'A Feast for Crows')
,('Home Invasion', 'Control the home area of another House.',  'Lannister', 1, 'A Feast for Crows')
,('Home Invasion', 'Control the home area of another House.',  'Baratheon', 1, 'A Feast for Crows')
,('Naval Superiority', 'Have more Ship units on the board than each other House.',  'Arryn', 1, 'A Feast for Crows')
,('Naval Superiority', 'Have more Ship units on the board than each other House.',  'Stark', 1, 'A Feast for Crows')
,('Naval Superiority', 'Have more Ship units on the board than each other House.',  'Lannister', 1, 'A Feast for Crows')
,('Naval Superiority', 'Have more Ship units on the board than each other House.',  'Baratheon', 1, 'A Feast for Crows')
,('Friendly Confines', 'Control more Castles than each other House.',  'Arryn', 1, 'A Feast for Crows')
,('Friendly Confines', 'Control more Castles than each other House.',  'Stark', 1, 'A Feast for Crows')
,('Friendly Confines', 'Control more Castles than each other House.',  'Lannister', 1, 'A Feast for Crows')
,('Friendly Confines', 'Control more Castles than each other House.',  'Baratheon', 1, 'A Feast for Crows')
,('Cavalry Charge', 'Have all 5 of your Knight units on the board.',  'Arryn', 1, 'A Feast for Crows')
,('Cavalry Charge', 'Have all 5 of your Knight units on the board.',  'Stark', 1, 'A Feast for Crows')
,('Cavalry Charge', 'Have all 5 of your Knight units on the board.',  'Lannister', 1, 'A Feast for Crows')
,('Cavalry Charge', 'Have all 5 of your Knight units on the board.',  'Baratheon', 1, 'A Feast for Crows')
,('Nothing but Ghosts', 'Have 1 unit in Harrenhal and no units in any areas adjacent to Harrenhal.',  'Arryn', 1, 'A Feast for Crows')
,('Nothing but Ghosts', 'Have 1 unit in Harrenhal and no units in any areas adjacent to Harrenhal.',  'Stark', 1, 'A Feast for Crows')
,('Nothing but Ghosts', 'Have 1 unit in Harrenhal and no units in any areas adjacent to Harrenhal.',  'Lannister', 1, 'A Feast for Crows')
,('Nothing but Ghosts', 'Have 1 unit in Harrenhal and no units in any areas adjacent to Harrenhal.',  'Baratheon', 1, 'A Feast for Crows')
,('Crossing Guard', 'Control two areas that are joined by the same bridge.',  'Arryn', 1, 'A Feast for Crows')
,('Crossing Guard', 'Control two areas that are joined by the same bridge.',  'Stark', 1, 'A Feast for Crows')
,('Crossing Guard', 'Control two areas that are joined by the same bridge.',  'Lannister', 1, 'A Feast for Crows')
,('Crossing Guard', 'Control two areas that are joined by the same bridge.',  'Baratheon', 1, 'A Feast for Crows')
,('Spreading the Wealth', 'Have more Power tokens on the board than each other House.',  'Arryn', 1, 'A Feast for Crows')
,('Spreading the Wealth', 'Have more Power tokens on the board than each other House.',  'Stark', 1, 'A Feast for Crows')
,('Spreading the Wealth', 'Have more Power tokens on the board than each other House.',  'Lannister', 1, 'A Feast for Crows')
,('Spreading the Wealth', 'Have more Power tokens on the board than each other House.',  'Baratheon', 1, 'A Feast for Crows')
,('Backdoor Politics', 'Each other House has a higher position on the Victory track than you.',  'Arryn', 2, 'A Feast for Crows')
,('Backdoor Politics', 'Each other House has a higher position on the Victory track than you.',  'Stark', 2, 'A Feast for Crows')
,('Backdoor Politics', 'Each other House has a higher position on the Victory track than you.',  'Lannister', 2, 'A Feast for Crows')
,('Backdoor Politics', 'Each other House has a higher position on the Victory track than you.',  'Baratheon', 2, 'A Feast for Crows')
,('Ample Harvest', 'Obtain position 5 or 6 on the Supply track.',  'Arryn', 2, 'A Feast for Crows')
,('Ample Harvest', 'Obtain position 5 or 6 on the Supply track.',  'Stark', 1, 'A Feast for Crows')
,('Ample Harvest', 'Obtain position 5 or 6 on the Supply track.',  'Lannister', 1, 'A Feast for Crows')
,('Ample Harvest', 'Obtain position 5 or 6 on the Supply track.',  'Baratheon', 1, 'A Feast for Crows')
,('Mercantile Ventures', 'Control more Ports than each other House.',  'Arryn', 2, 'A Feast for Crows')
,('Mercantile Ventures', 'Control more Ports than each other House.',  'Stark', 1, 'A Feast for Crows')
,('Mercantile Ventures', 'Control more Ports than each other House.',  'Lannister', 1, 'A Feast for Crows')
,('Mercantile Ventures', 'Control more Ports than each other House.',  'Baratheon', 1, 'A Feast for Crows')
,('Extend Your Reach', 'Control more sea areas than each other House.',  'Arryn', 2, 'A Feast for Crows')
,('Extend Your Reach', 'Control more sea areas than each other House.',  'Stark', 1, 'A Feast for Crows')
,('Extend Your Reach', 'Control more sea areas than each other House.',  'Lannister', 1, 'A Feast for Crows')
,('Extend Your Reach', 'Control more sea areas than each other House.',  'Baratheon', 1, 'A Feast for Crows')
,('Land Grab', 'Control more land areas than any other House.',  'Baratheon', 2, 'A Feast for Crows')
,('Land Grab', 'Control more land areas than any other House.',  'Lannister', 1, 'A Feast for Crows')
,('Land Grab', 'Control more land areas than any other House.',  'Stark', 1, 'A Feast for Crows')
,('Land Grab', 'Control more land areas than any other House.',  'Arryn', 1, 'A Feast for Crows')
,('Protect the Neck', 'Control Seagard, Greywater Watch, and Flint''s Finger.',  'Baratheon', 4, 'A Feast for Crows')
,('Protect the Neck', 'Control Seagard, Greywater Watch, and Flint''s Finger.',  'Lannister', 1, 'A Feast for Crows')
,('Protect the Neck', 'Control Seagard, Greywater Watch, and Flint''s Finger.',  'Stark', 1, 'A Feast for Crows')
,('Protect the Neck', 'Control Seagard, Greywater Watch, and Flint''s Finger.',  'Arryn', 1, 'A Feast for Crows')
,('The Throne', 'Hold the Iron Throne token.',  'Baratheon', 0, 'A Feast for Crows')
,('The Throne', 'Hold the Iron Throne token.',  'Lannister', 1, 'A Feast for Crows')
,('The Throne', 'Hold the Iron Throne token.',  'Stark', 1, 'A Feast for Crows')
,('The Throne', 'Hold the Iron Throne token.',  'Arryn', 1, 'A Feast for Crows')
,('Support the Crown', 'Have 3 units in Crackclaw Point and no units in King''s Landing.',  'Baratheon', 1, 'A Feast for Crows')
,('Support the Crown', 'Have 3 units in Crackclaw Point and no units in King''s Landing.',  'Lannister', 1, 'A Feast for Crows')
,('Support the Crown', 'Have 3 units in Crackclaw Point and no units in King''s Landing.',  'Stark', 2, 'A Feast for Crows')
,('Support the Crown', 'Have 3 units in Crackclaw Point and no units in King''s Landing.',  'Arryn', 1, 'A Feast for Crows')
,('The Blade', 'Hold the Valyrian Steel Blade token.',  'Baratheon', 1, 'A Feast for Crows')
,('The Blade', 'Hold the Valyrian Steel Blade token.',  'Lannister', 1, 'A Feast for Crows')
,('The Blade', 'Hold the Valyrian Steel Blade token.',  'Stark', 0, 'A Feast for Crows')
,('The Blade', 'Hold the Valyrian Steel Blade token.',  'Arryn', 1, 'A Feast for Crows')
,('Hold Court', 'Control King''s Landing.',  'Baratheon', 1, 'A Feast for Crows')
,('Hold Court', 'Control King''s Landing.',  'Lannister', 1, 'A Feast for Crows')
,('Hold Court', 'Control King''s Landing.',  'Stark', 4, 'A Feast for Crows')
,('Hold Court', 'Control King''s Landing.',  'Arryn', 2, 'A Feast for Crows')
,('A Firm Grip', 'Control Clackclaw Point and Kingswood.',  'Baratheon', 1, 'A Feast for Crows')
,('A Firm Grip', 'Control Clackclaw Point and Kingswood.',  'Lannister', 1, 'A Feast for Crows')
,('A Firm Grip', 'Control Clackclaw Point and Kingswood.',  'Stark', 3, 'A Feast for Crows')
,('A Firm Grip', 'Control Clackclaw Point and Kingswood.',  'Arryn', 2, 'A Feast for Crows')
,('Pull the Weeds', 'Control Searoad Marches, Blackwater, and The Reach.',  'Baratheon', 1, 'A Feast for Crows')
,('Pull the Weeds', 'Control Searoad Marches, Blackwater, and The Reach.',  'Lannister', 1, 'A Feast for Crows')
,('Pull the Weeds', 'Control Searoad Marches, Blackwater, and The Reach.',  'Stark', 2, 'A Feast for Crows')
,('Pull the Weeds', 'Control Searoad Marches, Blackwater, and The Reach.',  'Arryn', 2, 'A Feast for Crows')
,('The Raven', 'Hold the Messenger Raven token.',  'Baratheon', 1, 'A Feast for Crows')
,('The Raven', 'Hold the Messenger Raven token.',  'Lannister', 1, 'A Feast for Crows')
,('The Raven', 'Hold the Messenger Raven token.',  'Stark', 1, 'A Feast for Crows')
,('The Raven', 'Hold the Messenger Raven token.',  'Arryn', 0, 'A Feast for Crows')
,('Stop the Storm', 'Control Storm''s End.',  'Baratheon', 0, 'A Feast for Crows')
,('Stop the Storm', 'Control Storm''s End.',  'Lannister', 1, 'A Feast for Crows')
,('Stop the Storm', 'Control Storm''s End.',  'Stark', 3, 'A Feast for Crows')
,('Stop the Storm', 'Control Storm''s End.',  'Arryn', 1, 'A Feast for Crows')
,('Arbor Gold', 'Control The Arbor.',  'Baratheon', 2, 'A Feast for Crows')
,('Arbor Gold', 'Control The Arbor.',  'Lannister', 1, 'A Feast for Crows')
,('Arbor Gold', 'Control The Arbor.',  'Stark', 2, 'A Feast for Crows')
,('Arbor Gold', 'Control The Arbor.',  'Arryn', 4, 'A Feast for Crows')
,('A Riper Fruit', 'Control Winterfell.',  'Baratheon', 2, 'A Feast for Crows')
,('A Riper Fruit', 'Control Winterfell.',  'Lannister', 2, 'A Feast for Crows')
,('A Riper Fruit', 'Control Winterfell.',  'Stark', 0, 'A Feast for Crows')
,('A Riper Fruit', 'Control Winterfell.',  'Arryn', 1, 'A Feast for Crows')
,('Take the Black', 'Control Castle Black.',  'Baratheon', 1, 'A Feast for Crows')
,('Take the Black', 'Control Castle Black.',  'Lannister', 2, 'A Feast for Crows')
,('Take the Black', 'Control Castle Black.',  'Stark', 1, 'A Feast for Crows')
,('Take the Black', 'Control Castle Black.',  'Arryn', 1, 'A Feast for Crows')
,('A Stalwart Position', 'Control more Strongholds than each other House.',  'Baratheon', 2, 'A Feast for Crows')
,('A Stalwart Position', 'Control more Strongholds than each other House.',  'Lannister', 1, 'A Feast for Crows')
,('A Stalwart Position', 'Control more Strongholds than each other House.',  'Stark', 1, 'A Feast for Crows')
,('A Stalwart Position', 'Control more Strongholds than each other House.',  'Arryn', 3, 'A Feast for Crows')
,('A Mountainous Task', 'Control The Eyrie.',  'Baratheon', 3, 'A Feast for Crows')
,('A Mountainous Task', 'Control The Eyrie.',  'Lannister', 4, 'A Feast for Crows')
,('A Mountainous Task', 'Control The Eyrie.',  'Stark', 3, 'A Feast for Crows')
,('A Mountainous Task', 'Control The Eyrie.',  'Arryn', 0, 'A Feast for Crows');

INSERT INTO LookUp.Objectives (cName, cDescription, nVersionID)
SELECT DISTINCT
    TOS.title,
    TOS.description,
    V.nVersionID
FROM
    TempObjectives TOS
JOIN
    LookUp.Versions V
    ON
        V.cName = TOS.version_name
WHERE
    TOS.title IS not null;

INSERT INTO LookUp.SpecialObjectives (nHouseID, cDescription, nVersionID, nPoints)
SELECT DISTINCT
    H.nHouseID,
    TOS.description,
    V.nVersionID,
    TOS.points
FROM
    TempObjectives TOS
JOIN
    LookUp.Versions V
    ON
        V.cName = TOS.version_name
JOIN
    LookUp.Houses H
    ON
        H.cName = TOS.house
WHERE
    TOS.title IS null;

INSERT INTO LookUp.ObjectiveHousePoints(nObjectiveID, nHouseID, nPoints)
SELECT
    O.nObjectiveID,
    H.nHouseID,
    TOS.points
FROM
    TempObjectives TOS
JOIN
    LookUp.Versions V
    ON
        V.cName = TOS.version_name
JOIN
    LookUp.Houses H
    ON
        H.cName = TOS.house
JOIN
    LookUp.Objectives O
    ON
        O.cName = TOS.title AND
        O.nVersionID = V.nVersionID
WHERE
    TOS.title IS NOT null;

DROP TABLE IF EXISTS TempObjectives;
DROP TABLE IF EXISTS TempHouseAreaUnits;
DROP TABLE IF EXISTS TempConnectedAreas;
DROP TABLE IF EXISTS TempHouseCards;
DROP TABLE IF EXISTS TempCardAbilities;
DROP TABLE IF EXISTS TempOrderTokens;
DROP TABLE IF EXISTS TempWesterosDecks;
DROP TABLE IF EXISTS TempHouseTrackPositions;
