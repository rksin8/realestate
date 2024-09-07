-- Part 1:  Scrape, load, flatten
-- Part 2: Tranform using python and google sheet
-- Part 3: Analyse, Clean, Build Reports


-- load data into temporary table
BEGIN;

CREATE TEMP TABLE target(data jsonb) on commit drop;

copy target  from 'C:/Users/Admin/Documents/Data Analyst Portfolio Projects/realestate/test_new.json' 
	csv quote e'\x01' delimiter e'\x02';


select * from target;

select data->'_links'->'prettyUrl'->>'href' from target;


select data->'price' ->> 'display'  as rent
	from target;

select data->'price' ->> 'display'  as rent1
	, substring(regexp_replace(data->'price' ->> 'display',',','' ),'([0-9.]+)')::numeric  as rent 
	from target;

SELECT REGEXP_REPLACE('John Doe','(.*) (.*)','\2, \1'); 

select regexp_replace('123,56€',',','.' );
	
select  substring(regexp_replace('$1,380 per week',',','' ),'(\$[0-9.]+)');

select  data-> 'address' as address
	, data->> 'title' as title
	from target limit 5;


-- Check listing column
select  data-> 'address' ->> 'suburb' as suburb
	, data-> 'address' ->> 'state' as state
	from target;
-- Check listing column
select  NULLIF(data->> 'listingId','')::int as listingId
	from target limit 5;

-- Check transform price column
select 
	NULLIF(data->> 'listingId','')::int as listingId
	, NULLIF(regexp_replace(data-> 'price' ->> 'display', '\D','','g'), '')::numeric as rent
	from target;


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




drop table if exists realestat_flatten;

-- create a new table of flatten data
create table if not exists realestat_flatten
as 
select  NULLIF(data->> 'listingId','')::int as listingId
	, data ->> 'propertyType' as propertyType
	, NULLIF(data->> 'isRentChannel','')::boolean  as channelType
	, substring(regexp_replace(data->'price' ->> 'display',',','' ),'([0-9.]+)')::numeric as rent
	, NULLIF(data-> 'features' -> 'general' ->>'bedrooms','')::int as bedrooms  
	, NULLIF(data-> 'features' ->'general' ->> 'bathrooms' ,'')::int as bathrooms
	, NULLIF(data-> 'features' -> 'general' ->>'parkingSpaces' ,'')::int as parkingSpaces
	, data-> 'address' ->> 'streetAddress' as streetAddress
	, data-> 'address' ->> 'suburb' as suburb
	, data-> 'address' ->> 'state' as state
	, NULLIF(data-> 'address' ->>'postCode' ,'')::int as postCode
	, data->> 'title' as title
	, data->'_links'->'prettyUrl'->>'href' as url
	from target;


select * from realestat_flatten where 
	suburb like 'Sydney' 
	or suburb like 'Melbourne%'
	or suburb like 'Brisbane%'
	or suburb like 'Perth%'
	or suburb like 'Adelaide%';


-- re-check flatten data
select count(1) from realestat_flatten;

select * from realestat_flatten limit 5;

-- Delete temporary table
COMMIT;
drop table target;