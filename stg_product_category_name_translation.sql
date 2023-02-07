select 
    --primary key
    string_field_0 as portuguese_category_name,
    --details
    string_field_1 as english_category_name
from {{ source('ecommerce', 'product_category_name_translation') }}
