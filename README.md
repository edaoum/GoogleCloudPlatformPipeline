# NYC Yellow Taxi Pipeline

A production-grade data pipeline built on Google Cloud Platform that ingests, transforms, and analyzes NYC Yellow Taxi trip data from 2020 to present. The pipeline runs automatically every week and covers the full data engineering lifecycle: ingestion, transformation, orchestration, machine learning, and visualization.

---

## Architecture

```
NYC TLC (Public Source)
        │
        ▼
download_taxi_data.py       ← Downloads Parquet files to GCS
        │
        ▼
Google Cloud Storage        ← ny-yellow-taxi-trips-data-buckets
        │
        ▼
load_raw_trips_data.py      ← Loads raw data into BigQuery
        │
        ▼
BigQuery — raw_yellowtrips.trips
        │
        ▼
dbt (stg_trips)             ← Staging layer: cleaning + type casting
        │
        ▼
dbt (mart_trips_summary)    ← Mart layer: aggregations by borough/hour
        │
        ├──► views_fordashboard   ← SQL views for Looker Studio
        │
        └──► ml_dataset           ← Filtered dataset for ML training
                    │
                    ▼
             BigQuery ML           ← Boosted Tree Regressor (predict total_amount)
                    │
                    ▼
             Looker Studio         ← Interactive dashboards
```

All tasks are orchestrated by **Cloud Composer (Managed Airflow)** and run automatically every Friday at 23:00 UTC.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Cloud Platform | Google Cloud Platform |
| Raw Storage | Google Cloud Storage |
| Data Warehouse | BigQuery |
| Transformations | dbt (dbt-bigquery) |
| Orchestration | Cloud Composer (Airflow 2.11) |
| Machine Learning | BigQuery ML — Boosted Tree Regressor |
| Visualization | Looker Studio |
| Language | Python 3.12 |

---

## Project Structure

```
nyc-yellow-taxi-pipeline/
├── README.md
├── requirements.txt
├── .gitignore
│
├── pipeline/                          # Core Python scripts
│   ├── download_taxi_data.py          # Downloads Parquet files from NYC TLC → GCS
│   ├── load_raw_trips_data.py         # Loads GCS Parquet files → BigQuery raw table
│   ├── transform_trips_data.py        # Applies quality filters on raw data
│   ├── create_datasets.py             # Creates all BigQuery datasets
│   └── create_ml_dataset_table.py     # Builds the ML training dataset
│
├── airflow/
│   └── elt_dag_pipeline.py            # Airflow DAG — orchestrates the full pipeline
│
├── dbt/
│   └── nyc_taxi_dbt/
│       ├── dbt_project.yml
│       ├── models/
│       │   ├── staging/
│       │   │   ├── sources.yml        # BigQuery source declarations
│       │   │   └── stg_trips.sql      # Staging model: cleaning + casting
│       │   └── marts/
│       │       └── mart_trips_summary.sql  # Daily aggregations by borough
│       └── macros/
│           └── generate_schema_name.sql    # Custom schema routing macro
│
└── sql/
    ├── create_raw_trips_table.sql     # DDL for the raw trips table
    ├── views_demand.sql               # Demand & customer behavior views
    ├── views_financial.sql            # Revenue & pricing views
    └── views_ml_model.sql             # BigQuery ML model creation
```

---

## Data Source

Data comes from the **NYC Taxi & Limousine Commission (TLC)** public dataset:
- **Format**: Parquet
- **Coverage**: January 2020 → present (~65 files)
- **Volume**: ~200M+ rows across all years
- **Source URL**: `https://d37ci6vzurychx.cloudfront.net/trip-data/`

---

## Pipeline Details

### 1. Ingestion — `download_taxi_data.py`

Downloads monthly Parquet files from the NYC TLC CDN and uploads them directly to GCS without storing locally. Fully idempotent — files already in GCS are skipped. Execution logs are saved to GCS after each run.

### 2. Loading — `load_raw_trips_data.py`

Loads only new Parquet files (not yet in BigQuery) into `raw_yellowtrips.trips`. Uses a two-step strategy: load into a temporary table with schema auto-detection (to handle type drift across years), then insert into the final table with explicit `FLOAT64` cast on `passenger_count`. Tracks loaded files via a `source_file` column.

### 3. Transformation — dbt

dbt replaces one-off SQL scripts and adds testing, documentation, and lineage:

- **Staging layer** (`stg_trips`): cleans column names, casts types, applies quality filters
  - `passenger_count > 0`
  - `trip_distance > 0`
  - `payment_type != 6` (excludes voided trips)
  - `total_amount > 0`
- **Mart layer** (`mart_trips_summary`): daily aggregations by pickup/dropoff borough and payment type

### 4. Orchestration — Airflow DAG

The DAG `elt_pipeline_nyc_taxi` runs every Friday at 23:00 UTC and chains 4 tasks sequentially:

