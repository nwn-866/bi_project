{{ config(materialized='view') }}

with stg_product as (
    select distinct
        product
    from {{ ref('stg_aquaculture_export') }}
),

product_transfromed as (
    select
        product,
        -- 1) normalise common wording / ordering
        case
            when product in ('whole chilled', 'chilled whole') then 'Chilled Whole'
            when product in ('processed') then 'Processed'
            when product in ('processed packed') then 'Processed Packed'
            when product in ('processed powder') then 'Processed Powder'
            when product in ('processed cans or jars', 'processed cans or jars, whole') then 'Processed Cans or Jars'
            when product in ('meat chilled/fresh') then 'Chilled Meat'
            when product in ('frozen meat') then 'Frozen Meat'
            when product in ('chilled fillets') then 'Chilled Fillets'
            when product in ('frozen fillets') then 'Frozen Fillets'
            when product in ('frozen whole') then 'Frozen Whole'
            when product in ('frozen') then 'Frozen (unknown)'
            when product in ('frozen half shell') then 'Frozen Half Shell'
            when product in ('live') then 'Live'
            when product in ('crumbed, battered') then 'Crumbed or Battered'
            when product in ('smoked') then 'smoked'
            when product in ('dried, salted or in brine', 'smoked, dried, salted or in brine') then 'Dried, Salted or Brined'
            when product in ('mussel oil') then 'Mussel Oil'
            when product in ('salmonidae') then 'Salmonidae'
            else initcap(product)
        end as product_final
    from stg_product
),
product_catagorised as (
    select
        product,
        product_final,
        -- 2) high-level grouping for analysis
        case
            when product like '%chilled%' then 'Chilled'
            when product like '%frozen%' then 'Frozen'
            when product like '%processed%' then 'Processed'
            when product like '%live%' then 'Live Product'
            when (product like '%smoke%' or product like '%dried%' or product like '%salt%'or product like '%brined%') then 'Preserved'
            else 'Other'
        end as product_cat
    from product_transfromed
)

select
    product,
    product_final,
    product_cat
from product_catagorised
