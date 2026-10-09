# Customer-Churn-Analysis

MySQL • Exploratory Data Analysis • Customer Risk Segmentation • Power BI 

### **Project Overview**
This project analyzes customer churn across 64,374 customer records to uncover the primary drivers of customer attrition and revenue loss. Using MySQL, the analysis combines data quality verification, KPI aggregation, behavioral threshold identification, demographic matrix evaluations, revenue loss measurement, and automated customer risk scoring. The resulting data model and metrics serve as the foundation for executive dashboards built in Power BI.

### **Data Source**

Primary Dataset: [customer_churn_dataset.csv](./customer_churn_dataset.csv)

### **Tools**

* **Excel** - Raw Data
* **MySQL Workbench** - Data Analysis 
* **Power BI** - Creating Reports

### **Key Performance Indicators (KPIs)**

| **Metric** | **Value** |
|--------|-------|
| **Total Customers** | 64,374 | 
| **Gross Potential Revenue** | $34,827,839.00 | 
| **Total Churned Customers** | 30,493 |
| **Overall Churn Rate** | 47.37% |
| **Average Customer Spend** | $541.02 |
| **Revenue Lost to Churn** | $15,836,117.00 |
| **Revenue Retained** | $18,991,722.00 |

### **Operational & Behavioral Benchmarks**

* **Average Customer Tenure**: 31.99 months   
* **Average Usage Frequency**: 15.08 sessions/month   
* **Average Payment Delay**: 17.13 days   
* **Average Support Calls**: 5.40 calls

### **📊Core Findings & Strategic Insights**

#### **1. Support Call Escalation Tipping Point**
* **0–3 Support Calls**: Churn remains low between **22.88%** and **24.84%**.
* **4 Support Calls**: Churn increases to **31.84%.**
* **5+ Support Calls**: Churn sharply surges past **60%** (peaking at 61.78% for 7 calls).
* **Action**: Trigger an automated intervention workflow when a customer reaches 4 support calls to prevent escalation.

#### **2. Payment Delay Thresholds**

* **0–15 Days Delay**: Churn remains low between **9.60%** and **10.17%**.
* **16–30 Days Delay**: Churn increases dramatically to **71.29%**.
* **Action**: Flag accounts with payment delays exceeding 15 days for proactive billing assistance and payment plan options.

#### **3. Contract Type & Subscription Performance**

* **Monthly Contracts**: Highest churn rate at **52.11%**.   
* **Annual Contracts**: Moderate churn rate at **47.13%**.   
* **Quarterly Contracts**: Lowest churn rate at **44.06%**.   
* **Highest Revenue Stream**: Premium Monthly ($4,093,538) and Basic Monthly ($4,057,946) subscriptions drive top-line revenue but suffer from ~51-52% churn.

#### **4. Tenure Dynamics**

* Customers in the **3+ Years** tenure bracket show the highest churn rate at **56.03%**.   
* Early-tenure customers **(7–12 Months)** demonstrate lower churn **(29.58%)**.   
* **Action**: Re-engage long-tenure customers with loyalty programs and product upgrades to reduce long-term fatigue.

### Customer Risk Scoring Matrix

A rules-based segmentation model categorizes customers into actionable risk tiers:
| Risk Segment | Criteria |
|--------------|----------|
| **High Risk**| Payment_Delay > 15 AND Support_Calls > 5 |
| **Medium Risk** | Payment_Delay between 7–15 days OR Support_Calls between 3–5 calls |
| **Low Risk** | All other active customers |

## 📊 Power BI Interactive Dashboard
This features an interactive Customer Churn Analysis Dashboard designed to monitor, analyze, and diagnose customer retention patterns. The dashboard visualizes critical business metrics to help stakeholders understand why customers leave, who is most likely to churn, and how operational friction impacts revenue loss.

<img width="812" height="494" alt="image" src="https://github.com/user-attachments/assets/18003c65-0c19-4c39-a2ee-12da253bb8aa" />


