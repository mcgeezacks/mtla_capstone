{{ config(
    tags=["weekly"]
) }}

-- table with one line per product with its english category translation and other product information

with products as (

    select * from {{ ref('stg_products') }}

),

translation as (

    select * from {{ ref('stg_product_category_name_translation') }}

),

translated as (

    select
        -- primary
        products.product_id,
        -- details
        translation.english_category_name as category_name,
        products.product_name_length,
        products.product_description_length,
        products.product_height_cm,
        products.product_weight_g,
        products.product_length_cm,
        products.product_photos_qty
    from products
    left join translation on products.product_portuguese_category_name = translation.portuguese_category_name

)

select * from translated
