-- Title: USDT daily transfers, senders and receivers, last 7 days
-- Question: How many USDT transfers, distinct senders and distinct receivers occur each day?
-- Source: bigquery-public-data.crypto_ethereum.token_transfers
-- Date run: 2026-10-08
-- Estimated scan: ~3.5 GB
-- Notes: USDT contract 0xdac17f958d2ee523a2206206994597c13d831ec7.
--        The first and last day are partial because the window is "now - 7 days".

SELECT
  EXTRACT(DATE FROM block_timestamp) AS tx_date,
  COUNT(*) AS transfer_count,
  COUNT(DISTINCT from_address) AS unique_senders,
  COUNT(DISTINCT to_address) AS unique_receivers
FROM `bigquery-public-data.crypto_ethereum.token_transfers`
WHERE block_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  AND token_address = '0xdac17f958d2ee523a2206206994597c13d831ec7'
GROUP BY 1
ORDER BY 1 ASC;
