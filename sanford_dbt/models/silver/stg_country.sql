{{ config(materialized='view') }}

with stg_country as (

    select distinct
        country
    from {{ ref('stg_aquaculture_export') }}

),

stg_country_normalised as (
    select
        country,
        case
            -- Common ISO / long-form normalisation
            when country in ('UNITED STATES OF AMERICA') then 'UNITED STATES'
            when country in ('UNITED KINGDOM') then 'UNITED KINGDOM'
            when country in ('KOREA, REPUBLIC OF') then 'SOUTH KOREA'
            when country in ('VIET NAM') then 'VIETNAM'
            when country in ('CHINA, PEOPLE''S REPUBLIC OF') then 'CHINA'
            when country like 'HONG KONG%' then 'HONG KONG'
            -- Territories / special cases
            when country = 'SAMOA, AMERICAN' then 'AMERICAN SAMOA'
            when country = 'NORTHERN MARIANA ISLANDS' then 'NORTHERN MARIANA ISLANDS'
            when country = 'MICRONESIA, FEDERATED STATES OF' then 'MICRONESIA'
            -- Default: already clean
            else country
        end as country_final
    from stg_country
)

select
    country,
    country_final
from stg_country_normalised
