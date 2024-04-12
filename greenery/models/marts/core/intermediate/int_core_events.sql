with events as (
select * from {{ref('stg_postgres__events')}}
)

select
    events.event_date,
    count(distinct session_id) as session_count,
    count(distinct user_id) as user_count,
    {{ count_all_events('events.event_type', 'events.session_id', ['page_view', 'add_to_cart', 'checkout', 'package_shipped']) }}
from events
group by 
    events.event_date
