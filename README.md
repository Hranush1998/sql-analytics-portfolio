# sql-analytics-portfolio

# Чему я научилась?

## Программы

1. Visual Studio code
* VS работа с файлами
2. Docker desctop 
  * (компьютер) мой сервис
3. GitHub 
* мой профиль (портфолио)

## Процесс

- Создать учетную запись и установить программы.
- Понять работу программ, что для чего необходимо.
- Создать репозиторий, соединить с компьютером.
- Добавить базу данных.
- Сделать первый запрос. 
  

## Основные команды [^1]. 

```git add```
```git commit -m ""```
```git push```

[^1]: добавление файла, комментирование, соединение.

## План работы

+ git clone → edit → git add → git commit → git push

1. Создать базу данных
- создать новый репозиторий в учетной записе.
- скопировать репозиторий на свой компьютер.

```git clone https://github.com/username/myrepo.git```

- создать файл локально. 

2. Добавить данные в папку data (база данных).
3. init добавить готовые коды, для содание таблиц с соответвующими типами данных.
4. env общие сведения об учетной записи.
5. gitignore игнорирование определенных данных.
6. docker-compose.yaml установить связь между Docker Desktop и Visual Studio Code.

## Ознакомление с платформой *pgAdmin*
   
   http://localhost:5050/login?next=/browser/

   - введение первого запроса.
   - data output.

И на конец, чтобы не загружать компьютер сервера можно отключать и включать. 

```docker compose up -d```
```docker compose down```


# Session 03: Data Analysis with SQL | Part I

DDL: Data Definition Language
CRUD: Data Manipulation in Practice

+ DDL
+ запрос по клиентам

```sql 
SELECT *
FROM customers
```

+ запрос определенной таблицы

SELECT customer_name
FROM customers;

+ запрос с использованием where
  
SELECT customer_name
FROM customers
WHERE customer_id = 7;

+ найти клиента в городе с кодом 15562
  
SELECT city
FROM customers
WHERE zip_code = '15562';

+ продукты
  
SELECT *
FROM products;

+ Single-Column Index (DDL) (использовать индекс для сортировки category)
 + ???
  
CREATE INDEX idx_category_product_id
ON category (product_id);

+ заказы
  
SELECT *
FROM orders;

+ Ошибка
+ Single-Column Index (DDL)
  
CREATE INDEX idx_month_orders
ON month (order_id);

+ Продажи
  
SELECT *
FROM sales;

+ уже существует (DDL)
  
CREATE INDEX idx_sales_product_id
ON sales (product_id);
+ где индекс? Его нет, просто быстрее находит запрос.

SELECT *
FROM sales;

+ добавление ограничения (цена не может быть отрицательной) (DDL)
  
ALTER TABLE products
ADD CONSTRAINT chk_products_price
CHECK (price >= 0);

+ удаляем созданный индекс без возможности вернуть (DDL)
  
DROP INDEX idx_sales_product_id;

+ удаляю столбец продукты (DDL)
+ ERROR:  cannot drop table products because other objects depend on it
  
constraint sales_product_id_fkey on table sales depends on table products

+ не дает удалить данные привязанны

DROP TABLE products;
--изменить структуру (DDL)
--ошибка у нас нет такой таблицы

TRUNCATE TABLE sales_staging;
--CRUD
--CREATE (CRUD - INSERT)

-- Создали новую строку в таблице продукты и добавили данные по нему
INSERT INTO products (product_id, product_name, price, category)
VALUES (101, 'Wireless Mouse', 24.99, 'Accessories');

-- NULL допускаем, что данные пустые (CRUD)
INSERT INTO products (product_id, product_name, price)
VALUES (102, 'USB-C Cable', 9.99);

--хочу увидеть пустую ячейку NULL по category (CRUD)
SELECT product_name,price,product_id,category
FROM products
WHERE product_name = 'USB-C Cable';

--Извлекаю данные для просмотра (чтения данных)
--READ (SELECT) (CRUD)
SELECT product_id, product_name
FROM products;

-- WHERE (CRUD)
SELECT  *
FROM sales
WHERE total_sales < 50;
UPDATE (CRUD)

--обновляю конкретную строку, где product_id = 12
--(причем данные уже должны быть загружены, чтобы их менять)
UPDATE products
SET price = 49.99
WHERE product_id = 12;

--DELETE (CRUD)

