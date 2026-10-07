SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT
    v.VendorName,

    COALESCE(s.TotalRevenue, 0) AS TotalRevenue,

    CASE
        WHEN COALESCE(s.OrderCount, 0) = 0
            THEN 0
        ELSE s.TotalRevenue * 1.0 / s.OrderCount
    END AS AverageOrderValue,

    COALESCE(s.OrderCount, 0) AS OrderCount,

    r.AvgRating,

    COALESCE(u.UnsoldProductCount, 0)
        AS UnsoldProductCount

FROM Vendors v

LEFT JOIN
(
    SELECT
        p.VendorID,
        SUM(oi.Quantity * oi.UnitPrice)
            AS TotalRevenue,
        COUNT(DISTINCT o.OrderID)
            AS OrderCount

    FROM Products p
    INNER JOIN OrderItems oi
        ON p.ProductID = oi.ProductID
    INNER JOIN Orders o
        ON oi.OrderID = o.OrderID

    WHERE o.Status = 'Completed'

    GROUP BY p.VendorID
) s
    ON v.VendorID = s.VendorID

LEFT JOIN
(
    SELECT
        p.VendorID,
        AVG(CAST(r.Rating AS DECIMAL(10,2)))
            AS AvgRating

    FROM Products p
    INNER JOIN Reviews r
        ON p.ProductID = r.ProductID

    GROUP BY p.VendorID
) r
    ON v.VendorID = r.VendorID

LEFT JOIN
(
    SELECT
        p.VendorID,
        COUNT(*) AS UnsoldProductCount

    FROM Products p

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM OrderItems oi
        INNER JOIN Orders o
            ON oi.OrderID = o.OrderID
        WHERE oi.ProductID = p.ProductID
          AND o.Status = 'Completed'
    )

    GROUP BY p.VendorID
) u
    ON v.VendorID = u.VendorID

ORDER BY
    TotalRevenue DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;    