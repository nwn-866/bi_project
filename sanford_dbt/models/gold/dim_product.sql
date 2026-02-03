{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['product']) }} as product_id,
    product,
    product_final,
    product_cat
from {{ ref('stg_product') }}