-- Preview Orders
SELECT *
FROM raw.orders
LIMIT 10;

--count orders
SELECT COUNT(*) AS total_order_rows
FROM raw.orders;

-- count unique customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM raw.customers;

-- inspect order status
SELECT
    order_status,
    COUNT(*) AS order_count
FROM raw.orders
GROUP BY order_status
ORDER BY order_count DESC;

-- monthly order volume
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM raw.orders
GROUP BY 1
ORDER BY 1;

-- validate order id
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_order_ids,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_id_difference
FROM raw.orders;
--If duplicate_id_difference is zero and order_id is not null for all rows, the key is unique.

-- check null separately
SELECT COUNT(*) AS null_order_ids
FROM raw.orders
WHERE order_id IS NULL;

-- validate item to order relationship, This query counts item records that refer to a missing order.
SELECT COUNT(*) AS unmatched_order_items
FROM raw.order_items oi
LEFT JOIN raw.orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- KPI: Revenue
SELECT
    ROUND(SUM(price), 2) AS item_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight,
    COUNT(*) AS order_item_lines,
    COUNT(DISTINCT order_id) AS orders_with_items
FROM raw.order_items;
--Important: This is item revenue recorded in the dataset, not profit. 
--Freight is reported separately. We'll establish the final KPI definitions 
--and treatment of canceled orders before publishing business results.

