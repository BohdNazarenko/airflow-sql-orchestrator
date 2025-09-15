CREATE SCHEMA IF NOT EXISTS dm;

CREATE TABLE IF NOT EXISTS dm.daily_sales_totals (
  d DATE PRIMARY KEY,
  orders_count  INT NOT NULL,
  gross_revenue NUMERIC(12,2) NOT NULL,
  avg_check     NUMERIC(12,2) NOT NULL,
  pm_card       INT NOT NULL,
  pm_cash       INT NOT NULL,
  pm_mixed      INT NOT NULL,
  pm_lidl_plus  INT NOT NULL
);

-- Analise daily sales by count and payment type
INSERT INTO dm.daily_sales_totals AS t
(d, orders_count, gross_revenue, avg_check,
 pm_card, pm_cash, pm_mixed, pm_lidl_plus)
SELECT
  '{{ ds }}'::date AS d,
  COUNT(*) AS orders_count,
  COALESCE(SUM(total_amount), 0)::NUMERIC(12,2) AS gross_revenue,
  CASE WHEN COUNT(*) > 0
       THEN ROUND(COALESCE(SUM(total_amount),0) / COUNT(*), 2)
       ELSE 0::NUMERIC(12,2) END AS avg_check,
  COUNT(*) FILTER (WHERE payment_method = 'card'::shop.payment_method)      AS pm_card,
  COUNT(*) FILTER (WHERE payment_method = 'cash'::shop.payment_method)      AS pm_cash,
  COUNT(*) FILTER (WHERE payment_method = 'mixed'::shop.payment_method)     AS pm_mixed,
  COUNT(*) FILTER (WHERE payment_method = 'lidl_plus'::shop.payment_method) AS pm_lidl_plus
FROM shop.sales
WHERE sale_ts::date = '{{ ds }}'::date
ON CONFLICT (d) DO UPDATE
SET orders_count  = EXCLUDED.orders_count,
    gross_revenue = EXCLUDED.gross_revenue,
    avg_check     = EXCLUDED.avg_check,
    pm_card       = EXCLUDED.pm_card,
    pm_cash       = EXCLUDED.pm_cash,
    pm_mixed      = EXCLUDED.pm_mixed,
    pm_lidl_plus  = EXCLUDED.pm_lidl_plus;