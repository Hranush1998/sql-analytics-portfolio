--CREATE DATABASE final_sql_project;
-- Analytics Schema;

CREATE SCHEMA IF NOT EXISTS analytics;
SET search_path TO analytics;

--Location

DROP TABLE IF EXISTS analytics.location CASCADE; 

CREATE TABLE analytics.location (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL
);

--Frequency of Purchases

DROP TABLE IF EXISTS analytics.frequency CASCADE;

CREATE TABLE analytics.frequency (
    frequency_id SERIAL PRIMARY KEY,
    frequency VARCHAR(50) NOT NULL
);

--Payment Method

DROP TABLE IF EXISTS analytics.payment_method CASCADE;

CREATE TABLE analytics.payment_method (
    payment_method_id SERIAL PRIMARY KEY,
    payment_method VARCHAR(50) NOT NULL
);


-- Product features

DROP TABLE IF EXISTS analytics.product_features CASCADE;

CREATE TABLE analytics.product_features (
    product_features_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES analytics.product(product_id),
    category_id INT REFERENCES analytics.category(category_id),
    size_id INT REFERENCES analytics.size(size_id),
    color_id INT REFERENCES analytics.color(color_id),
    season_id INT REFERENCES analytics.season(season_id)
);

--Product

DROP TABLE IF EXISTS analytics.product CASCADE;

CREATE TABLE analytics.product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
);


--Category

DROP TABLE IF EXISTS analytics.category CASCADE;

CREATE TABLE analytics.category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

--Size

DROP TABLE IF EXISTS analytics.size CASCADE;

CREATE TABLE analytics.size (
    size_id SERIAL PRIMARY KEY,
    size VARCHAR(10) NOT NULL
);

--Color

DROP TABLE IF EXISTS analytics.color CASCADE;

CREATE TABLE analytics.color (
    color_id SERIAL PRIMARY KEY,
    color VARCHAR(50) NOT NULL
);

--Season

DROP TABLE IF EXISTS analytics.season CASCADE;

CREATE TABLE analytics.season (
    season_id SERIAL PRIMARY KEY,
    season VARCHAR(50) NOT NULL
);



--Customer

DROP TABLE IF EXISTS analytics.customer CASCADE;

CREATE TABLE analytics.customer (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(20),
    location_id INT REFERENCES analytics.location(location_id),
    subscription_status VARCHAR(10),
    previous_purchases INT,
    frequency_id INT REFERENCES analytics.frequency(frequency_id)
);

-- Purchase (FACT table)

DROP TABLE IF EXISTS analytics.purchase CASCADE;

CREATE TABLE analytics.purchase (
    purchase_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES analytics.customer(customer_id),
    product_id INT REFERENCES analytics.product(product_id),
    purchase_amount_usd NUMERIC(10,2),
    review_rating NUMERIC(3,1),
    discount_applied VARCHAR(10),
    payment_method_id INT REFERENCES analytics.payment_method(payment_method_id),
    purchase_date DATE
);

--JOIN TABLES

-- customer 

SELECT	
cu.customer_id,
cu.age,
cu.gender,
cu.subscription_status,
cu.previous_purchases,
lo.location_name,
f.frequency
FROM
analytics.customer cu
RIGHT JOIN analytics.location lo ON cu.location_id = lo.location_id 
RIGHT JOIN analytics.frequency f ON cu.frequency_id = f.frequency_id

-- purchase

SELECT
pu.purchase_id,
pu.customer_id,
pu.purchase_amount_usd,
pu.review_rating,
pu.discount_applied,
pr.product_name,
me.payment_method
FROM
analytics.purchase pu
RIGHT JOIN analytics.product pr ON pu.product_id = pr.product_id
RIGHT JOIN analytics.payment_method me ON pu.payment_method_id = me.payment_method_id

-- product features

