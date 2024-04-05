with order_items as ( 
        select * from {{ref('stg_postgres__order_items')}}
    ), 
orders as (
        select * from {{ ref('stg_postgres__orders')}}
),

products as (
    select * from {{ ref('stg_postgres__products')}}
)

select 
    order_date,
    order_items.product_id, 
    count(distinct orders.order_id) as order_count,
    sum(order_items.quantity) as total_quantity,
    sum(orders.order_cost) as total_revenue,
    sum(products.inventory) as total_inventory
from order_items
inner join orders 
    on orders.order_id  = order_items.order_id
inner join products
    ON products.product_id = order_items.product_id
group by 
    order_date,
    orders.order_id,
    order_items.product_id
