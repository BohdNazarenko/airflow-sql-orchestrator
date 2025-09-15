# dags/daily_sql_runner.py
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python import PythonOperator
import pendulum, glob, os, pathlib, logging

# === ENV from docker-compose ===
SQL_DIR = os.environ.get("SQL_DIR", "/opt/airflow/sources")   # .sql on docker place
SQL_CONN_ID = os.environ.get("SQL_CONN_ID", "shop_pg")          # Conn Id in Airflow

local_tz = pendulum.timezone("Europe/Warsaw")
today = pendulum.today("Europe/Warsaw")

def _notify(**ctx):
    logging.info("Daily SQL finished for %s", ctx["ds"])

def _no_files(**ctx):
    logging.warning("No .sql files found in %s", SQL_DIR)

with DAG(
    dag_id="daily_sql_runner",
    start_date=pendulum.datetime(today.year, today.month, today.day, tz=local_tz),  # старт — день создания
    schedule="0 9 * * *",          # every day at 09:00
    catchup=False,
    tags=["mvp", "sql"],
    template_searchpath=[SQL_DIR],
) as dag:

    sql_paths = sorted(glob.glob(os.path.join(SQL_DIR, "*.sql")))
    prev = None

    if not sql_paths:
        prev = PythonOperator(task_id="no_sql_files", python_callable=_no_files)

    for full_path in sql_paths:
        # file name without path
        fname = pathlib.Path(full_path).name

        task_id = "run_" + pathlib.Path(fname).stem.replace(".", "_").replace("-", "_")

        t = PostgresOperator(
            task_id=task_id,
            postgres_conn_id=SQL_CONN_ID,
            sql=fname,                     # file name
        )

        if prev:
            prev >> t
        prev = t

    notify = PythonOperator(task_id="notify", python_callable=_notify)
    if prev:
        prev >> notify