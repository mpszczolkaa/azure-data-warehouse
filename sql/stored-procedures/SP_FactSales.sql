CREATE PROCEDURE dw.LoadFactSales_CDC
AS
BEGIN
    SET NOCOUNT ON;

    --LATEST CHANGES SalesOrderHeader--


    IF OBJECT_ID('tempdb..#HeaderChanges') IS NOT NULL
        DROP TABLE #HeaderChanges;

    SELECT *
    INTO #HeaderChanges
    FROM
    (
        SELECT *,
               ROW_NUMBER() OVER
               (
                   PARTITION BY SalesOrderID
                   ORDER BY __$start_lsn DESC, __$seqval DESC
               ) AS rn
        FROM dbo.stg_SalesOrderHeader_CDC
        WHERE __$operation IN (2, 4)
    ) h
    WHERE rn = 1;


    --LATEST CHANGES SalesOrderDetail--
    

    IF OBJECT_ID('tempdb..#DetailChanges') IS NOT NULL
        DROP TABLE #DetailChanges;

    SELECT *
    INTO #DetailChanges
    FROM
    (
        SELECT *,
               ROW_NUMBER() OVER
               (
                   PARTITION BY SalesOrderID, SalesOrderDetailID
                   ORDER BY __$start_lsn DESC, __$seqval DESC
               ) AS rn
        FROM dbo.stg_SalesOrderDetail_CDC
        WHERE __$operation IN (2, 4)
    ) d
    WHERE rn = 1;


    
     
 --UPDATE FactSales--  

    UPDATE f
    SET
        f.DateKey =
            CONVERT(INT, CONVERT(VARCHAR(8), h.OrderDate, 112)),

        f.CustomerKey = dc.CustomerKey,

        f.ProductKey = dp.ProductKey,

        f.OrderQty = d.OrderQty,

        f.UnitPrice = d.UnitPrice,

        f.SalesAmount = d.LineTotal

    FROM dw.FactSales f

    INNER JOIN #DetailChanges d
        ON f.SalesOrderID = d.SalesOrderID
       AND f.SalesOrderDetailID = d.SalesOrderDetailID

    INNER JOIN #HeaderChanges h
        ON d.SalesOrderID = h.SalesOrderID

    LEFT JOIN dw.DimCustomer dc
        ON h.CustomerID = dc.CustomerID

    LEFT JOIN dw.DimProduct dp
        ON d.ProductID = dp.ProductID

    WHERE d.__$operation = 4;


     
   --INSERT FactSales--

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
        CONVERT(INT, CONVERT(VARCHAR(8), h.OrderDate, 112)),

        dc.CustomerKey,

        dp.ProductKey,

        d.SalesOrderID,

        d.SalesOrderDetailID,

        d.OrderQty,

        d.UnitPrice,

        d.LineTotal

    FROM #DetailChanges d

    INNER JOIN dbo.stg_SalesOrderHeader h
        ON d.SalesOrderID = h.SalesOrderID

    LEFT JOIN dw.DimCustomer dc
        ON h.CustomerID = dc.CustomerID

    LEFT JOIN dw.DimProduct dp
        ON d.ProductID = dp.ProductID

    WHERE d.__$operation = 2

      AND NOT EXISTS
      (
          SELECT 1
          FROM dw.FactSales f
          WHERE f.SalesOrderID = d.SalesOrderID
            AND f.SalesOrderDetailID = d.SalesOrderDetailID
      );


    
    
  -- DELETE FactSales--

    DELETE f
    FROM dw.FactSales f

    INNER JOIN
    (
        SELECT DISTINCT
            SalesOrderID,
            SalesOrderDetailID
        FROM dbo.stg_SalesOrderDetail_CDC
        WHERE __$operation = 1
    ) d
        ON f.SalesOrderID = d.SalesOrderID
       AND f.SalesOrderDetailID = d.SalesOrderDetailID;


    
    --DROP TEMPORARY TABLES--
   

    DROP TABLE #HeaderChanges;
    DROP TABLE #DetailChanges;
END;
GO
