{{ config(materialized='table') }}

select
    customer_id as cust_key,
    customer_id,
    first_name,
    last_name,
    email,
    phone_number,
    state
from {{ source('oliver_src', 'customer') }}