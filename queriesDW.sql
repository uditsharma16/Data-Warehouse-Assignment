--------------------------------------------------------------
----Task 1----------------------------------------------------
--------------------------------------------------------------
select * from (select p.product_name, sum(tf.total_sale) as "TOTAl_SALE",rank() over(order by sum(tf.total_sale) desc) as "RANK"
from product p,transactions_fact tf,date_table dt
where p.product_id=tf.product_id and  tf.date_id=dt.date_id and dt.month_num=12
group by p.product_name
) where rownum<6;

--------------------------------------------------------------
----Task 2----------------------------------------------------
--------------------------------------------------------------
select * from (select s.store_name, sum(tf.total_sale) as "TOTAl_SALE",rank() over(order by sum(tf.total_sale) desc) as RANK
from store s,transactions_fact tf
where s.store_id=tf.store_id  
group by s.store_name) where rownum=1;

--------------------------------------------------------------
----Task 3----------------------------------------------------
--------------------------------------------------------------

-----------------------Enter Month In Words
select * from(
select p.product_name, sum(tf.total_sale)total_sale,dt.month,rank() over(partition by dt.month order by sum(tf.total_sale) desc) as rank
from product p,transactions_fact tf,date_table dt
where p.product_id=tf.product_id  and tf.date_id=dt.date_id and 
dt.month_num in (select * from (select unique(month_num) from date_table 
where month_num<=(select unique(dt.month_num) from date_table dt where dt.month=upper('&MonthInWords')) order by month_num desc) 
where rownum<=3)
group by dt.month,p.product_name
order by total_sale desc)res where res.rank<=3 order by res.month,res.rank;

------------------------Enter Month In Numbers
select * from(
select p.product_name, sum(tf.total_sale)total_sale,dt.month,rank() over(partition by dt.month order by sum(tf.total_sale) desc) as rank
from product p,transactions_fact tf,date_table dt
where p.product_id=tf.product_id  and tf.date_id=dt.date_id and 
dt.month_num in (select * from (select unique(month_num) from date_table where month_num<=&MonthInNumber order by month_num desc) 
where rownum<=3)
group by dt.month,p.product_name
order by total_sale desc)res where res.rank<=3 order by res.month,res.rank;



--------------------------------------------------------------
----Task 4----------------------------------------------------
--------------------------------------------------------------
CREATE MATERIALIZED VIEW STOREANALYSIS 
as select s.store_id,p.product_id,sum(tf.total_sale)
from product p,store s,transactions_fact tf
where tf.store_id=s.store_id and tf.product_id=p.product_id
group by s.store_id,p.product_id
order by s.store_id,p.product_id;
--------------------------------------------------------------
----Task 5----------------------------------------------------
--------------------------------------------------------------
----Cube Function
select s.store_id,p.product_id,sum(tf.total_sale)
from product p,store s,transactions_fact tf
where tf.store_id=s.store_id and tf.product_id=p.product_id
group by CUBE(s.store_id,p.product_id)
order by s.store_id,p.product_id;
---Roll Up Function
select s.store_id,p.product_id,sum(tf.total_sale)
from product p,store s,transactions_fact tf
where tf.store_id=s.store_id and tf.product_id=p.product_id
group by ROLLUP(s.store_id,p.product_id)
order by s.store_id,p.product_id;


