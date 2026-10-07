SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    c.CategoryID,
    c.CategoryName,

    COALESCE(
        SUM(
            CASE
                WHEN o.OrderID IS NOT NULL
                    THEN oi.Quantity
                ELSE 0
            END
        ),
        0
    ) AS TotalItemsSold,

    COALESCE(
        SUM(
            CASE
                WHEN o.OrderID IS NOT NULL
                    THEN oi.Quantity * oi.UnitPrice
                ELSE 0
            END
        ),
        0
    ) AS TotalRevenue

FROM Categories c

LEFT JOIN ProductCategories pc
    ON c.CategoryID = pc.CategoryID

LEFT JOIN Products p
    ON pc.ProductID = p.ProductID

LEFT JOIN OrderItems oi
    ON p.ProductID = oi.ProductID

LEFT JOIN Orders o
    ON oi.OrderID = o.OrderID
   AND o.Status = 'Completed'

GROUP BY
    c.CategoryID,
    c.CategoryName

ORDER BY
    c.CategoryID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;