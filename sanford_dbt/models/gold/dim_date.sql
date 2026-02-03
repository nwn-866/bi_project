{{ config(materialized='table') }}

with years as (

    select generate_series(2020, 2030) as calendar_year

),

final as (

    select
        calendar_year,

        calendar_year + 1              as fiscal_year_number,

        'FY' || right((calendar_year + 1)::text, 2)
                                   as fiscal_year

    from years
)

select
    {{ dbt_utils.generate_surrogate_key(['calendar_year']) }} as fiscal_year_id,
    calendar_year,
    fiscal_year_number,
    fiscal_year
from final
order by calendar_year
