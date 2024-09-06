/*
1. I want to buy an apartement within a range of 700 to 800,
display the suburbs in Melbourne where I can find such appartments
*/

select * from realestat_flatten;


select state
	, round(avg(rent),2) as avg_rent 
	from realestat_flatten where state='Vic'
	and propertytype='apartment'
	and rent between 700 and 800 --and surface_area between a and b
	group by state
	order by count(1) desc;
