{{
    config(
        materialized='view',
        schema='dw_ecoessentials'
    )
}}

with source_data as (
    select
        campaign_id,
        campaign_name,
        campaign_discount,
        _fivetran_synced
    from {{ source('postgres_raw', 'campaigns') }}
    where _fivetran_deleted = false
),

cleaned_data as (
    select
        campaign_id,
        trim(campaign_name) as campaign_name,
        round(campaign_discount, 2) as campaign_discount_percentage,
        _fivetran_synced as synced_at
    from source_data
)

select * from cleaned_data
