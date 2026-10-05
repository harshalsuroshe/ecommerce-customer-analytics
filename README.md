\# E-commerce Customer Profitability \& Retention Intelligence



\## Overview



An end-to-end data analytics project analyzing customer behavior,

revenue, customer value, and repeat purchasing in an e-commerce

marketplace.

## 📊 Power BI Dashboard

![E-commerce Sales Overview](images/powerbi-sales-overview.png)



## 🔍 Key Findings

- Generated approximately **13.22M in item revenue** across the analyzed transactions.
- Analyzed approximately **96K delivered orders**.
- Average Order Value was approximately **137.04**.
- Overall on-time delivery rate was approximately **91.89%**.
- **Health & Beauty** was the highest-performing product category by item revenue.
- **São Paulo (SP)** generated the highest item revenue among Brazilian states.
- Delivery performance showed a relationship with customer review scores, highlighting the importance of timely fulfillment.





\## Business Problem



The objective is to understand which customer behaviors and segments

are associated with higher customer value and repeat purchasing, and

translate the findings into actionable business recommendations.



\## Tools



\- SQL

\- PostgreSQL

\- Python

\- Pandas

\- Statistics

\- Power BI

\- Git/GitHub



\## Dataset



Brazilian E-Commerce Public Dataset by Olist.



The dataset contains approximately 100,000 orders from 2016–2018

and includes customer, order, product, seller, payment, review,

and delivery information.



\## Project Status



🚧 In Progress



\## Key Questions



\- Who are the most valuable customers?

\- What proportion of customers make repeat purchases?

\- How quickly do customers return?

\- Which customer segments have the highest value?

\- How does retention vary across cohorts?

\- What behaviors are associated with repeat purchasing?



\## Project Structure



```text

data/

sql/

python/

powerbi/

docs/

images/



\## Data Model



The project uses the Brazilian E-Commerce Public Dataset by Olist,

which contains multiple related tables covering customers, orders,

order items, payments, reviews, products, and sellers.



The primary analytical entities are:



\- Customers

\- Orders

\- Order Items

\- Products

\- Payments

\- Reviews

\- Sellers



A key modeling consideration is the distinction between order-level

and order-item-level grain. This prevents double-counting when

joining transactional tables.

```

* Data cleaning and validation with pandas.

* Order-level analytical table created by aggregating item, payment and review data.

* Exploratory analysis of sales, customer segments, categories, sellers, delivery and reviews.

* Exported datasets stored in `data/processed/powerbi/`.

* Visualisations stored in `images/`.

* Findings documented in `docs/python_eda_findings.md`.
