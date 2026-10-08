-- Q10 - Comprehensive Vendor Performance
-- Completed sales; review-weighted ratings, NULL when unreviewed.
-- Sales, ratings and catalog counts are aggregated independently to avoid fan-out.

SELECT
    v.VendorName,
    COALESCE(s.TotalRevenue, 0) AS TotalRevenue,
    CASE WHEN COALESCE(s.OrderCount, 0) = 0 THEN 0
         ELSE s.TotalRevenue / s.OrderCount END AS AverageOrderValue,
    COALESCE(s.OrderCount, 0) AS OrderCount,
    r.AvgRating,
    COALESCE(catalog.ProductCount, 0) - COALESCE(s.SoldProductCount, 0) AS UnsoldProductCount
FROM Vendors v
LEFT JOIN
(
    SELECT p.VendorID,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue,
           COUNT(DISTINCT o.OrderID) AS OrderCount,
           COUNT(DISTINCT p.ProductID) AS SoldProductCount,
           SUM(CAST(oi.Quantity AS BIGINT)) AS TotalUnits
    FROM Products p
    INNER JOIN OrderItems oi ON oi.ProductID = p.ProductID
    INNER JOIN Orders o ON o.OrderID = oi.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY p.VendorID
) s ON s.VendorID = v.VendorID
LEFT JOIN
(
    SELECT p.VendorID, AVG(CAST(r.Rating AS DECIMAL(10,2))) AS AvgRating
    FROM Products p
    INNER JOIN Reviews r ON r.ProductID = p.ProductID
    GROUP BY p.VendorID
) r ON r.VendorID = v.VendorID
LEFT JOIN
(
    SELECT VendorID, COUNT(*) AS ProductCount
    FROM Products
    GROUP BY VendorID
) catalog ON catalog.VendorID = v.VendorID
ORDER BY TotalRevenue DESC, v.VendorName, v.VendorID;
