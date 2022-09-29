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
)

--Grant Select Permisions for Merge_Example table
GRANT SELECT on MERGE_EXAMPLE to servig01, webera01, lenang01, mieslm01, eggerd01, aghaer01, tommad01, nevink01

--Example 2.1 Answer
INSERT ALL 
INTO SUMMARY_REPO_EXAMPLE
(SERVICE, SITE, MONTH, METRIC_NAME_SUBMITTED, VALUE, UPDATE_TIME, PREMIER_REPORTING_PERIOD, UPDATE_USER)
   VALUES('Lab', 'MSB', TO_DATE('2020-01-01','YYYY-MM-DD'), 'Troponin (<=50 min)', 0.8913, 
            TO_DATE('2020-01-14','YYYY-MM-DD'), 'Jan 2020', 'OAO'
        )
INTO SUMMARY_REPO_EXAMPLE
(SERVICE, SITE, MONTH, METRIC_NAME_SUBMITTED, VALUE, UPDATE_TIME, PREMIER_REPORTING_PERIOD, UPDATE_USER)   
    VALUES('Lab', 'MSH', TO_DATE('2020-02-01','YYYY-MM-DD'), 'Troponin (<=50 min)', 0.85, 
            TO_DATE('2020-02-14','YYYY-MM-DD'), 'Feb 2020', 'OAO'
        )
    SELECT * FROM DUAL;
    
    
--Example 2.2 Answer
INSERT INTO SUMMARY_REPO_EXAMPLE
(SERVICE, SITE, MONTH, METRIC_NAME_SUBMITTED, VALUE, UPDATE_TIME, PREMIER_REPORTING_PERIOD, UPDATE_USER)
SELECT SERVICE, SITE, MONTH, METRIC_NAME_SUBMITTED, VALUE, UPDATE_TIME, PREMIER_REPORTING_PERIOD, UPDATE_USER 
FROM villea04.MERGE_EXAMPLE
WHERE SERVICE = 'New Service Line'


MERGE INTO summary_repo_example  SR
USING villea04.merge_example SOURCE_TABLE

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
