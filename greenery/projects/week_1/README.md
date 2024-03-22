# Week 1 Assignment

### Question 1: How many users do we have?
** Answer: 130
``` sql
SELECT 
    COUNT(DISTINCT USER_ID)
FROM DEV_DB.DBT_NIMAAREF6GMAILCOM.STG_POSTGRES__USERS;
```

### Question 2: On average, how mamy order do we receive per hour?
** Answer: Approximately 7.5 orders per hour.
```sql
WITH order_hour as (
SELECT 
    DATE_TRUNC(HOUR, CREATED_AT) AS ORDER_HOUR, 
    COUNT(DISTINCT ORDER_ID) AS ORDER_COUNT
FROM DEV_DB.DBT_NIMAAREF6GMAILCOM.STG_POSTGRES__ORDERS
GROUP BY DATE_TRUNC(HOUR, CREATED_AT)
)

SELECT AVG(ORDER_COUNT) AS AVG_ORDERS_PER_HOUR
FROM ORDER_HOUR ;
```

### Question 3: On average, how long does an order take from being placed to being delivered?
** Answer: 3.9 days on average.
```sql
with order_delivery_days as (
SELECT  
    ORDER_ID,
    DATEDIFF(DAY,MIN(CREATED_AT),MIN(DELIVERED_AT)) AS DELIVERY_TIME
    
FROM DEV_DB.DBT_NIMAAREF6GMAILCOM.STG_POSTGRES__ORDERS
GROUP BY ORDER_ID
) 

SELECT 
AVG(DELIVERY_TIME) 
FROM order_delivery_days;
```


### Question 4: How many users have only made one purchase? Two purchases? Three+ purchases?
** Answer: Single: 25, Two: 28, Three +: 71

``` sql
with user_orders as(

SELECT 
    USER_ID,
    COUNT(DISTINCT ORDER_ID) AS ORDER_COUNT
FROM DEV_DB.DBT_NIMAAREF6GMAILCOM.STG_POSTGRES__ORDERS
GROUP BY USER_ID
ORDER BY COUNT(DISTINCT ORDER_ID) DESC
) 

SELECT 
    COUNT(CASE WHEN ORDER_COUNT = 1 THEN USER_ID END) AS SINGLE_PURCHASE,
    COUNT(CASE WHEN ORDER_COUNT = 2 THEN USER_ID END) AS TWO_PURCHASES,
    COUNT(CASE WHEN ORDER_COUNT>= 3 THEN USER_ID END) AS THREE_OR_MORE_PURCHASES
FROM user_orders;
```


### Question 5: On average, how many unique sessions do we have per hour?
** Answer: Approximately 16.3 sessions per hour.
```sql
WITH session_hour as (
SELECT 
    DATE_TRUNC(HOUR, CREATED_AT) AS ORDER_HOUR, 
    COUNT(DISTINCT SESSION_ID) AS SESSION_COUNT
FROM DEV_DB.DBT_NIMAAREF6GMAILCOM.STG_POSTGRES__EVENTS
GROUP BY DATE_TRUNC(HOUR, CREATED_AT)
)

SELECT AVG(SESSION_COUNT) AS AVG_SESSIONS_PER_HOUR
FROM session_hour ;
```
