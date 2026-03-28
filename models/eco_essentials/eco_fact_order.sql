{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH order_lines AS (
    SELECT * FROM {{ source('ecoessentials_landing', 'order_line') }}
),

orders AS (
    SELECT * FROM {{ source('ecoessentials_landing', 'order') }}
),

products AS (
    SELECT * FROM {{ source('ecoessentials_landing', 'product') }}
),

dim_product AS (
    SELECT * FROM {{ ref('eco_dim_product') }}
),

dim_campaign AS (
    SELECT * FROM {{ ref('eco_dim_campaign') }}
),

dim_customer AS (
    SELECT * FROM {{ ref('eco_dim_customer') }}
),

dim_date AS (
    SELECT * FROM {{ ref('eco_dim_date') }}
)

SELECT
    dp.product_key,
    dc.campaign_key,
    dcust.cust_key,
    dd.date_key,
    ol.quantity,
    ol.discount,
    p.price,
    ol.price_after_discount AS final_price,
    o.order_id
FROM order_lines ol
JOIN orders o
    ON ol.order_id = o.order_id
JOIN products p
    ON ol.product_id = p.product_id
JOIN dim_product dp
    ON ol.product_id = dp.product_id
JOIN dim_campaign dc
    ON ol.campaign_id = dc.campaign_id
JOIN dim_customer dcust
    ON o.customer_id = dcust.customer_id
JOIN dim_date dd
    ON CAST(o.order_timestamp AS DATE) = dd.date