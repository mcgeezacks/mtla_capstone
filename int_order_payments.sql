-- table with one record per order payment attaching purchased & approved date information to payments

with orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_order_payments') }}

),

final as (

    select
        --primary
        payments.order_payment_id,
        --foreign
        orders.order_id,
        --datetime
        orders.purchased_at,
        orders.approved_at,
        --details
        payments.payment_installments,
        payments.payment_seq,
        payments.payment_value,
        payments.payment_method
    from payments
    left join orders on payments.order_id = orders.order_id

)

select * from final
