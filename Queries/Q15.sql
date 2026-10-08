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
