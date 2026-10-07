SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    x.VendorName,
    x.ProductName,
    x.UnitsSold,

    1 +
    (
        SELECT COUNT(*)

        FROM
        (
            SELECT
                p2.VendorID,
                p2.ProductID,

                SUM(
                    CASE
                        WHEN o2.Status = 'Completed'
                            THEN ISNULL(oi2.Quantity, 0)
                        ELSE 0
                    END
                ) AS UnitsSold

            FROM Products p2

            LEFT JOIN OrderItems oi2
                ON p2.ProductID = oi2.ProductID

            LEFT JOIN Orders o2
                ON oi2.OrderID = o2.OrderID

            GROUP BY
                p2.VendorID,
                p2.ProductID
        ) y

        WHERE y.VendorID = x.VendorID
          AND y.UnitsSold > x.UnitsSold

    ) AS ProductRank

FROM
(
    SELECT
        v.VendorID,
        v.VendorName,
        p.ProductID,
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
        v.VendorID,
        v.VendorName,
        p.ProductID,
        p.ProductName
) x

ORDER BY
    x.VendorName,
    ProductRank,
    x.ProductName;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;