SELECT
    p.ProductID,
    p.ProductName,

    (
        SELECT TOP 1
            ph.Price
        FROM PriceHistory ph
        WHERE ph.ProductID = p.ProductID
        ORDER BY ph.EffectiveFrom
    ) AS OriginalPrice,

    p.Price AS CurrentPrice,

    p.Price -
    (
        SELECT TOP 1
            ph.Price
        FROM PriceHistory ph
        WHERE ph.ProductID = p.ProductID
        ORDER BY ph.EffectiveFrom
    ) AS PriceDifference

FROM Products p

WHERE
    (
        SELECT TOP 1
            ph.Price
        FROM PriceHistory ph
        WHERE ph.ProductID = p.ProductID
        ORDER BY ph.EffectiveFrom
    ) <> p.Price

ORDER BY
    p.ProductID;