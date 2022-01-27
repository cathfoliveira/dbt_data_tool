-- especifico o schema e a tabela, assim se mudar, não preciso sair mudando em todas as queries
-- os detalhes dessas sources estão no arquivo de configuração .yaml
-- carrega a fonte e faz a tipagem que pode fazer a conversão, como o timestamp que está na tabela como string
-- e aqui dentro ele já pode ser convertido a timestamp de fato.

-- adding the below config, means that we want to create a table on Redshift. You may use 'view' instead.
-- {{
--     config(
--         materialize='table'
--     )
-- }}

WITH source AS (
    SELECT * FROM {{'data_lake_raw','atomic_events'}}
)
SELECT
    event_id::varchar,
    event_timestamp::timestamp,             -- aplicando a tipagem correta, ele já converte o string para timestamp dentro do dbt
    event_type::varchar,
    browser_language::varchar,
    browser_name::varchar,
    browser_user_agent::varchar,
    click_id::varchar,
    device_is_mobile::boolean,
    device_type::varchar,
    geo_country::varchar,
    geo_latitude::float,
    geo_longitude::float,
    geo_region_name::varchar,
    geo_timezone::varchar,
    ip_address::varchar,
    os::varchar,
    os_name::varchar,
    os_timezone::varchar,
    page_url::varchar,
    page_url_path::varchar,
    referer_medium::varchar,
    referer_url::varchar,
    referer_url_port::varchar,
    referer_url_scheme::varchar,
    user_custom_id::varchar,
    user_domain_id::varchar as cookie_id,       -- pode renomear para um padrao de nomenclatura    
    utm_campaign::varchar,
    utm_content::varchar,
    utm_medium::varchar,
    utm_source::varchar,
	date::date
FROM source