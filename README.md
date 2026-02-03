# bi_project
This repository include bi development work


Sanford Aquaculture Export Analysis – BI Technical Solution

This repository contained an end-to-end Business Intelligence solution developed as part of the Sanford BI Analyst technical assessment. 
The solution analyses New Zealand aquaculture export data (FY23–FY25) to support strategic decisions around markets, products, and pricing.
Scope & Objectives
The solution addresses three core business questions:
• Which export markets demonstrate the strongest growth and pricing performance?
• Which species and product categories are the most profitable?
• Where are opportunities to optimise pricing by market?

The design emphasises data profiling for executive decision-making.

Data Validation & Ingestion

- Source data is received as annual CSV extracts. Prior to ingestion, files are validated for naming conventions, required columns, and basic data integrity. 
- Data ingestion handled via Python, enabling incremental loads, batch-level audit tracking, and safe reprocessing where required.
- Invalid or unexpected files are rejected and logged.

Architecture Overview
The solution follows a modern, modular analytics architecture:

	CSV Files - > Python Ingestion (incremental, audited) - > PostgreSQL (Docker)/bronze layer - > dbt Transformations (Silver & Gold layers) -> Star Schema ->	Power BI Reporting

Technology Choices

	• Tools and technology evaluation identified PostgreSQL hosted on Docker.
	• Python used to ingestion, validation, and operational logging.
	• dbt is used to manage transformations, data modelling standards, and create a governed semantic layer.
	• Power BI is used for interactive reporting and executive dashboards.

Data Modelling

A star schema was implemented in the Gold layer, consisting of a central fact table capturing export value, volume, and average price, surrounded by conformed dimensions.
fiscal year, country, product, and species. This structure supports performant reporting and accurate fiscal time analysis.

Reporting & Insights
The Power BI report is structured across three focused pages:

1. Market Performance – Growth and pricing by country.
2. Product & Species Profitability – Value and margin drivers across the product portfolio.
3. Pricing Strategy – Market-level price dispersion and optimisation opportunities.

Each page combines targeted KPI cards with supporting visuals to balance executive summary and analytical depth.

Outcome
This solution demonstrates a complete BI delivery lifecycle, from ingestion through to executive insight. 
It reflects Sanford’s emphasis on data quality, transparency, and practical decision support.

Key Insights for Sanford Aquaculture Analytics
- UNITED STATES and CHINA amoung overall key markert in terms of average price per kg and total export value(nzd).
- SOUTH KOREA and UNITED STATES amoung the key markert drive for average value per kg and related to product category Preserved.
- French Polynesia having highest demand in pricing strategy. 
- Processed Packed and Processed Powder have broght more total export value(nzd).
- Frozen Half Shell has more total export value(nzd).
- Salmon has gained more average price per kg.
- mussels fallen into more products.

More
- can integrate iso_3166 standardised country data set for more insight into regional spred.


