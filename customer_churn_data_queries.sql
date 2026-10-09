create database customer_churn;

create table customer_churn_data
(
CustomerID int,
Age	int,
Gender	text,
Tenure int,
Usage_Frequency int,	
Support_Calls int,	
Payment_Delay int,	
Subscription_Type text,
Contract_Length text,
Total_Spend decimal,	
Last_Interaction int,	
Churn int
);


SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/jhern/OneDrive/Documents/JJ/SQL + POWERBI/REAL/Customer Churn/customer_churn_dataset.csv'
INTO TABLE customer_churn_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- Use this line to skip the CSV header row

SELECT * FROM customer_churn_data;

-- DATA CLEANING
WITH cte_duplicate AS
(
	SELECT
		*,
        ROW_NUMBER()OVER(PARTITION BY CustomerID, Age, Gender, Tenure, Usage_Frequency,	Support_Calls,	
						Payment_Delay,	Subscription_Type, Contract_Length, Total_Spend, Last_Interaction, Churn) AS row_num
	FROM customer_churn_data
) 
SELECT 
	*
FROM cte_duplicate
WHERE row_num > 1;

SELECT
	COUNT(DISTINCT CustomerID) AS total_customers
FROM customer_churn_data;

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
FROM customer_churn_data;

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
FROM customer_churn_data;

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
FROM customer_churn_data;

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

