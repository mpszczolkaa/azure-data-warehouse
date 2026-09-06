CREATE TABLE dw.dimDate
(
    DateKey INT NOT NULL,
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL
);

WITH Numbers AS
(
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.all_columns a
    CROSS JOIN sys.all_columns b
),
Dates AS
(
    SELECT
        DATEADD(
            DAY,
            n,
            CAST('2011-05-31' AS DATE)
        ) AS FullDate
    FROM Numbers
    WHERE n <= DATEDIFF(
        DAY,
        '2011-05-31',
        '2014-06-30'
    )
)
INSERT INTO dw.dimDate
(
    DateKey,
    FullDate,
    Year,
    Quarter,
    Month,
    MonthName
)
SELECT
    YEAR(FullDate) * 10000
        + MONTH(FullDate) * 100
        + DAY(FullDate) AS DateKey,
    FullDate,
    YEAR(FullDate) AS Year,
    DATEPART(QUARTER, FullDate) AS Quarter,
    MONTH(FullDate) AS Month,
    DATENAME(MONTH, FullDate) AS MonthName
FROM Dates;
