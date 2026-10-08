-- Combined query runner; exact copies of Queries/Q1.sql through Q20.sql.
-- Run against the assessment database after seeding.

-- Q01 - Customer Order Summary
-- All order statuses count; customers without orders are excluded.

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY
    NumberOfOrders DESC,
    c.CustomerID;

GO

-- Q02 - Unordered Products
-- Never ordered means no OrderItems row in ANY order status.

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

GO

-- Q03 - Vendor Revenue Breakdown
-- Completed order lines only; include vendors with zero completed sales.

SELECT
    v.VendorID,
    v.VendorName,
    COALESCE(s.TotalOrders, 0) AS TotalOrders,
    COALESCE(s.TotalItemsSold, 0) AS TotalItemsSold,
    COALESCE(s.TotalRevenue, 0) AS TotalRevenue
FROM Vendors v
LEFT JOIN
(
    SELECT
        p.VendorID,
        COUNT(DISTINCT o.OrderID) AS TotalOrders,
        SUM(CAST(oi.Quantity AS BIGINT)) AS TotalItemsSold,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
    FROM Products p
    INNER JOIN OrderItems oi
        ON p.ProductID = oi.ProductID
    INNER JOIN Orders o
        ON oi.OrderID = o.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY
        p.VendorID
) s
    ON v.VendorID = s.VendorID
ORDER BY
    TotalRevenue DESC,
    v.VendorID;

GO

-- Q04 - Top 10 Spending Customers
-- Exactly ten customers at most; CustomerID breaks spending ties deterministically.

SELECT TOP 10
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderItems oi
    ON o.OrderID = oi.OrderID
WHERE o.Status = 'Completed'
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY
    TotalSpent DESC,
    c.CustomerID;

GO

-- Q05 - Inactive Customers
-- All statuses count. Exactly 90 days ago is inside the activity window.

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    MAX(o.OrderDate) AS LastOrderDate
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
HAVING
    MAX(o.OrderDate) < DATEADD(DAY, -90, SYSUTCDATETIME())
ORDER BY
    LastOrderDate,
    c.CustomerID;

GO

-- Q06 - Top-Selling Product Per Vendor
-- Units sold use completed orders. All tied products, including zero-sales ties, are returned.

SELECT
    v.VendorName,
    p.ProductName,
    SUM(
        CASE
            WHEN o.Status = 'Completed'
                THEN ISNULL(CAST(oi.Quantity AS BIGINT), 0)
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
          SELECT ISNULL(SUM(CAST(oi2.Quantity AS BIGINT)), 0)
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
                  THEN ISNULL(CAST(oi.Quantity AS BIGINT), 0)
              ELSE 0
          END
      )
)
ORDER BY
    v.VendorName,
    p.VendorID,
    p.ProductName,
    p.ProductID;

GO

-- Q07 - Second Most Expensive Product Per Category
-- Second DISTINCT price level, including all ties. Fewer than two price levels yields no row.

SELECT
    c.CategoryName,
    p.ProductName,
    p.Price
FROM Categories c
INNER JOIN ProductCategories pc
    ON c.CategoryID = pc.CategoryID
INNER JOIN Products p
    ON pc.ProductID = p.ProductID
WHERE
(
    SELECT COUNT(DISTINCT p2.Price)
    FROM ProductCategories pc2
    INNER JOIN Products p2
        ON pc2.ProductID = p2.ProductID
    WHERE pc2.CategoryID = c.CategoryID
      AND p2.Price > p.Price
) = 1
ORDER BY
    c.CategoryName,
    p.ProductName;

GO

-- Q08 - Frequently Bought Together
-- All order statuses count, as Q8 specifies no status filter. One unordered pair per order.

SELECT
    p1.ProductName AS ProductA,
    p2.ProductName AS ProductB,
    COUNT(*) AS TimesBoughtTogether
FROM OrderItems oi1
INNER JOIN OrderItems oi2
    ON oi1.OrderID = oi2.OrderID
   AND oi1.ProductID < oi2.ProductID
INNER JOIN Products p1
    ON oi1.ProductID = p1.ProductID
INNER JOIN Products p2
    ON oi2.ProductID = p2.ProductID
GROUP BY
    p1.ProductID,
    p1.ProductName,
    p2.ProductID,
    p2.ProductName
ORDER BY
    TimesBoughtTogether DESC,
    ProductA,
    ProductB;

GO

-- Q09 - Month-over-Month Revenue Growth
-- Compare the immediately preceding CALENDAR month. Missing/zero prior revenue gives NULL growth.

SELECT
    YEAR(currentMonth.MonthStart) AS [Year],
    MONTH(currentMonth.MonthStart) AS [Month],
    currentMonth.Revenue,

    previousMonth.Revenue AS PreviousMonthRevenue,

    CASE
        WHEN previousMonth.Revenue IS NULL
          OR previousMonth.Revenue = 0
            THEN NULL

        ELSE
            ((currentMonth.Revenue - previousMonth.Revenue)
             * 100.0)
             / previousMonth.Revenue
    END AS GrowthPercentage

