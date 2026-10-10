-- Title: Binance 14 daily USDT net flow, last 7 days
-- Question: How did the daily USDT net flow of the Binance 14 wallet change over the last 7 days?
-- Source: bigquery-public-data.crypto_ethereum.token_transfers
-- Date run: 2026-10-10
-- Estimated scan: 3.93 GB

with flow as (
select 
date(block_timestamp) as flow_date,
sum(case when from_address = '0x28c6c06298d514db089934071355e5743bf21d60'
then -safe_cast(value as float64) / 1e6 else 0 end ) as sent_usd,
sum(case when to_address = '0x28c6c06298d514db089934071355e5743bf21d60'
then safe_cast(value as float64) / 1e6 else 0 end ) as received_usd,
from`bigquery-public-data.crypto_ethereum.token_transfers`
where block_timestamp >= timestamp_sub(current_timestamp(), interval 7 day) and
token_address = '0xdac17f958d2ee523a2206206994597c13d831ec7' and (
from_address =  '0x28c6c06298d514db089934071355e5743bf21d60' or 
to_address =  '0x28c6c06298d514db089934071355e5743bf21d60')
group by 1
)

select
*,
sent_usd + received_usd as net_flow
from flow
order by flow_date asc
