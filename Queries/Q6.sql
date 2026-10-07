SET STATISTICS IO ON;
SET STATISTICS TIME ON;


SELECT
    v.VendorName,
    p.ProductName,
    SUM(
        CASE
            WHEN o.Status = 'Completed'
                THEN ISNULL(oi.Quantity, 0)
            ELSE 0
        END
    ) AS UnitsSold
FROM Vendors v
INNER JOIN Products p
    ON v.VendorID = p.VendorID
LEFT JOIN OrderItems oi
    ON p.ProductID = oi.ProductID
LEFT JOIN Orders o
    ON oi.OrderID = o.OrderID
GROUP BY
    v.VendorName,
    p.VendorID,
    p.ProductID,
    p.ProductName
HAVING NOT EXISTS
(
    SELECT 1
    FROM Products p2
    WHERE p2.VendorID = p.VendorID
      AND
      (
          SELECT ISNULL(SUM(oi2.Quantity), 0)
          FROM OrderItems oi2
          INNER JOIN Orders o2
              ON oi2.OrderID = o2.OrderID
          WHERE oi2.ProductID = p2.ProductID
            AND o2.Status = 'Completed'
      )
      >
      SUM(
          CASE
              WHEN o.Status = 'Completed'
                  THEN ISNULL(oi.Quantity, 0)
              ELSE 0
          END
      )
)
ORDER BY
    v.VendorName,
    p.ProductName;


SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;