> 🔗 **Power BI File:** [Download the customer_churn_dashboard.pbix report](./customer_churn_dashboard.pbix)

### SQL Queries

This project utilizes MySQL Workbench to perform end-to-end data processing, exploratory analysis, and key performance indicator (KPI) calculations. Below is the breakdown of the SQL workflows executed on customer_churn_dataset:

```sql
-- 1. Total Customers, Total Revenue, Total Churn, Overall Churn Rate, and Average Spend
SELECT
	COUNT(CustomerID) AS total_customers,
    SUM(Total_Spend) AS total_revenue,
    SUM(Churn) AS total_churned_customers,
	ROUND((SUM(Churn) / COUNT(CustomerID)) * 100, 2) AS churned_rate_pct,
	AVG(Total_Spend) AS avg_spend
FROM customer_churn_data;

-- 2. Overall Customer Engagement & Operational Averages
-- (Avg Tenure, Avg Usage Frequency, Avg Payment Delay, Avg Support Calls)
SELECT 
	ROUND(AVG(Tenure), 2) AS avg_tenure,
    ROUND(AVG(Usage_Frequency), 2) AS avg_usage_frequency,
    ROUND(AVG(Payment_Delay), 2) AS avg_payment_delay,
    ROUND(AVG(Support_Calls), 2) AS avg_support_calls
FROM customer_churn_data;

-- 3. Churn Rate by Contract Length
SELECT
	Contract_Length,
    COUNT(CustomerID) AS total_customer,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100 / COUNT(CustomerID), 2) AS churned_rate_pct
FROM customer_churn_data
GROUP BY Contract_Length;

-- 4. Churn Rate & Customer Count by Support Call Volume
SELECT
	Support_Calls,
    COUNT(CustomerID) AS total_customer,
    SUM(Churn) AS total_churned_customer,
    ROUND((SUM(Churn) / COUNT(CustomerID)) * 100, 2) AS churned_rate_pct
FROM customer_churn_data
GROUP BY Support_Calls
ORDER BY Support_Calls ASC;

-- 5. Impact of Payment Delay on Churn
SELECT
	MIN(Payment_Delay), 
    MAX(Payment_Delay)
FROM customer_churn_data; -- To find the minimum and maximum Payment Delay for bracketing

SELECT
	CASE 
		WHEN Payment_Delay = 0 THEN "0 Days (On-Time)"
        WHEN Payment_Delay BETWEEN 1 AND 7 THEN "1-7 Days"
        WHEN Payment_Delay BETWEEN 8 AND 15 THEN "8-15 Days"
        WHEN Payment_Delay BETWEEN 16 AND 30 THEN "16-30 Days"
        ELSE "30+"
	END AS payment_delay_bracket,
    COUNT(CustomerID) AS total_customers,
    SUM(Churn) AS total_churned_customers,
    ROUND((SUM(Churn) / COUNT(CustomerID)) * 100, 2) AS churned_rate_pct
FROM customer_churn_data
GROUP BY payment_delay_bracket
ORDER BY churned_rate_pct desc;

-- 6. Demographics Matrix: Churn and Spend by Age Group and Gender
SELECT	
	MIN(Age),
    MAX(Age)
FROM customer_churn_data; To find the minimum and maximum Age for bracketing

SELECT
	CASE
		WHEN Age < 25 THEN "Under 25"
        WHEN Age BETWEEN 25 AND 34 THEN "25-34"
        WHEN Age BETWEEN 35 AND 49 THEN "35-49"
        WHEN Age BETWEEN 50 AND 64 THEN "50-64"
        ELSE "65+"
	END AS age_bracket,
    Gender,
    COUNT(CustomerID) AS total_customers,
    SUM(Churn) AS total_churned_customers,
    SUM(Total_Spend) AS total_spend,
    ROUND(AVG(Total_Spend), 2) as avg_spend,
    ROUND((SUM(Churn) / COUNT(CustomerID)) * 100, 2) AS churned_rate_pct
FROM customer_churn_data
GROUP BY age_bracket, Gender
ORDER BY age_bracket, Gender;

-- 7. Customer Tenure Cohort vs Churn
SELECT 
	MIN(Tenure),
    MAX(Tenure)
FROM customer_churn_data; To find the minimum and maximum Tenure for bracketing

SELECT 
	CASE
		WHEN Tenure <= 6 THEN "6 Months"
        WHEN Tenure BETWEEN 7 AND 12 THEN "7-12 Months"
        WHEN Tenure BETWEEN 13 AND 24 THEN "1-2 Years"
        WHEN Tenure BETWEEN 25 AND 36 THEN "2-3 Years"
        ELSE "3+ Years"
	END AS tenure_bracket,
    COUNT(CustomerID) AS total_customers,
    SUM(Churn) AS total_churned_customers,
    ROUND((SUM(Churn) / COUNT(CustomerID)) * 100, 2) AS churned_rate_pct
FROM customer_churn_data
GROUP BY tenure_bracket
ORDER BY churned_rate_pct DESC;

-- 8. Revenue Breakdown by Subscription Type and Contract Length
SELECT
	Subscription_Type,
    Contract_Length,
    COUNT(CustomerID) AS total_customers,
	SUM(Total_Spend) AS total_revenue,
    ROUND(AVG(Total_Spend), 2) AS avg_spend,
    SUM(Churn) AS total_churned_customers,
    ROUND((SUM(Churn) / COUNT(CustomerID)) * 100, 2) AS churned_rate_pct
FROM customer_churn_data
GROUP BY Subscription_Type, Contract_Length
ORDER BY total_revenue DESC;

-- 9. Revenue Retained vs Revenue Lost to Churn
SELECT
	SUM(CASE WHEN Churn = 0 THEN Total_Spend ELSE 0 END) AS retained_revenue,
    SUM(CASE WHEN Churn = 1 THEN Total_Spend ELSE 0 END) AS revenue_lost_to_churn,
    SUM(Total_Spend) AS gross_potential_revenue,
    ROUND(SUM(CASE WHEN Churn = 1 THEN Total_Spend ELSE 0 END) / SUM(Total_Spend),2) AS revenue_loss_percent
FROM customer_churn_data;

-- 10. Customer Risk Scoring Matrix
SELECT
	CustomerID,
    Subscription_Type,
    Contract_Length,
    Total_Spend,
    Churn,
    CASE
		WHEN (Payment_Delay > 15 AND Support_Calls > 5) THEN "High Risk"
        WHEN (Payment_Delay BETWEEN 7 AND 15 OR Support_Calls BETWEEN 3 AND 5) THEN "Medium Risk"
        ELSE "Low Risk"
	END AS risk_segment
FROM customer_churn_data;
```
### Strategic Recommendations

* **Route Support Escalations at Call 4**: Automatically assign dedicated retention support when a customer reaches 4 support calls to resolve root issues before churn surges past 60% at 5+ calls.   
* **Automate Billing Alerts at 10 Days**: Trigger proactive payment assistance and flexible billing reminders around Day 10 to prevent accounts from entering the 16+ day payment delay bracket, where churn spikes to 71.29%.   
* **Incentivize Monthly Contract Conversions**: Launch targeted promotions (such as a free month or upgrade perks) to convert Monthly subscribers (51.61% churn) into Quarterly or Annual plans with lower attrition rates.   
* **Launch a Long-Tenure Loyalty Program**: Create a VIP tier and legacy rewards for accounts crossing 2–3 years of tenure to combat product fatigue and decrease the high 56.03% churn rate among long-term customers.

## **Author - Jhernwin E. Flora**
This project is part of my portfolio, showcasing my skills essential for data analyst roles. 
