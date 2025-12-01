CREATE OR REPLACE TABLE stage.product_reviews AS
SELECT 
    SEQ4()+1 AS review_id,
    UNIFORM(1,3000,RANDOM()) AS product_id,
    UNIFORM(1,5,RANDOM()) AS rating,
    DATEADD(DAY, -UNIFORM(0,60,RANDOM()), CURRENT_DATE) AS review_date,
    OBJECT_CONSTRUCT(
        'comment',  (ARRAY_CONSTRUCT('Bon produit','Moyen','Excellent','Pas satisfait')
                      [UNIFORM(0,3,RANDOM())])::STRING,
        'language', (ARRAY_CONSTRUCT('fr','en','es')
                      [UNIFORM(0,2,RANDOM())])::STRING
    ) AS review_data
FROM TABLE(GENERATOR(ROWCOUNT => 20000));