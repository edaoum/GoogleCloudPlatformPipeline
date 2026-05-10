# NYC Yellow Taxi — Data Analysis

An analytical exploration of **200M+ NYC Yellow Taxi trips** (2020–2026) built on Google Cloud Platform. This project approaches the dataset from a **Data Analyst perspective** — the focus is on extracting business insights, identifying behavioral patterns, and telling a story with data through structured notebooks and an interactive Power BI dashboard.

> **Looking for the pipeline?** Switch to the [`data-engineering`](../../tree/data-engineering) branch for the full ELT pipeline, dbt models, and Airflow orchestration.

---

## Business Context

NYC Yellow Taxi generates millions of trip records every month across five boroughs. Raw data alone tells nothing — the value lies in what you extract from it.

This project was built around five concrete business questions:

- **Where and when is demand highest?** Identifying peak hours, seasonal patterns, and geographic hotspots
- **Which zones and boroughs are most profitable?** Breaking down revenue by zone, borough, and trip type
- **How do passengers behave?** Analysing payment preferences, tipping patterns, and passenger segmentation
- **What happened during COVID-19?** Measuring the full impact of the pandemic on the taxi market and its recovery
- **Are there data quality issues worth monitoring?** Surfacing anomalies — disputed trips, voided fares, unknown payment types

---

## What This Branch Contains

```
data-analysis/
├── notebooks/                              # 6 analytical Jupyter notebooks
│   ├── 00_setup_and_data_overview.ipynb    # Dataset structure & quality assessment
│   ├── 01_operational_analysis.ipynb       # Trip efficiency & zone performance
│   ├── 02_financial_analysis.ipynb         # Revenue breakdown & profitability
│   ├── 03_behavioral_analysis.ipynb        # Passenger behavior & tipping patterns
│   ├── 04_geographic_analysis.ipynb        # Spatial flows & hotspot analysis
│   └── 05_temporal_analysis.ipynb          # Seasonality, COVID impact & YoY trends
│
├── config/
│   └── bq_config.py                        # Centralized BigQuery connection
│
├── exports/                                # Charts exported from notebooks (PNG)
│
├── powerbi/
│   └── README_powerbi.md                   # Power BI connection guide
│
└── requirements_analysis.txt              # Python dependencies
```

---

## Analytical Framework

Each notebook follows the same narrative structure:

**Business question → Data exploration → Visualisation → Key findings**

This makes every notebook readable by both technical and non-technical audiences — a Data Analyst deliverable, not a data science experiment.

---

## Notebooks

### 00 — Setup & Data Overview
Establishes the foundation for the entire analysis. Assesses data quality (missing values, outliers, anomalies), documents the dataset structure, and produces global statistics.

Key outputs:
- 200M+ trips confirmed after quality filtering
- COVID-19 impact clearly visible in 2020 data
- Significant outliers in `total_amount` and `trip_distance` identified and handled per notebook
- `airport_fee` and `congestion_surcharge` have expected missing values for pre-2019 trips

---

### 01 — Operational Analysis
Analyses trip efficiency, distance and duration patterns, vendor comparison, and zone-level performance.

Key findings:
- Median trip distance: **2–3 miles** — short urban trips dominate
- Late night hours (1–5 AM) generate longer, more profitable trips
- Morning rush (7–9 AM) and evening rush (5–8 PM) are peak demand periods
- Both vendors (Creative Mobile vs VeriFone) show near-identical operational metrics
- **Midtown Manhattan** zones dominate pickup volume by a wide margin

---

### 02 — Financial Analysis
Breaks down revenue components, tracks fare evolution over time, and identifies the most profitable zones and time periods.

Key findings:
- Total revenue collapsed **80%+** during COVID-19 lockdowns (March–June 2020)
- Full financial recovery achieved by mid-2022
- **Base fare** accounts for ~70% of total revenue; **tips** ~15%
- **JFK and LaGuardia airport trips** generate 2–3x the average fare of standard Manhattan trips
- Late night and early morning hours show the highest **revenue per mile**
- Average fares increased **~65%** between 2020 and 2026 driven by surcharges and fare adjustments

---

### 03 — Behavioral Analysis
Analyses passenger payment preferences, tipping behavior, and trip segmentation.

Key findings:
- **Credit card payments** represent 85%+ of all transactions and have grown consistently year over year
- **Cash usage has declined significantly** since 2020 — accelerated by COVID-19
- **80%+ of credit card passengers leave a tip** — average tip rate: 18–22% of base fare
- Cash tips are not recorded in the TLC dataset — tip analysis is therefore limited to card payments
- **Solo passengers account for 70%+** of all trips
- Four distinct trip profiles identified: Very Short Budget, Short Standard, Medium Commuter, Long Premium

---

### 04 — Geographic Analysis
Maps borough-to-borough flows, identifies revenue hotspots, and builds a zone performance matrix.

