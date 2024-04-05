with order_items as ( 
        select * from {{ref('stg_postgres__order_items')}}
    ),
products as (
    select * from {{ ref('stg_postgres__products')}}
), 

orders as (
select * from {{ ref('stg_postgres__orders')}}
),

order_day as (
select distinct 
    order_date,
    order_id
from orders

)

select 
    order_day.order_date,
    order_items.order_id,
    products.product_id,
    {{ dbt_utils.generate_surrogate_key(['order_items.order_id', 'products.product_id']) }} AS order_line_id,
    products.price,
    order_items.quantity, 
    (products.price * order_items.quantity) as total_revenue,
    
from order_items
inner join products
    on products.product_id = order_items.product_id
inner join order_day 
    on order_day.order_id = order_items.order_id
