select
    --primary key
    order_id,
    --foreign keys
    customer_id AS session_id,
    --date/time
    order_purchase_timestamp as purchased_at,
    order_approved_at as approved_at,
    order_delivered_carrier_date as carrier_delivered_at,
    order_delivered_customer_date as customer_delivered_at,
    order_estimated_delivery_date as delivery_date_estimate,
    --details
    order_status
from {{ source('ecommerce', 'orders') }}
