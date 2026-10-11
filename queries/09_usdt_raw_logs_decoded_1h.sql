-- Title: USDT transfers decoded from raw logs
-- Question: What do USDT Transfer events look like when decoded from raw topics and data?
-- Source: bigquery-public-data.crypto_ethereum.logs
-- Date run: 2026-10-11
-- Estimated scan: 637.7 MB

select
block_timestamp,
concat('0x',substr(topics[offset(1)],27)) as sender,
concat('0x',substr(topics[offset(2)],27))  as receiver,
round(safe_cast(data as int64) /1e6, 2 ) as amount_usdt
from `bigquery-public-data.crypto_ethereum.logs`
where block_timestamp >= timestamp_sub(current_timestamp(), interval 1 hour)
and address = '0xdac17f958d2ee523a2206206994597c13d831ec7'
and topics[offset(0)] = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
