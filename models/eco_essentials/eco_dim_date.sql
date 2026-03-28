{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH date_spine AS (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2020-01-01' as date)",
        end_date="cast('2030-12-31' as date)"
    ) }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['date_day']) }} AS date_key,
    date_day AS date,
    EXTRACT(day FROM date_day) AS day,
    EXTRACT(month FROM date_day) AS month,
    EXTRACT(year FROM date_day) AS year
FROM date_spine
