{{ config(
    tags=["weekly"]
) }}
-- products dimension with product details and category, sales counts, sales totals, and average review scores

--import CTEs
with order_items as (

    select * from {{ ref('int_order_items') }}

),

reviews as (

    select * from {{ ref('stg_order_reviews') }}

),

products as (

    select * from {{ ref('int_products') }}

),

product_details as (

    select
        products.product_id,
        count(products.product_id) as total_sales_count,
        sum(order_items.price) as total_sales_value,
        avg(reviews.review_score) as average_product_review_score
    from products
    left join order_items on products.product_id = order_items.product_id
    left join reviews on order_items.order_id = reviews.order_id
    group by product_id

),

final as (

    select
        products.product_id,
        products.category_name,
        products.product_name_length,
        products.product_description_length,
        products.product_height_cm,
        products.product_weight_g,
        products.product_length_cm,
        products.product_photos_qty,
        product_details.total_sales_count,
        product_details.total_sales_value,
        product_details.average_product_review_score
    from products
    left join product_details on products.product_id = product_details.product_id

)

select * from final
