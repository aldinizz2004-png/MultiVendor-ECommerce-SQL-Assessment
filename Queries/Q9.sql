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
