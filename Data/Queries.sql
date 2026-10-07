-- =========================================================
-- Q1 - Customer Order Summary
-- =========================================================

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY
    NumberOfOrders DESC;

-- =========================================================
-- Q2 - Unordered Products
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    v.VendorName
FROM Products p
INNER JOIN Vendors v
    ON p.VendorID = v.VendorID
WHERE NOT EXISTS
(
    SELECT 1
    FROM OrderItems oi
    WHERE oi.ProductID = p.ProductID
)
ORDER BY
    p.ProductID;    



    -- =========================================================
-- Q3 - Vendor Revenue Breakdown
-- =========================================================

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

-- =========================================================
-- Q4 - Top 10 Spending Customers
-- =========================================================

SELECT TOP 10
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderItems oi
    ON o.OrderID = oi.OrderID
WHERE o.Status = 'Completed'
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY
    TotalSpent DESC,
    c.CustomerID;


