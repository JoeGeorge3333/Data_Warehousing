{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
)}}

select
    certification_completion_id,
    employee_id,
    first_name,
    last_name,
    email,
    PARSE_JSON(certification_json):certification_name::varchar      as certification_name,
    PARSE_JSON(certification_json):certification_cost::float        as certification_cost,
    PARSE_JSON(certification_json):certification_awarded_date::date as certification_awarded_date,
    _fivetran_synced

from {{ source('oliver_src', 'employee_certifications') }}
