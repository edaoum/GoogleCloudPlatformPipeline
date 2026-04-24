-- =============================================================================
-- create_raw_trips_table.sql
-- Pipeline NYC Yellow Taxi -- Project: ny-yellow-taxi-trips
--
-- Creates the raw trips table in BigQuery with the full schema.
-- Run this once before loading any data with load_raw_trips_data.py.
-- The source_file column tracks which Parquet file each row came from,
-- enabling idempotent incremental loading.
-- =============================================================================

CREATE TABLE IF NOT EXISTS `ny-yellow-taxi-trips.raw_yellowtrips.trips`
(
  VendorID                INTEGER,        -- Taxi vendor: 1 = Creative Mobile, 2 = VeriFone
  tpep_pickup_datetime    TIMESTAMP,      -- Pickup date and time
  tpep_dropoff_datetime   TIMESTAMP,      -- Dropoff date and time
  passenger_count         FLOAT64,        -- Number of passengers (FLOAT64 for cross-year compatibility)
  trip_distance           FLOAT64,        -- Trip distance in miles
  RatecodeID              FLOAT64,        -- Rate code: 1=Standard, 2=JFK, 3=Newark, 4=Nassau/Westchester, 5=Negotiated, 6=Group ride
  store_and_fwd_flag      STRING,         -- Whether trip was stored locally before sending to server (Y/N)
  PULocationID            INTEGER,        -- TLC pickup zone ID
  DOLocationID            INTEGER,        -- TLC dropoff zone ID
  payment_type            INTEGER,        -- 1=Credit card, 2=Cash, 3=No charge, 4=Dispute, 5=Unknown, 6=Voided
  fare_amount             FLOAT64,        -- Base fare calculated by meter
  extra                   FLOAT64,        -- Miscellaneous extras (rush hour, overnight surcharges)
  mta_tax                 FLOAT64,        -- MTA tax triggered based on metered rate
  tip_amount              FLOAT64,        -- Tip amount (auto-populated for credit card tips only)
  tolls_amount            FLOAT64,        -- Total tolls paid during trip
  improvement_surcharge   FLOAT64,        -- Improvement surcharge assessed at flag drop
  total_amount            FLOAT64,        -- Total amount charged to passengers (target variable for ML)
  congestion_surcharge    FLOAT64,        -- Congestion surcharge for trips in Manhattan south of 96th St
  airport_fee             FLOAT64,        -- Airport pickup fee for JFK and LaGuardia
  source_file             STRING          -- Source Parquet filename for traceability (e.g. yellow_tripdata_2024-01.parquet)
);
