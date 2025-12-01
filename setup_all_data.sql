CREATE OR REPLACE DATABASE fashionhub;
USE DATABASE fashionhub;

CREATE OR REPLACE SCHEMA core;
CREATE OR REPLACE SCHEMA Data;
CREATE OR REPLACE SCHEMA marts;


CREATE OR REPLACE TABLE data.customers AS
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

------------------------------------------------------------------

CREATE OR REPLACE TABLE data.products AS
SELECT 
    SEQ4() + 1 AS id,
    INITCAP(SUBSTR(UUID_STRING(),1,6)) AS name,
    (ARRAY_CONSTRUCT('Vêtements','Électronique','Maison','Beauté')
        [UNIFORM(0,3,RANDOM())])::STRING AS category,
    INITCAP(SUBSTR(UUID_STRING(),1,4)) AS brand,
    ROUND(UNIFORM(10,500,RANDOM()),2) AS price,
    ROUND(UNIFORM(5,400,RANDOM()),2) AS cost
FROM TABLE(GENERATOR(ROWCOUNT => 3000));

--------------------------------------------------------------
CREATE OR REPLACE TABLE data.orders CLUSTER BY(order_date) AS
SELECT
    SEQ4()+1 AS id,
    UNIFORM(1,5000000,RANDOM()) AS customer_id,
    DATEADD(DAY, -UNIFORM(0,180,RANDOM()), CURRENT_DATE) AS order_date,
    (ARRAY_CONSTRUCT('PENDING','SHIPPED','CANCELLED','COMPLETED')
        [UNIFORM(0,3,RANDOM())])::STRING AS status,
    ROUND(UNIFORM(20,1000,RANDOM()),2) AS amount,
    (ARRAY_CONSTRUCT('credit_card','paypal','stripe','bank_transfer')
        [UNIFORM(0,3,RANDOM())])::STRING AS payment_method
FROM TABLE(GENERATOR(ROWCOUNT => 12000000));

---------------------------------------------------------------------


CREATE OR REPLACE TABLE data.order_items AS
SELECT 
    SEQ4()+1 AS id,
    UNIFORM(1,12000000,RANDOM()) AS order_id,
    UNIFORM(1,3000,RANDOM()) AS product_id,
    UNIFORM(1,5,RANDOM()) AS quantity,
    ROUND(UNIFORM(10,500,RANDOM()),2) AS unit_price
FROM TABLE(GENERATOR(ROWCOUNT => 1000000));

-----------------------------------------------------------------

CREATE OR REPLACE TABLE data.clickstream_events (
    event_id        BIGINT,
    customer_id     BIGINT,
    event_time      TIMESTAMP,
    event_data      VARIANT
)
CLUSTER BY (event_time);



-------------------------------------------------------------------

CREATE OR REPLACE TABLE data.product_reviews (
    review_id     BIGINT,
    product_id    BIGINT,
    rating        INT,
    review_date   DATE,
    review_data   VARIANT
);



---------------------------------------------------------------


CREATE OR REPLACE TABLE data.api_logs (
    log_id       BIGINT,
    log_time     TIMESTAMP,
    log_data     VARIANT
)
CLUSTER BY (log_time);






create schema stages; 


CREATE OR REPLACE STAGE stages.internal_stage;



CREATE OR REPLACE FILE FORMAT json_ff TYPE = 'JSON';
CREATE OR REPLACE FILE FORMAT csv_ff TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"';


COPY INTO data.clickstream_events
FROM (
  SELECT
    $1:event_id::NUMBER              AS event_id,
    $1:customer_id::NUMBER           AS customer_id,
    TO_TIMESTAMP_NTZ($1:event_time::STRING) AS event_time,
    $1:event_data                    AS event_data
  FROM @stages.internal_stage/clickstream_events.jsonl
    (FILE_FORMAT => 'json_ff')
);


COPY INTO data.product_reviews
(review_id, product_id, rating, review_date, review_data)
FROM @stages.internal_stage/product_reviews.csv
FILE_FORMAT = (FORMAT_NAME = 'csv_ff');

COPY INTO data.api_logs
FROM (
  SELECT
    $1:log_id::NUMBER                    AS log_id,
    TO_TIMESTAMP_NTZ($1:log_time::STRING) AS log_time,
    $1:log_data                          AS log_data
  FROM @stages.internal_stage/api_logs.jsonl
    (FILE_FORMAT => 'json_ff')
);















