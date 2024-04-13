## Week 4 Assignment Questions & Answers

**Part 1. dbt Snapshots**

	
1. Which products had their inventory change from week 3 to week 4?
** Answer: String of pearls, Pothos, Monstera, Bamboo, Philodendron, ZZ Plant
```sql 
select * 
from dev_db.dbt_nimaaref6gmailcom.inventory_snapshot
where cast(dbt_updated_at as date) > '2024-04-03'
```

2. Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory?
Products that had the most fluctuations would: ZZ Plant, Philodendron, Pothos, Monstera, Bamboo, String of pearls. These products had their inventory change each week. 
``` sql 
with base as (
select 
    cast(dbt_updated_at as date) as snapshot_date,
    name as product_name, 
    sum(inventory) as total_inv,
    row_number()over(partition by name order by cast(dbt_updated_at as date) asc) as snapshot_count
from dev_db.dbt_nimaaref6gmailcom.inventory_snapshot
group by 1,2
)

select *

from base 
where snapshot_count = 3
```
4.  Did we have any items go out of stock in the last 3 weeks? 
Yes, we had two products go out of stock: Pothos, String of pearls. 
``` sql 

with base as (
select 
    cast(dbt_updated_at as date) as snapshot_date,
    name as product_name, 
    sum(inventory) as total_inv,
    row_number()over(partition by name order by cast(dbt_updated_at as date) asc) as snapshot_count
from dev_db.dbt_nimaaref6gmailcom.inventory_snapshot
group by 1,2
)

select *

from base 
where total_inv = 0
```


** Part 2. Modeling Challenge ** 

1. How are our users moving through the product funnel? Which steps in the funnel have largest drop off points?
*Answer: The largest drop off is between a product page view and add to cart. 

2. The Product and Engineering teams will want to track how they are improving these metrics on an ongoing basis. As such, we need to think about how we can model the data in a way that allows us to set up reporting for the long-term tracking of our goals.
*Answer: We have set up models to monitor daily funnel performance as well as product funnel performance. This should allow the engineering team to review lower performing products to prioritize page improvements. 

