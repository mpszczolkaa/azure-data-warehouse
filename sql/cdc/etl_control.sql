--CREATE TABLE CONTROL TO CDC--

CREATE TABLE ETL_Control
(
    TableName VARCHAR(100) NOT NULL PRIMARY KEY,
    LastProcessedLSN BINARY(10) NULL,
    LastRunDateTime DATETIME2 NULL
);

INSERT INTO dbo.ETL_Control
(
    TableName,
    LastProcessedLSN,
    LastRunDateTime
)
VALUES
('Sales_Customer', NULL, NULL),
('Person_Person', NULL, NULL),
('Production_Product', NULL, NULL),
('Production_ProductSubcategory', NULL, NULL),
('Production_ProductCategory', NULL, NULL),
('Sales_SalesOrderHeader', NULL, NULL),
('Sales_SalesOrderDetail', NULL, NULL);
