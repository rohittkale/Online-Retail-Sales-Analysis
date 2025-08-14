# 📊 Online Retail Sales Analysis – Complete SQL-Based Data Model & BI Queries

A comprehensive *MySQL-based Online Retail Sales Analysis System* that demonstrates professional database design, indexing, data constraints, and advanced business intelligence (BI) queries.  
Includes *schema creation, sample data insertion, indexes, and 40+ analytical SQL queries* for customer insights, product performance, sales trends, and advanced reporting.

***

## 🚀 Features

### 🏗 Database Design
- *Relational Schema*: Customers, Products, Orders, Order Details, and Payments tables
- *Constraints*: Primary keys, foreign keys, unique constraints, and default values
- *Indexes*: Optimized performance with indexing on frequently queried fields
- *Sample Data*: Preloaded test data for immediate analysis
- *Data Integrity*: Enforced relationships and validation rules

### 📈 Business Intelligence Queries
- *Customer Insights*: Lifetime value, retention, and segmentation
- *Product Performance*: Bestsellers, slow movers, seasonal trends
- *Sales Analysis*: Monthly, quarterly, and yearly sales breakdown
- *Discount Impact*: Revenue and quantity correlation with discounts
- *Payment Analysis*: Payment method preferences and trends
- *Geographic Revenue*: Country/state-wise revenue distribution
- *Advanced Analytics*: RFM analysis, market basket analysis, customer cohorts

### 🔧 Technical Features
- *Fully Normalized Design*: Eliminates redundancy and ensures scalability
- *Optimized Joins*: Efficient queries for large datasets
- *Reusable Queries*: Modular SQL patterns for BI reporting
- *Performance Tuning*: Index-based acceleration for key reports

***

## 🛠 Tech Stack

| Component | Technology | Implementation |
|-----------|------------|----------------|
| *Database* | MySQL 8.0+ | Schema, constraints, triggers |
| *Data Model* | ERD-based | 3NF relational design |
| *Queries* | SQL (DML, DDL) | BI queries, aggregations, joins |
| *Indexing* | MySQL Indexes | Performance optimization |
| *Security* | Constraints & Permissions | Data consistency and role-based access |

***

## 🚀 Getting Started

### Prerequisites
- *MySQL Server* 8.0 or higher
- *SQL Client*: MySQL Workbench, DBeaver, or CLI

### Installation

1. Clone or Download the Project
```bash
git clone https://github.com/rohittkale/online-retail-sales-analysis.git
cd online-retail-sales-analysis
```

2. *Run the SQL Script*
   sql
   -- Start MySQL server
   mysql -u root -p

   -- Execute the script
   source /path/to/OnlineRetail_Master.sql
   

3. *Database Name*
   
   OnlineRetail
   

4. *Explore Data*
   Run included queries for instant insights.

***

## 📊 Example Queries

*1. Total Revenue*
sql
SELECT SUM(total_amount) AS total_revenue FROM Orders;


*2. Top 5 Customers by Spending*
sql
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;


*3. Monthly Sales Trend*
sql
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS revenue
FROM Orders
GROUP BY month
ORDER BY month;


***

## 🌟 Key Learning Outcomes

This project demonstrates proficiency in:
- *Database Design & Normalization*
- *Advanced SQL Queries* for BI reporting
- *Data Integrity & Constraints*
- *Performance Optimization with Indexing*
- *Aggregations, Joins, and Subqueries*
- *Business Intelligence Insights using SQL*

***

## 🚀 Future Enhancements
- [ ] Add stored procedures for automated reporting
- [ ] Create database triggers for real-time data updates
- [ ] Implement role-based access control
- [ ] Integrate with a dashboard tool (Power BI / Tableau)
- [ ] Automate monthly revenue reports

***

## 🐛 Troubleshooting

*Database Import Error*

Solution:
- Ensure MySQL server version is 8.0+
- Check SQL script path and permissions
- Use UTF-8 encoding when importing


*Query Running Slow*

Solution:
- Ensure indexes are created (run SHOW INDEX FROM table_name)
- Use EXPLAIN to analyze query execution plan
- Optimize joins and WHERE clauses


***

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (git checkout -b feature/NewFeature)
3. Commit your changes (git commit -m 'Add NewFeature')
4. Push to the branch (git push origin feature/NewFeature)
5. Open a Pull Request

***

## 📄 License
This project is created for educational and analytical purposes.  
Feel free to use, modify, and share with attribution.

***

## 🙋 Author
*Name*: Rohit Pran Kale  
*Email*: [kalerohit1912@gmail.com](mailto:kalerohit1912@gmail.com)  
*LinkedIn*: [linkedin.com/in/rohitkale](https://linkedin.com/in/rohitkale)  
*GitHub*: [github.com/rohitkale](https://github.com/rohitkale)

***

⭐ *Star this repository if you found it helpful for learning SQL & Data Analysis!*

***

*Happy Querying! 📊*

Built with ❤ using MySQL
