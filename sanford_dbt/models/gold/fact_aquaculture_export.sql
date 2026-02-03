{{ config(materialized='table') }}


with aquaculture_export as (
select *
--    -- {{ dbt_utils.generate_surrogate_key(['c.country','p.product','sp.species','d.fiscal_year']) }} as export_id,
--     c.country_id,
--     -- p.product_id,
--     -- sp.species_id,
--     -- d.fiscal_year_id,   
--     -- d.fiscal_year,
--     -- c.country,
--     -- sp.species,
--     -- p.product_final as product,
--     -- p.product_cat as product_category,
--     -- sp.species_final as species_final,
--     -- sum(s.volume_kg) as total_volume_kg,
--     -- sum(s.value_nzd) as total_value_nzd,
--     -- --avg(s.price_per_kg) as avg_price_per_kg,
--     case
--     when sum(volume_kg) > 0 then sum(value_nzd) / sum(volume_kg)
--     else null
--     end as avg_price_per_kg
from {{ ref('stg_aquaculture_export') }} 
),
-- join to dimensions to get surrogate keys
fact_with_id as (

    select
        y.fiscal_year_id,
        c.country_id,
        p.product_id,
        s.species_id,
        -- keep readable fields (optional but very useful in Power BI / debugging)
        e.fiscal_year,
        e.country,
        c.country_final ,
        p.product,
        p.product_final,
        p.product_cat    as product_category,
        s.species,
        s.species_final,
        e.volume_kg,
        e.value_nzd
        -- ,
        -- e.price_per_kg
    from aquaculture_export e
    -- fiscal year dim (join using FY label e.g. FY23)
    join {{ ref('dim_date') }} y
      on e.fiscal_year = y.fiscal_year
    -- country dim (join using raw country)
    join {{ ref('dim_country') }} c
      on e.country = c.country
    -- product dim (join using raw product)
    join {{ ref('dim_product') }} p
      on e.product = p.product
    -- species dim (join using raw species)
    join {{ ref('dim_species') }} s
      on e.species = s.species
),
fact as (

    select
        -- stable fact primary key (hash of all dimension keys at this grain)
        {{ dbt_utils.generate_surrogate_key([
            'fiscal_year_id',
            'country_id',
            'product_id',
            'species_id'
        ]) }} as export_id,
        fiscal_year_id,
        country_id,
        product_id,
        species_id,
        fiscal_year,
        country,
        country_final ,
        product,
        product_final,
        product_category,
        species,
        species_final,
        sum(volume_kg) as total_volume_kg,
        sum(value_nzd) as total_value_nzd,
        case
            when sum(volume_kg) > 0 then sum(value_nzd) / sum(volume_kg)
            else null
        end as avg_price_per_kg
    from fact_with_id
    group by
        fiscal_year_id,
        country_id,
        product_id,
        species_id,
        fiscal_year,
        country,
        country_final ,
        product,
        product_final,
        product_category,
        species,
        species_final
)
select * from fact