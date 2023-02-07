with orders as (

    select * from {{ ref('int_orders') }}

),

reviews as (

    select * from {{ ref('stg_order_reviews') }}

),


final as (

    select
        --primary
        reviews.order_review_sk,
        --foreign
        orders.order_id,
        orders.customer_id,
        reviews.review_id,
        --datetime
        orders.purchased_at,
        orders.approved_at,
        orders.carrier_delivered_at,
        orders.customer_delivered_at,
        orders.delivery_date_estimate,
        reviews.review_date,
        reviews.review_answer_timestamp,
        --details
        reviews.review_score
    from orders
    left join reviews on orders.order_id = reviews.order_id

)

select * from final
