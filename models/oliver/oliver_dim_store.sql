{{ config(materialized='table') }}

select
    store_id as store_key,
    store_id,
    store_name,
    street,
    city,
    state
from {{ source('oliver_src', 'store') }}