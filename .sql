Session 03: Data Analysis with SQL | Part I

-- Таблицы customers, products, и sales уже существуют.
-- Ваша задача — не открытие , а улучшение, внедрение и оптимизация.

Задание 1 | Применение отсутствующих бизнес-правил с помощью команды ALTER TABLE

-- Адреса электронной почты сотрудников должны быть уникальными.
  
ALTER TABLE customers
ADD CONSTRAINT uq_customers_email UNIQUE (email);

-- Указание номеров телефонов сотрудников должно быть обязательным.
   
ALTER TABLE customers
ALTER COLUMN phone_number SET NOT NULL;

-- Цены на продукцию должны быть неотрицательными.
  
ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price >= 0);

-- Сумма продаж должна быть неотрицательной.

ALTER TABLE sales
ADD CONSTRAINT chk_sales_total CHECK (total_sales >= 0);

Задание 2 | Добавить новый аналитический атрибут

-- Добавление нового атрибута sales_channel в таблицу sales, который указывает, была ли продажа совершена онлайн или в магазине.

ALTER TABLE sales
ADD COLUMN sales_channel TEXT;

 -- Ограничение для sales_channel, чтобы разрешить только 'online' или 'store'.

ALTER TABLE sales
ADD CONSTRAINT chk_sales_channel
CHECK (sales_channel IN ('online', 'store'));

-- Обновление существующих записей, чтобы установить значение sales_channel на 'online' для всех продаж с четными идентификаторами транзакций.

UPDATE sales
SET sales_channel = 'online'
WHERE transaction_id % 2 = 0;

--  WHERE transaction_id % 2 = 0 Фильтрует строки, применяя обновление только к тем, у которых остаток от transaction_id деления на 2 равен 0 (т. е., четные идентификаторы).  

SELECT *
FROM sales
WHERE transaction_id % 2 = 0

-- Проверка обновленных записей

Задание 3 | Добавление индексов для повышения производительности запросов

CREATE INDEX idx_sales_product_id
ON sales (product_id);

-- Создание индекса на столбце product_id в таблице sales для оптимизации запросов, которые фильтруют или сортируют по этому столбцу.
-- Этот индекс улучшит производительность запросов, которые часто ищут продажи по конкретным продуктам.

CREATE INDEX idx_sales_customer_id
ON sales (customer_id);

-- Создание индекса на столбце customer_id в таблице sales для оптимизации запросов, которые фильтруют или сортируют по этому столбцу.
-- Этот индекс улучшит производительность запросов, которые часто ищут продажи по конкретным клиентам.

CREATE INDEX idx_products_category
ON products (category);

-- Создание индекса на столбце category в таблице products для оптимизации запросов, которые фильтруют или сортируют по этому столбцу.
-- Этот индекс улучшит производительность запросов, которые часто ищут продукты по категориям.

Задание 4 | Проверка использования индекса с помощью EXPLAIN

EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id;

-- Использование EXPLAIN для анализа плана выполнения запроса, который агрегирует общую выручку по каждому продукту.

QUERY PLAN
"HashAggregate  (cost=142.99..144.24 rows=100 width=36)"
"  Group Key: product_id"
"  ->  Seq Scan on sales  (cost=0.00..117.99 rows=4999 width=10)"

-- В данном плане выполнения видно, что используется последовательное сканирование (Seq Scan) по таблице sales, что указывает на то, что индекс не был использован.
-- Это может быть связано с тем, что оптимизатор запросов решил, что последовательное сканирование будет более эффективным для данного объема данных.
-- Для улучшения производительности можно рассмотреть возможность изменения запроса или структуры данных, чтобы лучше использовать созданные индексы.







