-- Title: Daily transactions, unique senders and average gas price, last 7 days
-- Question: How do daily activity and the average effective gas price (Gwei) trend over the past week?
-- Source: bigquery-public-data.crypto_ethereum.transactions
-- Date run: 2026-10-08
-- Estimated scan: not recorded
-- Notes: The first and last day are partial because the window is "now - 7 days".

SELECT
  EXTRACT(DATE FROM block_timestamp) AS tx_date,
  COUNT(*) AS tx_count,
  COUNT(DISTINCT from_address) AS unique_senders,
  ROUND(AVG(receipt_effective_gas_price / 1e9), 4) AS avg_gas_price_gwei
FROM `bigquery-public-data.crypto_ethereum.transactions`
WHERE block_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
GROUP BY 1
ORDER BY 1 ASC;
