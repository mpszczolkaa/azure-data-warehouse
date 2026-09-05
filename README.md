# 📊 Azure Data Warehouse

This project demonstrates how to build an end-to-end Data Warehouse solution using Microsoft Azure, Azure Data Factory, Azure Data Lake Storage Gen2 and Azure Synapse Analytics.

The pipeline extracts data from the AdventureWorks OLTP database, processes it using ETL pipelines and Change Data Capture (CDC), and loads analytics-ready data into a Star Schema Data Warehouse.

The final data model is connected to Power BI to create an interactive sales analytics dashboard.
## **🏗️ Data Architecture**
<img width="1072" height="406" alt="image" src="https://github.com/user-attachments/assets/62d74f72-5a5c-49f6-9950-e204d7d63ed5" />

## **📖 Project Overview**

The pipeline performs the following steps:

**Source layer** – AdventureWorks transactional data is stored in Azure SQL Database contain 7 tables.

**Data ingestion** – Azure Data Factory extracts data from Azure SQL Database and loads it into Azure Data Lake Storage Gen2 Landing layer.

**Staging layer** – data from ADLS Gen2 is loaded into staging tables in Azure Synapse Dedicated SQL Pool, where it is prepared for further processing.

**Data Warehouse layer** – the data is transformed into a Star Schema consisting of fact and dimension tables. The model includes FactSales, DimCustomer, DimProduct and DimDate.

**Change Data Capture** – CDC is used to detect INSERT, UPDATE and DELETE operations in the source database. Changes are processed through Azure Data Factory, ADLS Gen2, staging tables and stored procedures to keep the Data Warehouse up to date.

**Data processing** – Synapse SQL stored procedures process CDC changes and apply them to the Data Warehouse tables.

**Data visualization** – Power BI is connected to the Synapse Data Warehouse and provides an interactive sales analytics dashboard.

## **🔄 Change Data Capture**

Change Data Capture (CDC) was implemented to process changes occurring in the AdventureWorks source database.
CDC uses the last processed LSN stored in the ETL_Control table to identify and process only new changes. The changes are stored as Parquet files in ADLS and then loaded into dedicated Synapse staging CDC tables for further processing.

The pipeline handles:

**INSERT**–new records are added to the Data Warehouse

**UPDATE** –existing records are updated

**DELETE** –deleted records are removed from the Data Warehouse

## **⭐Star Schema**
The Data Warehouse uses a Star Schema optimized for analytical queries. FactSales contains sales transactions and measures while dimension tables provide customer, product and date context.

<img width="795" height="979" alt="StarSchema" src="https://github.com/user-attachments/assets/c24f8a3a-36af-407b-ab98-0c3b59335840" />

## **🏭Azure Data Factory ETL**

Azure Data Factory is used as the main orchestration layer for the data pipeline.

The master pipeline coordinates multiple child pipelines responsible for CDC processing, full loads, staging and Data Warehouse loading.


**The pipeline flow includes:**

CDC pipelines for Customer, Person, Product and Sales Order data

Full Load pipelines for initial and supporting data loads

Loading data from ADLS Gen2 into Synapse staging tables

Execution of SQL stored procedures to transform and load the Data Warehouse

Loading dimension tables before the final FactSales table

<img width="1706" height="922" alt="image" src="https://github.com/user-attachments/assets/751b159f-fc47-49a6-aec4-4c796b7f2c0a" />





## 📊 Power BI Dashboard

The Power BI dashboard provides an interactive overview of sales performance.
<img width="1437" height="555" alt="image" src="https://github.com/user-attachments/assets/55494968-3b17-48d0-bd7d-ab28dfca4f2c" />

### Dashboard Features

 **Total Sales** — total revenue generated from sales.
 
 **Total Orders** — total number of sales orders.
 
 **Total Quantity** — total quantity of products sold.
 
 **Total Sales by Year** — sales trends over time.
 
 **Sales by Category and Subcategory** — sales analysis by product category with drill-down to subcategories.
 
 **Year Slicer** — interactive filtering by year.
 
 **Interactive Visuals** — selecting data points dynamically filters other visuals.

### Drill-Down

The **Sales by Category and Subcategory** visual supports drill-down analysis:

Category
   ↓
Subcategory

This allows users to move from a high-level category view to detailed product subcategory analysis.

## **🛡️ License**

This project is licensed under the MIT License. You are free to use, modify, and share this project with proper attribution.







