{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['species']) }} as species_id,
    species,
    species_final
from {{ ref('stg_species') }}