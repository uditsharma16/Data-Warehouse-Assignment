---Task 1---------------------------------------
select * from (select p.product_name, sum(tf.total_sale) as "TOTAl_SALE",rank() over(order by sum(tf.total_sale) desc) as "RANK"
from product p,transactions_fact tf,date_table dt
where p.product_id=tf.product_id and  tf.date_id=dt.date_id and dt.month_num=12
group by p.product_name
) where rownum<6;

----Task 2----------------------------------------
select * from (select s.store_name, sum(tf.total_sale) as "TOTAl_SALE",rank() over(order by sum(tf.total_sale) desc) as RANK
from store s,transactions_fact tf
where s.store_id=tf.store_id  
group by s.store_name) where rownum=1;

----Task 3------------------------------------------------------------------------


select * from (select p.product_name, sum(tf.total_sale) as "TOTAl_SALE",rank() over(order by sum(tf.total_sale) desc)||' '||dt.month as "RANK"
from product p,transactions_fact tf,date_table dt
where p.product_id=tf.product_id and dt.month_num=@EmpIDVar and tf.date_id=dt.date_id
group by p.product_name,dt.month
) where rownum<4
union
select * from (select p.product_name, sum(tf.total_sale) as "TOTAl_SALE",rank() over(order by sum(tf.total_sale) desc)||' '||dt.month as "RANK"
from product p,transactions_fact tf,date_table dt
where p.product_id=tf.product_id and dt.month_num=@EmpIDVar-1 and tf.date_id=dt.date_id
group by p.product_name,dt.month
) where rownum<4
union
select * from (select p.product_name, sum(tf.total_sale) as "TOTAl_SALE",rank() over(order by sum(tf.total_sale) desc)||' '||dt.month as "RANK"
from product p,transactions_fact tf,date_table dt
where p.product_id=tf.product_id and dt.month_num=@EmpIDVar-2 and tf.date_id=dt.date_id
group by p.product_name,dt.month
) where rownum<4;

----Task 4---------------------------------------------------
CREATE MATERIALIZED VIEW STOREANALYSIS 
as select s.store_id,p.product_id,sum(tf.total_sale)
from product p,store s,transactions_fact tf
where tf.store_id=s.store_id and tf.product_id=p.product_id
group by s.store_id,p.product_id
order by s.store_id,p.product_id;




--select p.product_name, sum(tf.total_sale) as "TOTAl_SALE",rank() over(order by sum(tf.total_sale) desc)||' '||extract(month from tf.t_date) as "RANK"
--from product p,transactions_fact tf,date_table dt
--where p.product_id=tf.product_id and dt.date_id=tf.date_id and dt.month_num in(12,11,10)
--group by p.product_name,extract(month from tf.t_date)
--order by extract(month from tf.t_date) desc ;

select * from(
select p.product_name, sum(tf.total_sale)total_sale,dt.month,rank() over(partition by dt.month order by sum(tf.total_sale) desc) as rank
from product p,transactions_fact tf,date_table dt
where p.product_id=tf.product_id  and tf.date_id=dt.date_id and 
dt.month_num in (select * from (select unique(month_num) from date_table where month_num<=&month order by month_num desc) where rownum<=3)
group by dt.month,p.product_name
order by total_sale desc)res where res.rank<=3 order by res.month,res.rank;



