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

-- Example 5.1 answer
SELECT * FROM SUMMARY_REPO_EXAMPLE;

-- Example 5.2 answer
SELECT * FROM SUMMARY_REPO_EXAMPLE
WHERE site = 'MSH' OR site = 'MSBI';

-- Example 5.3 answer 
SELECT a.service, a.site, a.premier_reporting_period, a.metric_name_submitted, a.value 
FROM SUMMARY_REPO_EXAMPLE a
WHERE a.site = 'MSH' OR a.site = 'MSBI';

-- Example 5.4 answer
SELECT a.*, b.general_group, b.display_order, b.reporting_tab 
FROM SUMMARY_REPO_EXAMPLE a
LEFT JOIN OAO_DEVELOPMENT.BSC_MAPPING_EXAMPLE b 
ON a.service = b.service AND a.metric_name_submitted = b.metric_name_submitted;

-- Example 6.1 answer
CREATE VIEW summary_repo_mapping AS
SELECT a.*, b.general_group, b.display_order, b.reporting_tab 
FROM OAO_DEVELOPMENT.SUMMARY_REPO_EXAMPLE a
LEFT JOIN OAO_DEVELOPMENT.BSC_MAPPING_EXAMPLE b 
ON a.service = b.service AND a.metric_name_submitted = b.metric_name_submitted;

-- Example 6.2
SELECT * FROM SUMMARY_REPO_MAPPING a
WHERE a.service = 'test';


        
