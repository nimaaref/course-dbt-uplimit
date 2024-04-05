with product_event as ( 
    select * from {{ref('int_product_event')}}
), 

product_orders as (
    select * from {{ref('int_product_orders')}}
),

product_summary as (
select
    opr.order_date,
    opr.product_id,
    count(distinct opr.order_id) as order_count,
    sum(opr.quantity) as quantity_ordered,
    sum(opr.total_revenue) as product_revenue
from product_orders as opr
group by 
    opr.order_date,
    opr.product_id
    )

select 
    ps.order_date, 
    ps.product_id,
    sum(pe.session_count) as session_count,
    sum(pe.user_count) as user_count,
    sum(pe.page_view_count) as page_views_count,
    sum(pe.add_to_cart_count) as add_to_cart_count,
    sum(ps.order_count) as order_count,
    sum(ps.quantity_ordered) as quantity_ordered,
    sum(ps.product_revenue) as product_revenue
    
from product_summary as ps
inner join product_event as pe 
    on pe.event_date = ps.order_date
    and pe.product_id = ps.product_id
group by 
    ps.order_date,
    ps.product_id