DELETE FROM sales
WHERE transaction_id = 1004;

--Все связи уже установлены и определены ключи
--Constraints
--UNIQUE Constraint
--ERROR:  relation "customers" already exists

CREATE TABLE customers ( customer_id INTEGER PRIMARY KEY,
email TEXT UNIQUE, phone_number TEXT);
--NOT NULL Constraint
-- ERROR:  relation "customers" already exists
CREATE TABLE customers ( customer_id INTEGER PRIMARY KEY,
  phone_number TEXT NOT NULL, email TEXT);
--PRIMARY KEY Constraint
CREATE TABLE products ( product_id INTEGER PRIMARY KEY,
  product_name TEXT NOT NULL,
  price NUMERIC(10, 2)
);
--FOREIGN KEY Constraint
CREATE TABLE sales (
  transaction_id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  total_sales NUMERIC(10, 2),
  FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
);
--CHECK Constraint
CREATE TABLE sales (
  transaction_id INTEGER PRIMARY KEY,
  total_sales NUMERIC(10, 2) CHECK (total_sales >= 0)
);



## Анализ данных ЧАСТЬ I

ORDER BY

EXPLAIN
SELECT *
FROM sales;

EXPLAIN
SELECT *
FROM products;

EXPLAIN 
SELECT product_name, price
FROM products;

SELECT product_name,
		category
FROM 	products
ORDER BY product_name ASC;

SELECT
  product_name,
  price
FROM products
ORDER BY price DESC;

SELECT
  product_name,
  category,
  price
FROM products
ORDER BY category ASC, price DESC;

-- LIMIT

SELECT
  product_name,
  price
FROM products
ORDER BY price DESC
LIMIT 10;


-- GROUP BY

SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id;

-- MIX

SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;


SELECT 
  category
FROM products;

SELECT 
  category
  COUNT (*)
FROM products
GROUP BY category;

SELECT
  product_id,
  COUNT(transaction_id) AS number_of_transactions
FROM sales
GROUP BY product_id;


SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id;


SELECT
  category,
  AVG(price) AS average_price
FROM products
GROUP BY category;


SELECT
  product_id,
  COUNT(transaction_id) AS transaction_count
FROM sales
GROUP BY product_id,
ORDer BY COUNT(transaction_id) DESC;

-- DISTINCT

SELECT DISTINCT category
FROM products;

SELECT DISTINCT
  category,
  price
FROM products;


-- DISTINCT с COUNT

SELECT DISTINCT
  COUNT(category)
  COUNT(DISTINCT category),
FROM products;


SELECT DISTINCT
  category,
  price
FROM products;

SELECT
  category,
  price
FROM products
GROUP BY category, price;

--HAVING
--Он работает с агрегированными значениями, а не с необработанными строками.

SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
HAVING SUM(total_sales) > 10000;


-- where + having

SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
WHERE total_sales > 0
GROUP BY product_id
HAVING SUM(total_sales) > 10000;

SELECT product_id,
COUNT (transaction_id) AS транзакция
FROM sales
GROUP BY product_id
HAVING COUNT(transaction_id) >= 50;
	
SELECT
  product_id,
  COUNT(transaction_id) AS transaction_count,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
HAVING
  COUNT(transaction_id) >= 50
  AND SUM(total_sales) > 10000;


## Упражнение 
+ Задание 1

ALTER TABLE customers
ADD CONSTRAINT uq_customers_email UNIQUE (email);

ALTER TABLE customers
ALTER COLUMN phone_number SET NOT NULL;


ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price >= 0);

ALTER TABLE sales
ADD CONSTRAINT chk_sales_total CHECK (total_sales >= 0);

+ Задание 2

ALTER TABLE sales
ADD COLUMN sales_channel TEXT;

ALTER TABLE sales
ADD CONSTRAINT chk_sales_channel
CHECK (sales_channel IN ('online', 'store'));

UPDATE sales
SET sales_channel = 'online'
WHERE transaction_id % 2 = 0;

+ WHERE transaction_id % 2 = 0 Фильтрует строки, применяя обновление только к тем, у которых остаток от transaction_idделения на 2 равен 0 (т. е., четные идентификаторы).  

SELECT *
FROM sales
WHERE transaction_id % 2 = 0

+ Задание 3

CREATE INDEX idx_sales_product_id
ON sales (product_id);










