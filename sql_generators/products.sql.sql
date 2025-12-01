CREATE OR REPLACE TABLE stage.products AS
SELECT 
    SEQ4() + 1 AS id,
    INITCAP(SUBSTR(UUID_STRING(),1,6)) AS name,
    (ARRAY_CONSTRUCT('Vêtements','Électronique','Maison','Beauté')
        [UNIFORM(0,3,RANDOM())])::STRING AS category,
    INITCAP(SUBSTR(UUID_STRING(),1,4)) AS brand,
    ROUND(UNIFORM(10,500,RANDOM()),2) AS price,
    ROUND(UNIFORM(5,400,RANDOM()),2) AS cost
FROM TABLE(GENERATOR(ROWCOUNT => 3000));