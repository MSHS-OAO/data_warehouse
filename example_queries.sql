--- insert statements start here
/* Basic insert statment*/

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
	    
/* Insert statment from select example*/
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
	  

/* Merge statment example*/

MERGE INTO OAO_DEVELOPMENT.summary_repo_example  SR
USING OAO_DEVELOPMENT.merge_example SOURCE_TABLE
ON (  SR."SITE" = SOURCE_TABLE."SITE" AND
      SR."SERVICE" = SOURCE_TABLE."SERVICE" AND
      SR."METRIC_NAME_SUBMITTED" = SOURCE_TABLE."METRIC_NAME_SUBMITTED" AND
      SR."PREMIER_REPORTING_PERIOD" = SOURCE_TABLE."PREMIER_REPORTING_PERIOD")
WHEN MATCHED THEN 
UPDATE  SET SR."VALUE" = SOURCE_TABLE."VALUE",
            SR."UPDATE_TIME" = SOURCE_TABLE."UPDATE_TIME",
            SR."UPDATE_USER" = SOURCE_TABLE."UPDATE_USER"
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

/* Insert all statment example*/
	
INSERT ALL 
INTO OAO_DEVELOPMENT.summary_repo_example (SERVICE,
					   SITE,
					   MONTH,
				   	   METRIC_NAME_SUBMITTED,
					   VALUE)
VALUES('Lab',
       'MSB',
        TO_DATE('2020-01-01','YYYY-MM-DD'),
       'Troponin (<=50 min)',
	0.8913)
INTO OAO_DEVELOPMENT.merge_example (SERVICE,
					   SITE,
					   MONTH,
				   	   METRIC_NAME_SUBMITTED,
					   VALUE)
VALUES('Lab',
       'MSB',
        TO_DATE('2020-01-01','YYYY-MM-DD'),
       'Troponin (<=50 min)',
	0.8913)					
SELECT * FROM dual; 

--- select all records from a specified table
SELECT * FROM OAO_DEVELOPMENT.summary_repo_example;
SELECT * FROM OAO_DEVELOPMENT.bsc_mapping_example;

--- select all records from a specified table that meet a given condition
SELECT * FROM OAO_DEVELOPMENT.summary_repo_example
WHERE site = 'MSH' OR site = 'MSBI';

--- select specific columns from a specified table that meet a given condition using table alias 
SELECT a.service, a.site, a.premier_reporting_period, a.metric_name_submitted, a.value 
FROM OAO_DEVELOPMENT.summary_repo_example a
WHERE a.site = 'MSH' OR a.site = 'MSBI';

--- join specific columns from two tables
SELECT a.*, b.GENERAL_GROUP, b.DISPLAY_ORDER, b.REPORTING_TAB 
FROM OAO_DEVELOPMENT.SUMMARY_REPO_EXAMPLE a
LEFT JOIN OAO_DEVELOPMENT.BSC_MAPPING_EXAMPLE b 
ON a.SERVICE = b.SERVICE AND a.METRIC_NAME_SUBMITTED = b.METRIC_NAME_SUBMITTED;

--- use nested queries to filter and join two tables
Select b.*, c.GENERAL_GROUP, c.DISPLAY_ORDER, c.REPORTING_TAB
FROM(
SELECT a.*
FROM OAO_DEVELOPMENT.SUMMARY_REPO_EXAMPLE a
WHERE a.site = 'MSBI' OR a.site = 'MSH') b
LEFT JOIN OAO_DEVELOPMENT.BSC_MAPPING_EXAMPLE c 
ON b.SERVICE = c.SERVICE AND b.METRIC_NAME_SUBMITTED = c.METRIC_NAME_SUBMITTED;

--- store query as view
CREATE VIEW msh_msbi_lab AS
SELECT b.*, c.GENERAL_GROUP, c.DISPLAY_ORDER, c.REPORTING_TAB
FROM(
SELECT a.*
FROM OAO_DEVELOPMENT.SUMMARY_REPO_EXAMPLE a
WHERE a.site = 'MSBI' OR a.site = 'MSH') b
LEFT JOIN OAO_DEVELOPMENT.BSC_MAPPING_EXAMPLE c 
ON b.SERVICE = c.SERVICE AND b.METRIC_NAME_SUBMITTED = c.METRIC_NAME_SUBMITTED;

-- select all records from view that we just created. 
SELECT * FROM msh_msbi_lab;

--- drop view for presentation purposes
DROP VIEW msh_msbi_lab;
