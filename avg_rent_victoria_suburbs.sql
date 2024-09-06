/*
1. What is the avg rent for apartments in Victoria different suburbs? 
Categories the result based on number of bedrooms?

*/

select * from realestat_flatten where rent is not null limit 20;

select rent from realestat_flatten limit 20;


select suburb
	, bedrooms
	, round(avg(rent),2) as avg_rent
	from realestat_flatten where 
	state in ('Vic')
	and propertytype='apartment'
	and rent is not null and rent > 100
	group by suburb, bedrooms
	order by avg_rent desc;

