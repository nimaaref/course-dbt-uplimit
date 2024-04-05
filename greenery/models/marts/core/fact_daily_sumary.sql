with orders as (
select * from {{ref('stg_postgres__orders')}}
), 

events as (

select 
    event_date,
    count(distinct session_id) as session_count

from dev_db.dbt_nimaaref6gmailcom.stg_postgres__events
group by event_date
)

select 
    order_date,
    sum(order_cost) as total_revenue,
    count(distinct order_id) as order_count,
    count(distinct user_id) as user_count, 
    sum(events.session_count) as session_count,
    sum(shipping_cost) as total_shipping_cost
from orders
inner join events 
    on events.event_date  = order_date
group by order_date