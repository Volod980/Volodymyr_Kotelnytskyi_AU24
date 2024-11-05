with last_store as ( select r.staff_id,
		            inv.store_id,
		            MAX(pm.payment_date) as last_payment_date
		            from rental r
			    left join payment pm 
			    on pm.rental_id = r.rental_id
			    left join public.inventory inv 
			    on inv.inventory_id = r.inventory_id
			    group by r.staff_id, inv.store_id),
latest_store_where_staff_worked as (select distinct  on (ls.staff_id) 
						        ls.staff_id,
						        ls.store_id
						    from last_store ls
						    order by ls.staff_id, ls.last_payment_date desc ),
amount as (select r.staff_id,
		    sum(pm.amount) as total_amount
		    from rental r
		    inner join payment pm 
		    on pm.rental_id = r.rental_id
		    left join public.inventory inv 
		    on inv.inventory_id = r.inventory_id
		    where to_char(pm.payment_date,'dd.mm.yyyy') between '01.01.2017' and '31.12.2017'
		    group by r.staff_id)

select lsp.staff_id,
       lsp.store_id,
       am.total_amount
from latest_store_where_staff_worked lsp
left join amount am on lsp.staff_id = am.staff_id
where am.total_amount >= (
    select min(total_amount)
    from (
        select distinct total_amount
        from amount
        order by total_amount desc
        LIMIT 3) as amn)
order by am.total_amount desc; 