SELECT 
pr.product_features_id,
pro.product_name,
ca.category_name,
si.size,
co.color,
se.season
FROM
analytics.product_features pr
RIGHT JOIN analytics.product pro ON pr.product_id = pro.product_id
RIGHT JOIN analytics.category ca ON pr.category_id = ca.category_id
RIGHT JOIN analytics.size si ON pr.size_id = si.size_id
RIGHT JOIN analytics.color co ON pr.color_id = co.color_id
RIGHT JOIN analytics.season se ON pr.season_id = se.season_id

--  customer_analysis

SELECT	
cu.customer_id,
cu.age,
cu.gender,
cu.subscription_status,
cu.previous_purchases,
lo.location_name,
f.frequency
FROM
analytics.customer cu
RIGHT JOIN analytics.location lo ON cu.location_id = lo.location_id 
RIGHT JOIN analytics.frequency f ON cu.frequency_id = f.frequency_id

CREATE TABLE IF NOT EXISTS customer_analysis AS
SELECT	
cu.customer_id,
cu.age,
cu.gender,
cu.subscription_status,
cu.previous_purchases,
lo.location_name,
f.frequency
FROM
analytics.customer cu
RIGHT JOIN analytics.location lo ON cu.location_id = lo.location_id 
RIGHT JOIN analytics.frequency f ON cu.frequency_id = f.frequency_id

SELECT *
FROM customer_analysis

-- purchase_analysis

SELECT
pu.purchase_id,
pu.customer_id,
pu.purchase_amount_usd,
pu.review_rating,
pu.discount_applied,
pr.product_name,
me.payment_method
FROM
analytics.purchase pu
RIGHT JOIN analytics.product pr ON pu.product_id = pr.product_id
RIGHT JOIN analytics.payment_method me ON pu.payment_method_id = me.payment_method_id

CREATE TABLE IF NOT EXISTS purchase_analysis AS
SELECT
pu.purchase_id,
pu.customer_id,
pu.purchase_amount_usd,
pu.review_rating,
pu.discount_applied,
pr.product_name,
me.payment_method
FROM
analytics.purchase pu
RIGHT JOIN analytics.product pr ON pu.product_id = pr.product_id
RIGHT JOIN analytics.payment_method me ON pu.payment_method_id = me.payment_method_id

SELECT *
FROM purchase_analysis

-- product_analysis

SELECT 
pr.product_features_id,
pro.product_name,
ca.category_name,
si.size,
co.color,
se.season
FROM
analytics.product_features pr
RIGHT JOIN analytics.product pro ON pr.product_id = pro.product_id
RIGHT JOIN analytics.category ca ON pr.category_id = ca.category_id
RIGHT JOIN analytics.size si ON pr.size_id = si.size_id
RIGHT JOIN analytics.color co ON pr.color_id = co.color_id
RIGHT JOIN analytics.season se ON pr.season_id = se.season_id

CREATE TABLE IF NOT EXISTS product_analysis AS
SELECT 
pr.product_features_id,
pro.product_name,
ca.category_name,
si.size,
co.color,
se.season
FROM
analytics.product_features pr
RIGHT JOIN analytics.product pro ON pr.product_id = pro.product_id
RIGHT JOIN analytics.category ca ON pr.category_id = ca.category_id
RIGHT JOIN analytics.size si ON pr.size_id = si.size_id
RIGHT JOIN analytics.color co ON pr.color_id = co.color_id
RIGHT JOIN analytics.season se ON pr.season_id = se.season_id

SELECT *
FROM product_analysis


-- 5 товаров с самым высоким общим доходом

SELECT 
product_name,
SUM(purchase_amount_usd) AS total_revenue
FROM purchase_analysis
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- категории товаров

SELECT 
category_name,
COUNT(*)
FROM product_analysis
GROUP BY category_name;

-- продажи по продукту

SELECT
product_name,
COUNT(purchase_id) AS number_of_transactions
FROM purchase_analysis
GROUP BY product_name
ORDER BY number_of_transactions DESC;

-- Общий доход по каждому продукту

