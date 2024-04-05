select
    order_id,
    user_id,
    promo_id,
    address_id,
    cast(created_at as date) order_date,
    order_cost,
    shipping_cost,
    order_total, 
    tracking_id, 
    shipping_service, 
    cast(estimated_delivery_at as date) as estimated_delivery_at,
    cast(delivered_at as date) as delivered_at,
    status
from {{ source('postgres','orders') }}