FROM
(
    SELECT
        DATEFROMPARTS(
            YEAR(o.OrderDate),
            MONTH(o.OrderDate),
            1
        ) AS MonthStart,

        SUM(oi.Quantity * oi.UnitPrice) AS Revenue

    FROM Orders o
    INNER JOIN OrderItems oi
        ON o.OrderID = oi.OrderID

    WHERE o.Status = 'Completed'

    GROUP BY
        DATEFROMPARTS(
            YEAR(o.OrderDate),
            MONTH(o.OrderDate),
            1
        )
) currentMonth

LEFT JOIN
(
    SELECT
        DATEFROMPARTS(
            YEAR(o.OrderDate),
            MONTH(o.OrderDate),
            1
        ) AS MonthStart,

        SUM(oi.Quantity * oi.UnitPrice) AS Revenue

    FROM Orders o
    INNER JOIN OrderItems oi
        ON o.OrderID = oi.OrderID

    WHERE o.Status = 'Completed'

    GROUP BY
        DATEFROMPARTS(
            YEAR(o.OrderDate),
            MONTH(o.OrderDate),
            1
        )
) previousMonth

    ON previousMonth.MonthStart =
       DATEADD(MONTH, -1, currentMonth.MonthStart)

ORDER BY
    currentMonth.MonthStart;

GO

-- Q10 - Comprehensive Vendor Performance
-- Completed sales; review-weighted ratings, NULL when unreviewed.
-- Sales, ratings and catalog counts are aggregated independently to avoid fan-out.

SELECT
    v.VendorName,
    COALESCE(s.TotalRevenue, 0) AS TotalRevenue,
    CASE WHEN COALESCE(s.OrderCount, 0) = 0 THEN 0
         ELSE s.TotalRevenue / s.OrderCount END AS AverageOrderValue,
    COALESCE(s.OrderCount, 0) AS OrderCount,
    r.AvgRating,
    COALESCE(catalog.ProductCount, 0) - COALESCE(s.SoldProductCount, 0) AS UnsoldProductCount
FROM Vendors v
LEFT JOIN
(
    SELECT p.VendorID,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue,
           COUNT(DISTINCT o.OrderID) AS OrderCount,
           COUNT(DISTINCT p.ProductID) AS SoldProductCount,
           SUM(CAST(oi.Quantity AS BIGINT)) AS TotalUnits
    FROM Products p
    INNER JOIN OrderItems oi ON oi.ProductID = p.ProductID
    INNER JOIN Orders o ON o.OrderID = oi.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY p.VendorID
) s ON s.VendorID = v.VendorID
LEFT JOIN
(
    SELECT p.VendorID, AVG(CAST(r.Rating AS DECIMAL(10,2))) AS AvgRating
    FROM Products p
    INNER JOIN Reviews r ON r.ProductID = p.ProductID
    GROUP BY p.VendorID
) r ON r.VendorID = v.VendorID
LEFT JOIN
(
    SELECT VendorID, COUNT(*) AS ProductCount
    FROM Products
    GROUP BY VendorID
) catalog ON catalog.VendorID = v.VendorID
ORDER BY TotalRevenue DESC, v.VendorName, v.VendorID;

GO

-- Q11 - Customer Spending Rank
-- Competition ranking: 1,1,3. Aggregate completed spending before comparing customers.
-- Customers with zero completed spending are included.

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COALESCE(spending.TotalSpent, 0) AS TotalSpent,
    1 + COUNT(higher.CustomerID) AS CustomerRank
FROM Customers c
LEFT JOIN
(
    SELECT o.CustomerID, SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
    FROM Orders o
    INNER JOIN OrderItems oi ON oi.OrderID = o.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY o.CustomerID
) spending ON spending.CustomerID = c.CustomerID
LEFT JOIN
(
    SELECT o.CustomerID, SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
    FROM Orders o
    INNER JOIN OrderItems oi ON oi.OrderID = o.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY o.CustomerID
) higher ON higher.TotalSpent > COALESCE(spending.TotalSpent, 0)
GROUP BY c.CustomerID, c.FirstName, c.LastName, spending.TotalSpent
ORDER BY TotalSpent DESC, c.CustomerID;

GO

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

GO

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

GO

-- Q14 - Customer Monthly Spending
-- Completed order lines grouped by both year and month.

SELECT
    c.CustomerID,

    CONCAT(
        c.FirstName,
        ' ',
        c.LastName
    ) AS CustomerName,

    YEAR(o.OrderDate) AS [Year],
    MONTH(o.OrderDate) AS [Month],

    SUM(
        oi.Quantity * oi.UnitPrice
    ) AS MonthlySpent

FROM Customers c

INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID

