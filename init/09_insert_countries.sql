-- Load core dimension tables from CSV files
-- COPY must read files inside the container; we mounted ./data to /docker-entrypoint-initdb.d/data

\echo 'Loading core dimension tables from CSVs'
COPY analytics.category
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/category.csv'
CSV HEADER;

COPY analytics.color
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/color.csv'
CSV HEADER;

COPY analytics.customer
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/customer.csv'
CSV HEADER;

COPY analytics.frequency
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/frequency.csv'
CSV HEADER;

COPY analytics.location
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/location.csv'
CSV HEADER;

COPY analytics.payment_method
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/payment_method.csv'
CSV HEADER;

COPY analytics.product
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/product.csv'
CSV HEADER;

COPY analytics.purchase
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/purchase.csv'
CSV HEADER;

COPY analytics.season
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/season.csv'
CSV HEADER;

COPY analytics.size
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/size.csv'
CSV HEADER;

COPY analytics.product_features
FROM '/docker-entrypoint-initdb.d/data/analytics_schema_project/product_features.csv'
CSV HEADER;
