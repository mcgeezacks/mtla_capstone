select
    --primary key
    {{ dbt_utils.surrogate_key(['review_id', 'order_id']) }} as order_review_sk,
    --foreign keys
    review_id,
    order_id,
    --date/time
    review_creation_date as review_date,
    review_answer_timestamp,
    --details
    review_score
from {{ source('ecommerce', 'order_reviews') }}
