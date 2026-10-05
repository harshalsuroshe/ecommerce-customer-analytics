--clean customer-order dataset

SELECT
    c.customer_unique_id,
    o.order_id,
    o.order_purchase_timestamp::DATE AS order_date
FROM raw.orders AS o
JOIN raw.customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL;

-- Repeat-customer rate
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM raw.orders AS o
    JOIN raw.customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE order_count >= 2
    ) AS repeat_customers,

    COUNT(*) FILTER (
        WHERE order_count = 1
    ) AS one_time_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_count >= 2
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_pct

FROM customer_orders;

-- customer purchase frequency
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM raw.orders AS o
    JOIN raw.customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)

SELECT
    order_count,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM customer_orders
GROUP BY order_count
ORDER BY order_count;

-- each customer's first and most recent purchase
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_purchase_timestamp)::DATE AS first_purchase_date,
    MAX(o.order_purchase_timestamp)::DATE AS latest_purchase_date,
    (
        MAX(o.order_purchase_timestamp)::DATE
        - MIN(o.order_purchase_timestamp)::DATE
    ) AS days_between_first_and_last
FROM raw.orders AS o
JOIN raw.customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC, latest_purchase_date DESC;

-- time between repeat purchases
WITH delivered_orders AS (
    SELECT DISTINCT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
    FROM raw.orders AS o
    JOIN raw.customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp IS NOT NULL
),

purchase_gaps AS (
    SELECT
        customer_unique_id,
        order_id,
        order_purchase_timestamp,

        LAG(order_purchase_timestamp) OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp, order_id
        ) AS previous_purchase_timestamp

    FROM delivered_orders
)

SELECT
    customer_unique_id,
    order_id,
    previous_purchase_timestamp,
    order_purchase_timestamp AS current_purchase_timestamp,

    ROUND(
        (
            EXTRACT(
                EPOCH FROM (
                    order_purchase_timestamp
                    - previous_purchase_timestamp
                )
            ) / 86400.0
        )::NUMERIC,
        2
    ) AS days_since_previous_purchase

FROM purchase_gaps
WHERE previous_purchase_timestamp IS NOT NULL
ORDER BY days_since_previous_purchase DESC;

------------------------------------------------------------------------------------------------