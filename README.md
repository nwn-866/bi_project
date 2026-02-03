# Sanford Aquaculture Export Analysis – BI Technical Solution

## Overview
This repository contains an end-to-end Business Intelligence solution developed as part of the **Sanford BI Analyst technical assessment**.

The solution analyses **New Zealand aquaculture export data (FY23–FY25)** to support strategic decision-making across **markets, products, and pricing**.  
It demonstrates the full BI delivery lifecycle—from data ingestion and transformation through to executive-ready reporting.

---

## Scope & Objectives
The solution addresses the following core business questions:

- **Right Market:** Which export markets demonstrate the strongest growth and pricing performance?
- **Right Product:** Which species and product categories are the most profitable?
- **Right Price:** Where are opportunities to optimise pricing by market?

The design emphasises **data quality, profiling, and clarity**, ensuring insights are suitable for executive decision-making.

---

## Repository Structure
sanford_analytics/
│
├── data/
│ ├── input/ # Source CSV files (FY23–FY25)
│ ├── processed/ # Successfully ingested files
│ └── reject/ # Rejected or invalid files
│
├── docker/
│ └── docker-compose.yml # PostgreSQL container configuration
│
├── scripts/
│ └── sanford_export_raw_data_ingest.py
│ # Python script for incremental CSV ingestion
│
├── sanford_dbt/
│ ├── models/
│ │ ├── silver/ # Staging and standardisation models
│ │ └── gold/ # Star schema (facts and dimensions)
│ ├── macros/ # dbt macros
│ ├── packages.yml # dbt package dependencies
│ └── dbt_project.yml # dbt project configuration
│
├── sql/
│ └── schema_setup.sql # Database schema and table creation scripts
│
├── power_bi/
│ └── *.pbix # Power BI dashboard files
│
├── logs/
│ └── ingestion_logs/ # Optional runtime logs
│
├── .gitignore
└── README.md # Project documentation


---

## Data Validation & Ingestion
Source data is received as **annual CSV extracts**.

Prior to ingestion, files are validated for:
- Naming conventions
- Required columns
- Basic data integrity

Python-based ingestion supports:
- Incremental loading
- Batch-level audit tracking
- Safe reprocessing where required

Invalid or unexpected files are automatically **rejected and logged**.

---

## Architecture Overview
The solution follows a modern, modular analytics architecture:

CSV Files
→ Python Ingestion (incremental, audited)
→ PostgreSQL (Docker / Bronze layer)
→ dbt Transformations (Silver & Gold layers)
→ Star Schema , built on gold layer
→ Power BI Reporting


---

## Technology Choices
- **PostgreSQL (Docker):** Lightweight, reproducible analytical database environment
- **Python:** Data ingestion, validation, and operational logging
- **dbt:** Transformation logic, modelling standards, and governed semantic layer
- **Power BI:** Interactive dashboards and executive reporting

---

## Data Modelling
A **star schema** is implemented in the Gold layer, consisting of:
- A central **fact table** capturing export value, volume, and average price
- Conformed dimensions:
  - Fiscal Year
  - Country
  - Product
  - Species

This structure supports **high-performance reporting** and accurate fiscal time analysis.

---

## Reporting & Insights
The Power BI report is structured across **three focused pages**:

1. **Market Overview** – Growth and pricing by country  
2. **Profitability Overview** – Value and margin drivers across the product/species portfolio  
3. **Pricing Strategy** – Market-level price dispersion and optimisation opportunities  

Each page combines targeted **KPI cards** with supporting visuals to balance executive summary and analytical depth.

---

## Key Insights (Sample Findings)
- **United States** and **China** are key markets in terms of both average price per kg and total export value.
- **South Korea** and the **United States** demonstrate strong pricing performance within the *Preserved* product category.
- **French Polynesia** shows the highest pricing levels, indicating premium market positioning.
- *Processed Packed* and *Processed Powder* products contribute the highest total export value.
- *Frozen Half Shell* products account for significant export value by volume.
- **Salmon** commands the highest average price per kg.
- **Mussels** are represented across multiple product forms, indicating broad product diversification.

---

## Future Enhancements
- Integrate **ISO 3166** standardised country reference data to enable regional and geopolitical analysis
- Extend pricing analysis with cost data to support margin-based profitability insights

---

## Outcome
This solution demonstrates a complete BI delivery lifecycle—from ingestion through to executive insight—aligned with **Sanford’s emphasis on data quality, transparency, and practical decision support**.
