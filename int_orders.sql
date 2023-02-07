

-- to substitute customer session_id for customer_id in orders table

with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

final as (

    select
        --primary
        orders.order_id,
        --foreign
        customers.customer_id,
        --datetime
        orders.purchased_at,
        orders.approved_at,
        orders.carrier_delivered_at,
        orders.customer_delivered_at,
        orders.delivery_date_estimate,
        --details
        orders.order_status
    from orders
    left join customers on orders.session_id = customers.session_id

)

select * from final
