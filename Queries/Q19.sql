SELECT
    c.CategoryName,

    COALESCE(p.ProductCount, 0)
        AS ProductCount,

    COALESCE(s.UnitsSold, 0)
        AS UnitsSold,

    COALESCE(s.Revenue, 0)
        AS Revenue,

    r.AvgRating

FROM Categories c

LEFT JOIN
(
    SELECT
        pc.CategoryID,
        COUNT(DISTINCT pc.ProductID)
            AS ProductCount

    FROM ProductCategories pc

    GROUP BY pc.CategoryID
) p
    ON c.CategoryID = p.CategoryID

LEFT JOIN
(
    SELECT
        pc.CategoryID,

        SUM(oi.Quantity)
            AS UnitsSold,

        SUM(
            oi.Quantity * oi.UnitPrice
        ) AS Revenue

    FROM ProductCategories pc

    INNER JOIN OrderItems oi
        ON pc.ProductID = oi.ProductID

    INNER JOIN Orders o
        ON oi.OrderID = o.OrderID

    WHERE o.Status = 'Completed'

    GROUP BY pc.CategoryID
) s
    ON c.CategoryID = s.CategoryID

LEFT JOIN
(
    SELECT
        pc.CategoryID,

        AVG(
            CAST(
                r.Rating AS DECIMAL(10,2)
            )
        ) AS AvgRating

    FROM ProductCategories pc

    INNER JOIN Reviews r
        ON pc.ProductID = r.ProductID

    GROUP BY pc.CategoryID
) r
    ON c.CategoryID = r.CategoryID

ORDER BY
    c.CategoryName;