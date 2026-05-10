# =============================================================================
# bq_config.py
# NYC Yellow Taxi — Data Analysis Branch
#
# Centralized BigQuery connection configuration.
# All notebooks import from this module to ensure consistency
# across the entire analysis project.
# =============================================================================

from google.cloud import bigquery
import pandas as pd

# --- Project configuration ---
PROJECT_ID = "ny-yellow-taxi-trips"
LOCATION = "us-central1"

# --- Dataset references ---
DATASETS = {
    "raw": "raw_yellowtrips",
    "transformed": "transformed_data",
    "staging": "dbt_staging",
    "marts": "dbt_marts",
    "dashboard": "views_fordashboard",
    "ml": "ml_dataset"
}

# --- Main table references ---
TABLES = {
    "raw_trips": f"{PROJECT_ID}.raw_yellowtrips.trips",
    "cleaned_trips": f"{PROJECT_ID}.transformed_data.cleaned_and_filtered",
    "taxi_zone": f"{PROJECT_ID}.raw_yellowtrips.taxi_zone",
    "trips_summary": f"{PROJECT_ID}.dbt_marts.mart_trips_summary"
}

# --- Date range of available data ---
DATA_START = "2020-01-01"
DATA_END = "2026-03-31"


def get_bq_client():
    """
    Returns an authenticated BigQuery client.
    Uses Application Default Credentials (ADC) — run
    'gcloud auth application-default login' before using locally.
    """
    return bigquery.Client(project=PROJECT_ID, location=LOCATION)


def run_query(sql: str) -> pd.DataFrame:
    """
    Executes a BigQuery SQL query and returns the result as a DataFrame.

    Args:
        sql: SQL query string to execute.

    Returns:
        pd.DataFrame with query results.
    """
    client = get_bq_client()
    return client.query(sql).to_dataframe()


def run_query_from_table(table_key: str, limit: int = None) -> pd.DataFrame:
    """
    Reads a full table from BigQuery by its key in TABLES dict.

    Args:
        table_key: Key from the TABLES dict (e.g. 'cleaned_trips').
        limit: Optional row limit.

    Returns:
        pd.DataFrame with table contents.
    """
    table = TABLES[table_key]
    sql = f"SELECT * FROM `{table}`"
    if limit:
        sql += f" LIMIT {limit}"
    return run_query(sql)
