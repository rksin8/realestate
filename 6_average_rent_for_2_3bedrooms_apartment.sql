/*
6. What is the avg rent for apartments 2-3 bedrooms in major state of Australia?

*/

select * from realestat_flatten where rent is not null limit 20;

select rent from realestat_flatten limit 20;


select state,
	avg(rent) as avg_rent
	from realestat_flatten where 
	state in ('Vic','NSW','WA')
	and propertytype='apartment'
	and rent is not null and rent > 100
	and bedrooms between 2 and 3
	group by state
	order by avg_rent desc;

