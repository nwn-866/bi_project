{{ config(materialized='view') }}

with stg_aquaculture_export as (

    select
        lower(trim(species)) as species,
        lower(trim(product)) as product,
        upper(trim(country)) as country,
        s.volume::numeric    as volume_kg,
        s.value::numeric     as value_nzd,
        s.batch_id,
        b.fiscal_year,
        b.loaded_end_time
    from aquaculture_bronze.staging s
    inner join sanford_audit.batch_details b
      on s.batch_id = b.batch_id
    where b.status = 'LOADED'
)

select
    *
    -- ,
    -- case 
    --     when volume_kg > 0 then value_nzd / volume_kg
    --     else null
    -- end as price_per_kg
from stg_aquaculture_export