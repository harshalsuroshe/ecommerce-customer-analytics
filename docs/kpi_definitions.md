\# KPI Definitions — E-commerce Customer Analytics



\## 1. Sales Performance



\*\*Item Revenue\*\*

\- Definition: Sum of product item prices.

\- Calculation: `SUM(order\_items.price)`

\- Population: Orders with status `delivered`.

\- Excludes: Freight charges, product costs, refunds, and other costs not modeled in this metric.



\*\*Freight Revenue\*\*

\- Definition: Sum of freight values associated with delivered order items.

\- Calculation: `SUM(order\_items.freight\_value)`



\*\*Total Orders\*\*

\- Definition: Number of distinct delivered orders.

\- Calculation: `COUNT(DISTINCT order\_id)`



\*\*Average Order Value (AOV)\*\*

\- Definition: Average item revenue per delivered order.

\- Calculation: Item revenue / distinct delivered orders.

\- Freight is excluded from the primary AOV definition.



\## 2. Product and Seller Performance



\*\*Category Item Revenue\*\*

\- Definition: Item revenue grouped by product category.

\- Aggregation: Sum of item prices by category.



\*\*Seller Item Revenue\*\*

\- Definition: Item revenue attributed to each seller.

\- Aggregation: Sum of item prices by seller.



\*\*Items Sold / Item Lines\*\*

\- Definition: Number of rows in the order-items table.

\- Calculation: `COUNT(\*)`

\- Note: This counts item lines, not necessarily units.



\## 3. Customer Retention



\*\*Unique Customers\*\*

\- Definition: Distinct `customer\_unique\_id` values with at least one delivered order.



\*\*Repeat Customer\*\*

\- Definition: A unique customer with at least two delivered orders in the observed dataset period.



\*\*Repeat Customer Rate\*\*

\- Calculation: Repeat customers / unique customers × 100.



\*\*Purchase Gap\*\*

\- Definition: Elapsed time between consecutive delivered orders for a unique customer.



\## 4. Delivery Performance



\*\*Delivery Duration\*\*

\- Definition: Elapsed time between order purchase and actual customer delivery.



\*\*On-Time Delivery\*\*

\- Definition: Actual delivery timestamp is earlier than or equal to the estimated delivery timestamp.



\*\*Late Delivery\*\*

\- Definition: Actual delivery timestamp is later than the estimated delivery timestamp.



\*\*On-Time Delivery Rate\*\*

\- Calculation: On-time delivered orders / eligible delivered orders × 100.

\- Eligibility: Actual and estimated delivery timestamps are both present.



\## 5. Review Performance



\*\*Average Review Score\*\*

\- Definition: Average valid review score, using scores from 1 to 5.

\- Note: For order-level comparisons, reviews are aggregated to one score per order before joining to delivery data.



\## General Limitations



\- The dataset represents a historical observation period, not current e-commerce performance.

\- Item revenue is not profit because product costs and other expenses are unavailable.

\- Repeat-customer rate is an observed-period measure, not a cohort-based retention rate.

\- Associations between delivery delays and review scores do not establish causation.

\- Metrics depend on the filters and definitions specified in each SQL query.

