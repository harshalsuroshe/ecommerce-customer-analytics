-- 1. Inspect order status distribution
SELECT
    order_status,
    COUNT(*) AS order_count
FROM raw.orders
GROUP BY order_status
ORDER BY order_count DESC;


-- 2. Monthly sales trends for delivered orders
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::DATE
        AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS item_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_revenue
FROM raw.orders AS o
JOIN raw.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- date range covered by the dataset:
SELECT
    MIN(order_purchase_timestamp)::DATE AS first_order_date,
    MAX(order_purchase_timestamp)::DATE AS last_order_date
FROM raw.orders;