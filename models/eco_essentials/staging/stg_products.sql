{{
    config(
        materialized='view',
        schema='dw_ecoessentials'
    )
}}

with source_data as (
    select
        product_id,
        product_type,
        product_name,
        price,
        _fivetran_synced
    from {{ source('postgres_raw', 'products') }}
    where _fivetran_deleted = false
),

cleaned_data as (
    select
        product_id,
        trim(lower(product_type)) as product_type,
        trim(product_name) as product_name,
        round(price, 2) as product_price,
        _fivetran_synced as synced_at
    from source_data
)

select * from cleaned_data
