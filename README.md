# BigData Journey — Airflow SQL Runner

Мини-проект: Airflow ежедневно в 09:00 выполняет все *.sql из папки и пишет метрики в витрины dm.*.

Аналитики кладут свои скрипты в sources/ — DAG подхватывает их сам.

**Что внутри:**

	•	Airflow (webserver, scheduler, worker) + CeleryExecutor
	•	Redis — брокер задач
	•	Postgres (postgres) — метабаза Airflow
	•	Postgres (pg_shop) — рабочая БД магазина (данные/витрины)
	•	DAG daily_sql_runner — читает SQL из sources/ и гоняет по алфавиту каждый день в 09:00

**Требования:**

    •	Docker + Docker Compose
    •	Свободные порты: 8080 (Airflow UI), 5433 (pg_shop наружу)

**Структура проекта:**

    project-root/
    ├─ docker-compose.yml
    ├─ dags/
    │  ├─ daily_sql_runner.py      # DAG: выполняет *.sql из sources/
    │  └─ hello_world.py           # демо-DAG (не обязателен)
    ├─ sources/                    # сюда аналитики кладут ежедневные .sql
    │  ├─ 01_customer_behavior_analise.sql
    │  └─ 02_sales_analise.sql
    ├─ sql_initialise_scripts/     # разовые скрипты инициализации БД
    │  ├─ create_db.sql
    │  ├─ create_tables.sql
    │  └─ initial_db.sql
    ├─ plugins/                    # (опционально) свои плагины Airflow
    └─ logs/                       # логи Airflow (монтируются в контейнер)


В docker-compose.yml папка ./sources смонтирована в контейнер как /opt/airflow/sources, а DAG берёт путь из ENV SQL_DIR=/opt/airflow/sources.

Как запустить

1. В начале вводим команду:

`docker build -t airflow-with-java .`

а после загрузки: `docker-compose up --build`

2.	Зайдите в Airflow UI: http://localhost:8080

логин/пароль по умолчанию: airflow / airflow.

3.	Создайте Connection к БД магазина (если ещё не создан):

Через UI: Admin → Connections → +

	•	Conn Id: shop_pg
	•	Conn Type: Postgres
	•	Host: pg_shop
	•	Port: 5432
	•	Schema/Database: shop_analytics  (или retail, если данные у вас в этой базе)
	•	Login: shop_user
	•	Password: shop_password

4. 	Запустить DAG вручную (кнопка Trigger DAG в UI) — для проверки.

Как работает daily_sql_runner

	•	Берёт путь к SQL из ENV SQL_DIR (по умолчанию /opt/airflow/sources).
	•	Собирает все *.sql, сортирует по имени (01_*.sql, 02_*.sql, …).
	•	Передаёт имя файла оператору, а оператор сам читает файл из template_searchpath и подставляет Jinja-переменные ({{ ds }} и т.п.).
	•	Выполняет последовательно. В конце — короткое уведомление в лог.

Где класть SQL и как их писать

	•	Кладите файлы в sources/, называйте с префиксом порядка:
	•	01_customer_behavior_analise.sql
	•	02_sales_analise.sql

#### Где смотреть результат

1.	В UI Airflow

	•	DAGs → daily_sql_runner → Grid/Graph — статусы тасок.
	•	Клик по таску → Log (выполненный SQL), Rendered (как подставился {{ ds }}).

2. В БД

    `SELECT * FROM dm.daily_customer_metrics ORDER BY d DESC;`
    `SELECT * FROM dm.daily_sales_totals  ORDER BY d DESC;`
