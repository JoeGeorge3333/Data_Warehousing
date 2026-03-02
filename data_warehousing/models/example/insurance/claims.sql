{{ config(materialized="table", schema="dw_insurance") }}


select
    c.firstname as customer_first_name,
    c.lastname as customer_last_name,
    d.date_day,
    p.policyid,
    a.firstname as agent_first_name,
    a.lastname as agent_last_name,
    f.claimamount
from {{ ref("fact_claim") }} f

left join {{ ref("dim_customer") }} c on f.customer_key = c.customer_key

left join {{ ref("dim_agent") }} a on f.agent_key = a.agent_key

left join {{ ref("dim_policy") }} p on f.policy_key = p.policy_key

left join {{ ref("dim_date") }} d on f.date_key = d.date_key
