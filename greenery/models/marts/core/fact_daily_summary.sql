 with orders as (

 select * from dev_db.dbt_nimaaref6gmailcom.stg_postgres__orders
 ), 
 events as (
 select * from dev_db.dbt_nimaaref6gmailcom.int_core_events
 ), 
 
 daily_orders as (
    select 
        order_date, 
        sum(order_cost) as total_revenue,
        count(distinct order_id) as order_count,
        count(distinct user_id) as user_count, 
        sum(shipping_cost) as total_shipping_cost
    from orders
    group by order_date
), 
daily_events as (

    select 
        event_date,
        sum(session_count) as session_count, 
        sum(page_view_count) as page_view_count,
        sum(add_to_cart_count) as add_to_cart_count,
        sum(checkout_count) as checkout_count, 
        sum(package_shipped_count) as package_shipped_count
    
    from events
    group by event_date
)

select 
    daily_events.event_date,
    sum(daily_orders.total_revenue) as total_revenue,
    sum(daily_orders.order_count) as order_count,
    sum(daily_orders.user_count) as user_count, 
    sum(daily_events.session_count) as session_count,
    sum(daily_orders.total_shipping_cost) as total_shipping_cost, 
    sum(daily_events.page_view_count) as page_view_count,
    sum(daily_events.add_to_cart_count) as add_to_cart_count,
    sum(daily_events.checkout_count) as checkout_count,
    sum(daily_events.package_shipped_count) as package_shipped_count
from daily_events
left join daily_orders 
    on daily_events.event_date  = daily_orders.order_date
group by daily_events.event_date