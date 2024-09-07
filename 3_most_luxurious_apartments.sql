/*
3. Which are the top 3 most luxurios neighbourhoods in Victoria in different suburbs? 
Luxurious neighborhoods can be defined as suburbs which has the most no. of apartments
costing over $1000 per week.

*/

select * from realestat_flatten where rent is not null limit 20;

select rent from realestat_flatten limit 20;


-- Solution 1: 
select suburb
	, count(*) as cnt
	from realestat_flatten where 
	state in ('Vic')
	and propertytype='apartment'
	and rent is not null
	and rent > 700
	group by suburb
	order by cnt desc limit 3;



	
-- Solution 2

select suburb
	, count(1)
	, rank() over(order by suburb desc ) as rn
	from realestat_flatten where 
	state in ('Vic')
	and propertytype='apartment'
	and rent is not null
	and rent > 1000
	group by suburb

with cte as
	(
	select suburb,
	count(*),
	rank() over(order by count(*) desc) as rnk
	from realestat_flatten where 
	state in ('Vic')
	and propertytype='apartment'
	and rent is not null
	and rent > 1000
	group by suburb
	)
	select *
	from cte
	where rnk <= 3;



