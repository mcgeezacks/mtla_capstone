with products as (

select * from {{ ref('dim_products') }}
),

order_reviews as (

select * from {{ ref('int_order_items') }}

),


product_categories as (

  select
    products.category_name,
    date_trunc(order_reviews.review_date, month) as review_date_month,
    count(order_reviews.review_score) as monthly_count_category_reviews,
    round(avg(order_reviews.review_score), 2) as monthly_average_review_score,
    approx_quantiles(order_reviews.review_score,100) [offset(50)] as monthly_median_review_score,
    sum(case when order_reviews.review_score = 1 then 1 else 0 end) as monthly_count_1_reviews,
    sum(case when order_reviews.review_score = 2 then 1 else 0 end) as monthly_count_2_reviews,
    sum(case when order_reviews.review_score = 3 then 1 else 0 end) as monthly_count_3_reviews,
    sum(case when order_reviews.review_score = 4 then 1 else 0 end) as monthly_count_4_reviews,
    sum(case when order_reviews.review_score = 5 then 1 else 0 end) as monthly_count_5_reviews
  from order_reviews
  inner join products on products.product_id = order_reviews.product_id
  where products.category_name is not null
  group by 1, 2
  having count(order_reviews.review_score) >= 30

),

totals as (

  select
    {{ dbt_utils.surrogate_key(['category_name', 'review_date_month']) }} as product_category_month_sk,
    category_name,
    review_date_month,
    monthly_count_category_reviews,
    monthly_average_review_score,
    monthly_median_review_score,
    monthly_count_1_reviews,
    monthly_count_2_reviews,
    monthly_count_3_reviews,
    monthly_count_4_reviews,
    monthly_count_5_reviews,
    sum(monthly_count_category_reviews) over (partition by review_date_month) as total_count_reviews_month,
    sum(monthly_count_1_reviews) over (partition by review_date_month) as total_monthly_count_1_reviews,
    sum(monthly_count_2_reviews) over (partition by review_date_month) as total_monthly_count_2_reviews,
    sum(monthly_count_3_reviews) over (partition by review_date_month) as total_monthly_count_3_reviews,
    sum(monthly_count_4_reviews) over (partition by review_date_month) as total_monthly_count_4_reviews,
    sum(monthly_count_5_reviews) over (partition by review_date_month) as total_monthly_count_5_reviews
  from product_categories
  order by review_date_month asc

)

select * from totals
