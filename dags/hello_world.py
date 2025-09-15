from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.dummy import DummyOperator
from airflow.utils.trigger_rule import TriggerRule
from datetime import datetime

def hello_world():
    print("Hello World!")

with DAG(
    'branching_dag',
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
) as dag:
    branch = PythonOperator(
        task_id='branch_logic',
        python_callable=hello_world
    )

branch