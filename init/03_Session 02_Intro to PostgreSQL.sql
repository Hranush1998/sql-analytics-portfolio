CREATE DATABASE aca;

-- 01_schema.sql

-- Safety: drop if you are iterating (comment these in production)
-- DROP TABLE IF EXISTS sales CASCADE;
-- DROP TABLE IF EXISTS orders CASCADE;
-- DROP TABLE IF EXISTS products CASCADE;
-- DROP TABLE IF EXISTS customers CASCADE;
-- DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE IF NOT EXISTS employees (
  employee_id   SERIAL PRIMARY KEY,
  first_name    TEXT,
  last_name     TEXT,
  email         TEXT,
  salary        NUMERIC
);

CREATE TABLE IF NOT EXISTS customers (
  customer_id   INTEGER PRIMARY KEY,
  customer_name TEXT,
  address       TEXT,
  city          TEXT,
  zip_code      TEXT
);

CREATE TABLE IF NOT EXISTS products (
  product_id    INTEGER PRIMARY KEY,
  product_name  TEXT,
  price         NUMERIC,
  description   TEXT,
  category      TEXT
);

-- orders: include year/quarter/month as stored columns (loaded from CSV)
CREATE TABLE IF NOT EXISTS orders (
  order_id    INTEGER PRIMARY KEY,
  order_date  TIMESTAMP,
  year        INT,
  quarter     INT,
  month       TEXT
);

CREATE TABLE IF NOT EXISTS sales (
  transaction_id INTEGER PRIMARY KEY,
  order_id       INTEGER REFERENCES orders(order_id)     ON DELETE RESTRICT,
  product_id     INTEGER REFERENCES products(product_id) ON DELETE RESTRICT,
  customer_id    INTEGER REFERENCES customers(customer_id) ON DELETE RESTRICT,
  employee_id    INTEGER REFERENCES employees(employee_id) ON DELETE SET NULL,
  total_sales    NUMERIC,
  quantity       INTEGER,
  discount       NUMERIC
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_sales_order_id   ON sales(order_id);
CREATE INDEX IF NOT EXISTS idx_sales_product_id ON sales(product_id);
CREATE INDEX IF NOT EXISTS idx_sales_customer_id ON sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_date      ON orders(order_date);

SELECT * FROM public.customers LIMIT 10;

SELECT * FROM public.employees LIMIT 10;

SELECT * FROM public.orders LIMIT 10;

SELECT * FROM public.products LIMIT 10;

SELECT * FROM public.sales LIMIT 10;


-- ADD CONSTRAINT  

ALTER TABLE products
ADD CONSTRAINT chk_products_price
CHECK (price >= 0);


INSERT INTO products (product_id, product_name, price, category)
VALUES (101, 'Wireless Mouse', 24.99, 'Accessories');

INSERT INTO products (product_id, product_name, price)
VALUES (102, 'USB-C Cable', 9.99);

SELECT
  product_id,
  product_name
FROM products;

SELECT
  *
FROM sales
WHERE total_sales < 50;

UPDATE products
SET price = 49.99
WHERE product_id = 12;

DELETE FROM sales
WHERE transaction_id = 1004;

-- select and display the first 10 rows from the sales table
SELECT *
FROM sales
LIMIT 10;

-- Comment
/*
SELECT
  s.transaction_id,
  p.product_name,
  s.total_sales
FROM sales s
JOIN products p
  ON s.product_id = p.product_id
WHERE s.total_sales > 100;
*/


-- Aliasing

SELECT
  product_name AS item_name,
  price AS unit_price
FROM products;

SELECT
  s.transaction_id,
  p.product_name,
  s.total_sales
FROM sales AS s
JOIN products AS p
  ON s.product_id = p.product_id;