SELECT
product_name,
SUM(purchase_amount_usd) AS total_revenue
FROM purchase_analysis
GROUP BY product_name
ORDER BY total_revenue DESC;

-- средняя цена продукта

SELECT 
product_name,
AVG(purchase_amount_usd) AS average_price
FROM purchase_analysis
GROUP BY product_name
ORDER BY average_price DESC
LIMIT 10;

-- товары, которые принесли более 10 000 долларов общей выручки 

SELECT 
product_name,
SUM(purchase_amount_usd) AS total_revenue
FROM purchase_analysis
GROUP BY product_name
HAVING SUM(purchase_amount_usd) > 10000
ORDER BY total_revenue DESC;

SELECT 
product_name,
SUM(purchase_amount_usd) AS total_revenue
FROM purchase_analysis
GROUP BY product_name
HAVING SUM(purchase_amount_usd) > 9500
ORDER BY total_revenue DESC;

-- товары, по которым совершено не менее 50 транзакций

SELECT 
product_name,
COUNT(purchase_id) AS number_of_transactions
FROM purchase_analysis
GROUP BY product_name
HAVING COUNT(purchase_id) >= 150
ORDER BY number_of_transactions DESC;

-- customer_analysis + purchase_analysis

CREATE TABLE IF NOT EXISTS customer_purchase_analysis AS
SELECT
pu.purchase_id,
pu.customer_id,
pu.purchase_amount_usd,
pu.review_rating,
pu.discount_applied,
pu.product_name,
pu.payment_method,
cu.age,
cu.gender,
cu.subscription_status,
cu.previous_purchases,
cu.location_name,
cu.frequency
FROM
purchase_analysis pu
RIGHT JOIN customer_analysis cu ON pu.customer_id = cu.customer_id;


SELECT *
FROM customer_purchase_analysis

---------------------------------------------------------

-- Анализ объема транзакций по городам

SELECT 
location_name,
COUNT(purchase_id) AS purchase_count
FROM customer_purchase_analysis
GROUP BY location_name
HAVING COUNT(purchase_id) > 60
ORDER BY purchase_count DESC
LIMIT 20;




-- Категории с высокой частотой, но низким доходом

SELECT
product_name,
COUNT(purchase_id) AS purchase_count,
SUM(purchase_amount_usd) AS total_sales_purchase
FROM customer_purchase_analysis
GROUP BY product_name
HAVING COUNT(purchase_id) > 50
AND SUM(purchase_amount_usd) > 4000
ORDER BY purchase_count ASC;

-- Средняя стоимость сделки по городам


SELECT 
location_name,
AVG(purchase_amount_usd) AS purchase_count
FROM customer_purchase_analysis
GROUP BY location_name
HAVING AVG(purchase_amount_usd) > 60
ORDER BY purchase_count DESC
LIMIT 20;

-- рассчитать общую сумму продаж для сделок со скидкой и без скидки

SELECT
CASE 
WHEN discount_applied = 'NO' THEN 'Discounted'
ELSE 'full price'
END AS pricing_type,
SUM(purchase_amount_usd) AS total_sales_purchase
FROM customer_purchase_analysis
GROUP BY pricing_type;


-- -- Сколько клиентов в каждой стране

SELECT 
location_name,
COUNT(customer_id) AS total_customers
FROM customer_purchase_analysis
GROUP BY location_name
ORDER BY total_customers DESC;

-- Какой доход приносит каждая страна
SELECT
location_name,
SUM(purchase_amount_usd) AS total_sales_purchase,
COUNT(DISTINCT customer_id) AS total_customers
FROM customer_purchase_analysis
GROUP BY location_name
ORDER BY total_sales_purchase DESC;

-- Каков средний доход на одного клиента по странам
SELECT 
location_name,
SUM(purchase_amount_usd)/COUNT(DISTINCT customer_id) AS avg_revenue_per_customer
FROM customer_purchase_analysis
GROUP BY location_name
ORDER BY avg_revenue_per_customer DESC;


