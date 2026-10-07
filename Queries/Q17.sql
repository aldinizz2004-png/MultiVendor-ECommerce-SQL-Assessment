SELECT
    c.CustomerID,

    CONCAT(
        c.FirstName,
        ' ',
        c.LastName
    ) AS CustomerName,

    COUNT(
        DISTINCT
        YEAR(o.OrderDate) * 100
        + MONTH(o.OrderDate)
    ) AS NumberOfMonthsWithOrders

FROM Customers c

INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName

HAVING
    COUNT(
        DISTINCT
        YEAR(o.OrderDate) * 100
        + MONTH(o.OrderDate)
    ) >= 2

ORDER BY
    NumberOfMonthsWithOrders DESC,
    c.CustomerID;