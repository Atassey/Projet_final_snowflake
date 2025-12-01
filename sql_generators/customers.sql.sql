CREATE OR REPLACE TABLE stage.customers AS
SELECT 
    SEQ4() + 1 AS id,
    INITCAP(SUBSTR(UUID_STRING(),1,5) || ' ' || SUBSTR(UUID_STRING(),1,7)) AS name,
    LOWER(SUBSTR(UUID_STRING(),1,5) || '.' || SUBSTR(UUID_STRING(),1,7) || '@mail.com') AS email,
    TO_VARCHAR(UNIFORM(1000000000,9999999999,RANDOM())) AS phone,
    (ARRAY_CONSTRUCT('France','Canada','USA','Maroc','Belgique')
        [UNIFORM(0,4,RANDOM())])::STRING AS country,
    DATEADD(DAY, -UNIFORM(0,365,RANDOM()), CURRENT_DATE) AS date_inscription,
    (ARRAY_CONSTRUCT('google','facebook','instagram','email','direct')
        [UNIFORM(0,4,RANDOM())])::STRING AS acquisition_source
FROM TABLE(GENERATOR(ROWCOUNT => 5000000));