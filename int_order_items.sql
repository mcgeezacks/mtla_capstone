-- table with one record per unique item ordered connecting it to relevant order dates and product information

with orders as (

    select * from {{ ref('stg_orders') }}

),

order_items as (

    select * from {{ ref('stg_order_items') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

reviews as (

    select * from {{ ref('stg_order_reviews') }}

),

recent_order_reviews as (

    select
        orders.order_id,
        row_number() over (partition by reviews.order_id order by reviews.review_date desc) as row_num_review_date,
        reviews.review_score,
        reviews.review_date
    from orders
    inner join reviews on reviews.order_id = orders.order_id
    where orders.order_status not in ('canceled', 'unavailable', 'created')
    qualify row_num_review_date = 1

),

final as (

    select
        --primary key
        order_items.order_item_sk,
        --foreign keys
        order_items.product_id,
        customers.customer_id,
        orders.order_id,
        order_items.seller_id,
        --date_time
        order_items.shipping_limit_date,
        orders.purchased_at,
        orders.approved_at,
        orders.carrier_delivered_at,
        orders.customer_delivered_at,
        orders.delivery_date_estimate,
        recent_order_reviews.review_date,
        --details
        orders.order_status,
        order_items.price,
        order_items.freight_value,
        recent_order_reviews.review_score
    from order_items
    left join orders on order_items.order_id = orders.order_id
    left join customers on customers.session_id = orders.session_id
    left join recent_order_reviews on recent_order_reviews.order_id = orders.order_id

)

select * from final
