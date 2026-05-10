# NYC Yellow Taxi Trips — Data Analysis Branch

This branch contains the Data Analyst perspective of the NYC Yellow Taxi pipeline project. While the `main` branch focuses on data engineering (ingestion, transformation, orchestration), this branch focuses entirely on **extracting business insights** from the data.

---

## Objective

Turn 200M+ rows of NYC taxi trip data (2020–2026) into actionable business insights through structured analysis, professional notebooks, and an interactive Power BI dashboard.

---

## Structuredata-analysis/
├── config/
│   └── bq_config.py                   # Centralized BigQuery connection
├── notebooks/
│   ├── 00_setup_and_data_overview.ipynb     # Dataset structure & quality
│   ├── 01_operational_analysis.ipynb        # Trip efficiency & zone performance
│   ├── 02_financial_analysis.ipynb          # Revenue breakdown & profitability
│   ├── 03_behavioral_analysis.ipynb         # Passenger behavior & tipping
│   ├── 04_geographic_analysis.ipynb         # Spatial patterns & OD flows
│   └── 05_temporal_analysis.ipynb           # Seasonality & COVID-19 impact
├── sql/
│   └── analytical_queries.sql              # Advanced SQL queries for Power BI
├── exports/                                # Charts exported from notebooks
├── powerbi/
│   └── README_powerbi.md                   # Power BI connection guide
└── requirements_analysis.txt              # Python dependencies

---

## Notebooks

| # | Notebook | Key Questions |
|---|---|---|
| 00 | Setup & Data Overview | Dataset structure, quality assessment, global distributions |
| 01 | Operational Analysis | Trip profiles, hourly patterns, vendor comparison, top zones |
| 02 | Financial Analysis | Revenue evolution, fare composition, airport premium, profitability |
| 03 | Behavioral Analysis | Payment trends, tipping behavior, passenger segmentation |
| 04 | Geographic Analysis | Borough flows, OD matrix, revenue concentration, zone matrix |
| 05 | Temporal Analysis | Monthly timeline, seasonality, COVID impact, YoY comparison |

---

## Data Source

All data comes from the BigQuery datasets built by the `main` branch pipeline:

| Dataset | Table | Description |
|---|---|---|
| `transformed_data` | `cleaned_and_filtered` | Main analysis table — 200M+ filtered rows |
| `raw_yellowtrips` | `taxi_zone` | NYC zone lookup — 265 zones |

---

## Getting Started

### Prerequisites

- Python 3.10+
- GCP project access with BigQuery read permissions
- Application Default Credentials configured

```bashgcloud auth application-default login

### Install dependencies

```bashpip install -r requirements_analysis.txt

### Run notebooks

Open any notebook in Jupyter or VS Code and run all cells sequentially.
Each notebook is self-contained and imports from `config/bq_config.py`.

---

## Power BI Dashboard

The Power BI dashboard connects directly to BigQuery and tells the story of NYC taxi data across 5 narrative pages:

1. **Executive Summary** — Key metrics at a glance
2. **Operational Performance** — Trip efficiency & zone analysis
3. **Financial Analysis** — Revenue, fares & profitability
4. **Customer Behavior** — Payment, tipping & passenger profiles
5. **Temporal & Geographic Patterns** — Seasonality, COVID impact & spatial flows

See `powerbi/README_powerbi.md` for connection instructions.

---

## Key Findings Summary

- **COVID-19** caused an 80%+ collapse in trip volume in April 2020, with full recovery by 2022
- **Manhattan** accounts for 85%+ of all pickups — outer boroughs rely on other transport modes
- **Airport trips** (JFK, LaGuardia) generate 2–3x the average fare of standard Manhattan trips
- **Credit card payments** have grown to 85%+ of transactions, accelerated by the pandemic
- **Friday and Saturday evenings** (8 PM–2 AM) are the absolute peak demand periods
- **Average fares have increased 20–30%** since 2020, driven by surcharges and fare adjustments
