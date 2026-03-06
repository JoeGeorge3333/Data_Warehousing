
{{ config(materialized='table') }}

select
    employee_id as employee_key,
    employee_id,
    first_name,
    last_name,
    email,
    phone_number,
    hire_date,
    position
from {{ source('oliver_src', 'employee') }}