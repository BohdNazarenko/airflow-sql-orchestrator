CREATE SCHEMA IF NOT EXISTS shop; --create tables in folder retail (instead of public)

CREATE TYPE shop.payment_method AS ENUM
    ('card', 'cash', 'mixed', 'lidl_plus');

CREATE TABLE IF NOT EXISTS shop.store
(
    store_id  BIGSERIAL PRIMARY KEY,
    address   TEXT    NOT NULL UNIQUE,
    city      TEXT    NOT NULL,
    opens_at  TIME(0) NOT NULL,
    closes_at TIME(0) NOT NULL,
    timezone  TEXT    NOT NULL DEFAULT 'Europe/Warsaw'
);

CREATE TABLE IF NOT EXISTS shop.customer
(
    customer_id BIGSERIAL PRIMARY KEY,
    full_name   TEXT,
    email       TEXT UNIQUE,
    birth_date  DATE,
    created_at  TIMESTAMP,
    CHECK (email IS NULL OR email ~ '^[^@]+@[^@]+\.[^@]+$')
);

CREATE TABLE IF NOT EXISTS shop.sales
(
    sale_id        BIGSERIAL PRIMARY KEY,
    store_id       BIGINT                REFERENCES shop.store (store_id) ON DELETE SET NULL,
    customer_id    BIGINT                REFERENCES shop.customer (customer_id) ON DELETE SET NULL,
    sale_ts        TIMESTAMPTZ           NOT NULL DEFAULT now(),
    total_amount   NUMERIC(12, 2),
    payment_method shop.payment_method NOT NULL DEFAULT 'card'
);

























