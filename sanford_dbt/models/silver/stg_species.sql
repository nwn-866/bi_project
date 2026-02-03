{{ config(materialized='view') }}

with species_transfromed as (
    select distinct
        species,
        initcap(species) as species_final
    from {{ ref('stg_aquaculture_export') }}

)
select
    species,
    species_final
from species_transfromed