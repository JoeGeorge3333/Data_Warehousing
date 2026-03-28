{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH emails AS (
    SELECT DISTINCT subscriberemail
    FROM {{ source('ecoessentials_landing_emails', 'marketingemails') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['subscriberemail']) }} AS email_key,
    subscriberemail AS email_address
FROM emails

