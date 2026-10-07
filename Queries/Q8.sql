SELECT
    p1.ProductName AS ProductA,
    p2.ProductName AS ProductB,
    COUNT(*) AS TimesBoughtTogether
FROM OrderItems oi1
INNER JOIN OrderItems oi2
    ON oi1.OrderID = oi2.OrderID
   AND oi1.ProductID < oi2.ProductID
INNER JOIN Orders o
    ON oi1.OrderID = o.OrderID
INNER JOIN Products p1
    ON oi1.ProductID = p1.ProductID
INNER JOIN Products p2
    ON oi2.ProductID = p2.ProductID
WHERE o.Status = 'Completed'
GROUP BY
    p1.ProductID,
    p1.ProductName,
    p2.ProductID,
    p2.ProductName
ORDER BY
    TimesBoughtTogether DESC,
    ProductA,
    ProductB;