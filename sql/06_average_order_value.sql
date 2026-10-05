--- Overall AOV
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_item_revenue,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM raw.orders AS o
JOIN raw.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

--AOV By Month

SELECT
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp
    )::DATE AS order_month,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(SUM(oi.price), 2) AS total_item_revenue,

    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value

FROM raw.orders AS o
JOIN raw.order_items AS oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'

GROUP BY 1
ORDER BY 1;

-- AOV BY Customer State
SELECT
    c.customer_state,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(SUM(oi.price), 2) AS total_item_revenue,

    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value

FROM raw.orders AS o

JOIN raw.customers AS c
    ON o.customer_id = c.customer_id

JOIN raw.order_items AS oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'

GROUP BY c.customer_state
ORDER BY average_order_value DESC;

-- Compare item revenue with freight-inclusive order value
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(SUM(oi.price), 2) AS item_revenue,

    ROUND(SUM(oi.freight_value), 2) AS freight_revenue,

    ROUND(
        SUM(oi.price + oi.freight_value),
        2
    ) AS item_plus_freight_total,

    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS item_aov,

    ROUND(
        SUM(oi.price + oi.freight_value)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS item_plus_freight_aov

FROM raw.orders AS o
JOIN raw.order_items AS oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered';