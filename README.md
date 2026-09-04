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

The pipeline handles:

**INSERT**–new records are added to the Data Warehouse

**UPDATE** –existing records are updated

**DELETE** –deleted records are removed from the Data Warehouse

