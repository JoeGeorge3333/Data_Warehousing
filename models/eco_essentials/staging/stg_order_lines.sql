{{
    config(
        materialized='view',
        schema='dw_ecoessentials'
    )
}}

with source_data as (
    select
        order_line_id,
        order_id,
        product_id,
        campaign_id,
        quantity,
        discount,
        promotional_campaign,
        price_after_discount,
        _fivetran_synced
    from {{ source('postgres_raw', 'order_lines') }}
    where _fivetran_deleted = false
),

cleaned_data as (
    select
        order_line_id,
        order_id,
        product_id,
        campaign_id,
        quantity,
        round(discount, 2) as discount_percentage,
        promotional_campaign as is_promotional,
        round(price_after_discount, 2) as unit_price_after_discount,
        round(quantity * price_after_discount, 2) as line_total,
        _fivetran_synced as synced_at
    from source_data
)

select * from cleaned_data
