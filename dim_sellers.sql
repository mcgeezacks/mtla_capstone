{{ config(
    tags=["weekly"]
) }}
-- table with one row per seller that calculates a lifetime value, first order, and most recent order, and average review score

--import CTEs
with sellers as (

    select * from {{ ref('stg_sellers') }}

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

seller_detail_calculations as (

    select
        order_items.seller_id,
        max(order_items.purchased_at) as most_recent_sale_date,
        min(order_items.purchased_at) as first_sale_date,
        round(sum(order_items.price)) as seller_ltv,
        count(distinct order_items.order_id) as seller_order_count,
        max(order_items.price) as largest_single_item_sale,
        ntile(3) over (order by sum(order_items.price) desc) as seller_profile_bucket
    from order_items
    group by seller_id
),

seller_details as (

    select
        --primary
        sellers.seller_id,
        --foreign
        sellers.seller_zip,
        --datetime
        seller_detail_calculations.most_recent_sale_date,
        seller_detail_calculations.first_sale_date,
        --details
        seller_detail_calculations.seller_ltv,
        seller_detail_calculations.seller_order_count,
        seller_detail_calculations.largest_single_item_sale,
        seller_detail_calculations.seller_profile_bucket,
        sellers.seller_city,
        sellers.seller_state
    from sellers
    left join seller_detail_calculations on sellers.seller_id = seller_detail_calculations.seller_id

)

--simple select
select * from seller_details
