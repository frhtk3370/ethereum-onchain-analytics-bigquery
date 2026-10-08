-- Title: Transactions and unique senders, last 24 hours
-- Question: How many transactions and distinct sender addresses occurred in the last day?
-- Source: bigquery-public-data.crypto_ethereum.transactions
-- Date run: 2026-10-08
-- Estimated scan: 87.23 MB
-- Notes: Partition filter on block_timestamp keeps the scan small (unfiltered: ~155 GB).

SELECT
  COUNT(*) AS tx_count,
  COUNT(DISTINCT from_address) AS unique_senders
FROM `bigquery-public-data.crypto_ethereum.transactions`
WHERE block_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY);
