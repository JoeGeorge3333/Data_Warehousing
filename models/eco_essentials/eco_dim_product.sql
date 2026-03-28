{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH products AS (
    SELECT * 
    FROM {{ source('ecoessentials_landing', 'product') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['product_id', 'product_name']) }} AS product_key,
    product_id,
    product_type,
    product_name
FROM products

