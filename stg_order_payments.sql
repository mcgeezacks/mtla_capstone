select
    --primary key
    {{ dbt_utils.surrogate_key(['order_id', 'payment_sequential']) }} AS order_payment_id,
    --foreign keys
    order_id,
    --details
    payment_type as payment_method,
    payment_sequential as payment_seq,
    payment_installments,
    payment_value
from {{ source('ecommerce', 'order_payments') }}
