
SELECT
    v.VendorID,
    v.VendorName,
    COALESCE(s.TotalOrders, 0) AS TotalOrders,
    COALESCE(s.TotalItemsSold, 0) AS TotalItemsSold,
    COALESCE(s.TotalRevenue, 0) AS TotalRevenue
FROM Vendors v
LEFT JOIN
(
    SELECT
        p.VendorID,
        COUNT(DISTINCT o.OrderID) AS TotalOrders,
        SUM(oi.Quantity) AS TotalItemsSold,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
    FROM Products p
    INNER JOIN OrderItems oi
        ON p.ProductID = oi.ProductID
    INNER JOIN Orders o
        ON oi.OrderID = o.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY
        p.VendorID
) s
    ON v.VendorID = s.VendorID
ORDER BY
    TotalRevenue DESC;
