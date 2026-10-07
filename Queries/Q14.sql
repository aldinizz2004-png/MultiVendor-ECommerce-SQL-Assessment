SELECT
    c.CustomerID,

    CONCAT(
        c.FirstName,
        ' ',
        c.LastName
    ) AS CustomerName,

    YEAR(o.OrderDate) AS [Year],
    MONTH(o.OrderDate) AS [Month],

    SUM(
        oi.Quantity * oi.UnitPrice
    ) AS MonthlySpent

FROM Customers c

INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID

INNER JOIN OrderItems oi
    ON o.OrderID = oi.OrderID

WHERE o.Status = 'Completed'

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName,
    YEAR(o.OrderDate),
    MONTH(o.OrderDate)

ORDER BY
    c.CustomerID,
    [Year],
    [Month];