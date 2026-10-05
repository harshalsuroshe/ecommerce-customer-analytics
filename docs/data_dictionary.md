\# Data Dictionary



\# Data Quality Rules



\## Completeness



\- `order\_id` must not be null.

\- `customer\_id` must not be null in the orders table.

\- `product\_id` must not be null in order\_items.

\- `seller\_id` must not be null in order\_items.



\## Uniqueness



\- `orders.order\_id` should be unique.

\- `customers.customer\_id` should be unique.

\- `products.product\_id` should be unique.

\- `sellers.seller\_id` should be unique.



\## Validity



\- `review\_score` should be between 1 and 5.

\- `price` should not be negative.

\- `freight\_value` should not be negative.



\## Referential Integrity



\- Every order customer should exist in customers.

\- Every order item order should exist in orders.

\- Every order item product should exist in products.

\- Every order item seller should exist in sellers.



\## Date Logic



\- Delivery should not occur before purchase.

\- Delivery-related timestamps may legitimately be missing

&#x20; for orders that were not delivered.



\## customers



\*\*Grain:\*\* One row per customer-order relationship.



| Column | Description | Data Type | Key |

|---|---|---|---|

| customer\_id | Customer identifier associated with an order | | |

| customer\_unique\_id | Unique identifier for the actual customer | | |

| customer\_zip\_code\_prefix | Customer ZIP prefix | | |

| customer\_city | Customer city | | |

| customer\_state | Customer state | | |



\## orders



\*\*Grain:\*\* One row per order.



\## order\_items



\*\*Grain:\*\* One row per product line within an order.



\## order\_payments



\*\*Grain:\*\* One row per payment transaction associated with an order.



\## order\_reviews



\*\*Grain:\*\* One review record associated with an order/review.



\## products



\*\*Grain:\*\* One row per product.



\## sellers



\*\*Grain:\*\* One row per seller.



\## category\_translation



\*\*Grain:\*\* One row per product category translation.

