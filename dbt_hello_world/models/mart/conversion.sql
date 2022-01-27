-- PRECISO ESCREVER O SQL DE ACORDO COM O BD QUE ESTIVER USANDO.
-- pra esta query eu quero que ele crie uma tabela. se a tabela já existe ele dropa e recria. se trocar para incremental, ele vai apendar dados novos numa tabela existente.
{{
    config(
        materialized='table'
    )
}}

-- Referenciando a tabela que criamos em staging já com a tipagem correta e nomenclatura corrigida
WITH source AS (

    SELECT * FROM {{ ref('stg__atomic_events') }} 

),

-- para a sequencia de eventos pego o imediatamente anterior para saber o tempo entre a abertura e o fechamento da sessao.
get_previous_timestamp AS ( 

    SELECT
        *,
        LAG(event_timestamp) OVER (PARTITION BY cookie_id ORDER BY event_timestamp) AS  previous_timestamp
    FROM source

),

-- Se a diferenca de tempo for >= 30 eh uma sessao nova senao é a mesma sessao.
flag_new_session AS (

    SELECT
        *,
        CASE WHEN date_diff('minute', previous_timestamp, event_timestamp) >= 30 
            THEN 1 ELSE 0 
        END AS new_session
    FROM get_previous_timestamp

),

-- particiona pelo cookie id e vai criando ids das sessoes 0,1,2 etc
get_session_idx AS (

    SELECT
        *,
        SUM(new_session) OVER (PARTITION BY cookie_id ORDER BY event_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS session_idx
    FROM flag_new_session

),

-- pacote do dbt que cria um surrogate key (hash md5) usando as duas colunas que passei como parametro
-- como estou usando uma biblioteca do dbt preciso especifica-la em packages.yaml na raiz do projeto.
create_session_id AS (

SELECT
    *,
    {{ dbt_utils.surrogate_key(['cookie_id', 'session_idx']) }} AS session_id
FROM get_session_idx

),

-- pra cada sessao, me tras o primeiro e o ultimo timestamp
calculate_conversion AS (

    SELECT
        session_id,
        cookie_id,
        session_idx,
        FIRST_VALUE(event_timestamp) OVER (PARTITION BY session_id ORDER BY event_timestamp rows between unbounded preceding and unbounded following) AS session_start_at,
        LAST_VALUE(event_timestamp) OVER (PARTITION BY session_id ORDER BY event_timestamp rows between unbounded preceding and unbounded following) AS session_end_at,
        page_url_path = '/confirmation' AS is_conversion
    FROM create_session_id

)

SELECT * FROM calculate_conversion