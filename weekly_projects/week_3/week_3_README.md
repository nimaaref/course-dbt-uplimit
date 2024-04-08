## Week 3 Assignment Questions & Answers

**Part 1. Models**

	

* Conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. 
* Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product*

 1. What is our overall conversion rate? 
	** Answer:  54%
```sql 
with fds as (
select * from dev_db.dbt_nimaaref6gmailcom.fact_daily_sumary)

select 
sum(order_count) as order_count,
sum(session_count) as session_count,
(sum(order_count)/sum(session_count))*100 as conversion_rate

from fds
```


 2. What is our conversion rate by product? 
 
 Top 10 products filtered by order count descending. 
 
| PRODUCT NAME     | PAGE VIEWS | ORDER COUNT | PRODUCT CONVERSION RATE % |
|------------------|------------|-------------|-------------------------|
| String of pearls | 65         | 39          | 60.0                    |
| Bamboo           | 69         | 36          | 52.2                    |
| Arrow Head       | 64         | 35          | 54.7                    |
| ZZ Plant         | 65         | 34          | 52.3                    |
| Orchid           | 74         | 34          | 45.9                    |
| Birds Nest Fern  | 80         | 33          | 41.3                    |
| Majesty Palm     | 69         | 33          | 47.8                    |
| Aloe Vera        | 65         | 32          | 49.2                    |
| Pink Anthurium   | 74         | 31          | 41.9                    |
| Philodendron     | 63         | 30          | 47.6                    |

 3. Create a macro to simplify part of a model(s).

	I created a macro to complete a count for specified event types in the argument. This is helpful as it helps reinforce the DRY principle. 

```` sql
{% macro count_all_events(event_type_column, product_id_column, event_types) %}

{% for event_type in event_types %}

count(case  when {{ event_type_column }} = '{{ event_type }}'  then {{ product_id_column }} end) as {{ event_type }}_count{% if  not loop.last %},

{% endif %}

{% endfor %}

{% endmacro %}

````

 4. Add a post hook to your project to apply grants to the role “reporting”.

Added in the dbt_project.yml file

````sql 

models:
greenery:
	+post-hook:
		- "{{grant(role='reporting')}}"
````

 5. Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project. 

I installed the dbt-utils package and used it in an intermediate product_orders table to create a surrogate key for each order which I named order_line_id. 

```` sql 

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
````
 6.  Show (using dbt docs and the model DAGs) how you have simplified or improved a DAG using macros and/or dbt packages.

		The photo has been added to the dag to the project submission. Created a new intermediate model for events which runs into my fact_product_performance_daily. 


