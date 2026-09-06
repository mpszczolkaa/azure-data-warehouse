CREATE TABLE dw.FactSales
(
    SalesKey           INT IDENTITY(1,1) NOT NULL,
    DateKey            INT NOT NULL,
    CustomerKey        INT NOT NULL,
    ProductKey         INT NOT NULL,
    SalesOrderID       INT NOT NULL,
    SalesOrderDetailID INT NOT NULL,
    OrderQty           INT NOT NULL,
    UnitPrice          DECIMAL(18,2) NOT NULL,
    SalesAmount        DECIMAL(18,2) NOT NULL
);




    INSERT INTO dw.FactSales
(
    DateKey,
    CustomerKey,
    ProductKey,
    SalesOrderID,
    SalesOrderDetailID,
    OrderQty,
    UnitPrice,
    SalesAmount
)
SELECT
    dt.DateKey,
    c.CustomerKey,
    p.ProductKey,
    d.SalesOrderID,
    d.SalesOrderDetailID,
    d.OrderQty,
    d.UnitPrice,
    d.OrderQty * d.UnitPrice AS SalesAmount
FROM stg_SalesOrderDetail d
INNER JOIN stg_SalesOrderHeader h
    ON d.SalesOrderID = h.SalesOrderID
INNER JOIN dw.DimCustomer c
    ON h.CustomerID = c.CustomerID
INNER JOIN dw.DimProduct p
    ON d.ProductID = p.ProductID
INNER JOIN dw.DimDate dt
    ON CAST(h.OrderDate AS DATE) = dt.[Date];

