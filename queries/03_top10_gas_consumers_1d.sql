-- Title: Top 10 gas consumers, last 24 hours
-- Question: Which receiving addresses consumed the most gas in the last day?
-- Source: bigquery-public-data.crypto_ethereum.transactions
-- Date run: 2026-10-08
-- Estimated scan: 104.71 MB
-- Notes: receipt_gas_used is actual gas spent (gas is only the sender's limit).
--        A NULL to_address means contract creation transactions.


SELECT
  to_address,
  SUM(receipt_gas_used) AS total_gas_used
FROM `bigquery-public-data.crypto_ethereum.transactions`
WHERE block_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
