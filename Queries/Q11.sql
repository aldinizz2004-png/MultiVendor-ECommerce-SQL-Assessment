SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    x.CustomerID,
    x.CustomerName,
    x.TotalSpent,

    1 +
    (
        SELECT COUNT(*)
        FROM
        (
            SELECT
                c2.CustomerID,
                SUM(
                    CASE
                        WHEN o2.Status = 'Completed'
                            THEN ISNULL(
                                oi2.Quantity * oi2.UnitPrice,
                                0
                            )
                        ELSE 0
                    END
                ) AS TotalSpent

            FROM Customers c2

            LEFT JOIN Orders o2
                ON c2.CustomerID = o2.CustomerID

            LEFT JOIN OrderItems oi2
                ON o2.OrderID = oi2.OrderID

            GROUP BY c2.CustomerID
        ) y

        WHERE y.TotalSpent > x.TotalSpent
    ) AS CustomerRank

FROM
(
    SELECT
        c.CustomerID,

        CONCAT(
            c.FirstName,
            ' ',
            c.LastName
        ) AS CustomerName,

        SUM(
            CASE
                WHEN o.Status = 'Completed'
                    THEN ISNULL(
                        oi.Quantity * oi.UnitPrice,
                        0
                    )
                ELSE 0
            END
        ) AS TotalSpent

    FROM Customers c

    LEFT JOIN Orders o
        ON c.CustomerID = o.CustomerID

    LEFT JOIN OrderItems oi
        ON o.OrderID = oi.OrderID

    GROUP BY
        c.CustomerID,
        c.FirstName,
        c.LastName
) x

ORDER BY
    x.TotalSpent DESC,
    x.CustomerID;
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;    