Key findings:
- **Manhattan accounts for 85%+ of all pickups**
- The **Manhattan → Queens** corridor is the second largest flow, driven by airport trips
- Revenue is highly concentrated: top 10 zones generate a disproportionate share of total revenue
- Two distinct high-value profiles: **High Volume / Moderate Value** (Midtown) vs **Low Volume / High Value** (Airports)
- **Revenue per mile** is highest in airport zones and Midtown Manhattan

---

### 05 — Temporal Analysis
Examines seasonality, weekly cycles, hourly demand peaks, and the long-term COVID-19 impact.

Key findings:
- **Spring (March–May)** and **Autumn (September–October)** are peak seasons for trip volume
- **Friday and Saturday evenings (8 PM–2 AM)** are the absolute peak demand periods
- **Sunday mornings** show distinct patterns: late-starting demand and higher average fares
- COVID-19 caused a market collapse in April 2020 — recovery was gradual through 2021
- Average fares **increased during the COVID period** — remaining trips were longer and higher-value
- Post-recovery trips are on average longer and more expensive than pre-pandemic trips

---

## Power BI Dashboard

The dashboard connects directly to BigQuery and tells the story of NYC taxi data across **6 narrative pages**:

| Page | Story told |
|---|---|
| **Executive Summary** | 203M trips, $5B+ revenue — key metrics and the full timeline at a glance |
| **Operational Performance** | Where and when do taxis operate most efficiently? |
| **Financial Analysis** | How is revenue generated, distributed, and evolving? |
| **Customer Behavior** | How do passengers pay, tip, and travel? |
| **Temporal & Geographic** | When is demand highest and where does it concentrate? |
| **Data Quality & Anomalies** | What do disputed and voided trips reveal about data integrity? |

---

## BigQuery Views

8 analytical views optimized for both notebooks and Power BI:

| View | Description |
|---|---|
| `demand_over_time` | Daily trip volume and revenue |
| `trips_by_borough` | Demand per NYC borough over time |
| `trips_by_hour` | Hourly demand and fare patterns |
| `revenue_over_time` | Revenue breakdown by component (fare, tips, tolls, congestion, airport) |
| `payment_type_breakdown` | Credit card vs cash distribution and tipping |
| `avg_fare_by_borough` | Fare, tip and distance per borough |
| `customer_behavior` | Passenger count, tip rate and payment by year |
| `anomalies` | Disputed, voided and unknown payment trips with daily anomaly rate |

All views filter from **January 2020 to present** using `CURRENT_TIMESTAMP()` — no hardcoded dates, fully future-proof.

---

## Key Findings Summary

| Theme | Finding |
|---|---|
| Volume | 200M+ trips across 2020–2026, with full COVID recovery by mid-2022 |
| Revenue | $5B+ total revenue; average fare up 65% since 2020 |
| Geography | Manhattan = 85%+ of pickups; airports generate 2–3x standard fares |
| Behavior | 85%+ card payments; 80%+ tip rate on card; 70%+ solo passengers |
| Timing | Friday/Saturday 8 PM–2 AM = peak demand; spring/autumn = peak seasons |
| COVID | 80%+ volume collapse in April 2020; structural shift in trip profile post-recovery |
| Anomalies | Less than 1% disputed/voided trips but visible in data quality monitoring |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Data Warehouse | BigQuery (Google Cloud Platform) |
| Analytical views | SQL — 8 optimized BigQuery views |
| Notebooks | Python 3.12 · Jupyter · pandas · matplotlib · seaborn · plotly |
| Dashboard | Power BI Desktop — DirectQuery on BigQuery |
| Authentication | Google Cloud Application Default Credentials |

---

## Getting Started

### Prerequisites

- Python 3.10+
- Google Cloud account with access to `ny-yellow-taxi-trips` BigQuery project
- `gcloud` CLI installed and authenticated

### 1. Clone the repository

```bash
git clone https://github.com/edaoum/GoogleCloudPlatformPipeline.git
cd GoogleCloudPlatformPipeline
# data-analysis is the default branch — no checkout needed
```

### 2. Install dependencies

```bash
pip install -r data-analysis/requirements_analysis.txt
```

### 3. Authenticate with GCP

```bash
gcloud auth application-default login
gcloud config set project ny-yellow-taxi-trips
```

### 4. Run the notebooks

```bash
cd data-analysis
jupyter notebook
```

Open any notebook in `notebooks/` and run all cells sequentially. Each notebook is self-contained and imports from `config/bq_config.py`.

### 5. Connect Power BI

See `data-analysis/powerbi/README_powerbi.md` for step-by-step BigQuery connection instructions.

---

## Data Source

All data is sourced from the **NYC Taxi & Limousine Commission (TLC)** public dataset, ingested and transformed by the `data-engineering` branch pipeline:

| Table | Description |
|---|---|
| `transformed_data.cleaned_and_filtered` | Main analysis table — 200M+ filtered rows |
| `raw_yellowtrips.taxi_zone` | NYC zone lookup — 265 zones |

---

## Environment

No secrets stored in the repository. All BigQuery connections use Google Cloud Application Default Credentials. Never commit `sa-key.json` or `profiles.yml`.
