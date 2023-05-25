use behealthy;

select cid, mid, sum(quantity)
from invoice_details natural join invoice
group by cid, mid with rollup;

select sid, mid, sum(quantity)
from supplier_order_details natural join supplier_order
group by sid, mid with rollup;

select cid, mid, max(amount)
from invoice_details natural join invoice
group by cid, mid with rollup;

select eid, mid, sum(purchase_rate)
from supplier_order_details natural join supplier_order
group by eid, mid with rollup;

select bill_id, mid, sum(quantity)
from prescription_details natural join prescription
group by bill_id, mid with rollup;
