-- Q19 - Category Performance Analysis
-- AvgRating is the equal-weight mean of rated PRODUCT averages; exclude unreviewed products.

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

        SUM(CAST(oi.Quantity AS BIGINT))
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

        AVG(r.ProductAvgRating) AS AvgRating

    FROM ProductCategories pc

    INNER JOIN
    (
        SELECT ProductID,
               AVG(CAST(Rating AS DECIMAL(10,2))) AS ProductAvgRating
        FROM Reviews
        GROUP BY ProductID
    ) r
        ON pc.ProductID = r.ProductID

    GROUP BY pc.CategoryID
) r
    ON c.CategoryID = r.CategoryID

ORDER BY
    c.CategoryName;
