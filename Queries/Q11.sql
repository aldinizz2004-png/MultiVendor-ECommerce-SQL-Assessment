-- Q11 - Customer Spending Rank
-- Competition ranking: 1,1,3. Aggregate completed spending before comparing customers.
-- Customers with zero completed spending are included.

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COALESCE(spending.TotalSpent, 0) AS TotalSpent,
    1 + COUNT(higher.CustomerID) AS CustomerRank
FROM Customers c
LEFT JOIN
(
    SELECT o.CustomerID, SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
    FROM Orders o
    INNER JOIN OrderItems oi ON oi.OrderID = o.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY o.CustomerID
) spending ON spending.CustomerID = c.CustomerID
LEFT JOIN
(
    SELECT o.CustomerID, SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
    FROM Orders o
    INNER JOIN OrderItems oi ON oi.OrderID = o.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY o.CustomerID
) higher ON higher.TotalSpent > COALESCE(spending.TotalSpent, 0)
GROUP BY c.CustomerID, c.FirstName, c.LastName, spending.TotalSpent
ORDER BY TotalSpent DESC, c.CustomerID;
