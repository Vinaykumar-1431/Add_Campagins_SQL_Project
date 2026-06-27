# Add Campaign Analysis | SQL Data Analytics Project

## 📌 Project Overview

This project focuses on analyzing digital advertising campaign performance using **MySQL and SQL analytics**.
The goal is to extract meaningful insights from campaign, advertisement, user, and interaction data to measure performance, user engagement, and conversion metrics.

## 🛠️ Tools & Technologies

* MySQL Workbench
* SQL
* Data Analysis
* Database Design
* GitHub

## 📂 Dataset Tables

The database contains the following tables:

* **Users** – User demographic and profile information
* **Campaigns** – Campaign details and performance tracking
* **Ads** – Advertisement information
* **Ad Events** – User interactions such as impressions, clicks, leads, and opportunities

## 🎯 Business Objectives

Analyze campaign effectiveness and answer important business questions:

* Identify top-performing ads
* Measure campaign CTR (Click Through Rate)
* Calculate conversion rates
* Analyze user engagement
* Find performance trends
* Detect data quality issues

## 📊 Key SQL Analysis Performed

### 1. Top Ads Performance

* Find top 3 ads per campaign based on clicks

### 2. Campaign CTR Analysis

Formula:

CTR = Total Clicks / Total Impressions

Calculated daily CTR for each campaign.

### 3. User Engagement Analysis

* Find users with clicks above average
* Calculate engagement score

Engagement Score:

Clicks + Leads + Opportunities

### 4. Conversion Analysis

Conversion Rate:

Leads / Clicks

Used to identify high-performing campaigns and ads.

### 5. User Interaction Analysis

Performed analysis on:

* First interaction date
* Multi-campaign users
* Users who viewed but never clicked
* Continuous user activity

### 6. Campaign Performance Tracking

Analyzed:

* Running total of clicks
* Daily performance drops
* Campaign contribution percentage
* Top campaigns by location

### 7. Data Quality Checks

Identified:

* Ads where clicks > impressions
* Incorrect interaction records

## 📈 SQL Concepts Used

* SELECT statements
* JOIN operations
* GROUP BY
* Aggregate functions
* Subqueries
* Window functions
* CTEs
* Ranking functions
* Date functions
* Data validation queries

## 🚧 Challenges Faced

* Handling multiple table relationships
* Writing complex SQL queries
* Calculating business metrics correctly
* Managing large datasets
* Validating data accuracy

## 📁 Project Files

```
Add-Campaign-Analysis/
│
├── Add_Campaign_Analysis.sql
├── Campaigns_Data.csv
├── Ads.csv
├── Add_Events_Data.csv
└── README.md
```

## 👨‍💻 Author

Vinay Kumar

Skills:
SQL | Power BI | Python | Data Analytics
