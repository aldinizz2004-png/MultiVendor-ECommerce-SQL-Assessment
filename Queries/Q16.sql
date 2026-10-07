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