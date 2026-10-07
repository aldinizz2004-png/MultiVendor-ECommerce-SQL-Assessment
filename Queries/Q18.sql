SELECT DISTINCT
    c.CustomerID,

    CONCAT(
        c.FirstName,
        ' ',
        c.LastName
    ) AS CustomerName,

    firstMonth.MonthStart AS FirstMonth,
    secondMonth.MonthStart AS SecondMonth

FROM
(
    SELECT DISTINCT
        CustomerID,

        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart

    FROM Orders

    WHERE Status = 'Completed'
) firstMonth

INNER JOIN
(
    SELECT DISTINCT
        CustomerID,

        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart

    FROM Orders

    WHERE Status = 'Completed'
) secondMonth

    ON firstMonth.CustomerID =
       secondMonth.CustomerID

   AND secondMonth.MonthStart =
       DATEADD(
           MONTH,
           1,
           firstMonth.MonthStart
       )

INNER JOIN Customers c
    ON firstMonth.CustomerID = c.CustomerID

ORDER BY
    c.CustomerID,
    FirstMonth;