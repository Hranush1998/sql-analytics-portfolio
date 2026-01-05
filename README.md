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


### DDL (Data Definition Language, «язык определения данных») — это часть языка SQL, которая используется для определения, изменения и удаления структуры объектов базы данных, таких как таблицы, представления, индексы и схемы, а не сами данные внутри них. Основные команды DDL включают CREATE (создать), ALTER (изменить) и DROP (удалить). 

  ### Ключевые команды DDL

+ CREATE: Создает новый объект базы данных (например, CREATE TABLE).
  
+ ALTER: Модифицирует существующий объект (например, добавляет столбец в таблицу).

+ DROP: Удаляет объект из базы данных.

+ TRUNCATE: Удаляет все строки из таблицы, но сохраняет её структуру. 

DDL: Data Definition Language
CRUD: Data Manipulation in Practice

+ DDL
+ запрос по клиентам

```sql 
SELECT *
FROM customers
```

+ запрос определенной таблицы

```sql 
SELECT customer_name
FROM customers;
```

+ Запрос с лимитом
  
```sql
SELECT customer_name
FROM customers
LIMIT 5;
```

+ запрос с использованием where
```sql  
SELECT customer_name
FROM customers
WHERE customer_id = 7;
```

```sql
SELECT customer_name
FROM customers
WHERE customer_id = 7
LIMIT 5;
```

+ найти клиента в городе с кодом 15562
  
 ```sql 
SELECT city
FROM customers
WHERE zip_code = '15562';
```

+ продукты
  
 ```sql   
SELECT *
FROM products
LIMIT 10;
```

+ Single-Column Index (DDL) 
  
```sql 
CREATE INDEX idx_category_product_id
ON category (product_id);
```

+ где индекс? Его нет, просто быстрее находит запрос.
  
+ Важно понимать Эта команда не изменяет данные.
Она изменяет эффективность доступа базы данных к существующим данным.

-------

+ добавление ограничения (цена не может быть отрицательной) (DDL)
  
```sql 
ALTER TABLE products
ADD CONSTRAINT chk_products_price
CHECK (price >= 0);
```

+ удаляем созданный индекс без возможности вернуть (DDL)
  
```sql 
DROP INDEX idx_sales_product_id;
```

+ удаляю столбец продукты (DDL)

```sql 
DROP TABLE products;
```
+ ERROR:  cannot drop table products because other objects depend on it
constraint sales_product_id_fkey on table sales depends on table products 

+ SQL state: 2BP01
Detail: constraint sales_product_id_fkey on table sales depends on table products
Hint: Use DROP ... CASCADE to drop the dependent objects too.

---------------------

+ Удаляет все строки из таблицы, сохраняя при этом её структуру. 
  
```sql 
TRUNCATE TABLE sales_staging;
```

### CRUD: Data Manipulation in Practice

### CRUD — это аббревиатура от четырех базовых операций при работе с данными: Create (Создание), Read (Чтение), Update (Обновление/Редактирование) и Delete (Удаление). Эти операции являются основой взаимодействия с большинством приложений, баз данных и API, позволяя управлять жизненным циклом записей (добавлять, просматривать, изменять и удалять). 

### Как CRUD-операции работают:

+ Create (Создание): Добавление новой записи (например, регистрация пользователя, добавление товара). 

INSERT INTO добавить данные по продукту
  
+ Read (Чтение): Получение и просмотр существующих данных (например, профиль пользователя, список товаров).

+ Update (Обновление): Изменение существующих данных (например, редактирование профиля, изменение цены товара).

+ Delete (Удаление): Удаление записи (например, удаление аккаунта, товара). 

+ CREATE (CRUD - INSERT)
------------------------
+ Создали новую строку в таблице продукты и добавили данные по нему

```sql 
INSERT INTO products (product_id, product_name, price, category)
VALUES (101, 'Wireless Mouse', 24.99, 'Accessories');
```
+ Создали новую строку в таблице продукты и добавили данные по нему
  
```sql 
INSERT INTO products (product_id,product_name,price,category)
VALUES (129,'Wireless Mouses',24.99, 'Accessories')
```

+ NULL допускаем, что данные пустые (CRUD)
+ Вы можете опустить столбцы, допускающие NULL или имеющие значения по умолчанию.
  Когда в запросе опускаешь столбец это означает, что значение в нем будет null (NULL по category)

```sql
INSERT INTO products (product_id, product_name, price)
VALUES (102, 'USB-C Cable', 9.99);
```

+ хочу увидеть пустую ячейку NULL по category (CRUD)

```sql  
SELECT product_name,price,product_id,category
FROM products
WHERE product_name = 'USB-C Cable';
```

+ Извлекаю данные для просмотра (чтения данных)
+ READ = (SELECT) (CRUD)

```sql 
SELECT product_id, product_name
FROM products
LIMIT 10;
```

+ WHERE (CRUD)
+ Фильтрация строк осуществляется с помощью WHERE

```sql
SELECT  *
FROM sales
WHERE total_sales < 50;
```

+ UPDATE (CRUD)

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










