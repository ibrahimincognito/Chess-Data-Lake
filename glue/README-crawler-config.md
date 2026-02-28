# Glue Crawler Configuration

The AWS Glue crawler is used to automatically discover the schema and partitions of the processed Parquet data stored in S3.

## Crawler Details

- **Name:** `lichess-leaderboard-crawler`
- **Data source:** `s3://lichess-processed-data-ibrahim/leaderboard/`
- **Output database:** `lichess_db`
- **IAM role:** `AWSGlueServiceRole-lichess`
- **Schedule:** On‑demand (run manually after each day's data arrives)
- **Schema change policy:** Add new columns only, log deleted objects
- **Recrawl policy:** Crawl new folders only

## How to Run

1. Go to AWS Glue Console → Crawlers.
2. Select `lichess-leaderboard-crawler`.
3. Click **Run crawler**.
4. After completion, the table `leaderboard` in `lichess_db` is updated with new partitions.

## Why This Matters

The crawler creates a table in the Glue Data Catalog that enables Athena to query the data using SQL. The partitioning by `performance` and `snapshot_date` makes queries efficient and cost‑effective.