```
download_taxi_data → load_raw_trips_data → run_dbt_transformations → create_ml_dataset
```

Each script is fetched from GCS at runtime, allowing code updates without DAG redeployment. The pipeline stops if any dbt test fails, preventing bad data from reaching the ML dataset.

### 5. Machine Learning — BigQuery ML

A **Boosted Tree Regressor** is trained on recent trip data to predict `total_amount`:
- Training data: trips from November 2024 onwards with card or cash payments only
- Features: `passenger_count`, `trip_distance`, `PULocationID`, `DOLocationID`, `payment_type`, `fare_amount`, `extra`, `mta_tax`, `tolls_amount`, `congestion_surcharge`, `airport_fee`
- Target: `total_amount`
- Evaluation: `ML.EVALUATE` (MAE, RMSE, R²)
- Feature importance: `ML.GLOBAL_EXPLAIN`

### 6. Visualization — Looker Studio

6 analytical views power the Looker Studio dashboard:
- `demand_over_time` — daily trip volume and revenue
- `trips_by_borough` — pickup demand per NYC borough
- `trips_by_hour` — hourly demand patterns
- `revenue_over_time` — fare, tips, tolls, congestion breakdown
- `payment_type_breakdown` — payment method distribution
- `avg_fare_by_borough` — average fare and tip per borough

---

## BigQuery Datasets

| Dataset | Description |
|---|---|
| `raw_yellowtrips` | Raw Parquet data loaded from GCS |
| `transformed_data` | Cleaned and filtered trips table |
| `views_fordashboard` | Analytical SQL views for Looker Studio |
| `dbt_staging` | dbt staging layer (views) |
| `dbt_marts` | dbt marts layer (materialized tables) |
| `ml_dataset` | Filtered dataset for BigQuery ML training |

---

## Getting Started

### Prerequisites

- Google Cloud project with billing enabled
- `gcloud` CLI installed and authenticated
- Python 3.10+
- dbt-bigquery

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/nyc-yellow-taxi-pipeline.git
cd nyc-yellow-taxi-pipeline
```

### 2. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 3. Configure GCP

```bash
gcloud config set project YOUR_PROJECT_ID
gcloud auth application-default login
```

### 4. Create GCS bucket and BigQuery datasets

```bash
gcloud storage buckets create gs://YOUR_BUCKET_NAME \
  --location=us-central1

python3 pipeline/create_datasets.py
```

### 5. Run the pipeline manually

```bash
# Download Parquet files to GCS
python3 pipeline/download_taxi_data.py

# Load into BigQuery
python3 pipeline/load_raw_trips_data.py

# Run dbt transformations
cd dbt/nyc_taxi_dbt
dbt run
dbt test
cd ../..

# Create ML dataset
python3 pipeline/create_ml_dataset_table.py
```

### 6. Configure dbt

Create `~/.dbt/profiles.yml`:

```yaml
nyc_taxi_dbt:
  target: prod
  outputs:
    prod:
      type: bigquery
      method: oauth
      project: YOUR_PROJECT_ID
      dataset: dbt_staging
      location: us-central1
      threads: 4
      timeout_seconds: 300
```

### 7. Deploy on Cloud Composer (optional)

```bash
# Upload scripts to GCS
gcloud storage cp pipeline/*.py gs://YOUR_BUCKET_NAME/from-git/

# Package and upload dbt project
tar -czf nyc-taxi-dbt.tar.gz dbt/nyc_taxi_dbt/
gcloud storage cp nyc-taxi-dbt.tar.gz gs://YOUR_BUCKET_NAME/dbt/

# Deploy DAG
gcloud storage cp airflow/elt_dag_pipeline.py \
  gs://YOUR_COMPOSER_BUCKET/dags/
```

---

## Key Design Decisions

**Idempotency**: Every script checks what already exists before processing. Files already in GCS are skipped by `download_taxi_data.py`. Rows already loaded (tracked via `source_file`) are skipped by `load_raw_trips_data.py`. This makes reruns safe at any point.

**Schema drift handling**: NYC TLC changed the type of `passenger_count` from `INT64` to `FLOAT64` across years. The loading script handles this by using auto-detection on a temporary table and casting explicitly before inserting into the final table.

**dbt over raw SQL**: Transformations are versioned, tested, and documented via dbt instead of one-off SQL scripts. The `generate_schema_name` macro ensures dbt writes to the exact target dataset without name concatenation.

**Runtime dbt install**: dbt-bigquery is installed at task runtime in the Airflow DAG to avoid dependency conflicts with the Composer/Airflow environment. This adds ~1 minute per run but eliminates version conflicts entirely.

---

## Environment Variables

No secrets are stored in the repository. Authentication relies on Google Cloud Application Default Credentials. Never commit `sa-key.json` or `profiles.yml`.

---

## License

MIT License — see [LICENSE](LICENSE) for details.
