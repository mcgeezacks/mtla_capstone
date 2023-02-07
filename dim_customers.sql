-- table with one row per customer that calculates a lifetime value, first order, and most recent order, and average review score

--import CTEs
with customers as (

    select * from {{ ref('stg_customers') }}

),

order_items as (

    select * from {{ ref('int_order_items') }}

),

reviews as (

    select * from {{ ref('stg_order_reviews') }}

),

orders as (

    select * from {{ ref('int_orders') }}

),


-- logic CTEs
average_order_review_scores as (

    select
        orders.customer_id,
        avg(reviews.review_score) as average_review_score
    from orders
    left join reviews on orders.order_id = reviews.order_id
    group by orders.customer_id

),

recent_addresses as (

    select
        customers.customer_id,
        customers.customer_city,
        customers.customer_state,
        customers.customer_zip
    from customers
    left join orders on orders.customer_id = customers.customer_id
    -- find the most recent purchase order delivery address to use as customer address
    qualify row_number() over (partition by orders.customer_id order by orders.purchased_at desc) = 1

),

customer_detail_calculations as (

    select
            order_items.customer_id,
            max(order_items.purchased_at) as most_recent_purchase_date,
            min(order_items.purchased_at) as first_purchase_date,
            round(sum(order_items.price)) as customer_ltv,
            count(distinct order_items.order_id) as customer_order_count,
            max(order_items.price) as largest_single_item_purchase,
            ntile(3) over (order by sum(order_items.price) desc) as customer_profile_bucket
    from order_items
    group by 1

),

customer_details as (

    select
        --primary
        recent_addresses.customer_id,
        --foreign
        recent_addresses.customer_zip,
        --datetime
        customer_detail_calculations.most_recent_purchase_date,
        customer_detail_calculations.first_purchase_date,
        --details
        average_order_review_scores.average_review_score,
        customer_detail_calculations.customer_ltv,
        customer_detail_calculations.customer_order_count,
        customer_detail_calculations.largest_single_item_purchase,
        customer_detail_calculations.customer_profile_bucket,
        recent_addresses.customer_city,
        recent_addresses.customer_state
    from recent_addresses
    left join customer_detail_calculations on recent_addresses.customer_id = customer_detail_calculations.customer_id
    left join average_order_review_scores on average_order_review_scores.customer_id = recent_addresses.customer_id

)

--simple select
select * from customer_details
