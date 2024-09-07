/*
4. Identify the top 5 most affordable neighborhoods in Victoria State.

*/

select * from realestat_flatten where rent is not null limit 20;

select rent from realestat_flatten limit 20;

select rent from realestat_flatten
	order by rent asc;


-- Solution 1: 
select suburb, round(avg(rent),2) avg_price, count(1) as no_of_apartments
	, rank() over(order by round(avg(rent),2) ) as rnk
	from realestat_flatten where 
	state in ('Vic')
	and propertytype='apartment'
	and rent is not null
--	and rent > 700
	group by suburb
	order by rnk limit 5;



	
-- Solution 2

select suburb
	, count(1)
	, rank() over(order by suburb desc ) as rn
	from realestat_flatten where 
	state in ('Vic')
	and propertytype='apartment'
	and rent is not null
--	and rent > 100
	group by suburb

	

with cte as
	(
	select suburb, round(avg(rent),2) avg_price, count(1) as no_of_apartments
	, rank() over(order by round(avg(rent),2) ) as rnk
	from realestat_flatten where 
	state in ('Vic')
	and propertytype='apartment'
	and rent is not null
--	and rent > 100
	group by suburb
	)
	select *
	from cte
	where rnk <= 5;




