with events as (
select * from {{ref('stg_postgres__events')}}
)

select
    events.event_date,
    events.product_id, 
    count(distinct session_id) as session_count,
    count(distinct user_id) as user_count,
    {{ count_all_events('events.event_type', 'events.product_id', ['page_view', 'add_to_cart']) }}
from events
where product_id is not null 
group by 
    events.event_date,
    events.product_id