-- Title: Top 10 gas consumers with token labels, last 24 hours
-- Question: Which of the top gas-consuming addresses are known ERC-20 tokens?
-- Source: bigquery-public-data.crypto_ethereum.transactions, bigquery-public-data.crypto_ethereum.tokens
-- Date run: 2026-10-08
-- Estimated scan: 1.49 GB
-- Notes: LEFT JOIN keeps non-token contracts (symbol is NULL), e.g. routers and entry points.


WITH top_gas AS (
  SELECT
    to_address,
    SUM(receipt_gas_used) AS total_gas_used
  FROM `bigquery-public-data.crypto_ethereum.transactions`
  WHERE block_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY)
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 10
)
SELECT
  g.to_address,
  t.symbol,
  g.total_gas_used
FROM top_gas AS g
LEFT JOIN `bigquery-public-data.crypto_ethereum.tokens` AS t
  ON t.address = g.to_address
ORDER BY g.total_gas_used DESC;
