{{ config(
    materialized = 'table',
    schema = 'dw_insurance'
) }}

SELECT
    cu.customer_key,
    a.agent_key,
    d.date_key,
    s.issue_type
FROM {{ ref('stg_customer_service_interactions') }} s
INNER JOIN {{ ref('dim_customer') }} cu ON s.customer_id = cu.customerid
INNER JOIN {{ ref('dim_agent') }} a ON s.agent_id = a.agentid
INNER JOIN {{ ref('dim_date') }} d ON d.date_day = s.interaction_date
