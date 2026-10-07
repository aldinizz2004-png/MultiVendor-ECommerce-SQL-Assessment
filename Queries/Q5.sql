SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    MAX(o.OrderDate) AS LastOrderDate
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
HAVING
    MAX(o.OrderDate) < DATEADD(DAY, -90, SYSUTCDATETIME())
ORDER BY
    LastOrderDate;