-- Сессия 04: Анализ данных с помощью SQL | Фильтрация
-- Денормализованная табличная структура

-- Создание sales_analysis таблицы

CREATE TABLE IF NOT EXISTS sales_analysis AS
SELECT
    s.transaction_id,

    o.order_date,
    DATE(o.order_date) AS order_date_date,
    o.year,
    o.quarter,
    o.month,

    c.customer_name,
    c.city,
    c.zip_code,

    p.product_name,
    p.category,
    p.price,

    e.first_name  AS employee_first_name,
    e.last_name   AS employee_last_name,
    e.salary      AS employee_salary,

    s.quantity,
    s.discount,
    s.total_sales

FROM sales AS s
JOIN orders AS o
    ON s.order_id = o.order_id
JOIN customers AS c
    ON s.customer_id = c.customer_id
JOIN products AS p
    ON s.product_id = p.product_id
LEFT JOIN employees AS e
    ON s.employee_id = e.employee_id;

    -- Добавление индексов

    CREATE INDEX idx_sales_analysis_order_date
    ON sales_analysis(order_date_date);

CREATE INDEX idx_sales_analysis_year
    ON sales_analysis(year);

CREATE INDEX idx_sales_analysis_city
    ON sales_analysis(city);

CREATE INDEX idx_sales_analysis_category
    ON sales_analysis(category);

    -- В контексте нашего тематического исследования это может означать следующее:

-- анализ продаж, совершенных в конкретном году,
-- сделки с большими скидками,
-- товары, относящиеся к определенной категории, или
-- клиенты из определенного города.
-- и т. д.
-- Чтобы извлечь только те записи, которые важны для вашего анализа, необходимо отфильтровать данные.

-- WHERE 

 -- Например, вы можете захотеть просмотреть только те продажи, где:

-- общий объем продаж превышает определенный порог.
-- заказы, размещенные в определенном квартале
-- товары по цене выше средней.

-- To define these filtering conditions, the WHERE clause is combined with operators.

-- Some of these operators are intuitive and closely resemble everyday language, such as BETWEEN, OR, IN, AND or LIKE.

-- By understanding how these operators work, you can precisely control which rows from tables like sales, orders, products, 
-- or customers are included in your analysis.

-- WHERE

-- Пример: выбрать транзакции, где общий объем продаж превышает 300.

SELECT
    transaction_id,
    order_date_date,
    product_name,
    total_sales
FROM sales_analysis
WHERE total_sales > 300
ORDER BY total_sales DESC;

-- Пример: выбрать транзакции для товаров в категории «Электроника».

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category = 'Electronics';

-- Сочетание условий с помощью оператора И
-- Для включения строки в список оператор AND требует выполнения всех условий.

-- Пример: выбрать транзакции из 2024 с помощью high total sales.

SELECT
    transaction_id,
    order_date_date,
    year,
    product_name,
    total_sales
FROM sales_analysis
WHERE year = 2023
  AND total_sales > 300;

-- Пример: выберите раздел «Продажа электроники» в городе Ист-Аманда.

SELECT
    transaction_id,
    city,
    category,
    total_sales
FROM sales_analysis
WHERE city = 'East Amanda'
  AND category = 'Electronics';

-- Сочетание условий с ИЛИ
-- Для корректной работы оператора OR необходимо, чтобы выполнялось хотя бы одно условие.

SELECT
    transaction_id,
    order_date_date,
    city,
    total_sales
FROM sales_analysis
WHERE city = 'East Amanda'
OR city = 'Smithside';

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category = 'Toys'
AND total_sales > 300;

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category = 'Toys'
  OR category = 'Books';

-- Использование оператора BETWEEN для диапазонов.
-- Этот BETWEEN оператор используется для фильтрации значений в заданном диапазоне.
-- Диапазон включает в себя оба граничных значения.
-- Пример: выберите транзакции с общей суммой продаж от 50 000 до 150 000.

SELECT
    transaction_id,
    order_date_date,
    total_sales
FROM sales_analysis
WHERE total_sales BETWEEN 300 AND 500;

SELECT
    transaction_id,
    year,
    total_sales
FROM sales_analysis
WHERE year BETWEEN 2022 AND 2024;


SELECT
    transaction_id,
    year,
    total_sales
FROM sales_analysis
WHERE year>=2022 and year<2024;


-- OR VS IN

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category = 'Toys'
  OR category = 'Books';

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category IN ('Toys','Books');

-- Использование IN
-- Оператор INпроверяет, совпадает ли значение с каким-либо значением в указанном списке.

SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city IN ('East Amanda', 'Smithside', 'Lake Thomas');

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category IN ('Electronics', 'Books');

-- Использование NOT IN
-- Оператор NOT INисключает строки, соответствующие любому значению в указанном списке.

-- Пример: исключить транзакции из определенных городов.

SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city NOT IN ('East Lori', 'Anthonymouth');


-- Пример: исключить категории товаров с низким приоритетом.

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category NOT IN ('Toys', 'Books');

-- LIKE
-- Пример: выберите товары, название которых начинается с буквы «Е».

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE product_name LIKE 'E%';

-- Пример: выберите города, в названии которых содержится слово «Север».

SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city LIKE '%North%';

-- Пример использования оператора LIKE
-- WHERE product_name LIKE 'Elec%'
-- WHERE product_name LIKE '%Phone'
-- WHERE product_name LIKE '%Pro%'
-- WHERE city LIKE '_ast%'
-- WHERE city LIKE 'N%_%'
-- WHERE category LIKE 'B%ks'

LIKE vs ILIKE

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE LOWER(category) LIKE LOWER('electronics%');


SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category ILIKE 'electronics%';


