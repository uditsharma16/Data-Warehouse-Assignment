---Task 1
select  p.product_name, sum(tf.total_sale) as "TOTAl_SALE"
from product p,transactions_fact tf
where p.product_id=tf.product_id and extract(month from tf.t_date)=12 
group by p.product_name
order by sum(tf.total_sale) desc;

----Task 2
select s.store_name,tf.total_sale,rownum as "Rank"
from store s,transactions_fact tf
where s.store_id=tf.store_id;
--------------------------

