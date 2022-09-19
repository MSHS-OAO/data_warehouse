-- NUMBER Data Type

/*
Oracle NUMBER data type is used to store numeric values that can be negative or positive. 

Syntax of the NUMBER data type:

NUMBER[(precision [, scale])]

NUMBER data type has precision and scale.

The precision is the number of digits in a number. It ranges from 1 to 38.
The scale is the number of digits to the right of the decimal point in a number. It ranges from -84 to 127.
For example, the number 1234.56 has a precision of 6 and a scale of 2. So to store this number, you need NUMBER(6,2) 

We can force Oracle to rounded of to nearest tens,hundreds,thousands place. To do that, You can specify negetive scale.
*/

CREATE TABLE number_demo ( 
    number_value NUMERIC(6, 2) 
);

INSERT INTO number_demo
VALUES(100.99); 

-- Rounded to two decimal places
INSERT INTO number_demo
VALUES(90.551);

-- Rounded to two decimal places
INSERT INTO number_demo
VALUES(87.556);

CREATE TABLE number_demo1 ( 
    number_value NUMERIC(6, -2) 
);

-- All the numbers are inserted up to 100s place
INSERT INTO number_demo1
VALUES(110.99);


INSERT INTO number_demo1
VALUES(90.551);


INSERT INTO number_demo1
VALUES(87.556);

CREATE TABLE number_demo2 ( 
    number_value NUMERIC(6, -1) 
);

-- All the numbers are inserted up to 10s place
INSERT INTO number_demo2
VALUES(1119.99);


INSERT INTO number_demo2
VALUES(90.551);


INSERT INTO number_demo2
VALUES(87.556);

-- Drop the tables
DROP TABLE number_demo;
DROP TABLE number_demo1;
DROP TABLE number_demo2;


-- CHARACTER Data Types
/*
To define a CHAR column, you need to specify a string length either in bytes or characters as shown following:

CHAR(length BYTE)
CHAR(length CHAR)

If you don’t explicitly specify BYTE or CHAR followed the length, Oracle uses the BYTE by default. 
The default value of length is 1 if you skip the length.

A VARCHAR2 column can store a value that ranges from 1 to 4000 bytes. 
It means that for a single-byte character set, you can store up to 4000 characters in a VARCHAR2 column.
Since Oracle Database 12c, you can specify the maximum size of 32767 for the VARCHAR2 data type.
*/

CREATE TABLE t (
    x CHAR(10),
    y VARCHAR2(10)
);


INSERT INTO t(x, y )
VALUES('Oracle', 'Oracle');


SELECT
    *
FROM
    t


--DUMP() function to return the detailed information on x and y columns
--Oracle DUMP() function allows you to find the data type, length, and internal representation of a value.
-- Example:
--         Typ=96: denotes the CHAR data type. https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/Data-Types.html#GUID-7B72E154-677A-4342-A1EA-C74C1EA928E6
--         Len=10: the length of the string is 10.
--         79,114,97,99,108,101,32,32,32,32 : is the decimal (or ASCII) representation of the string
SELECT
    x,
    DUMP(x),
    y,
    DUMP(y)
FROM
    t;

--We can use the LENGTHB() function to get the number of bytes used by the x and y columns
SELECT
    LENGTHB(x),
    LENGTHB(y)
FROM
    t;

DROP TABLE t;

-- DATE and TIMESTAMPS
/*
Oracle Database has its own propriety format for storing date data.
It uses fixed-length fields of 7 bytes, each corresponding to century, year, month, day, hour, minute, and second to store date data.
*/

-- Check the standard date format
SELECT
  value
FROM
  V$NLS_PARAMETERS
WHERE
  parameter = 'NLS_DATE_FORMAT';
  
-- Get the current date
SELECT
  sysdate
FROM
  dual;

-- Date to Charecter
SELECT
  TO_CHAR( SYSDATE, 'MM/DD/YYYY' )
FROM
  dual;

-- String to Date
SELECT
  TO_DATE( 'August 01, 2017', 'MONTH DD, YYYY' )
FROM
  dual;   
  
  
DROP TABLE DEMODATES;

-- Examples, More infor on formatting can be found at:
-- https://docs.oracle.com/database/121/SQLRF/sql_elements004.htm#SQLRF00212 refer table 2-15
CREATE TABLE DEMODATES (
    event_name VARCHAR2 ( 255 ) NOT NULL,
    location VARCHAR2 ( 255 ) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
);

-- TO_DATE vs DATE
INSERT INTO DEMODATES
            (event_name,
             location,
             start_date,
             end_date)
VALUES     ( 'TechEd Europe',
        'Barcelona, Spain',
            DATE '2017-11-14',
            DATE '2017-11-16' ); 
INSERT INTO DEMODATES
            (event_name,
             location,
             start_date,
             end_date)
VALUES     ( 'Oracle OpenWorld',
        'San Francisco, CA, USA',
            TO_DATE( 'October 01, 2017', 'MONTH DD, YYYY' ),
            TO_DATE( 'October 05, 2017', 'MONTH DD, YYYY')); 
            

            
/* 
The TIMESTAMP data type allows you to store date and time data including year, month, day, hour, minute and second.

In addition, it stores the fractional seconds, which is not stored by the DATE data type. 

fractional_seconds_precision is the number of digits in the fractional part of the SECONDS of datetime field. 
Accepted values of fractional_seconds_precision are 0 to 9. 
The default is 6
*/


SELECT
  value
FROM
  V$NLS_PARAMETERS
WHERE
  parameter = 'NLS_TIMESTAMP_FORMAT';


CREATE TABLE TIMEUPDATED (
    service_line VARCHAR(20) NOT NULL,
    uploaded_at TIMESTAMP (9) NOT NULL,
);

INSERT INTO TIMEUPDATED (
    service_line,
    uploaded_at
    )
VALUES (
    'ED',
    LOCALTIMESTAMP(9)
    );

INSERT INTO TIMEUPDATED (
    service_line,
    uploaded_at
    )
VALUES (
    'Engineering',
    LOCALTIMESTAMP(2)
    );
INSERT INTO TIMEUPDATED (
    service_line,
    uploaded_at
    )
VALUES (
    'Biomed/Clinical',
    TO_TIMESTAMP('03-AUG-17 11:20:30.45 AM')
    );

SELECT service_line,TO_CHAR(uploaded_at, 'MONTH DD, YYYY "at" HH24:MI') as UPDATETIME
FROM TIMEUPDATED;

-- To extract components a TIMESTAMP such as year, month, day, hour,minute, and second, you use the EXTRACT() function
SELECT 
    service_line,
    EXTRACT(year FROM uploaded_at) year,
    EXTRACT(month FROM uploaded_at) month,
    EXTRACT(day FROM uploaded_at) day,
    EXTRACT(hour FROM uploaded_at) hour,
    EXTRACT(minute FROM uploaded_at) minute,
    EXTRACT(second FROM uploaded_at) seScond
FROM 
    TIMEUPDATED;

    
DROP TABLE TIMEUPDATED;
DROP TABLE DEMODATES;
