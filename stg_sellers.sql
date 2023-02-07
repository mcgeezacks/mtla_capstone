select
    --primary key
    seller_id,
    --foreign keys
    seller_zip_code_prefix as seller_zip,
    --details
    seller_city,
    seller_state
from {{ source('ecommerce', 'sellers') }}
