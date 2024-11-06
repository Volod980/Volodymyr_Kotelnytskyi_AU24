-- PART 1, task 2
-- First variant
select concat(ad.address,' ',ad.address2) as address,
       sum(amount) as revenue from store s 
inner join  inventory i   on i.store_id  = s.store_id 
inner join  rental r  on r.inventory_id = i.inventory_id 
inner join payment  p  on p.rental_id = r.rental_id
inner join  address ad on ad.address_id  = s.address_id 
where  to_char(payment_date,'dd.mm.yyyy')  >= '01.03.2017' 
group by concat(ad.address,' ',ad.address2),
         s.store_id;
         
 -- Second variant       
 with store_with_address as (select s.store_id,
                                    s.address_id,
                                    concat(ad.address,' ',ad.address2) as address from store s 
                             inner join address ad on ad.address_id  = s.address_id)
                  							   
			                select s.address,
			                       sum(amount)  from store_with_address s
			                inner join (select store_id,
			                                  inventory_id from inventory )i   on i.store_id  = s.store_id 
							inner join (select inventory_id,
			                                   rental_id from rental) r  on r.inventory_id = i.inventory_id 
							inner join (select rental_id, 
							                  payment_date,
							                  amount  from payment where to_char(payment_date,'dd.mm.yyyy') >= '01.03.2017' ) p 
							on p.rental_id = r.rental_id
						    group by address;  -- I will use this variant because this variant is more optimized 
                                               --and  execution time is smaller then in other scripts
			                  
			                  
			                  
			                  