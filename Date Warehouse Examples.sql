--Example 1 Answer
CREATE TABLE SUMMARY_REPO_EXAMPLE
(
    Service VARCHAR2(50),
    Site VARCHAR2(26),
    Month Date,
    Premier_Reporting_Period VARCHAR2(45),
    Metric_Name_Submitted VARCHAR2(75),
    Update_Time Date,
    Update_User VARCHAR2(25),
    Value Number(38,4),
    Constraint summary_repo_pk PRIMARY KEY
        (
        Service,
        Site,
        Month,
        Metric_Name_Submitted
        )
    ENABLE
)

--Grant Select Permisions for Merge_Example table run as OAO_Developement user
GRANT SELECT on MERGE_EXAMPLE to servig01, webera04, lenang01, mieslm01, eggerd02, aghaer01, tommad01, nevink01, villea04
GRANT SELECT on BSC_MAPPING_EXAMPLE to servig01, webera04, lenang01, mieslm01, eggerd02, aghaer01, tommad01, nevink01, villea04

--Example 2.1 Answer
INSERT ALL 
INTO SUMMARY_REPO_EXAMPLE
(SERVICE, SITE, MONTH, METRIC_NAME_SUBMITTED, VALUE, UPDATE_TIME, PREMIER_REPORTING_PERIOD, UPDATE_USER)
   VALUES('New Service MSHS', 'MSB', TO_DATE('2020-01-01','YYYY-MM-DD'), 'Troponin (<=50 min)', 0.8913, 
            TO_DATE('2020-01-14','YYYY-MM-DD'), 'Jan 2020', 'OAO'
        )
INTO SUMMARY_REPO_EXAMPLE
(SERVICE, SITE, MONTH, METRIC_NAME_SUBMITTED, VALUE, UPDATE_TIME, PREMIER_REPORTING_PERIOD, UPDATE_USER)   
    VALUES('New Service MSHS', 'MSH', TO_DATE('2020-02-01','YYYY-MM-DD'), 'Troponin (<=50 min)', 0.85, 
            TO_DATE('2020-02-14','YYYY-MM-DD'), 'Feb 2020', 'OAO'
        )
    SELECT * FROM DUAL;
    
    
--Example 2.2 Answer
INSERT INTO SUMMARY_REPO_EXAMPLE
(SERVICE, SITE, MONTH, METRIC_NAME_SUBMITTED, VALUE, UPDATE_TIME, PREMIER_REPORTING_PERIOD, UPDATE_USER)
SELECT SERVICE, SITE, MONTH, METRIC_NAME_SUBMITTED, VALUE, UPDATE_TIME, PREMIER_REPORTING_PERIOD, UPDATE_USER 
FROM OAO_DEVELOPMENT.MERGE_EXAMPLE
WHERE SERVICE = 'New Service Line'

