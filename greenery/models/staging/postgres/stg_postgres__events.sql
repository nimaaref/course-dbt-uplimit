select
    event_id,
    session_id,
    user_id,
    page_url,
    cast(created_at as date) as event_date,
    event_type,
    order_id,
    product_id
from {{ source('postgres','events') }}