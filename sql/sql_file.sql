CREATE SCHEMA  sanford_audit;
CREATE SCHEMA  aquaculture_bronze;
CREATE SCHEMA  aquaculture_silver;
CREATE SCHEMA  aquaculture_gold;

-- sanford_audit.batch_details definition

-- Drop table

-- DROP TABLE sanford_audit.batch_details;

CREATE TABLE sanford_audit.batch_details (
	batch_id int8  NOT NULL,
	file_name text NOT NULL,
	fiscal_year text NOT NULL,
	loaded_start_time timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	loaded_end_time timestamp NULL,
	status text DEFAULT 'PENDING'::text NOT NULL,
	CONSTRAINT batch_details_pkey PRIMARY KEY (batch_id)
);


-- aquaculture_bronze.staging definition

-- Drop table

-- DROP TABLE aquaculture_bronze.staging;

CREATE TABLE aquaculture_bronze.staging (
	species text NULL,
	product text NULL,
	country text NULL,
	volume numeric NULL,
	value numeric NULL,
	batch_id int8 NULL
);



--aquaculture_silver and gold schema tables generated through DBT


-- check data 


select distinct species , count(1) from aquaculture_bronze.staging group by species ;
--3 unique species selected and they were transformed through dbt

select distinct product  , count(1) from aquaculture_bronze.staging group by product ;
-- 22 unique products selected and they were transformed to developed product category for further insights through dbt

select distinct country   , count(1) from aquaculture_bronze.staging group by country ;
-- 57 unique countries selected and they were standerdised for further insights through dbt ,
-- manual checkes been done due to limited attributers



