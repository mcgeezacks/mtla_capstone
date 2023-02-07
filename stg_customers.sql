select
    --primary key
    customer_unique_id as customer_id,
    --foreign keys
    customer_id as session_id,
    customer_zip_code_prefix as customer_zip,
    --details
    customer_city,
    customer_state
from {{ source('ecommerce', 'customers') }}
