-- Q13 - Product Sales Ranking Per Vendor
-- Completed units; competition ranking per vendor, including zero-sales products.
-- Compare product totals, not individual sales rows.

SELECT
    v.VendorName,
    p.ProductName,
    COALESCE(sales.UnitsSold, 0) AS UnitsSold,
    1 + COUNT(higher.ProductID) AS ProductRank
FROM Products p
INNER JOIN Vendors v ON v.VendorID = p.VendorID
LEFT JOIN
(
    SELECT oi.ProductID, SUM(CAST(oi.Quantity AS BIGINT)) AS UnitsSold
    FROM OrderItems oi
    INNER JOIN Orders o ON o.OrderID = oi.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY oi.ProductID
) sales ON sales.ProductID = p.ProductID
LEFT JOIN
(
    SELECT p2.VendorID, p2.ProductID,
           SUM(CAST(oi.Quantity AS BIGINT)) AS UnitsSold
    FROM Products p2
    INNER JOIN OrderItems oi ON oi.ProductID = p2.ProductID
    INNER JOIN Orders o ON o.OrderID = oi.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY p2.VendorID, p2.ProductID
) higher ON higher.VendorID = p.VendorID
        AND higher.UnitsSold > COALESCE(sales.UnitsSold, 0)
GROUP BY v.VendorID, v.VendorName, p.ProductID, p.ProductName, sales.UnitsSold
ORDER BY v.VendorName, v.VendorID, ProductRank, p.ProductName, p.ProductID;
