-- Title: USDT daily transfers, unique users and volume (30 days)
-- Question: How do daily USDT transfers, unique senders/receivers and dollar volume trend over 30 days?
-- Source: bigquery-public-data.crypto_ethereum.token_transfers
-- Date run: 2026-10-09
-- Estimated scan: 16.39 GB
-- Notes: First day is partial. Volume = value / 1e6 (USDT has 6 decimals).


select
extract(date from block_timestamp) as dayy,
count(*) as t_count,
count(distinct from_address) as u_sender,
count(distinct to_address) as u_receiver,
sum(safe_cast(value as float64)/1e6) as vol_usdt
from `bigquery-public-data.crypto_ethereum.token_transfers`
where block_timestamp >= timestamp_sub(current_timestamp, interval 30 day)
and token_address = '0xdac17f958d2ee523a2206206994597c13d831ec7'
group by 1
order by 1 asc
