ALTER SESSION SET USE_CACHED_RESULT = FALSE;

USE DATABASE FASHIONHUB;
USE SCHEMA FAKE_DATA;


-- Warehouse très petit

CREATE OR REPLACE WAREHOUSE WH_XS
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

-- Warehouse petit

CREATE OR REPLACE WAREHOUSE WH_S
WITH WAREHOUSE_SIZE = 'SMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

-- Warehouse moyen

CREATE OR REPLACE WAREHOUSE WH_M
WITH WAREHOUSE_SIZE = 'MEDIUM'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

-- Warehouse grand

CREATE OR REPLACE WAREHOUSE WH_L
WITH WAREHOUSE_SIZE = 'LARGE'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

------------------------------------------------------------------------------------------
SHOW WAREHOUSES;

USE WAREHOUSE WH_XS;

SELECT 
  country,
  COUNT(*) AS nb_clients
FROM fake_data.customers
GROUP BY country
ORDER BY nb_clients DESC; --Q1 XS

USE WAREHOUSE WH_M;

SELECT 
  country,
  COUNT(*) AS nb_clients
FROM fake_data.customers
GROUP BY country
ORDER BY nb_clients DESC; --Q1 M

--------------------------------------------------------------------------------------------------

USE WAREHOUSE WH_S;

SELECT 
  c.country,
  DATE_TRUNC('month', o.order_date) AS month,
  SUM(oi.quantity * oi.unit_price) AS total_revenue,
  COUNT(DISTINCT o.id) AS nb_orders
FROM fake_data.orders o
JOIN fake_data.order_items oi ON o.id = oi.order_id
JOIN fake_data.customers c    ON c.id = o.customer_id
GROUP BY c.country, DATE_TRUNC('month', o.order_date)
ORDER BY month, total_revenue DESC; --Q2 S


USE WAREHOUSE WH_M;


SELECT 
  c.country,
  DATE_TRUNC('month', o.order_date) AS month,
  SUM(oi.quantity * oi.unit_price) AS total_revenue,
  COUNT(DISTINCT o.id) AS nb_orders
FROM fake_data.orders o
JOIN fake_data.order_items oi ON o.id = oi.order_id
JOIN fake_data.customers c    ON c.id = o.customer_id
GROUP BY c.country, DATE_TRUNC('month', o.order_date)
ORDER BY month, total_revenue DESC; --Q2 M



----------------------------------------------------------------------------------------------


USE WAREHOUSE WH_M;

SELECT 
  customer_id,
  event_time::date AS event_date,
  event_data:"page"::string    AS page,
  event_data:"device"::string  AS device,
  event_data:"duration_seconds"::number AS duration
FROM fake_data.clickstream_events
WHERE event_data:"page"::string IN ('products','checkout')
  AND event_time >= DATEADD(day,-7,current_timestamp())
ORDER BY duration DESC; --Q3 M



USE WAREHOUSE WH_L;


SELECT 
  customer_id,
  event_time::date AS event_date,
  event_data:"page"::string    AS page,
  event_data:"device"::string  AS device,
  event_data:"duration_seconds"::number AS duration
FROM fake_data.clickstream_events
WHERE event_data:"page"::string IN ('products','checkout')
  AND event_time >= DATEADD(day,-7,current_timestamp())
ORDER BY duration DESC; --Q3 l






-----------------------------------------------------------------------------------------______________________


USE WAREHOUSE WH_S;

SELECT 
  COUNT(*)
FROM fake_data.orders; --MP1


USE WAREHOUSE WH_S;

SELECT 
  COUNT(*)
FROM fake_data.orders
WHERE order_date >= DATEADD(day, -30, CURRENT_DATE); --MP2













