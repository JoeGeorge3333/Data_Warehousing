{{ config(materialized='table') }}

with orders as (

    select *
    from {{ source('oliver_src', 'orders') }}

),

orderline as (

    select *
    from {{ source('oliver_src', 'orderline') }}

)

select
    o.customer_id as cust_key,
    to_number(to_char(cast(o.order_date as date), 'YYYYMMDD')) as date_key,
    o.store_id as store_key,
    ol.product_id as product_key,
    o.employee_id as employee_key,
    ol.quantity,
    ol.quantity * ol.unit_price as dollars_sold,
    ol.unit_price
from orderline ol
join orders o
    on ol.order_id = o.order_id