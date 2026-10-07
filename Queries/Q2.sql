
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

