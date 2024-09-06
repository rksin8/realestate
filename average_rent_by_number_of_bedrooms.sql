/*
1. What is the average rental price of 1 room, 2 room, 3 room apartments in the major suburbs in Australia?
Arrange the result such that avg rent for each type of room is shown in separate column
*/

select * from realestat_flatten;


select  avg(rent) from realestat_flatten;

select suburb, bedrooms
	, round(avg(rent),2) as avg_rent
	from realestat_flatten  where bedrooms in (1,2,3,4)
	group by suburb, bedrooms
	order by suburb, bedrooms;



--- transform table into wider format

with cte as
	(
select suburb, bedrooms
	, round(avg(rent),2) as avg_rent
	from realestat_flatten  where bedrooms in (1,2,3,4)
	group by suburb, bedrooms
	order by suburb, bedrooms
) select suburb
	, max(case when bedrooms='1' then avg_rent end) as "1 room"
	, max(case when bedrooms='2' then avg_rent end) as "2 room"
	, max(case when bedrooms='3' then avg_rent end) as "3 room"
	, max(case when bedrooms='4' then avg_rent end) as "4 room"
from cte
group by suburb;

