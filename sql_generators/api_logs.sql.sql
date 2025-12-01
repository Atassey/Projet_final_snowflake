
CREATE OR REPLACE TABLE stage.api_logs CLUSTER BY(log_time) AS
SELECT 
    SEQ4()+1 AS log_id,
    DATEADD(SECOND, -UNIFORM(0,172800,RANDOM()), CURRENT_TIMESTAMP()) AS log_time,
    OBJECT_CONSTRUCT(
        'endpoint', (ARRAY_CONSTRUCT('/login','/checkout','/search','/order')
                      [UNIFORM(0,3,RANDOM())])::STRING,
        'method', (ARRAY_CONSTRUCT('GET','POST','POST','GET','PUT','DELETE')
                      [UNIFORM(0,5,RANDOM())])::STRING,
        'status_code', (ARRAY_CONSTRUCT(200,201,404,500)
                      [UNIFORM(0,3,RANDOM())]),
        'response_time_ms', UNIFORM(20,2000,RANDOM()),
        'ip_address', CONCAT(UNIFORM(1,255,RANDOM()),'.',UNIFORM(1,255,RANDOM()),'.',UNIFORM(1,255,RANDOM()),'.',UNIFORM(1,255,RANDOM()))
    ) AS log_data
FROM TABLE(GENERATOR(ROWCOUNT => 50000));