{{
    config(
        materialized='view',
        schema='dw_ecoessentials'
    )
}}

with source_data as (
    select
        order_id,
        customer_id,
        order_timestamp,
        _fivetran_synced
    from {{ source('postgres_raw', 'orders') }}
    where _fivetran_deleted = false
),

cleaned_data as (
    select
        order_id,
        customer_id,
        order_timestamp as order_date,
        cast(order_timestamp as date) as order_date_only,
        _fivetran_synced as synced_at
    from source_data
)

select * from cleaned_data
