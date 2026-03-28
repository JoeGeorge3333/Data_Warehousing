{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH email_timestamps AS (
    SELECT DISTINCT eventtimestamp
    FROM {{ source('ecoessentials_landing_emails', 'marketingemails') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['eventtimestamp']) }} AS email_timestamp_key,
    eventtimestamp AS event_timestamp
FROM email_timestamps
