{{
    config(
        materialized='view',
        schema='dw_ecoessentials'
    )
}}

with source_data as (
    select
        customer_id,
        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_address,
        customer_city,
        customer_state,
        customer_zip,
        customer_country,
        _fivetran_synced
    from {{ source('postgres_raw', 'customers') }}
    where _fivetran_deleted = false
),

cleaned_data as (
    select
        customer_id,
        trim(customer_first_name) as first_name,
        trim(customer_last_name) as last_name,
        lower(trim(customer_email)) as email,
        trim(customer_phone) as phone,
        trim(customer_address) as address,
        trim(customer_city) as city,
        upper(trim(customer_state)) as state,
        trim(customer_zip) as zip,
        trim(customer_country) as country,
        _fivetran_synced as synced_at
    from source_data
)

select * from cleaned_data
