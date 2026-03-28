{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH customers AS (
    SELECT * FROM {{ source('ecoessentials_landing', 'customer') }}
),

marketing_emails AS (
    SELECT DISTINCT
        NULLIF(customerid, 'NULL') AS customerid,
        subscriberfirstname,
        subscriberid,
        subscriberlastname,
        subscriberemail
    FROM {{ source('ecoessentials_landing_emails', 'marketingemails') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'COALESCE(c.customer_email, m.subscriberemail)',
        'COALESCE(c.customer_first_name, m.subscriberfirstname)',
        'COALESCE(c.customer_last_name, m.subscriberlastname)'
    ]) }} AS cust_key,
    COALESCE(c.customer_id, TRY_CAST(m.customerid AS NUMBER)) AS customer_id,
    COALESCE(c.customer_first_name, m.subscriberfirstname) AS customer_firstname,
    COALESCE(c.customer_last_name, m.subscriberlastname) AS customer_lastname,
    COALESCE(c.customer_email, m.subscriberemail) AS customer_email,
    c.customer_address,
    c.customer_city,
    c.customer_state,
    c.customer_zip,
    c.customer_country,
    CASE
        WHEN m.subscriberid IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS is_subscriber
FROM customers c
FULL OUTER JOIN marketing_emails m
    ON c.customer_id = m.customerid
    