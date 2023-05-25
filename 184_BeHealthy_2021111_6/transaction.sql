use behealthy;

start transaction;
update employee, (select eid, sum(net_amount) as employee_order
from supplier_order
group by eid) as employee_order(eid, val),
(select sum(net_amount)
from supplier_order) as tot_amount(val)
set salary=(1+(employee_order.val/tot_amount.val))*salary
where employee.eid=employee_order.eid;
commit;

start transaction;
select supplier_order.status, sum(net_amount)
from supplier_order
where datediff(now(), date) < 200
group by supplier_order.status;
commit;