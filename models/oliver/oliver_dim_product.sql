{{ config(materialized='table') }}

select
    product_id as product_key,
    product_id,
    product_name,
    description
from {{ source('oliver_src', 'product') }}