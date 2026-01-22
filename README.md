# MySQL-Restaurant-Database-Project

Restaurant Orders Analysis project built using MySQL.
I created a small restaurant database and wrote SQL queries to analyze orders, revenue, customer spending, and menu performance.

## What this project contains
- Database creation: `restaurant`
- Tables: `customer`, `menu`, `orders`
- Sample data for customers, menu items, and orders
- 25+ queries to generate business insights

## Tables Used
- customer: customer details (name, city)
- menu: menu items, category, price
- orders: order transactions (date, quantity, payment mode)

## Analysis and Insights
Some of the insights generated in this project:
- Total orders and total revenue
- Revenue by payment method (UPI / Card / Cash)
- Top-selling items (by quantity and revenue)
- Category-wise revenue performance
- Customer spending and ranking
- Daily and monthly revenue trends

## SQL Concepts Practiced
- Joins (INNER JOIN, LEFT JOIN)
- Aggregations (SUM, AVG, COUNT)
- GROUP BY and HAVING
- Subqueries
- Window functions (RANK, Running Total)
- Views for invoice-style output
- Stored Procedure (customer summary)
- Indexing for better query performance

## Repository Files
- `restaurant_ordering.sql` : full project code (schema + inserts + queries)
- `SCREENSHOTS.pdf` : output screenshots and insights
- `screenshots/` : query output proof (optional)

## How to Run
1. Open MySQL
2. Run the SQL file:
   ```sql
   SOURCE restaurant_sql_project.sql;
