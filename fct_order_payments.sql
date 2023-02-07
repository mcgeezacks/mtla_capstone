with orders as(
    select * from {{ ref('int_orders') }}
),

payments as (
    select * from {{ ref('int_order_payments') }}
),



joined as (
    select
        --primary
        payments.order_payment_id,
        --foreign
        orders.order_id,
        orders.customer_id,
        --timedate
        orders.purchased_at,
        orders.approved_at,
        --details
        payments.payment_seq,
        payments.payment_installments,
        payments.payment_value,
        payments.payment_method,
        orders.order_status
    from orders
    inner join payments on payments.order_id = orders.order_id
),

payment_attempts as (

    select
        --primary
        order_payment_id,
        --foreign
        order_id,
        customer_id,
        --datetime
        purchased_at,
        approved_at,
        --details
        payment_value,
        -- replaces original payment_seq & payment_installments fields with values that reflect the actual payment sequence & # of installments
        row_number() over (partition by order_id order by purchased_at asc) as payment_seq,
        count(order_payment_id) over (partition by order_id) as payment_installments
    from joined
    order by purchased_at

)

select * from payment_attempts
