## Week 2 Assignment Questions & Answers

**Part 1. Models**

 1. What is our repeat user rate? 
 **Answer:  27%
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
    COUNT(CASE WHEN ORDER_COUNT >= 2 THEN USER_ID END) AS TWO_OR_MORE,
    COUNT(DISTINCT USER_ID) AS TOTAL_USERS,
    COUNT(CASE WHEN ORDER_COUNT >= 2 THEN USER_ID END)/SUM(ORDER_COUNT) AS REPEAT_RATE
    
FROM user_orders;
```

 3. What are good indicators of a user who will likely purchase again?
    What about indicators of users who are likely NOT to purchase again?
    If you had more data, what features would you want to look into to
    answer this question? (NOTE: This is a hypothetical question vs.
    something we can analyze in our Greenery data set. Think about what
    exploratory analysis you would do to approach this question.)
	    
	- To help answer these questions I'd complete two analyses: RFM and Loyalty analysis. 
	- RFM will help provide a numerical score for each customer where a Loyalty analysis will provide information of how many new, existing, and lost users the company has. With users categorized with an RFM score and a Loyalty status we can start to have a better understanding of what a good customer is and will likely purchase again vs those who would not. 

4. Explain the product mart models you added. Why did you organize the
    models in the way you did?
    - Product Mart Models
	    - Intermediate table - product orders: A combination of orders, order_items, and products to provide a daily aggregate summary at the product level of important  metrics like order count, quantity sold, revenue sold, inventory. 
	    - Fact table - fact_product_performance_daily: A combination of events and product order data from the intermediate table. This provides the product team a comprehensive overview of important metrics like pageviews, add to carts, checkouts, users, for each product along revenue metrics and the available inventory of the product. This will help answer basic funnel analysis questions for products. 
 
 
 **Part 2. Tests** 
 
5. Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
I did not find any bad data this time around! 
6. Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
I think the best method would be to make them aware of the tests that are going to be done daily and being sure to use the dbt build command. 

**Part 3. Snapshots**

6. Which products had their inventory change from week 1 to week 2?
	The following six products: Pothos, Bamboo, Philodendron, String of pearls, ZZ Plant, Monstera.
