/*
1. What are the most expensive apartments in major state of Australia? 
Display the ad titile along with the city, suburb, cost, size.

*/

select * from realestat_flatten where rent is not null limit 20;

select rent from realestat_flatten limit 20;


select state,
	max(rent) as max_rent
	from realestat_flatten where 
	state in ('Vic','NSW','WA')
	and propertytype='apartment'
	and rent is not null and rent > 1000
	group by state
	order by max_rent desc;

-- final solution
with cte as 
	(
	select state,
	max(rent) as max_rent
	from realestat_flatten where 
	state in ('Vic','NSW','WA')
	and propertytype='apartment'
	and rent is not null and rent > 1000
	group by state
	)
	select x.title, x.state, x.suburb, x.rent
	from realestat_flatten x
	join cte on cte.state = x.state and cte.max_rent = x.rent
	where  propertytype='apartment'
	order by x.state, x.rent;










