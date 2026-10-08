-- Required connection options for filtered indexes.
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

-- =========================================================
-- INDEXES
-- =========================================================


-- Customer -> Addresses
CREATE INDEX IX_CustomerAddresses_CustomerID
ON CustomerAddresses(CustomerID);
GO

-- At most one default address per customer; zero defaults is allowed.
CREATE UNIQUE INDEX UX_CustomerAddresses_Default
ON CustomerAddresses(CustomerID)
WHERE IsDefault = 1;
GO


-- Vendor -> Products
CREATE INDEX IX_Products_VendorID
ON Products(VendorID) INCLUDE (ProductName, Price);
GO


-- Category -> Products
-- ProductCategories PK already starts with ProductID,
-- so this index supports queries starting from CategoryID.
CREATE INDEX IX_ProductCategories_CategoryID_ProductID
ON ProductCategories(CategoryID, ProductID);
GO


-- Customer order history / last order / monthly activity
CREATE INDEX IX_Orders_CustomerID_OrderDate
ON Orders(CustomerID, OrderDate) INCLUDE (Status);
GO


-- Completed-order analytics and monthly revenue
CREATE INDEX IX_Orders_Status_OrderDate
ON Orders(Status, OrderDate) INCLUDE (CustomerID);
GO


-- Product sales analytics
-- OrderItems already has UNIQUE(OrderID, ProductID),
-- so we add the reverse access path.
CREATE INDEX IX_OrderItems_ProductID_OrderID
ON OrderItems(ProductID, OrderID) INCLUDE (Quantity, UnitPrice);
GO

-- Order-first revenue queries need Quantity/UnitPrice without a row lookup.
-- The UNIQUE(OrderID, ProductID) constraint does not cover these value columns.
CREATE INDEX IX_OrderItems_OrderID_Covering
ON OrderItems(OrderID) INCLUDE (ProductID, Quantity, UnitPrice);
GO


-- Payment lookup by order
CREATE INDEX IX_Payments_OrderID
ON Payments(OrderID);
GO


-- Shipment lookup
CREATE INDEX IX_Shipments_OrderID
ON Shipments(OrderID);
GO

CREATE INDEX IX_Shipments_VendorID
ON Shipments(VendorID);
GO


-- Product rating analytics
CREATE INDEX IX_Reviews_ProductID
ON Reviews(ProductID) INCLUDE (Rating);
GO

-- A product can have only one open-ended current price.
CREATE UNIQUE INDEX UX_PriceHistory_Current
ON PriceHistory(ProductID) INCLUDE (Price, EffectiveFrom)
WHERE EffectiveTo IS NULL;
GO
