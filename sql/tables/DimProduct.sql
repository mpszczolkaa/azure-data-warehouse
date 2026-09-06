CREATE TABLE dw.DimProduct
(
    ProductKey          INT IDENTITY(1,1) NOT NULL,
    ProductID           INT NOT NULL,
    ProductName         VARCHAR(100) NULL,
    ProductNumber       VARCHAR(50) NULL,
    Color               VARCHAR(30) NULL,
    Size               VARCHAR(20) NULL,
    ListPrice           DECIMAL(18,2) NULL,
    SubcategoryID       INT NULL,
    SubcategoryName     VARCHAR(100) NULL,
    CategoryID          INT NULL,
    CategoryName        VARCHAR(100) NULL



);

INSERT INTO dw.DimProduct
(
    ProductID,
    ProductName,
    ProductNumber,
    Color,
    Size,
    ListPrice,
    SubcategoryID,
    SubcategoryName,
    CategoryID,
    CategoryName
)
SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Color,
    p.Size,
    p.ListPrice,
    ps.ProductSubcategoryID,
    ps.Name AS SubcategoryName,
    pc.ProductCategoryID,
    pc.Name AS CategoryName
FROM stg_Product p
LEFT JOIN stg_ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN stg_ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID;
