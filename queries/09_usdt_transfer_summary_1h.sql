-- Title: USDT transfer summary from raw logs (1h)
-- Question: What do the last hour of USDT transfers look like (count, unique wallets, volume, average, median, max)?
-- Source: bigquery-public-data.crypto_ethereum.logs
-- Date run: 2026-10-11
-- Estimated scan: 617 MB
-- Notes: Decoded from raw topics/data; median is approximate (APPROX_QUANTILES).

with decoded as (
  select
    concat('0x', substr(topics[offset(1)], 27)) as sender,
    concat('0x', substr(topics[offset(2)], 27)) as receiver,
    safe_cast(data as int64) / 1e6 as amount_usdt
  from `bigquery-public-data.crypto_ethereum.logs`
  where block_timestamp >= timestamp_sub(current_timestamp(), interval 1 hour)
    and address = '0xdac17f958d2ee523a2206206994597c13d831ec7'
    and topics[offset(0)] = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
)
select
  count(*) as transfer_count,
  count(distinct sender) as unique_senders,
  count(distinct receiver) as unique_receivers,
  round(sum(amount_usdt), 2) as total_volume_usdt,
  round(avg(amount_usdt), 2) as avg_amount_usdt,
  round(approx_quantiles(amount_usdt, 200)[offset(100)], 2) as median_amount_usdt,
  round(max(amount_usdt), 2) as max_amount_usdt
from decoded
