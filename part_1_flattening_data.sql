-- Part 1:  Scrape, load, flatten
-- Part 2: Tranform using python and google sheet
-- Part 3: Analyse, Clean, Build Reports


-- load data into temporary table
BEGIN;

CREATE TEMP TABLE target(data jsonb) on commit drop;
copy target  from 'C:/Users/Admin/Documents/Data Analyst Portfolio Projects/realestate/test_new.json' 
	csv quote e'\x01' delimiter e'\x02';


select * from target;



-- Check listing column
select  NULLIF(data->> 'listingId','')::int as listingId
	from target limit 5;

-- Check transform price column
select 
	NULLIF(data->> 'listingId','')::int as listingId
	, NULLIF(regexp_replace(data-> 'price' ->> 'display', '\D','','g'), '')::numeric as rent
	from target limit 5;


-- Flatten useful columns
select  NULLIF(data->> 'listingId','')::int as listingId
	, data ->> 'propertyType' as propertyType
	, NULLIF(data->> 'isRentChannel','')::boolean  as channelType
	, NULLIF(regexp_replace(data-> 'price' ->> 'display', '\D','','g'), '')::numeric as rent
	, NULLIF(data-> 'features' -> 'general' ->>'bedrooms','')::int as bedrooms  
	, NULLIF(data-> 'features' ->'general' ->> 'bathrooms' ,'')::int as bathrooms
	, NULLIF(data-> 'features' -> 'general' ->>'parkingSpaces' ,'')::int as parkingSpaces
	, data-> 'address' ->> 'streetAddress' as streetAddress
	, data-> 'address' ->> 'suburb' as suburb
	, data-> 'address' ->> 'state' as state
	, NULLIF(data-> 'address' ->>'postCode' ,'')::int as postCode
	from target limit 5;



-- create a new table of flatten data
create table if not exists realestat_flatten
as 
select  NULLIF(data->> 'listingId','')::int as listingId
	, data ->> 'propertyType' as propertyType
	, NULLIF(data->> 'isRentChannel','')::boolean  as channelType
	, NULLIF(regexp_replace(data-> 'price' ->> 'display', '\D','','g'), '')::numeric as rent
	, NULLIF(data-> 'features' -> 'general' ->>'bedrooms','')::int as bedrooms  
	, NULLIF(data-> 'features' ->'general' ->> 'bathrooms' ,'')::int as bathrooms
	, NULLIF(data-> 'features' -> 'general' ->>'parkingSpaces' ,'')::int as parkingSpaces
	, data-> 'address' ->> 'streetAddress' as streetAddress
	, data-> 'address' ->> 'suburb' as suburb
	, data-> 'address' ->> 'state' as state
	, NULLIF(data-> 'address' ->>'postCode' ,'')::int as postCode
	from target;

-- re-check flatten data
select count(1) from realestat_flatten;

select * from realestat_flatten;

-- Delete temporary table
COMMIT;
drop table target;