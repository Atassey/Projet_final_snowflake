CREATE OR REPLACE TABLE stage.clickstream_events CLUSTER BY(event_time) AS
SELECT 
    SEQ4()+1 AS event_id,
    UNIFORM(1,5000000,RANDOM()) AS customer_id,
    DATEADD(SECOND, -UNIFORM(0,86400,RANDOM()), CURRENT_TIMESTAMP()) AS event_time,
    OBJECT_CONSTRUCT(
        'page',   (ARRAY_CONSTRUCT('home','products','products','products','cart','checkout')
                    [UNIFORM(0,5,RANDOM())])::STRING,
        'device', (ARRAY_CONSTRUCT('mobile','desktop','desktop','tablet')
                    [UNIFORM(0,3,RANDOM())])::STRING,
        'duration_seconds', UNIFORM(5,300,RANDOM()),
        'browser', (ARRAY_CONSTRUCT('Chrome','Safari','Firefox','Edge')
                    [UNIFORM(0,3,RANDOM())])::STRING,
        'os', (ARRAY_CONSTRUCT('iOS','Android','Windows','MacOS','Linux')
                    [UNIFORM(0,4,RANDOM())])::STRING,
        'session_id', UUID_STRING()
    ) AS event_data
FROM TABLE(GENERATOR(ROWCOUNT => 200000));