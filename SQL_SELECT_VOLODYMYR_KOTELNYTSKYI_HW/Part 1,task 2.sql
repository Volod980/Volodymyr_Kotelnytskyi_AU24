-- PART 1, task 2
-- First variant
select concat(ad.address,' ',ad.address2) as address,
       sum(amount) as revenue from store s 
left join (select store_id,
                  inventory_id from inventory )i   on i.store_id  = s.store_id 
left join (select inventory_id,
                  rental_id from rental) r  on r.inventory_id = i.inventory_id 
left join (select rental_id, 
                  payment_date,
                  amount  from payment ) p  on p.rental_id = r.rental_id
left join (select address_id,
                  address,
                  address2 from address) ad on ad.address_id  = s.address_id 
where payment_date  >= '01.03.2017' 
group by concat(ad.address,' ',ad.address2),
         s.store_id;
         
 -- Second variant       
 with store_with_address as (select s.store_id,
                                    s.address_id,
                                    concat(ad.address,' ',ad.address2) as address from store s 
                             left join (select address_id,
                                               address,
                  							   address2 from address) ad on ad.address_id  = s.address_id)
                  							   
			                select s.address,
			                       sum(amount)  from store_with_address s
			                left join (select store_id,
			                                  inventory_id from inventory )i   on i.store_id  = s.store_id 
							left join (select inventory_id,
			                                   rental_id from rental) r  on r.inventory_id = i.inventory_id 
							inner join (select rental_id, 
							                  payment_date,
							                  amount  from payment where payment_date  >= '01.03.2017' ) p 
							on p.rental_id = r.rental_id
						    group by address;  -- I will use this variant because this variant is more optimized 
                                               --and  execution time is smaller then in other scripts
			                  
			                  
			                  
			                  