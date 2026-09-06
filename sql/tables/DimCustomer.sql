CREATE TABLE dw.DimCustomer
(
    CustomerKey INT IDENTITY(1,1) NOT NULL,
    CustomerID  INT NOT NULL,
    PersonID    INT NULL,
    StoreID     INT NULL,
    FirstName   VARCHAR(50) NULL,
    LastName    VARCHAR(50) NULL,
    FullName    VARCHAR(101) NULL
);


INSERT INTO dw.DimCustomer
(
    CustomerID,
    PersonID,
    StoreID,
    FirstName,
    LastName,
    FullName
)
SELECT
    c.CustomerID,
    c.PersonID,
    c.StoreID,
    p.FirstName,
    p.LastName,
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName
FROM dbo.stg_SalesCustomer c
LEFT JOIN stg_Person p
    ON c.PersonID = p.BusinessEntityID;
