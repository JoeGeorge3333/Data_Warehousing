{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH marketing_emails AS (
    SELECT * FROM {{ source('ecoessentials_landing_emails', 'marketingemails') }}
),

dim_campaign AS (
    SELECT * FROM {{ ref('eco_dim_campaign') }}
),

dim_email_timestamp AS (
    SELECT * FROM {{ ref('eco_dim_email_timestamp') }}
),

dim_customer AS (
    SELECT * FROM {{ ref('eco_dim_customer') }}
),

dim_date AS (
    SELECT * FROM {{ ref('eco_dim_date') }}
),

dim_event AS (
    SELECT * FROM {{ ref('eco_dim_event') }}
),

dim_email AS (
    SELECT * FROM {{ ref('eco_dim_email') }}
)

SELECT
    dc.campaign_key,
    det.email_timestamp_key,
    dcust.cust_key,
    dd.date_key,
    de.event_key,
    dem.email_key
FROM marketing_emails me
JOIN dim_campaign dc
    ON me.campaignid = dc.campaign_id
JOIN dim_email_timestamp det
    ON me.eventtimestamp = det.event_timestamp
JOIN dim_customer dcust
    ON me.subscriberemail = dcust.customer_email
JOIN dim_date dd
    ON CAST(me.eventtimestamp AS DATE) = dd.date
JOIN dim_event de
    ON me.eventtype = de.event_type
JOIN dim_email dem
    ON me.subscriberemail = dem.email_address