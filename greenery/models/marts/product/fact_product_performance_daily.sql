with events as ( 
    select * from {{ref('stg_postgres__events')}}
), 

product_orders as (
    select * from {{ref('int_product_orders')}}
)

select 
    event_date,
    events.product_id,
    count(case when event_type = 'page_view' then events.product_id end) AS page_view_count,
    count(case when event_type = 'add_to_cart' then events.product_id end) AS add_to_cart_count,
    count(distinct user_id) AS unique_user_count,
    sum(order_count) as order_count,
    sum(total_revenue) as total_revenue,
    sum(total_quantity) as total_quantity,
    sum(total_inventory) as total_inventory
from events
inner join product_orders
    on product_orders.PRODUCT_ID = events.PRODUCT_ID
    and product_orders.order_date = events.event_date
where 
    events.PRODUCT_ID is not null
group by 
    event_date,
    events.PRODUCT_ID
