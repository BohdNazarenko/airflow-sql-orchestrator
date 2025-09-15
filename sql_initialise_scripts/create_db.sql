SELECT current_user; --to see your username (when you connect to db you write it on user field)

CREATE DATABASE retail    --create database with name
    WITH OWNER shop_user    --choose owner name
    ENCODING 'UTF8'     --encoding of the new database.
    TEMPLATE template0; --This is a "template1" database from which every new database in a PostgreSQL cluster is copied by default.


DROP DATABASE shop_analytics;