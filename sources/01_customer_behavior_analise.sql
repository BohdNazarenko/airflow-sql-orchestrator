CREATE SCHEMA IF NOT EXISTS dm;

CREATE TABLE IF NOT EXISTS dm.daily_customer_metrics (
  d DATE PRIMARY KEY,
  new_customers      INT NOT NULL,
  active_customers   INT NOT NULL,
  first_time_buyers  INT NOT NULL,
  returning_buyers   INT NOT NULL
);

INSERT INTO dm.daily_customer_metrics AS t
(d, new_customers, active_customers, first_time_buyers, returning_buyers)
SELECT
  '{{ ds }}'::date AS d,

  -- 1) New registrations on this day
  (SELECT COUNT(*) FROM shop.customer c
   WHERE c.created_at::date = '{{ ds }}'::date) AS new_customers,

  -- 2) Bought at least once that day
  (SELECT COUNT(DISTINCT s.customer_id) FROM shop.sales s
   WHERE s.sale_ts::date = '{{ ds }}'::date) AS active_customers,

  -- 3) The first purchase in my life happened today
  (SELECT COUNT(DISTINCT s.customer_id)
     FROM shop.sales s
     WHERE s.sale_ts::date = '{{ ds }}'::date
       AND NOT EXISTS (
         SELECT 1 FROM shop.sales prev
         WHERE prev.customer_id = s.customer_id
           AND prev.sale_ts::date < '{{ ds }}'::date
       )
  ) AS first_time_buyers,

  -- 4) returns = active - first time buyers
  (
    (SELECT COUNT(DISTINCT s.customer_id) FROM shop.sales s
     WHERE s.sale_ts::date = '{{ ds }}'::date)
    -
    (SELECT COUNT(DISTINCT s.customer_id)
       FROM shop.sales s
       WHERE s.sale_ts::date = '{{ ds }}'::date
         AND NOT EXISTS (
           SELECT 1 FROM shop.sales prev
           WHERE prev.customer_id = s.customer_id
             AND prev.sale_ts::date < '{{ ds }}'::date
         )
    )
  ) AS returning_buyers
ON CONFLICT (d) DO UPDATE
SET new_customers     = EXCLUDED.new_customers,
    active_customers  = EXCLUDED.active_customers,
    first_time_buyers = EXCLUDED.first_time_buyers,
    returning_buyers  = EXCLUDED.returning_buyers;