--общее статистическое описание

SELECT 
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(purchase_amount_usd) AS total_purchase,
    AVG(purchase_amount_usd) AS avg_purchase,
    MIN(purchase_amount_usd) AS min_purchase,
    MAX(purchase_amount_usd) AS max_purchase
FROM customer_purchase_analysis;


--общее статистическое описание Женщин

SELECT 
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(purchase_amount_usd) AS total_purchase,
    AVG(purchase_amount_usd) AS avg_purchase,
    MIN(purchase_amount_usd) AS min_purchase,
    MAX(purchase_amount_usd) AS max_purchase
FROM customer_purchase_analysis
WHERE gender = 'Female';

--общее статистическое описание Мужчин

SELECT 
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(purchase_amount_usd) AS total_purchase,
    AVG(purchase_amount_usd) AS avg_purchase,
    MIN(purchase_amount_usd) AS min_purchase,
    MAX(purchase_amount_usd) AS max_purchase
FROM customer_purchase_analysis
WHERE gender = 'Male';

-- Анализ объема транзакций по возрастным группам
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS age_group,
    
    COUNT(*) AS total_transactions,
    SUM(purchase_amount_usd) AS total_volume,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_transaction,
    MIN(purchase_amount_usd) AS min_transaction,
    MAX(purchase_amount_usd) AS max_transaction

FROM customer_purchase_analysis
GROUP BY age_group
ORDER BY total_volume DESC;


-- 5 самых популярных продуктов среди всех покупателей

SELECT 
product_name,
COUNT(purchase_id) AS number_of_transactions
FROM customer_purchase_analysis
GROUP BY product_name
ORDER BY number_of_transactions DESC
LIMIT 5;

-- Какие категории товаров чаще всего покупают представители каждого пола
-- самых популярных продуктов среди женщин top 5


SELECT 
product_name,
COUNT(purchase_id) AS number_of_transactions
FROM customer_purchase_analysis
WHERE gender = 'Female'
GROUP BY product_name
ORDER BY number_of_transactions DESC
LIMIT 5;

-- 5 самых популярных продуктов среди мужчин

SELECT 
product_name,
COUNT(purchase_id) AS number_of_transactions
FROM customer_purchase_analysis
WHERE gender = 'Male'
GROUP BY product_name
ORDER BY number_of_transactions DESC
LIMIT 5;

-- средний возраст покупателей, которые приобрели определенный продукт

SELECT
product_name,
AVG(age) AS average_age
FROM customer_purchase_analysis
GROUP BY product_name
ORDER BY average_age DESC;


SELECT
product_name,
AVG(age) AS average_age
FROM customer_purchase_analysis
WHERE gender = 'Male'
GROUP BY product_name
ORDER BY average_age DESC;


SELECT
product_name,
AVG(age) AS average_age
FROM customer_purchase_analysis
WHERE gender = 'Female'
GROUP BY product_name
ORDER BY average_age DESC;

-- Диапазоны доходов

значения от 0 < x ≤ 20 диапазон 20
значения от 20 x ≤ 40 диапазон 40
значения от 40 < x ≤ 60 → диапазон 60
значения от 60 < x ≤ 80 → диапазон 80
значения от 80 < x ≤ 100 → диапазон 100


SELECT
  CEILING(purchase_amount_usd / 20.0) * 20 AS revenue_range,
  COUNT(*) AS purchase,
  SUM(purchase_amount_usd) AS total_purchase
FROM customer_purchase_analysis
GROUP BY CEILING(purchase_amount_usd / 20.0) * 20
ORDER BY revenue_range;

-- 5 продуктов с самым высоким средним рейтингом

SELECT 
    product_name,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    COUNT(*) AS review_count
FROM customer_purchase_analysis
GROUP BY product_name
HAVING COUNT(*) >= 5  
ORDER BY avg_rating DESC
LIMIT 5;


