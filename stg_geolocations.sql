
with cleaner_fcn as (

  select
    translate(geolocation_city, 'áâãàçéêíóôõú', 'aceiou') as geolocation_city,
    geolocation_lat,
    geolocation_lng,
    geolocation_state,
    geolocation_zip_code_prefix
  from {{ source('ecommerce', 'geolocations') }}

),

averages as (

    select
        geolocation_zip_code_prefix as geolocation_id,
        geolocation_city,
        geolocation_state,
        avg(geolocation_lat) as avg_lat,
        avg(geolocation_lng) as avg_lon,
    from cleaner_fcn
    group by geolocation_id, geolocation_city, geolocation_state
    qualify row_number() over (partition by geolocation_id order by geolocation_id asc) = 1

)

select * from averages
