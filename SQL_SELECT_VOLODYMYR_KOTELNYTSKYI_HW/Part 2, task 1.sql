
--PART 2, task 1
select    ll.staff_id,
          store_id,
          amount 
          from (select * from ( select r.staff_id,
						                inv.store_id,
						                payment_date, 
						                row_number() over ( partition by r.staff_id order by pm.payment_date desc) rn 
						                from rental r
						          left join  payment pm
						          on pm.rental_id = r.rental_id
						          left join public.inventory inv 
						          on inv.inventory_id = r.inventory_id ) l 
				where rn = 1 ) ll -- this part of the script give us information about 
						           -- in which store manager  worked last time
				left join (select r.staff_id,
				                  sum(amount) as amount
						          from rental r
						   left join  payment pm
						   on pm.rental_id = r.rental_id
						   left join public.inventory inv 
						   on inv.inventory_id = r.inventory_id
						   where payment_date between '01.01.2017' and '31.12.2017' 
						   group by r.staff_id ) r   -- this part of the script give us information about how much revenue 
						                              -- a manager generated in the stores 
		 on r.staff_id = ll.staff_id 
		 order by amount desc
		 limit 3;

            
  
   