-- Какой пол тратит больше?

SELECT 
    gender,
    SUM(purchase_amount_usd) AS total_spent,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_spent
FROM customer_purchase_analysis
GROUP BY gender
ORDER BY total_spent DESC;


-- Какой пол ставит более высокие оценки в отзывах?

SELECT 
    gender,
    ROUND(AVG(review_rating), 2) AS avg_rating
FROM customer_purchase_analysis
GROUP BY gender
ORDER BY avg_rating DESC;

-- Отличается ли частота покупок (еженедельно/ежегодно) между полами?

SELECT 
    gender,
    frequency,
    COUNT(*) AS purchase_count
FROM customer_purchase_analysis
GROUP BY gender, frequency
ORDER BY gender, purchase_count DESC;


-- Как частота покупок связана с количеством предыдущих покупок? 


SELECT 
    frequency,
    ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
    COUNT(*) AS customer_count
FROM customer_purchase_analysis
GROUP BY frequency
ORDER BY avg_previous_purchases DESC;


-- Какой процент клиентов с подпиской по сравнению с клиентами без подписки?

SELECT 
    subscription_status,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM customer_purchase_analysis
GROUP BY subscription_status;

--Тратят ли пользователи с подпиской больше, чем пользователи без подписки?

SELECT 
    subscription_status,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_spent,
    SUM(purchase_amount_usd) AS total_spent
FROM customer_purchase_analysis
GROUP BY subscription_status
ORDER BY avg_spent DESC;



-- Определённые цвета более популярны в определённые сезоны?

SELECT 
    season,
    color,
    COUNT(*) AS purchase_count
FROM product_analysis
WHERE season = 'Summer' OR season = 'Spring'
GROUP BY season, color
ORDER BY season, purchase_count DESC;


SELECT 
    season,
    color,
    COUNT(*) AS purchase_count
FROM product_analysis
WHERE season = 'Fall' 
OR season = 'Winter'
GROUP BY season, color
ORDER BY season, purchase_count DESC;


 -- Какой способ оплаты чаще всего используют крупные покупатели?

WITH high_spenders AS (
    SELECT *
    FROM customer_purchase_analysis
    WHERE purchase_amount_usd > (
        SELECT AVG(purchase_amount_usd)
        FROM customer_purchase_analysis
    )
)

SELECT 
    payment_method,
    COUNT(*) AS usage_count
FROM high_spenders
GROUP BY payment_method
ORDER BY usage_count DESC;

 -- В каком штате наибольшие средние расходы?

SELECT 
    location_name,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_spent
FROM customer_purchase_analysis
GROUP BY location_name
ORDER BY avg_spent DESC
LIMIT 1;


--Выводы:
•	Мужчин больше, чем женщин 
•	Женщины тратят больше денег, чем мужчины.
•	Клиенты в целом удовлетворены, независимо от пола.
•	Мужчины покупают в два раза больше, чем женщины.
•	Частота покупок умеренно связана с предыдущими покупками; ежеквартальные и еженедельные покупатели имеют наибольшее суммарное число покупок, тогда как ежегодные покупатели — наименьшее.
•	Подписчики и пользователи без подписки тратят почти одинаковую сумму за покупку; наличие подписки оказывает минимальное влияние на средний размер покупки.
•	Возраст клиентов практически не влияет на оценки в отзывах.
•	Наличие скидок почти одинаково распределено и не влияет на оценки.
•	Наибольшую среднюю сумму покупки имеют обувь, за ней с небольшим отставанием одежда; наименьшую среднюю сумму на транзакцию имеет верхняя одежда.
•	Цвета демонстрируют сезонность.
•	Размеры товаров в целом одинаковы во всех локациях.
•	Наибольшие средние расходы наблюдаются в Аляске.
•	Оценки в отзывах существенно не зависят от местоположения.
•	Крупные покупатели чаще всего используют кредитные карты, дебетовые карты и PayPal.



