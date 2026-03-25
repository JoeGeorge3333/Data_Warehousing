{{ config(
    materialized = 'view',
    schema = 'dw_insurance'
) }}

SELECT
    customer_id,
    agent_id,
    CAST(interaction_date AS DATE) AS interaction_date,
    issue_type
FROM {{ ref('customer_service_interactions') }}
