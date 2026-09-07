CREATE PROCEDURE SP_DimProduct
AS
BEGIN
    SET NOCOUNT ON;

  --INSERT NEW PRODUCT--

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
        p.Name,
        p.ProductNumber,
        p.Color,
        p.Size,
        p.ListPrice,
        s.ProductSubcategoryID,
        s.Name,
        c.ProductCategoryID,
        c.Name
    FROM dbo.stg_ProductionProduct_CDC p

    LEFT JOIN dbo.stg_ProductSubcategory s
        ON p.ProductSubcategoryID = s.ProductSubcategoryID

    LEFT JOIN dbo.stg_ProductCategory c
        ON s.ProductCategoryID = c.ProductCategoryID

    WHERE p.__$operation = 2

      AND NOT EXISTS
      (
          SELECT 1
          FROM dw.DimProduct d
          WHERE d.ProductID = p.ProductID
      );


--UPDATE PRODUCT--

    UPDATE d
    SET
        d.ProductName = p.Name,
        d.ProductNumber = p.ProductNumber,
        d.Color = p.Color,
        d.Size = p.Size,
        d.ListPrice = p.ListPrice,

        d.SubcategoryID = s.ProductSubcategoryID,
        d.SubcategoryName = s.Name,

        d.CategoryID = c.ProductCategoryID,
        d.CategoryName = c.Name

    FROM dw.DimProduct d

    INNER JOIN dbo.stg_ProductionProduct_CDC p
        ON d.ProductID = p.ProductID

    LEFT JOIN dbo.stg_ProductSubcategory s
        ON p.ProductSubcategoryID = s.ProductSubcategoryID

    LEFT JOIN dbo.stg_ProductCategory c
        ON s.ProductCategoryID = c.ProductCategoryID

    WHERE p.__$operation = 4;


--DELETE PRODUCT--

    DELETE d
    FROM dw.DimProduct d

    INNER JOIN dbo.stg_ProductionProduct_CDC p
        ON d.ProductID = p.ProductID

    WHERE p.__$operation = 1;

END;
GO
