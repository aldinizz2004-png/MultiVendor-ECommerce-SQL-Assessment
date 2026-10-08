-- Q16 - Inventory Risk Analysis
-- Strictly below threshold; include inactive products because the task does not exclude them.

DECLARE @StockThreshold INT = 10;

SELECT
    p.ProductID,
    p.ProductName,
    v.VendorName,
    p.StockQuantity AS CurrentStock

FROM Products p

INNER JOIN Vendors v
    ON p.VendorID = v.VendorID

WHERE p.StockQuantity < @StockThreshold

ORDER BY
    p.StockQuantity,
    p.ProductID;
