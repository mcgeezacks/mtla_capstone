select
    --primary key
    {{ dbt_utils.surrogate_key(['order_id', 'order_item_id']) }} as order_item_sk,
    --foreign keys
    order_id,
    product_id,
    seller_id,
    --date/time
    shipping_limit_date,
    --details
    order_item_id as order_item_seq,
    price,
    freight_value
from {{ source('ecommerce', 'order_items') }}
