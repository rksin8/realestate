/*
1. What size of an apartment can I expect with a weekly rent of 700-850 AUD in different suburbs of melbourne?
*/

select * from realestat_flatten;


select state, bedrooms
	,count(bedrooms) 
	from realestat_flatten where state='Vic'
	and propertytype='apartment'
	and rent between 700 and 800 --and surface_area between a and b
	group by state, bedrooms
	order by count(1) desc;
