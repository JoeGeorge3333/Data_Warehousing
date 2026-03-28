{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH campaigns AS (
    SELECT * FROM {{ source('ecoessentials_landing', 'promotional_campaign') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['campaign_id', 'campaign_name']) }} AS campaign_key,
    campaign_id,
    campaign_name,
    campaign_discount
FROM campaigns 