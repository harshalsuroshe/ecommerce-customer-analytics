-- delivery duration and delay
SELECT
    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400.0
        )::NUMERIC,
        2
    ) AS avg_delivery_days,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_estimated_delivery_date
                )
            ) / 86400.0
        )::NUMERIC,
        2
    ) AS avg_days_after_estimate

FROM raw.orders

WHERE order_status = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

-- Calculate on-time and late delivery rates
SELECT
    COUNT(*) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE order_delivered_customer_date
              <= order_estimated_delivery_date
    ) AS on_time_orders,

    COUNT(*) FILTER (
        WHERE order_delivered_customer_date
              > order_estimated_delivery_date
    ) AS late_orders,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_delivered_customer_date
                  <= order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS on_time_rate_pct,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_delivered_customer_date
                  > order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS late_rate_pct

FROM raw.orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

--Compare delivery performance by month
SELECT
    DATE_TRUNC(
        'month',
        order_purchase_timestamp
    )::DATE AS purchase_month,

    COUNT(*) AS delivered_orders,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_delivered_customer_date
                  <= order_estimated_delivery_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS on_time_rate_pct,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400.0
        )::NUMERIC,
        2
    ) AS avg_delivery_days

FROM raw.orders

WHERE order_status = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY 1
ORDER BY 1;

--------------------------------------------------------------------------------------------
--Review analysis
--inspect the distribution:
SELECT
    review_score,
    COUNT(*) AS review_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS review_percentage

FROM raw.order_reviews

WHERE review_score BETWEEN 1 AND 5

GROUP BY review_score
ORDER BY review_score;

--Compare review scores for late and on-time deliveries
WITH order_reviews AS (
    SELECT
        order_id,
        AVG(review_score) AS avg_review_score
    FROM raw.order_reviews
    WHERE review_score BETWEEN 1 AND 5
    GROUP BY order_id
),

delivery_status AS (
    SELECT
        order_id,
        CASE
            WHEN order_delivered_customer_date
                 <= order_estimated_delivery_date
                THEN 'On time'
            ELSE 'Late'
        END AS delivery_category
    FROM raw.orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
)

SELECT
    d.delivery_category,
    COUNT(*) AS reviewed_orders,
    ROUND(AVG(r.avg_review_score), 2) AS avg_review_score,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE r.avg_review_score <= 2
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS low_review_rate_pct

FROM delivery_status AS d

JOIN order_reviews AS r
    ON d.order_id = r.order_id

GROUP BY d.delivery_category
ORDER BY d.delivery_category;

------------------------------------------------------------------------------------------
--Investigate the relationship
--Examine the size of delivery delays
WITH delivery_days AS (
    SELECT
        order_id,
        EXTRACT(
            EPOCH FROM (
                order_delivered_customer_date
                - order_estimated_delivery_date
            )
        ) / 86400.0 AS days_after_estimate
    FROM raw.orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
)

SELECT
    CASE
        WHEN days_after_estimate < 0 THEN 'Early'
        WHEN days_after_estimate = 0 THEN 'On estimated date'
        WHEN days_after_estimate <= 3 THEN '1–3 days late'
        WHEN days_after_estimate <= 7 THEN '4–7 days late'
        ELSE 'More than 7 days late'
    END AS delivery_bucket,

    COUNT(*) AS order_count

FROM delivery_days

GROUP BY 1
ORDER BY order_count DESC;
  