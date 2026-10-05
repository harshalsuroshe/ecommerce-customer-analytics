WITH category_sales AS (
    SELECT
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'unknown'
        ) AS category_name,

        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(*) AS items_sold,
        ROUND(SUM(oi.price), 2) AS item_revenue,
        ROUND(SUM(oi.freight_value), 2) AS freight_revenue

    FROM raw.order_items AS oi

    JOIN raw.orders AS o
        ON oi.order_id = o.order_id

    JOIN raw.products AS p
        ON oi.product_id = p.product_id

    LEFT JOIN raw.category_translation AS ct
        ON p.product_category_name = ct.product_category_name

    WHERE o.order_status = 'delivered'

    GROUP BY 1
)

SELECT
    category_name,
    total_orders,
    items_sold,
    item_revenue,
    freight_revenue,
    ROUND(item_revenue + freight_revenue, 2) AS item_plus_freight
FROM category_sales
ORDER BY items_sold DESC;

--------------------------------------------------------------------------------------------
--								Find the top 10 categories

WITH category_sales AS (
    SELECT
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'unknown'
        ) AS category_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(*) AS items_sold,
        SUM(oi.price) AS item_revenue

    FROM raw.order_items AS oi
    JOIN raw.orders AS o
        ON oi.order_id = o.order_id
    JOIN raw.products AS p
        ON oi.product_id = p.product_id
    LEFT JOIN raw.category_translation AS ct
        ON p.product_category_name = ct.product_category_name

    WHERE o.order_status = 'delivered'
    GROUP BY 1
)

SELECT
    category_name,
    total_orders,
    items_sold,
    ROUND(item_revenue, 2) AS item_revenue
FROM category_sales
ORDER BY item_revenue DESC
LIMIT 10;

----------------------------------------------------------------------------------------------
--				Check whether the category translation table has duplicate source categories:
SELECT
    product_category_name,
    COUNT(*) AS row_count
FROM raw.category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;