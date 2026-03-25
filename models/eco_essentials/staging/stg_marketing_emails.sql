{{
    config(
        materialized='view',
        schema='dw_ecoessentials'
    )
}}

with source_data as (
    select
        emaileventid,
        emailid,
        emailname,
        campaignid,
        campaignname,
        customerid,
        subscriberid,
        subscriberemail,
        subscriberfirstname,
        subscriberlastname,
        sendtimestamp,
        eventtype,
        eventtimestamp,
        _fivetran_synced
    from {{ source('s3_raw', 'marketing_emails') }}
),

cleaned_data as (
    select
        emaileventid as email_event_id,
        emailid as email_id,
        trim(emailname) as email_name,
        campaignid as campaign_id,
        trim(campaignname) as campaign_name,
        customerid as customer_id,
        subscriberid as subscriber_id,
        lower(trim(subscriberemail)) as subscriber_email,
        trim(subscriberfirstname) as subscriber_first_name,
        trim(subscriberlastname) as subscriber_last_name,
        sendtimestamp as email_sent_at,
        upper(trim(eventtype)) as event_type,
        eventtimestamp as event_occurred_at,
        _fivetran_synced as synced_at
    from source_data
)

select * from cleaned_data
