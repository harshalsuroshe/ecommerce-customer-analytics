---------------------------- Find the top 10 sellers by item revenue -------------------------
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,

    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(*) AS item_lines,

    ROUND(SUM(oi.price), 2) AS item_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_revenue

FROM raw.sellers AS s

JOIN raw.order_items AS oi
    ON s.seller_id = oi.seller_id

JOIN raw.orders AS o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'delivered'

GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state

ORDER BY item_revenue DESC
LIMIT 10;

-------------------------- Compare seller revenue and order volume ---------------------------
ORDER BY total_orders DESC
LIMIT 10;  -- in above query

-----------------------------------Analyze seller locations --------------------------------
SELECT
    s.seller_state,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS item_revenue

FROM raw.sellers AS s

JOIN raw.order_items AS oi
    ON s.seller_id = oi.seller_id

JOIN raw.orders AS o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'delivered'

GROUP BY s.seller_state
ORDER BY item_revenue DESC;

-------------------------- Analyze customer reviews by seller ---------------------------
WITH order_review_scores AS (
    SELECT
        order_id,
        AVG(review_score) AS avg_order_review_score
    FROM raw.order_reviews
    WHERE review_score BETWEEN 1 AND 5
    GROUP BY order_id
)

SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT o.order_id) AS reviewed_orders,
    ROUND(AVG(r.avg_order_review_score), 2)
        AS avg_review_score

FROM raw.sellers AS s

JOIN raw.order_items AS oi
    ON s.seller_id = oi.seller_id

JOIN raw.orders AS o
    ON oi.order_id = o.order_id

JOIN order_review_scores AS r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'

GROUP BY s.seller_id, s.seller_state

HAVING COUNT(DISTINCT o.order_id) >= 10

ORDER BY avg_review_score DESC;

---------------------------------------Validation-------------------------------------------
-- Check whether seller IDs are unique in the seller table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM raw.sellers;

-- Check for order items that don't match a seller
SELECT COUNT(*) AS unmatched_items
FROM raw.order_items AS oi
LEFT JOIN raw.sellers AS s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;