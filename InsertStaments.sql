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
