
--ENABLE FOR DATABASE--
EXEC sys.sp_cdc_enable_db;


--CDC table Sales.Customer--
EXEC sys.sp_cdc_enable_table
    @source_schema = 'Sales',
    @source_name = 'Customer',
    @role_name = NULL;


--CDC table Person.Person--
EXEC sys.sp_cdc_enable_table
    @source_schema = 'Person',
    @source_name = 'Person',
    @role_name = NULL;


--CDC table Production.Product
EXEC sys.sp_cdc_enable_table
    @source_schema = 'Production',
    @source_name = 'Product',
    @role_name = NULL;


--CDC table Sales.SalesOrderHeader--
EXEC sys.sp_cdc_enable_table
    @source_schema = 'Sales',
    @source_name = 'SalesOrderHeader',
    @role_name = NULL;


--CDC table Sales.OrderDetail
EXEC sys.sp_cdc_enable_table
    @source_schema = 'Sales',
    @source_name = 'SalesOrderDetail',
    @role_name = NULL;
