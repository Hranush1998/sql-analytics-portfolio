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


# Session 02: Intro to PostgreSQL


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

+ обновляю конкретную строку, где product_id = 12
+ (причем данные уже должны быть загружены, чтобы их менять)
+ Важно! Обновления всегда должны быть направлены на конкретные строки 

```sql
UPDATE products
SET price = 49.99
WHERE product_id = 12;
```

```sql
UPDATE products
SET price = 51
WHERE product_id = 11;
```

+ DELETE (CRUD)
+ Данная DELETEинструкция удаляет записи из таблицы.

```sql
DELETE FROM sales
WHERE transaction_id = 1004;
```

### Mental Model to Remember

### DDL 
+ defines tables, columns, constraints, indexes
### CRUD 
+ inserts, reads, updates, deletes rows
### DML 
+ SQL language (INSERT, SELECT, UPDATE, DELETE) implementing CRUD

--------------------------------------

### Constraints
+ Ограничения определяют, какие типы данных может принимать таблица или столбец, и обычно устанавливаются при создании таблицы. 

### UNIQUE Constraint
  
+ Пример: необходимо убедиться, что каждый адрес электронной почты клиента уникален

```sql
CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  email TEXT UNIQUE,
  phone_number TEXT
);
```

### NOT NULL Constraint

+ NOT NULL ограничение гарантирует, что столбец не может содержать пустые (NULL) значения 

+ Пример: убедиться, что у каждого клиента есть номер телефона.
  
```sql
CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  phone_number TEXT NOT NULL,
  email TEXT
);
```

### PRIMARY KEY Constraint

+ Идентификатор PRIMARY KEYоднозначно определяет каждую строку в таблице.
+ Ограничение PRIMARY KEY автоматически обеспечивает соблюдение как , так UNIQUEи NOT NULL.
  
+ Пример: определить первичный ключ для таблицы товаров. 

```sql
CREATE TABLE products (
  product_id INTEGER PRIMARY KEY,
  product_name TEXT NOT NULL,
  price NUMERIC(10, 2)
);
```

### FOREIGN KEY Constraint

+ FOREIGN KEY устанавливает связь между двумя таблицами, ссылаясь на первичный ключ другой таблицы.

+ Foreign Key (Внешний ключ) — это столбец (или набор столбцов) в одной таблице базы данных, который ссылается на первичный ключ (PRIMARY KEY) другой таблицы, устанавливая между ними связь для обеспечения целостности данных (ссылочной целостности). Он гарантирует, что значения в дочерней таблице (с внешним ключом) соответствуют существующим записям в родительской таблице (с первичным ключом), предотвращая некорректные данные.

#### Ключевые моменты:

+ Связующий элемент: Внешний ключ — это "мост" между двумя таблицами, позволяющий извлекать связанные данные.

+ Целостность данных: Он не позволяет вставить в дочернюю таблицу запись, ссылающуюся на несуществующий первичный ключ в родительской таблице.

+ Пример: В таблице Заказы поле customer_id может быть внешним ключом, ссылающимся на id клиента в таблице Клиенты. Это значит, что каждый заказ должен быть связан с существующим клиентом.

+ Синтаксис (SQL): Создается с помощью оператора FOREIGN KEY и REFERENCES.
  
+ Действия: Можно настроить каскадное удаление (ON DELETE CASCADE) или обновление (ON UPDATE CASCADE), чтобы изменения в родительской таблице автоматически отражались в дочерней.

+ Пример: связать записи о продажах с клиентами.

```sql
CREATE TABLE sales (
  transaction_id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  total_sales NUMERIC(10, 2),
  FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
);
```

+ С учетом этого ограничения вы не сможете добавить продажу для клиента, которого нет в customers таблице. 

### CHECK Constraint

+ Ограничение CHECK определяет диапазон или условия значений, которые могут быть вставлены в столбец.

```sql
CREATE TABLE sales (
  transaction_id INTEGER PRIMARY KEY,
  total_sales NUMERIC(10, 2) CHECK (total_sales >= 0)
);
```

# Сессия 03: Анализ данных с помощью SQL | Часть I

+ Первое и самое важное, что нужно понять, это то, что SQL — это декларативный язык программирования .

+ Это означает:
+ Вы указываете базе данных, какой результат хотите получить.
+ Вы не указываете, как получить этот результат.

+ Что такое план запроса?
+ План запроса показывает, как база данных намерена выполнить SQL-запрос.

```sql
EXPLAIN
SELECT *
FROM sales;
```

+ Писать эффективные запросы к базе данных, чтобы анализировать только нужную часть данных, критически важно для снижения нагрузки на сервер, экономии ресурсов и повышения производительности системы в целом. Вместо полного сканирования таблиц, следует использовать фильтрацию (WHERE), ограничение количества строк (LIMIT), правильные соединения (JOIN), индексы и оптимизированные конструкции. 

+ Рассмотри разницу между запросами
   
```sql
EXPLAIN
SELECT *
FROM products;
```

```sql
EXPLAIN 
SELECT product_name, price
FROM products;
```
----------------------------------------

### ORDER BY

+ Этот ORDER BY пункт сортирует результаты запроса в порядке возрастания или убывания .

+ Направление сортировки можно явно задать с помощью следующих параметров:
+ ASC в порядке возрастания
+ DESC в порядке убывания
  
