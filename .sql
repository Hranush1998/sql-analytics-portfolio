Session 03: Data Analysis with SQL | Part I

# Упражнение 
## Задание 1

+ Таблицы customers, products, и sales уже существуют.
+ Ваша задача — не открытие , а улучшение, внедрение и оптимизация.

## Задание 1 | Применение отсутствующих бизнес-правил с помощью команды ALTER TABLE

+ Адреса электронной почты сотрудников должны быть уникальными.
  
```sql 
ALTER TABLE customers
ADD CONSTRAINT uq_customers_email UNIQUE (email);
```

+ Указание номеров телефонов сотрудников должно быть обязательным.
   
```sql 
ALTER TABLE customers
ALTER COLUMN phone_number SET NOT NULL;
```
+ Цены на продукцию должны быть неотрицательными.
  
```sql 
ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price >= 0);
```

+ Сумма продаж должна быть неотрицательной.

```sql
ALTER TABLE sales
ADD CONSTRAINT chk_sales_total CHECK (total_sales >= 0);
```

## Задание 2 | Добавить новый аналитический атрибут

ALTER TABLE sales
ADD COLUMN sales_channel TEXT;

ALTER TABLE sales
ADD CONSTRAINT chk_sales_channel
CHECK (sales_channel IN ('online', 'store'));

UPDATE sales
SET sales_channel = 'online'
WHERE transaction_id % 2 = 0;

+ WHERE transaction_id % 2 = 0 Фильтрует строки, применяя обновление только к тем, у которых остаток от transaction_id деления на 2 равен 0 (т. е., четные идентификаторы).  

SELECT *
FROM sales
WHERE transaction_id % 2 = 0

+ Задание 3

CREATE INDEX idx_sales_product_id
ON sales (product_id);













