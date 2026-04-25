# DATA 5360 — Dimensional Data Warehousing with dbt & Snowflake

**Author:** Eric Pesci  
**Program:** Information Systems, Utah State University  
**Course:** DATA 5360 — Data Warehousing  
**Tools:** dbt Cloud · Snowflake · SQL · YAML · FiveTran

---

## Project Overview

This repository contains my dbt project for DATA 5360, where I designed, built, and tested a dimensional data warehouse for EcoEssentials, a fictional e-commerce company with an integrated email marketing platform. The warehouse follows a star schema architecture and was built end-to-end using dbt on Snowflake: from FiveTran connectors through staging transformations to fully tested dimension and fact tables ready for analytics.

The project demonstrates core data engineering competencies, including dimensional modeling, surrogate key generation, data quality testing, ETL pipeline design, and analytics-ready warehouse delivery.

---

## Architecture

```
Source Systems (Snowflake raw schemas)
        │
        ▼
  dbt Sources (YAML-defined)
        │
        ▼
  Staging Layer (data cleansing, type casting, conditional logic)
        │
        ▼
  Dimension Tables (surrogate keys via dbt_utils)
        │
        ▼
  Fact Tables (foreign keys, measures, business logic)
```

All models are materialized as tables in Snowflake under the `dw_ecoessentials` schema using a custom `generate_schema_name` macro that writes to the exact schema name specified in each model's config rather than prepending the target schema.

---

## Business Context

EcoEssentials operates two interconnected data streams: an order management system that tracks customer purchases across products and promotional campaigns, and an email marketing platform that tracks subscriber engagement (opens, clicks). The warehouse brings these together into a single star schema so analysts can answer questions like:

- Which campaigns drive the most revenue?
- How does email engagement correlate with purchasing behavior?
- Which product categories perform best under specific promotions?
- What is the subscriber vs. non-subscriber breakdown across the customer base?

---

## Dimensional Model

### Dimension Tables

| Model | Description | Key Technique |
|---|---|---|
| `eco_dim_customer` | Customer demographics with a boolean `is_subscriber` field | `LEFT JOIN` + conditional expression against the marketing emails source to derive subscriber status |
| `eco_dim_product` | Product catalog (type, name) | Single-source dimension with composite surrogate key |
| `eco_dim_campaign` | Promotional campaigns and discount rates | Composite surrogate key from campaign_id + campaign_name |
| `eco_dim_date` | Complete calendar dimension covering 2020–2030 | Generated via `dbt_utils.date_spine`, independent of source data |
| `eco_dim_email` | Marketing email metadata | Surrogate key from email attributes |
| `eco_dim_email_timestamp` | Email send timestamps broken into date/time components | Timestamp decomposition for flexible time-based analysis |
| `eco_dim_event` | Email interaction event types (CLICK, SENT, OPEN) | Constrained via `accepted_values` test in schema YAML |

### Fact Tables

| Model | Description | Grain |
|---|---|---|
| `eco_fact_order` | Order line items with measures for quantity, discount, price, and final price | One row per order line, joining across customer, product, campaign, and date dimensions |
| `eco_fact_email_event` | Email interaction events linking subscribers to their engagement | One row per email event, joining across email, event, and timestamp dimensions |

---

## Testing & Data Quality

The schema file (`_schema_ecoessentials.yml`) defines automated data quality gates that run as part of every dbt pipeline execution:

- **Uniqueness tests** on all surrogate keys to prevent duplicate dimension records
- **Not-null tests** on primary and foreign keys to enforce completeness
- **Referential integrity tests** using dbt's `relationships` test on every fact table foreign key, validating that each key maps back to a valid dimension record
- **Accepted values tests** where business rules constrain a field (e.g., `event_type` is limited to CLICK, SENT, and OPEN)

---

## Project Structure

```
data-5360-dbt/
├── dbt_project.yml                        # Project config (Snowflake profile, packages)
├── packages.yml                           # dbt_utils, dbt_date dependencies
├── macros/
│   └── generate_schema_name.sql           # Custom macro for exact schema naming
└── models/
    └── ecoessentials/
        ├── _sources_ecoessentials.yml      # Source definitions (transactional DB, email platform)
        ├── _schema_ecoessentials.yml       # Model docs + test definitions
        ├── eco_dim_customer.sql
        ├── eco_dim_product.sql
        ├── eco_dim_campaign.sql
        ├── eco_dim_date.sql
        ├── eco_dim_email.sql
        ├── eco_dim_email_timestamp.sql
        ├── eco_dim_event.sql
        ├── eco_fact_order.sql
        └── eco_fact_email_event.sql
```

---

## Technical Highlights

| Concept | Implementation |
|---|---|
| Surrogate Keys | `dbt_utils.generate_surrogate_key()` across all dimensions, including composite keys where business context required it |
| Date Spine | `dbt_utils.date_spine()` generating a warehouse-independent calendar from 2020–2030 |
| Derived Fields | Boolean `is_subscriber` flag built from a conditional join rather than stored in the source |
| Schema Control | Custom `generate_schema_name` macro overriding dbt's default schema-prepending behavior |
| Data Testing | Automated uniqueness, not-null, referential integrity, and accepted values tests |
| Materialization | All models materialized as tables for downstream query performance |
| Multi-Source Joins | Fact tables joining 4–6 source tables with surrogate key lookups |
| Source Separation | Two distinct source systems (transactional database + email platform) unified into one schema |

---

## How to Run

1. Clone this repository into your dbt Cloud environment or local dbt CLI
2. Configure a Snowflake connection profile targeting your account
3. Run `dbt deps` to install `dbt_utils` and `dbt_date` packages
4. Run `dbt run --select ecoessentials` to build the EcoEssentials models
5. Run `dbt test --select ecoessentials` to execute the test suite

---

## What I Learned

This project reinforced several concepts that I continue to apply in my data engineering work:

- **Dimensional modeling** is a deliberate design process. Choosing the right grain for each fact table and identifying which attributes belong in dimensions vs. facts required careful planning before writing any SQL. I struggled with this in the beginning, but I have found a level of mastery by the end of this project.
- **dbt as a transformation framework** brings software engineering practices (version control, modularity, testing, documentation) into the analytics workflow. Writing models as SELECT statements with clear dependencies made the pipeline both readable and maintainable. It just made sense with my brain compared to SQL DDL statements.
- **Snowflake is a powerful tool.** Hosting my entire data warehouse in Snowflake, along with its ability to integrate with other tools such as dBeaver, FiveTran, and dbt, showed me how incredible Snowflake is in the world of data warehousing. I'm glad I had the opportunity to use it in this class.
- **Unifying disparate sources** into a single schema is where the real value of a warehouse emerges. Bringing order data and email engagement data together under one star schema unlocked analytical questions that neither source could answer on its own.

---

## Connect

- **GitHub:** [github.com/EricPesci1](https://github.com/EricPesci1)
- **Repository:** [github.com/EricPesci1/data-5360-dbt](https://github.com/EricPesci1/data-5360-dbt)
- **LinkedIn:** [www.linkedin.com/in/eric-pesci](www.linkedin.com/in/eric-pesci)



