{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH events AS (
    SELECT DISTINCT eventtype
    FROM {{ source('ecoessentials_landing_emails', 'marketingemails') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['eventtype']) }} AS event_key,
    eventtype AS event_type
FROM events