```sql
SELECT product_name,
		category
FROM 	products
ORDER BY product_name ASC;
```

```sql
SELECT
  product_name,
  price
FROM products
ORDER BY price DESC;
```

```sql
SELECT
  product_name,
  category,
  price
FROM products
ORDER BY category ASC, price DESC;
```

### итоги:

1. ORDER BY применяется после SELECT и FROM
2. По умолчанию сортировка осуществляется по возрастанию.
3. Используйте DESCдля обратного порядка
4. Текстовые столбцы отсортированы в алфавитном порядке.
5. Числовые столбцы сортируются по значению.
6. Для более точного контроля можно объединить несколько колонок.

------------- 

### LIMIT

+ Предположим, вам нужно получить названия товаров и цены, отсортированные по цене от самой высокой до самой низкой, но вас интересуют только 10 самых дорогих товаров

```sql
SELECT
  product_name,
  price
FROM products
ORDER BY price DESC
LIMIT 10;
```
----------------------------

### GROUP BY

+ Данный GROUP BY пункт позволяет группировать строки, имеющие одинаковые значения в одном или нескольких столбцах.
+ Она обычно используется вместе с агрегатными функциями для обобщения данных (max, min, sum, avg, count).

+ Предположим, вы хотите рассчитать общий объем продаж по каждому товару (LIMIT 10).

```sql
SELECT
	product_id,
	SUM (total_sales) AS total_revenue
FROM sales
GROUP BY product_id
LIMIT 10;
```

----------------------------------

### MIX

```sql
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;
```
--------------------------
+ Этот запрос возвращает категорию для каждого товара , которая может содержать множество дубликатов. Если вам нужно узнать только, какие категории существуют , GROUP BY то это подходящий инструмент. 

```sql
SELECT 
  category
FROM products;
```
+ В результате получается краткое резюме различных категорий товаров, хранящихся в базе данных. 
  
```sql
SELECT 
  category
  COUNT (*)
FROM products
GROUP BY category;
```
+ сколько транзакций продаж существует по каждому продукту
  

```sql
SELECT
  product_id,
  COUNT(transaction_id) AS number_of_transactions
FROM sales
GROUP BY product_id;
```
+ Общий доход по каждому продукту
  
```sql  
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id;
```
+ Средняя цена по категориям
  
```sql
SELECT
  category,
  AVG(price) AS average_price
FROM products
GROUP BY category;
```
+ сколько транзакций продаж существует для каждой комбинации товара и employee_id (позже мы получим имя сотрудника) 

```sql
SELECT
  product_id,
  COUNT(transaction_id) AS transaction_count
FROM sales
GROUP BY product_id,
ORDer BY COUNT(transaction_id) DESC;
```

### DISTINCT

+ Это DISTINCT ключевое слово используется для возврата уникальных значений из столбца или комбинации столбцов.
Оно особенно полезно, когда набор данных содержит повторяющиеся значения, и вы хотите понять, какие уникальные категории или комбинации присутствуют в данных. (Убрать дубликаты).

+ Предположим, вы хотите увидеть все уникальные категории товаров в productsтаблице.
  
```sql
SELECT DISTINCT category
FROM products;
```
+ Например, чтобы найти уникальные комбинации категории товара и цены:
  
```sql  
SELECT DISTINCT
  category,
  price
FROM products;
```

### DISTINCT с COUNT

+ Показывает количество строк и количество категорий
  
```sql  
SELECT DISTINCT
  COUNT(category)
  COUNT(DISTINCT category),
FROM products;
```

+ Во многих случаях DISTINCT & GROUP BY может дать тот же результат, даже если агрегатные функции не используются.
  
```sql  
SELECT DISTINCT
  category,
  price
FROM products;
```

```sql
SELECT
  category,
  price
FROM products
GROUP BY category, price;
```

+ Как вы думаете, какая команда быстрее: GROUP BYили DISTINCT?

+ Используйте эту функцию EXPLAINдля генерации планов выполнения обоих запросов и сравнения их предполагаемой стоимости, чтобы определить, какой из них будет работать эффективнее PostgreSQL.

-------------------------------------
### HAVING

+ Он работает с агрегированными значениями, а не с необработанными строками.

+ Представьте себе выполнение SQL-запросов как конвейер.

1. Сначала фильтруются исходные строки.
2. Затем строки группируются.
3. Совокупные показатели рассчитываются
4. При необходимости группы фильтруются повторно.

+ Это приводит к четкому разделению обязанностей:

1. WHERE  - фильтрация на уровне строк
2. GROUP BY - группировка данных
3. HAVING  - фильтрация на уровне группы

 -------------------------------

 + Предположим, вы хотите определить товары, которые принесли более 10 000 долларов общей выручки .

 ```sql
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
HAVING SUM(total_sales) > 10000;
```

+ where + having
+ WHERE удаляет ненужные строки на раннем этапе
+ HAVING Применяет бизнес-правила после агрегации

 ```sql
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
WHERE total_sales > 0
GROUP BY product_id
HAVING SUM(total_sales) > 10000;
```
+ Пример: найти товары, по которым совершено не менее 50 транзакций .
  
  ```sql 
SELECT product_id,
COUNT (transaction_id) AS транзакция
FROM sales
GROUP BY product_id
HAVING COUNT(transaction_id) >= 50;
	```
+ Несколько агрегированных условий можно комбинировать с помощью логических операторов.
   
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










