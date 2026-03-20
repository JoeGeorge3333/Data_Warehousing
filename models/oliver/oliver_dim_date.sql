{{ config(materialized='table') }}

with distinct_dates as (

    select distinct cast(order_date as date) as date_id
    from {{ source('oliver_src', 'orders') }}

    union

    select distinct certification_awarded_date as date_id
    from {{ ref('stg_employee_certifications') }}

)

select
    to_number(to_char(date_id, 'YYYYMMDD')) as date_key,
    date_id,
    dayname(date_id) as dayofweek,
    month(date_id) as month,
    quarter(date_id) as quarter,
    year(date_id) as year
from distinct_dates
