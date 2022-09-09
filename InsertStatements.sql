-- BASIC INSERT STATEMENT /SLIDE 12
INSERT INTO OAO_DEVELOPMENT.summary_repo_example
(SERVICE,
SITE,
MONTH,
METRIC_NAME_SUBMITTED,
VALUE,
UPDATE_TIME,
PREMIER_REPORTING_PERIOD,
UPDATE_USER)
VALUES('Lab',
	    'MSB',
 	    TO_DATE('2020-01-01','YYYY-MM-DD'),
	    'Troponin (<=50 min)',
	     0.8913,
	    TO_DATE('2020-02-18','YYYY-MM-DD'),
	    'Jan 2020',
	    'NA');
	    
-- Insert statment from select example / SLIDE 12
/* 
Note on DBMS_RANDOM.RANDOM : https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:1859804900346710586
				https://datacadamia.com/lang/plsql/dbms_random 
Example:
SELECT SITE, SERVICE, MONTH, DBMS_RANDOM.RANDOM AS RANDOM_COL
FROM  oao_development.summary_repo_example
ORDER BY  RANDOM_COL;
*/

INSERT INTO OAO_DEVELOPMENT.merge_example
SELECT *
FROM   (
    SELECT *
    FROM  oao_development.summary_repo_example
    ORDER BY DBMS_RANDOM.RANDOM)
WHERE  rownum < 21;
	  
-- Insert all statment example / SLIDE 13
	
INSERT ALL 
INTO OAO_DEVELOPMENT.summary_repo_example (SERVICE,
					   SITE,
					   MONTH,
				   	   METRIC_NAME_SUBMITTED,
					   VALUE,
                       			   PREMIER_REPORTING_PERIOD)
VALUES('Lab',
       'MSB',
        TO_DATE('2020-01-01','YYYY-MM-DD'),
       'Troponin (<=50 min)',
	0.8913,
       'Jan 2020')
INTO OAO_DEVELOPMENT.merge_example (SERVICE,
					   SITE,
					   MONTH,
				   	   METRIC_NAME_SUBMITTED,
					   VALUE,
                       			   PREMIER_REPORTING_PERIOD)
VALUES('Lab',
       'MSB',
        TO_DATE('2020-01-01','YYYY-MM-DD'),
       'Troponin (<=50 min)',
	0.8913,
       'Jan 2020')				
SELECT * FROM dual; 


-- Merge statment example / SLIDE 15

MERGE INTO OAO_DEVELOPMENT.summary_repo_example  SR
USING OAO_DEVELOPMENT.merge_example SOURCE_TABLE

-- Specify fields to be joined on

ON (  SR."SITE" = SOURCE_TABLE."SITE" AND
      SR."SERVICE" = SOURCE_TABLE."SERVICE" AND
      SR."METRIC_NAME_SUBMITTED" = SOURCE_TABLE."METRIC_NAME_SUBMITTED" AND
      SR."PREMIER_REPORTING_PERIOD" = SOURCE_TABLE."PREMIER_REPORTING_PERIOD")
-- Specify what fields to be updated when the records match

WHEN MATCHED THEN 
UPDATE  SET SR."VALUE" = SOURCE_TABLE."VALUE",
            SR."UPDATE_TIME" = SOURCE_TABLE."UPDATE_TIME",
            SR."UPDATE_USER" = SOURCE_TABLE."UPDATE_USER"
	    
-- Specify what fields to insert when the records don't match

WHEN NOT MATCHED THEN
INSERT( SR."SITE",
        SR."SERVICE",
        SR."METRIC_NAME_SUBMITTED",
        SR."VALUE", 
        SR."UPDATE_TIME", 
        SR."UPDATE_USER",
        SR."PREMIER_REPORTING_PERIOD")  
VALUES( SOURCE_TABLE."SITE",
        SOURCE_TABLE."SERVICE",
        SOURCE_TABLE."METRIC_NAME_SUBMITTED",
        SOURCE_TABLE."VALUE", 
        SOURCE_TABLE."UPDATE_TIME",
        SOURCE_TABLE."UPDATE_USER",
        SOURCE_TABLE."PREMIER_REPORTING_PERIOD");
	
-- Variant of MERGE to update only when values don't match

MERGE INTO OAO_DEVELOPMENT.summary_repo_example  SR
USING OAO_DEVELOPMENT.merge_example SOURCE_TABLE

-- Specify fields to be joined on

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
        SR."MONTH");  
VALUES( SOURCE_TABLE."SITE",
        SOURCE_TABLE."SERVICE",
        SOURCE_TABLE."METRIC_NAME_SUBMITTED",
        SOURCE_TABLE."VALUE", 
        SOURCE_TABLE."UPDATE_TIME",
        SOURCE_TABLE."UPDATE_USER",
        SOURCE_TABLE."PREMIER_REPORTING_PERIOD",
        SOURCE_TABLE."MONTH");


