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

### **Core Findings & Strategic Insights**

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




