CREATE PROCEDURE SP_DimCustomer
AS
BEGIN
    SET NOCOUNT ON;

--INSERT NEW CUSTOMER--
    
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
        CONCAT(p.FirstName, ' ', p.LastName)
    FROM dbo.stg_SalesCustomer_CDC c

    LEFT JOIN dbo.stg_PersonPerson_CDC p
        ON c.PersonID = p.BusinessEntityID

    WHERE c.__$operation = 2

      AND NOT EXISTS
      (
          SELECT 1
          FROM dw.DimCustomer d
          WHERE d.CustomerID = c.CustomerID
      );


--UPDATE DATA CUSTOMERS--
    UPDATE d
    SET
        d.PersonID = c.PersonID,
        d.StoreID = c.StoreID
    FROM dw.DimCustomer d

    INNER JOIN dbo.stg_SalesCustomer_CDC c
        ON d.CustomerID = c.CustomerID

    WHERE c.__$operation = 4;

--UPDATE DATA PERSON--
    UPDATE d
    SET
        d.FirstName = p.FirstName,
        d.LastName = p.LastName,
        d.FullName = CONCAT(p.FirstName, ' ', p.LastName)
    FROM dw.DimCustomer d

    INNER JOIN dbo.stg_PersonPerson_CDC p
        ON d.PersonID = p.BusinessEntityID

    WHERE p.__$operation = 4;

--DELETE CUSTOMER--

    DELETE d
    FROM dw.DimCustomer d

    INNER JOIN dbo.stg_SalesCustomer_CDC c
        ON d.CustomerID = c.CustomerID

    WHERE c.__$operation = 1;

END;
GO
