-- NUMBER Data Type

/*
Oracle NUMBER data type is used to store numeric values that can be negative or positive. 

Syntax of the NUMBER data type:

NUMBER[(precision [, scale])]

NUMBER data type has precision and scale.

The precision is the number of digits in a number. It ranges from 1 to 38.
The scale is the number of digits to the right of the decimal point in a number. It ranges from -84 to 127.
For example, the number 1234.56 has a precision of 6 and a scale of 2. So to store this number, you need NUMBER(6,2) 

We can force Oracle to rounded of to nearest tens,hundreds,thousands place. To do that, You can specify negetive precision
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

-- All the numbers are inserted as 100's
INSERT INTO number_demo1
VALUES(110.99);


INSERT INTO number_demo1
VALUES(90.551);


INSERT INTO number_demo1
VALUES(87.556);

CREATE TABLE number_demo2 ( 
    number_value NUMERIC(6, -1) 
);

-- All the numbers are inserted as 10's
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
