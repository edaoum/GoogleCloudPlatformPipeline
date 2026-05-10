# Power BI — BigQuery Connection Guide

## Prerequisites

- Power BI Desktop installed
- Google account with access to `ny-yellow-taxi-trips` BigQuery project
- BigQuery connector enabled in Power BI

---

## Connecting Power BI to BigQuery

1. Open Power BI Desktop
2. Click **Get Data** → **Google BigQuery**
3. Enter your **Billing Project ID**: `ny-yellow-taxi-trips`
4. Sign in with your Google account when prompted
5. Navigate to the datasets and select the tables below

---

## Tables to Import

| Dataset | Table | Use in Dashboard |
|---|---|---|
| `transformed_data` | `cleaned_and_filtered` | All pages — main fact table |
| `raw_yellowtrips` | `taxi_zone` | Zone and borough dimension |
| `views_fordashboard` | `demand_over_time` | Executive Summary, Temporal page |
| `views_fordashboard` | `trips_by_borough` | Geographic page |
| `views_fordashboard` | `revenue_over_time` | Financial page |
| `views_fordashboard` | `payment_type_breakdown` | Behavioral page |
| `views_fordashboard` | `avg_fare_by_borough` | Operational page |

---

## Recommended Import Mode

Use **Import mode** for the views (small, pre-aggregated).
Use **DirectQuery** for `cleaned_and_filtered` if you want live data.

---

## Dashboard Structure — 5 Pages

### Page 1 — Executive Summary
KPI cards: total trips, total revenue, avg fare, avg distance
Line chart: monthly trip volume (2020–2026)
Bar chart: revenue by year

### Page 2 — Operational Performance
Bar chart: top 15 pickup zones
Scatter: zone performance matrix (volume vs avg fare)
Bar: borough comparison (avg distance, avg fare, revenue/mile)

### Page 3 — Financial Analysis
Area chart: revenue components over time (fare, tips, tolls, congestion)
Bar: airport vs standard trip fare comparison
Treemap: revenue by zone

### Page 4 — Customer Behavior
Donut: payment type distribution
Line: tip rate evolution by year
Bar: passenger count breakdown

### Page 5 — Temporal & Geographic Patterns
Heatmap: demand by day of week × hour
Line: year-over-year monthly comparison
Matrix: borough-to-borough flow