INNER JOIN OrderItems oi
    ON o.OrderID = oi.OrderID

WHERE o.Status = 'Completed'

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName,
    YEAR(o.OrderDate),
    MONTH(o.OrderDate)

ORDER BY
    c.CustomerID,
    [Year],
    [Month];

GO

-- Q15 - Product Price Change Analysis
-- Include any historical change, even a return to the original price (difference = 0).

SELECT
    p.ProductID,
    p.ProductName,

    original.Price AS OriginalPrice,

    p.Price AS CurrentPrice,

    p.Price - original.Price AS PriceDifference

FROM Products p
INNER JOIN PriceHistory original
    ON original.ProductID = p.ProductID
   AND original.EffectiveFrom =
       (SELECT MIN(ph.EffectiveFrom)
        FROM PriceHistory ph
        WHERE ph.ProductID = p.ProductID)
WHERE original.Price <> p.Price
   OR EXISTS
      (SELECT 1
       FROM PriceHistory changed
       WHERE changed.ProductID = p.ProductID
         AND changed.Price <> original.Price)

ORDER BY
    p.ProductID;

GO

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

GO

-- Q17 - Customer Retention
-- Any order status; distinct YEAR + MONTH, not month number alone.

SELECT
    c.CustomerID,

    CONCAT(
        c.FirstName,
        ' ',
        c.LastName
    ) AS CustomerName,

    COUNT(
        DISTINCT
        YEAR(o.OrderDate) * 100
        + MONTH(o.OrderDate)
    ) AS NumberOfMonthsWithOrders

FROM Customers c

INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName

HAVING
    COUNT(
        DISTINCT
        YEAR(o.OrderDate) * 100
        + MONTH(o.OrderDate)
    ) >= 2

ORDER BY
    NumberOfMonthsWithOrders DESC,
    c.CustomerID;

GO

-- Q18 - Consecutive Monthly Purchases
-- Completed orders only. December -> January is consecutive; return each qualifying month pair.

SELECT DISTINCT
    c.CustomerID,

    CONCAT(
        c.FirstName,
        ' ',
        c.LastName
    ) AS CustomerName,

    firstMonth.MonthStart AS FirstMonth,
    secondMonth.MonthStart AS SecondMonth

FROM
(
    SELECT DISTINCT
        CustomerID,

        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart

    FROM Orders

    WHERE Status = 'Completed'
) firstMonth

INNER JOIN
(
    SELECT DISTINCT
        CustomerID,

        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart

    FROM Orders

    WHERE Status = 'Completed'
) secondMonth

    ON firstMonth.CustomerID =
       secondMonth.CustomerID

   AND secondMonth.MonthStart =
       DATEADD(
           MONTH,
           1,
           firstMonth.MonthStart
       )

INNER JOIN Customers c
    ON firstMonth.CustomerID = c.CustomerID

ORDER BY
    c.CustomerID,
    FirstMonth;

GO

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

GO

-- Q20 - Vendor Performance Matrix
-- Completed sales; review-weighted ratings, NULL when unreviewed.
-- Sales, ratings and catalog counts are aggregated independently to avoid fan-out.

SELECT
    v.VendorName,
    COALESCE(s.TotalRevenue, 0) AS TotalRevenue,
    CASE WHEN COALESCE(s.OrderCount, 0) = 0 THEN 0
         ELSE s.TotalRevenue / s.OrderCount END AS AvgOrderValue,
    COALESCE(s.OrderCount, 0) AS CompletedOrderCount,
    COALESCE(s.TotalUnits, 0) AS TotalUnits,
    r.AvgRating,
    COALESCE(catalog.ProductCount, 0) - COALESCE(s.SoldProductCount, 0) AS UnsoldCount
FROM Vendors v
LEFT JOIN
(
    SELECT p.VendorID,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue,
           COUNT(DISTINCT o.OrderID) AS OrderCount,
           COUNT(DISTINCT p.ProductID) AS SoldProductCount,
           SUM(CAST(oi.Quantity AS BIGINT)) AS TotalUnits
    FROM Products p
    INNER JOIN OrderItems oi ON oi.ProductID = p.ProductID
    INNER JOIN Orders o ON o.OrderID = oi.OrderID
    WHERE o.Status = 'Completed'
    GROUP BY p.VendorID
) s ON s.VendorID = v.VendorID
LEFT JOIN
(
    SELECT p.VendorID, AVG(CAST(r.Rating AS DECIMAL(10,2))) AS AvgRating
    FROM Products p
    INNER JOIN Reviews r ON r.ProductID = p.ProductID
    GROUP BY p.VendorID
) r ON r.VendorID = v.VendorID
LEFT JOIN
(
    SELECT VendorID, COUNT(*) AS ProductCount
    FROM Products
    GROUP BY VendorID
) catalog ON catalog.VendorID = v.VendorID
ORDER BY TotalRevenue DESC, v.VendorName, v.VendorID;

GO