--Example 3.1 Answer
INSERT INTO "OAO_DEVELOPMENT"."MERGE_EXAMPLE" (SERVICE, SITE, MONTH, PREMIER_REPORTING_PERIOD, METRIC_NAME_SUBMITTED, VALUE,UPDATE_USER) 
                                       VALUES ('New Line3', 'MSH', TO_DATE('2022-12-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dec 2022', 'New Metric', '1','<name1>');

INSERT INTO "OAO_DEVELOPMENT"."MERGE_EXAMPLE" (SERVICE, SITE, MONTH, PREMIER_REPORTING_PERIOD, METRIC_NAME_SUBMITTED, VALUE,UPDATE_USER) 
                                       VALUES ('New Line4', 'MSH', TO_DATE('2022-12-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dec 2022', 'New Metric', '1','<name2>');

--Example 3.2 Answer
INSERT ALL
WHEN UPDATE_USER = '<name1>' OR  UPDATE_USER = '<name2>'
THEN INTO OAO_DEVELOPMENT.MERGE_EXAMPLE 
WHEN UPDATE_USER = '<name1>' OR  UPDATE_USER = '<name2>'
THEN INTO OAO_DEVELOPMENT.MERGE_EXAMPLE 
SELECT * FROM OAO_DEVELOPMENT.MERGE_EXAMPLE;


-- Delete statment
DELETE FROM OAO_DEVELOPMENT.MERGE_EXAMPLE WHERE UPDATE_USER IN ('<name1>', '<name2>');

INSERT FIRST
WHEN UPDATE_USER = '<name1>' OR  UPDATE_USER = '<name2>'
THEN INTO OAO_DEVELOPMENT.MERGE_EXAMPLE 
WHEN UPDATE_USER = '<name1>' OR  UPDATE_USER = '<name2>'
THEN INTO OAO_DEVELOPMENT.MERGE_EXAMPLE 
SELECT * FROM OAO_DEVELOPMENT.MERGE_EXAMPLE;

-- Delete statment
DELETE FROM OAO_DEVELOPMENT.MERGE_EXAMPLE WHERE UPDATE_USER IN ('<name1>', '<name2>');

-- Delete statment
DELETE FROM OAO_DEVELOPMENT.MERGE_EXAMPLE WHERE UPDATE_USER IN ('<name1>', '<name2>');


--Example 4 Answer
MERGE INTO summary_repo_example  SR
USING OAO_DEVELOPMENT.merge_example SOURCE_TABLE

-- Specify fields to match on

ON (  SR."SITE" = SOURCE_TABLE."SITE" AND
      SR."SERVICE" = SOURCE_TABLE."SERVICE" AND
      SR."METRIC_NAME_SUBMITTED" = SOURCE_TABLE."METRIC_NAME_SUBMITTED" AND
      SR."PREMIER_REPORTING_PERIOD" = SOURCE_TABLE."PREMIER_REPORTING_PERIOD")
-- Specify what fields to be updated when the records match

WHEN MATCHED THEN 
UPDATE  SET SR."VALUE" = SOURCE_TABLE."VALUE",
            SR."UPDATE_TIME" = SOURCE_TABLE."UPDATE_TIME",
            SR."UPDATE_USER" = SOURCE_TABLE."UPDATE_USER"
-- WHERE clause prevents the all the records from getting merged

WHERE SR."VALUE" <> SOURCE_TABLE."VALUE"

-- Specify fields to be joined on

WHEN NOT MATCHED THEN
INSERT( SR."SITE",
        SR."SERVICE",
        SR."METRIC_NAME_SUBMITTED",
        SR."VALUE", 
        SR."UPDATE_TIME", 
        SR."UPDATE_USER",
        SR."PREMIER_REPORTING_PERIOD",
        SR."MONTH") 
VALUES( SOURCE_TABLE."SITE",
        SOURCE_TABLE."SERVICE",
        SOURCE_TABLE."METRIC_NAME_SUBMITTED",
        SOURCE_TABLE."VALUE", 
        SOURCE_TABLE."UPDATE_TIME",
        SOURCE_TABLE."UPDATE_USER",
        SOURCE_TABLE."PREMIER_REPORTING_PERIOD",
        SOURCE_TABLE."MONTH");       
       
-- Delete Example
        
MERGE INTO summary_repo_example  SR
USING OAO_DEVELOPMENT.merge_example SOURCE_TABLE

-- Specify fields to match on

ON (  SR."SITE" = SOURCE_TABLE."SITE" AND
      SR."SERVICE" = SOURCE_TABLE."SERVICE" AND
      SR."METRIC_NAME_SUBMITTED" = SOURCE_TABLE."METRIC_NAME_SUBMITTED" AND
      SR."PREMIER_REPORTING_PERIOD" = SOURCE_TABLE."PREMIER_REPORTING_PERIOD")
-- Specify what fields to be updated when the records match

WHEN MATCHED THEN 
UPDATE  SET SR."VALUE" = SOURCE_TABLE."VALUE",
            SR."UPDATE_TIME" = SOURCE_TABLE."UPDATE_TIME",
            SR."UPDATE_USER" = SOURCE_TABLE."UPDATE_USER"
-- WHERE clause prevents the all the records from getting merged

WHERE SR."VALUE" <> SOURCE_TABLE."VALUE"

-- INTRODUCE DELETE AFTER UPDATING RECORDS
DELETE WHERE SR.SERVICE = 'Lab'

-- Specify fields to be joined on

WHEN NOT MATCHED THEN
INSERT( SR."SITE",
        SR."SERVICE",
        SR."METRIC_NAME_SUBMITTED",
        SR."VALUE", 
        SR."UPDATE_TIME", 
        SR."UPDATE_USER",
        SR."PREMIER_REPORTING_PERIOD",
        SR."MONTH") 
VALUES( SOURCE_TABLE."SITE",
        SOURCE_TABLE."SERVICE",
        SOURCE_TABLE."METRIC_NAME_SUBMITTED",
        SOURCE_TABLE."VALUE", 
        SOURCE_TABLE."UPDATE_TIME",
        SOURCE_TABLE."UPDATE_USER",
        SOURCE_TABLE."PREMIER_REPORTING_PERIOD",
        SOURCE_TABLE."MONTH");
        
       
       
-- Example 5.1 answer
SELECT * FROM SUMMARY_REPO_EXAMPLE;

-- Example 5.2 answer
SELECT * FROM SUMMARY_REPO_EXAMPLE
WHERE site = 'MSH' OR site = 'MSQ';

-- Example 5.3 answer 
SELECT a.service, a.site, a.premier_reporting_period, a.metric_name_submitted, a.value 
FROM SUMMARY_REPO_EXAMPLE a
WHERE a.site = 'MSH' OR a.site = 'MSQ';

-- Example 5.4 answer
SELECT a.*, b.general_group, b.display_order, b.reporting_tab 
FROM SUMMARY_REPO_EXAMPLE a
LEFT JOIN OAO_DEVELOPMENT.BSC_MAPPING_EXAMPLE b 
ON a.service = b.service AND a.metric_name_submitted = b.metric_name_submitted
WHERE a.site = 'MSH' OR a.site = 'MSQ';

-- Example 6.1 answer
CREATE VIEW summary_repo_mapping AS
SELECT a.*, b.general_group, b.display_order, b.reporting_tab 
FROM SUMMARY_REPO_EXAMPLE a
LEFT JOIN OAO_DEVELOPMENT.BSC_MAPPING_EXAMPLE b 
ON a.service = b.service AND a.metric_name_submitted = b.metric_name_submitted
WHERE a.site = 'MSH' OR a.site = 'MSQ';

-- View query as virtual table (view)
SELECT * FROM summary_repo_mapping;

-- Example 6.2
SELECT * FROM SUMMARY_REPO_MAPPING a
WHERE a.service = 'test';
