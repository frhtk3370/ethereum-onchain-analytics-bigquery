-- Title: USDT wallet net flow, last 7 days
-- Question: Which wallets had the largest net USDT inflow and outflow over the last 7 days?
-- Source: bigquery-public-data.crypto_ethereum.token_transfers
-- Date run: 2026-10-10
-- Estimated scan: 3.5 GB

WITH flows AS (
  SELECT
    from_address AS wallet,
    -SAFE_CAST(value AS FLOAT64) / 1e6 AS amount_usd
  FROM `bigquery-public-data.crypto_ethereum.token_transfers`
  WHERE block_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
    AND token_address = '0xdac17f958d2ee523a2206206994597c13d831ec7'
  UNION ALL
  SELECT
    to_address AS wallet,
    SAFE_CAST(value AS FLOAT64) / 1e6 AS amount_usd
  FROM `bigquery-public-data.crypto_ethereum.token_transfers`
  WHERE block_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
    AND token_address = '0xdac17f958d2ee523a2206206994597c13d831ec7'
),
net AS (
  SELECT
    wallet,
    SUM(amount_usd) AS net_flow_usd
  FROM flows
  GROUP BY wallet
)
(SELECT 'inflow' AS direction, wallet, net_flow_usd
 FROM net
 ORDER BY net_flow_usd DESC
 LIMIT 10)
UNION ALL
(SELECT 'outflow' AS direction, wallet, net_flow_usd
 FROM net
 ORDER BY net_flow_usd ASC
 LIMIT 10)
