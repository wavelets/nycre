CREATE TABLE borough (
  id INTEGER,
  name varchar(9) DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE building_class_category (
  id varchar(3) DEFAULT '',
  name varchar(64),
  PRIMARY KEY (id)
);

CREATE TABLE building_class (
  id varchar(3) DEFAULT '',
  name varchar(64),
  PRIMARY KEY (id)
);

CREATE TABLE tax_class (
  id varchar(3) DEFAULT '',
  name varchar(64),
  PRIMARY KEY (id)
);

INSERT INTO borough (id, name)
VALUES
    (1,'Manhattan'),
    (2,'Bronx'),
    (3,'Brooklyn'),
    (4,'Queens'),
    (5,'Richmond');

INSERT INTO building_class_category (id, name)
VALUES
    ('01','ONE FAMILY HOMES'),
    ('02','TWO FAMILY HOMES'),
    ('05','TAX CLASS 1 VACANT LAND'),
    ('06','TAX CLASS 1 - OTHER'),
    ('21','OFFICE BUILDINGS'),
    ('32','HOSPITAL AND HEALTH FACILITIES'),
    ('04','TAX CLASS 1 CONDOS'),
    ('22','STORE BUILDINGS'),
    ('07','RENTALS - WALKUP APARTMENTS'),
    ('10','COOPS - ELEVATOR APARTMENTS'),
    ('13','CONDOS - ELEVATOR APARTMENTS'),
    ('25','LUXURY HOTELS'),
    ('27','FACTORIES'),
    ('30','WAREHOUSES'),
    ('31','COMMERCIAL VACANT LAND'),
    ('03','THREE FAMILY HOMES'),
    ('29','COMMERCIAL GARAGES'),
    ('41','TAX CLASS 4 - OTHER'),
    ('14','RENTALS - 4-10 UNIT'),
    ('08','RENTALS - ELEVATOR APARTMENTS'),
    ('12','CONDOS - WALKUP APARTMENTS'),
    ('37','RELIGIOUS FACILITIES'),
    ('09','COOPS - WALKUP APARTMENTS'),
    ('33','EDUCATIONAL FACILITIES'),
    ('36','OUTDOOR RECREATIONAL FACILITIES'),
    ('11','SPECIAL CONDO BILLING LOTS'),
    ('34','THEATRES'),
    ('15','CONDOS - 2-10 UNIT RESIDENTIAL'),
    ('16','CONDOS - 2-10 UNIT WITH COMMERCIAL UNIT'),
    ('26','OTHER HOTELS'),
    ('28','COMMERCIAL CONDOS'),
    ('38','ASYLUMS AND HOMES'),
    ('39', 'TRANSPORTATION FACILITIES'),
    ('18','TAX CLASS 3 - UTILITY PROPERTIES'),
    ('35','INDOOR PUBLIC AND CULTURAL FACILITIES'),
    ('11A','CONDO-RENTALS'),
    ('17','CONDOPS'),
    ('40','SELECTED GOVERNMENTAL FACILITIES'),
    ('23','LOFT BUILDINGS'),
    ('24','TAX CLASS 4 - UTILITY BUREAU PROPERTIES');

INSERT INTO tax_class (id, name)
VALUES
    (1,'residential up to 3 units, condos under three stories'),
    ('2A','residential rental, 4-6 units'),
    ('2B','residential rental, 7-10 units'),
    ('2C','residential condo or coop, 2-10 units'),
    (2,'residential, 11 units or more'),
    (3,'utility'),
    (4,'commercial or industrial');

-- Not dropping the sales table because you might have stuff if it!
CREATE TABLE IF NOT EXISTS sales (
  -- id INTEGER PRIMARY KEY,
  borough INTEGER DEFAULT NULL REFERENCES borough(id),
  date date DEFAULT NULL,
  address varchar(256) DEFAULT NULL,
  apt varchar(8) DEFAULT NULL,
  zip varchar(5) DEFAULT NULL,
  neighborhood varchar(64) DEFAULT NULL,
  buildingclasscat varchar(3) DEFAULT NULL REFERENCES building_class_category(id),
  buildingclass varchar(3) DEFAULT NULL REFERENCES building_class(id),
  taxclass varchar(2) DEFAULT NULL REFERENCES tax_class(id),
  block integer DEFAULT NULL,
  lot integer DEFAULT NULL,
  resunits integer DEFAULT NULL,
  comunits integer DEFAULT NULL,
  ttlunits integer DEFAULT NULL,
  land_sf bigint DEFAULT NULL,
  gross_sf bigint DEFAULT NULL,
  yearbuilt integer DEFAULT NULL,
  price bigint DEFAULT NULL,
  easement boolean DEFAULT NULL
);

DROP TABLE IF EXISTS sales_tmp;
CREATE TABLE sales_tmp (
  BOROUGH INTEGER DEFAULT NULL,
  NEIGHBORHOOD TEXT DEFAULT NULL,
  BUILDINGCLASSCATEGORY TEXT DEFAULT NULL,
  TAXCLASSATPRESENT TEXT DEFAULT NULL,
  BLOCK TEXT DEFAULT NULL,
  LOT TEXT DEFAULT NULL,
  EASEMENT TEXT DEFAULT NULL,
  BUILDINGCLASSATPRESENT TEXT DEFAULT NULL,
  ADDRESS TEXT DEFAULT NULL,
  APARTMENTNUMBER TEXT DEFAULT NULL,
  ZIPCODE TEXT DEFAULT NULL,
  RESIDENTIALUNITS TEXT DEFAULT NULL,
  COMMERCIALUNITS TEXT DEFAULT NULL,
  TOTALUNITS TEXT DEFAULT NULL,
  LANDSQUAREFEET TEXT DEFAULT NULL,
  GROSSSQUAREFEET TEXT DEFAULT NULL,
  YEARBUILT INTEGER DEFAULT NULL,
  TAXCLASSATTIMEOFSALE TEXT DEFAULT NULL,
  BUILDINGCLASSATTIMEOFSALE TEXT DEFAULT NULL,
  SALEPRICE TEXT DEFAULT NULL,
  SALEDATE TEXT DEFAULT NULL
);


CREATE INDEX price ON sales (price);

CREATE INDEX BBL ON sales (CONCAT(borough, block, lot));