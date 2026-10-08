-- Q12 - Category Revenue Analysis
-- Full sales credit to every product category; category totals are not additive across categories.

SELECT
    c.CategoryID,
    c.CategoryName,

    COALESCE(
        SUM(
            CASE
                WHEN o.OrderID IS NOT NULL
                    THEN CAST(oi.Quantity AS BIGINT)
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
