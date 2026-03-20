{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
)}}

select
    e.employee_key,
    d.date_key,
    c.certification_name,
    c.certification_cost

from {{ ref('stg_employee_certifications') }} c

inner join {{ ref('oliver_dim_employee') }} e
    on c.employee_id = e.employee_id

inner join {{ ref('oliver_dim_date') }} d
    on d.date_id = c.certification_awarded_date

