-- =========================================================
-- INDEXES
-- =========================================================


-- Customer -> Addresses
CREATE INDEX IX_CustomerAddresses_CustomerID
ON CustomerAddresses(CustomerID);
GO


-- Vendor -> Products
CREATE INDEX IX_Products_VendorID
ON Products(VendorID);
GO


-- Category -> Products
-- ProductCategories PK already starts with ProductID,
-- so this index supports queries starting from CategoryID.
CREATE INDEX IX_ProductCategories_CategoryID_ProductID
ON ProductCategories(CategoryID, ProductID);
GO


-- Customer order history / last order / monthly activity
CREATE INDEX IX_Orders_CustomerID_OrderDate
ON Orders(CustomerID, OrderDate);
GO


-- Completed-order analytics and monthly revenue
CREATE INDEX IX_Orders_Status_OrderDate
ON Orders(Status, OrderDate);
GO


-- Product sales analytics
-- OrderItems already has UNIQUE(OrderID, ProductID),
-- so we add the reverse access path.
CREATE INDEX IX_OrderItems_ProductID_OrderID
ON OrderItems(ProductID, OrderID);
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
ON Reviews(ProductID);
GO