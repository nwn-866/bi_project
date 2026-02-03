{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['country']) }} as country_id,
    country,
    country_final
from {{ ref('stg_country')}}