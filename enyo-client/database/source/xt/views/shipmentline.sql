select xt.create_view('xt.shipmentline', $$

	select 
    shipitem_orderitem_id,
    shipitem_shiphead_id,
    SUM(shipitem_qty) as shipitem_qty,
    shipitem_shipped,
    shipitem_shipdate,
    max(shipitem_transdate) as shipitem_lasttransdate,
    shipitem_invoiced,
    shipitem_invcitem_id,
    shipitem_value,
		coitem_linenumber as linenumber,
		coitem_item_id as item_id,
		coitem_warehous_id as warehous_id,
		coitem_qty_uom_id as qty_uom_id,
		coitem_qty_invuomratio as qty_invuomratio,
		coitem_scheddate as scheddate,
		coitem_qtyord as qtyord,
		coitem_qtyshipped as qtyshipped
	from shipitem, shiphead, xt.coiteminfo 	
	where ((shiphead_order_type='SO')
		and (shipitem_shiphead_id = shiphead_id)
		and (coitem_id = shipitem_orderitem_id))
	group by shipitem_orderitem_id, coitem_item_id, coitem_linenumber, coitem_itemsite_id, shipitem_shiphead_id, shipitem_shipped, shipitem_shipdate, shipitem_invoiced, shipitem_invcitem_id, shipitem_value, coitem_warehous_id, coitem_qty_uom_id, coitem_qty_invuomratio, coitem_scheddate, coitem_qtyord, coitem_qtyshipped; 

$$, false);

-- remove old trigger if any
drop trigger if exists shipmentline_did_change on xt.shipmentline;

-- create trigger
create trigger shipmentline_did_change instead of update on xt.shipmentline for each row execute procedure xt.shipmentline_did_change();


