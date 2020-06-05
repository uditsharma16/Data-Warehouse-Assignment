--------------------------------------------------------
--  File created - Friday-June-05-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure INLJ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "KBY5902"."INLJ" AS
t_id TRANSACTIONS.TRANSACTIONS_ID%type;
p_id TRANSACTIONS.PRODUCT_ID%type;
c_id TRANSACTIONS.CUSTOMER_ID%type;
c_name TRANSACTIONS.CUSTOMER_NAME%type;
s_id TRANSACTIONS.STORE_ID%type;
s_name TRANSACTIONS.STORE_NAME%type;
tt_date TRANSACTIONS.T_DATE%type;
t_quant TRANSACTIONS.QUANTITY%type;
type transact_type IS varray(50) of TRANSACTIONS%ROWTYPE;
transact transact_type;
md_p_id MASTERDATA.PRODUCT_ID%type;
p_name MASTERDATA.PRODUCT_NAME%type;
sup_id MASTERDATA.SUPPLIER_ID%type;
sup_name MASTERDATA.SUPPLIER_NAME%type;
md_price MASTERDATA.PRICE%type;
t_date_id date_table.date_id%type;
check_id NUMBER;
counter NUMBER;
loopnum NUMBER;
CURSOR transactions_fetch is 
SELECT * FROM transactions;
BEGIN
OPEN transactions_fetch;
loopnum:=0;
counter:=1;
CREATE_DATE_TABLE(
    YEAR_NUM => 2019
   );

LOOP
loopnum:=loopnum+1;
FETCH transactions_fetch BULK COLLECT INTO transact LIMIT 50;
EXIT WHEN transactions_fetch%notfound;
FOR counter in 1..50
LOOP
t_id:=transact(counter).transactions_id;
p_id:=transact(counter).product_id;
c_id:=transact(counter).customer_id;
c_name:=transact(counter).customer_name;
s_id:=transact(counter).store_id;
s_name:=transact(counter).store_name;
tt_date:=transact(counter).t_date;
t_quant:=transact(counter).quantity;
SELECT product_id,product_name,supplier_id,supplier_name,price
INTO md_p_id,p_name,sup_id,sup_name,md_price
FROM MASTERDATA
WHERE product_id=p_id;
SELECT date_id INTO t_date_id FROM DATE_TABLE WHERE t_date=tt_date;


--ADDING DATA IN DIMENSION TABLES
SELECT COUNT(*) INTO check_id FROM product WHERE product_id=p_id;
IF(check_id=0) THEN 
INSERT INTO product VALUES(p_id,p_name,md_price);
END IF;
SELECT COUNT(*) INTO check_id FROM customer WHERE customer_id=c_id;
IF(check_id=0) THEN 
INSERT INTO customer VALUES(c_id,c_name);
END IF;
SELECT COUNT(*) INTO check_id FROM supplier WHERE supplier_id=sup_id;
IF(check_id=0) THEN 
INSERT INTO supplier VALUES(sup_id,sup_name);
END IF;
SELECT count(*) INTO check_id FROM store WHERE store_id=s_id;
IF(check_id=0) THEN 
INSERT INTO store VALUES(s_id,s_name);
END IF;
SELECT count(*) INTO check_id FROM transactions_fact WHERE transactions_id=t_id;
IF(check_id=0) THEN 
INSERT INTO transactions_fact VALUES(t_id,t_date_id,t_quant,p_id,c_id,sup_id,s_id,t_quant*md_price);
END IF;
END LOOP;
END LOOP;
COMMIT;


  
Exception
WHEN OTHERS THEN
dbms_output.put_line('error is at'||counter||loopnum);
dbms_output.put_line(dbms_utility.format_call_stack());

END INLJ;

--dbms_output.put_line(p_name); 
--dbms_output.put_line(dbms_utility.format_call_stack());
--CREATE TABLE TRANSACTIONS (
--  TRANSACTIONS_ID	NUMBER(8,0)	NOT NULL, 
--  PRODUCT_ID		VARCHAR2(6)	NOT NULL, 
--  CUSTOMER_ID		VARCHAR2(4)	NOT NULL, 
--  CUSTOMER_NAME		VARCHAR2(30)	NOT NULL, 
--  STORE_ID			VARCHAR2(4)	NOT NULL, 
--  STORE_NAME		VARCHAR2(20) NOT NULL,
--  T_DATE			DATE		NOT NULL,
--  QUANTITY			NUMBER(3,0)	NOT NULL,
--  CONSTRAINT TRANSACTIONS_PK PRIMARY KEY (TRANSACTIONS_ID) );
--  
-- 
--  --  DDL for Table MASTERDATA
----------------------------------------------------------
--
--  CREATE TABLE "MASTERDATA" (
--  "PRODUCT_ID" VARCHAR2(6), 
--  "PRODUCT_NAME" VARCHAR2(30), 
--  "SUPPLIER_ID" VARCHAR2(5), 
--  "SUPPLIER_NAME" VARCHAR2(30), 
--  "PRICE" NUMBER(5,2) DEFAULT 0.0 );
--
--
--  
--

/
