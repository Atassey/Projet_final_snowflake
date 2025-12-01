
CREATE OR REPLACE TABLE stage.orders CLUSTER BY(order_date) AS
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