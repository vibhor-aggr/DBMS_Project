use behealthy;

drop trigger med_stock;
drop trigger refund_order;

delimiter //
create trigger med_stock before insert on invoice_details
for each row
begin
if ((select quantity
from medicine_inventory
where medicine_inventory.mid=new.mid and medicine_inventory.lot_number>new.lot_number and medicine_inventory.quantity>=new.quantity) is not null) then
update medicine_inventory
set sold_quantity= sold_quantity + new.quantity
where medicine_inventory.mid=new.mid and medicine_inventory.lot_number=new.lot_number;
update invoice
set net_amount= net_amount + new.amount
where invoice.bill_id=new.bill_id;
else
set new.quantity=0 and new.amount=0;
end if;
end //


delimiter //
create trigger refund_order before delete on invoice
for each row
begin
update medicine_inventory,
(select mid, lot_number, quantity
from invoice_details
where invoice_details.bill_id=old.bill_id) as bill_items
set sold_quantity= sold_quantity - bill_items.quantity
where medicine_inventory.mid=bill_items.mid and medicine_inventory.lot_number=bill_items.lot_number;
delete from invoice_details
where invoice_details.bill_id=old.bill_id;
end //