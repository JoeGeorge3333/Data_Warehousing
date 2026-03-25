{{
  config(
    materialized='table'
  )
}}

select
  policyid as policy_key,
  customerid,
  agentid,
  policytype,
  _fivetran_synced as created_at

from {{ source('insurance_landing', 'policies') }}
