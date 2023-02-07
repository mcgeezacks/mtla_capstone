{% test null_threshold(model, column_name, percent_threshold=2) %}

with null_percent_calculator as (

    select 
        count(case when {{ column_name }} is null then 1 end) *100 / 
        count( {{ column_name }}) as percent_null
    from {{ model }}

),

validation_errors as (

    select *
    from null_percent_calculator
    where percent_null > {{ percent_threshold }}
    
)

select * from validation_errors

{% endtest %}
