--------------------------------------------------------
--  File created - Friday-June-05-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure CREATE_DATE_TABLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "KBY5902"."CREATE_DATE_TABLE" (year_num NUMBER) AS 
leap_num NUMBER;
TYPE month_seq IS varray(12) of NUMBER;
mon_seq month_seq;
start_date DATE;
day_val NUMBER;
month_val VARCHAR(10);
month_num_val NUMBER;
quater NUMBER;
BEGIN
start_date:=TO_DATE('01-JAN-'||TO_CHAR(year_num));
IF(mod(year_num,400)=0)THEN
leap_num:=366;
ELSIF(mod(year_num,4)=0 and mod(year_num,100)=0)THEN
leap_num:=365;
ELSIF(mod(year_num,4)=0)THEN
leap_num:=366;
ELSE 
leap_num:=365;
END IF;
FOR i in 1..leap_num
LOOP
IF(extract(month from start_date) IN (1,2,3)) THEN
quater:=1;
ELSIF(extract(month from start_date) IN (4,5,6)) THEN
quater:=2;
ELSIF(extract(month from start_date) IN (7,8,9)) THEN
quater:=3;
ELSIF(extract(month from start_date) IN (10,11,12)) THEN
quater:=4;
END IF;
day_val:=extract(day from start_date);
month_val:=extract(month from start_date);
INSERT INTO DATE_TABLE VALUES(date_id_seq.nextval,day_val,to_char(start_date,'MONTH'),month_val,start_date,year_num,quater);
start_date:=start_date+1;
END LOOP;
dbms_output.put_line(dbms_utility.format_call_stack());
COMMIT;
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line('error in'||day_val||month_val);
END CREATE_DATE_TABLE;

--CREATE TABLE DATE_TABLE(
--DATE_ID NUMBER,
--DAY NUMBER,
--MONTH VARCHAR(10),
--MONTH_NUM NUMBER,
--YEAR NUMBER(4),
--QUATER NUMBER,
--CONSTRAINT DATE_ID_PK PRIMARY KEY(DATE_ID));

/
