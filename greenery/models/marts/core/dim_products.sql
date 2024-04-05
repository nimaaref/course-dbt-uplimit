WITH PRODUCTS AS (
    SELECT * FROM {{ref('stg_postgres__products')}}
)

SELECT 
    product_id,
    name as product_name, 
    price as product_price
FROM products