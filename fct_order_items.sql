with orders as (

    select * from {{ ref('int_orders') }}

),

order_items as (

    select * from {{ ref('int_order_items') }}

),


joined as (

    select
        --primary
        case when order_items.order_item_sk is null then {{dbt_utils.surrogate_key (['orders.order_id', 'orders.customer_id', 'order_items.product_id']) }} else order_items.order_item_sk end as order_item_sk,
        --foreign
        orders.order_id,
        orders.customer_id,
        order_items.seller_id,
        order_items.product_id,
        --datetime
        orders.purchased_at,
        orders.approved_at,
        orders.carrier_delivered_at,
        orders.customer_delivered_at,
        orders.delivery_date_estimate,
        order_items.shipping_limit_date,
        --details
        order_items.price,
        order_items.freight_value
    from order_items
    left join orders on order_items.order_id = orders.order_id

)

select * from joined
