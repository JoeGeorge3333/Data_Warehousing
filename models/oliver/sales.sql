{{ config(materialized='table') }}

select
    fs.cust_key,
    c.customer_id,
    c.first_name as customer_first_name,
    c.last_name as customer_last_name,
    c.email as customer_email,
    c.phone_number as customer_phone_number,
    c.state as customer_state,

    fs.date_key,
    d.date_id,
    d.dayofweek,
    d.month,
    d.quarter,
    d.year,

    fs.store_key,
    s.store_id,
    s.store_name,
    s.street,
    s.city,
    s.state as store_state,

    fs.product_key,
    p.product_id,
    p.product_name,
    p.description,

    fs.employee_key,
    e.employee_id,
    e.first_name as employee_first_name,
    e.last_name as employee_last_name,
    e.email as employee_email,
    e.phone_number as employee_phone_number,
    e.hire_date,
    e.position,

    fs.quantity,
    fs.dollars_sold,
    fs.unit_price

from {{ ref('fact_sales') }} fs
left join {{ ref('oliver_dim_customer') }} c
    on fs.cust_key = c.cust_key
left join {{ ref('oliver_dim_date') }} d
    on fs.date_key = d.date_key
left join {{ ref('oliver_dim_store') }} s
    on fs.store_key = s.store_key
left join {{ ref('oliver_dim_product') }} p
    on fs.product_key = p.product_key
left join {{ ref('oliver_dim_employee') }} e
    on fs.employee_key = e.employee_key