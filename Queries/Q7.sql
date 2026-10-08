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
