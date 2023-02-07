# Proposed Metrics


## For Product

### Metric
Count of Poor Reviews

### Definition
~~COUNT(distinct orders.order_id) WHERE order_reviews.review_score < 3~~
COUNT(distinct orders.order_id) WHERE avg(fct_order_reviews.review_score) < 3

### Visualization
Weekly amount of orders with low reviews by product category in orders delivered;
stacked bar chart with x-axis being `max(max(fct_orders.carrier_delivered_at, fct_orders.customer_delivered_at))`, y axis is COUNT(DISTINCT CASE WHEN
`avg(fct_order_reviews.review_score)` < 3 THEN `fct_orders.order_id` ELSE NULL END)
and bar groupings are defined by date_diff(`fct_orders.delivery_date_estimate`, `fct_orders.delivered_date`)

## For Marketing

### Metric
Trending customer regions

### Definition
COUNT(`fct_orders.customer_id`) by `dim_customers.customer_zip`

### Visualization
Heatmap for the last week with the number of `fct_orders.customer_id` (not distinct) determining
the color of the `geolocation_id`

### Metric
Customer volume

### Definition
COUNT(distinct`fct_orders.customer_id`) within (timeframe)


## For Finance

### Metrics
Revenue

### Definition
SUM(`dim_payments.payment_value`) for orders where `dim_payments.order_status` is delivered

### Visualization
Line graph with x-axis `fct_order_payments.purchased_at`

## For Logistics

### Metric
Shipping Estimate Accuracy

### Definition
`timestamp_diff(fct_orders.delivery_date_estimate, max(max(fct_orders.customer_delivered_date, fct_orders_carrier_delivered_at)), day)` as `time_diff_estimate_actual`

CASE WHEN `time_diff_estimate_actual < 0` THEN 'Early'
WHEN `time_diff_estimate_actual > 0` THEN 'Late' ELSE END AS `delivery_category`
WHERE `order_status` IS 'delivered'

### Visualization
Weekly heatmap where `geolocation_id` color is determined by COUNT(case when delivery_category = 'late')

## For CEO

### Metric
Order and Customer Volume

### Definition
COUNT(DISTINCT fct_orders.order_id) AS num_orders,
COUNT(DISTINCT fct_orders.customer_id) AS num_customers

### Visualization
Line graph with x-axis `fct_orders.purchased_at`; y-axis is number of customers & orders as
separate lines plotted over time
