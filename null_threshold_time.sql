{% test null_threshold_time(model, column_name, stable_date, date_part=week, percent_threshold=2) %}

with null_percent_calculator as (

    select 
        date_trunc({{ stable_date }}, {{ date_part }}) as search_interval,
        count(case when {{ column_name }} is null then 1 end) *100 / 
        count(*) as percent_null
    from {{ model }}
    group by search_interval
   
),

validation_errors as (

    select *
    from null_percent_calculator
    where percent_null > {{ percent_threshold }}
    
)

select * from validation_errors

{% endtest %}
