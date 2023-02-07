with orders as (

    select * from {{ ref('int_orders') }}

),

order_items as (

    select * from {{ ref('int_order_items') }}

),

reviews as (

    select * from {{ ref('stg_order_reviews') }}

),

aggregator as (

    select
        orders.order_id,
        count(order_items.order_item_sk) as order_item_count,
        sum(order_items.price) as total_order_item_value,
        sum(order_items.freight_value) as total_order_shipping_costs,
        avg(reviews.review_score) as average_order_review_score
    from orders
    left join order_items on orders.order_id = order_items.order_id
    left join reviews on orders.order_id = reviews.order_id
    group by 1

),

joined as (

    select
        --primary
        orders.order_id,
        --foreign
        orders.customer_id,
        --datetime
        orders.purchased_at,
        orders.approved_at,
        orders.customer_delivered_at,
        orders.carrier_delivered_at,
        orders.delivery_date_estimate,
        --details
        aggregator.order_item_count,
        aggregator.total_order_item_value,
        aggregator.total_order_shipping_costs,
        aggregator.average_order_review_score
    from orders
    left join aggregator on aggregator.order_id = orders.order_id

)

select * from joined
