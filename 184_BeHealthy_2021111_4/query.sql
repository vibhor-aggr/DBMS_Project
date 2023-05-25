use behealthy;

# Q1. Which medicine is sold the most in last 30 days along with its sold quantity?
with max_med(val) as
(select max(tot_qty)
from( select mid, sum(quantity)
from invoice_details natural join invoice
where datediff(now(), date) < 30
group by mid
) as med(mid, tot_qty))
select mid, name, tot_qty
from (select mid, name, sum(quantity)
from invoice_details natural join medicine_details natural join invoice
where datediff(now(), date) < 30
group by mid
) as med(mid, name, tot_qty), max_med
where med.tot_qty=max_med.val;

# Q2. Which all medicines are due for expiry in next 180 days?
select mid, lot_number, name, expiry_date 
from medicine_inventory natural join medicine_details
where datediff(expiry_date, now()) <= 360
order by expiry_date, mid, lot_number;

# Q3. How much bill amount is paid vs. unpaid in last one month?
select payment_status, sum(net_amount)
from invoice
#where datediff(now(), date) < 30
group by payment_status;

# Q4. Which all medicines are ordered to supplier sorted based on their quantity ordered?
select mid, name, sum(quantity) as tot_qty
from supplier_order_details natural join medicine_details
group by mid
order by tot_qty desc;

# Q5. Which all medicines have been ordered by customer with id ‘184’ in last one month along with the quantity ordered?
select mid, sum(quantity) as monthly_order
from invoice_details
where bill_id=(
select bill_id
from invoice
where cid=184 and datediff(now(), date) <= 30 
)
group by mid
order by monthly_order desc;

# Q6. What is the net profit for last one month (net profit = net_order_value - net_cost)?
with net_order_value(val) as 
(select sum(net_amount)
from invoice
where datediff(now(), date) <= 30),
net_cost_value(val) as
(select sum(cost_price*invoice_details.quantity)
from invoice_details inner join medicine_inventory using (mid, lot_number)
where bill_id in (
select bill_id
from invoice
where datediff(now(), date) <= 30))
select net_order_value.val as net_order, net_cost_value.val as net_cost, net_order_value.val - net_cost_value.val as net_profit
from net_order_value, net_cost_value;

# Q7. Which all medicines are most frequently ordered in last one month along with the bills count in which they are ordered?
with most_freq(val) as
(select max(med_count)
from(
select mid, count(*)
from invoice_details
where bill_id in (
select bill_id 
from invoice 
where datediff(now(), date) <= 30)
group by mid
) as med_info(mid, med_count))
select med_info.mid, name, med_info.med_count as bill_count
from medicine_details, most_freq, (
select mid, count(*)
from invoice_details
where bill_id in (
select bill_id 
from invoice 
where datediff(now(), date) <= 30)
group by mid
) as med_info(mid, med_count)
where med_info.med_count=most_freq.val and medicine_details.mid=med_info.mid;

# Q8. How many customers have no orders from past one year?
select count(distinct cid)
from customer
where cid not in (select eid from employee) and cid not in (select cid from invoice where datediff(now(), date) <= 365);

# Q9. Which all medicines have inventory stock less than 10% of their original quantity?
select mid, name, (sum(quantity) - sum(sold_quantity))/sum(quantity) as stock_sale_ratio
from medicine_inventory natural join medicine_details
group by mid
having stock_sale_ratio < .1
order by stock_sale_ratio;

# Q10. Filter medicines based on their generic name and compute their original/sold quantity.
select generic_name, count(*) as variants, avg(net_qty) as net_qty, avg(net_sold) as net_sold
from medicine_details, (select mid, sum(quantity), sum(sold_quantity)
from medicine_inventory
group by mid) as med_info(mid, net_qty, net_sold)
where medicine_details.mid=med_info.mid
group by generic_name;

# Q11. Write a query to display prime and normal customers count who are not the employee of BeHealthy Pharmacy.
select count(*) num
from customer
where type in ('prime', 'normal') and cid not in(select eid as cid from employee);
                                                 
# Q12. Who is oldest customer associated with BeHealthy Pharmacy and since when he/she is associated?
with oldest(val) as
(select min(created)
from customer)
select concat(customer.fname, ' ', customer.lname) as 'name', created
from customer, oldest
where customer.created=oldest.val;

# Q13. Which all bills are unpaid in last 100 days sorted based on bill date?
select payment_status, net_amount, date
from invoice
where datediff(now(), date) <= 100 and payment_status='unpaid'
order by date;

# Q14. Which all medicines in stock have already expired?
select mid, lot_number, name, expiry_date
from medicine_inventory natural join medicine_details
where datediff(expiry_date, now()) <= 0;

# Q15. Which all supplier orders are still pending?
select soid
from supplier_order
where status='pending';

# Q16. How many customers have placed order in last one month?
select count(distinct cid)
from invoice
where datediff(now(), date) <= 30;

# Q17. What is the average order value for last one month?
select avg(net_amount) as average_order_value
from invoice
where datediff(now(), date) <= 30;

