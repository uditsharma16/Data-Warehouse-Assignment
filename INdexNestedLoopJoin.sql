--------------------------------------------------------
--  File created - Monday-June-01-2020   
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
md_p_id MASTERDATA.PRODUCT_ID%type;
p_name MASTERDATA.PRODUCT_NAME%type;
sup_id MASTERDATA.SUPPLIER_ID%type;
sup_name MASTERDATA.SUPPLIER_NAME%type;
md_price MASTERDATA.PRICE%type;
check_id NUMBER;
counter NUMBER;
CURSOR transactions_fetch is 
SELECT * FROM transactions;

BEGIN
OPEN transactions_fetch;
LOOP
counter:=0;
LOOP 
FETCH transactions_fetch INTO t_id,p_id,c_id,c_name,s_id,s_name,tt_date,t_quant;
SELECT product_id,product_name,supplier_id,supplier_name,price
INTO md_p_id,p_name,sup_id,sup_name,md_price
FROM MASTERDATA
WHERE product_id=p_id;
--dbms_output.put_line(p_name||counter); 
counter := counter+1;
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


--dbms_output.put_line(check_id); 
SELECT count(*) INTO check_id FROM store WHERE store_id=s_id;
IF(check_id=0) THEN 
INSERT INTO store VALUES(s_id,s_name);
END IF;
--dbms_output.put_line(t_id); 
SELECT count(*) INTO check_id FROM transactions_fact WHERE transactions_id=t_id;
IF(check_id=0) THEN 
INSERT INTO transactions_fact VALUES(t_id,tt_date,t_quant,p_id,c_id,sup_id,s_id,t_quant*md_price);
END IF;


EXIT WHEN counter=50 OR transactions_fetch%notfound ; 
END LOOP;
EXIT WHEN transactions_fetch%notfound;
END LOOP;

--dbms_output.put_line(p_name); 
--dbms_output.put_line(dbms_utility.format_call_stack());
COMMIT;
END INLJ;

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
