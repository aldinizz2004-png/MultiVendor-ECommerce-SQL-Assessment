-- =========================================================
-- Multi-Vendor E-Commerce Database
-- SQL Server
-- =========================================================


-- =========================================================
-- Customers
-- =========================================================

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,

    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(30) NULL,
    DateOfBirth DATE NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME()
);
GO


-- =========================================================
-- Customer Addresses
-- Customer 1 : N Addresses
-- =========================================================

CREATE TABLE CustomerAddresses (
    AddressID INT IDENTITY(1,1) PRIMARY KEY,

    CustomerID INT NOT NULL,

    AddressLine1 NVARCHAR(150) NOT NULL,
    AddressLine2 NVARCHAR(150) NULL,

    City NVARCHAR(100) NOT NULL,
    StateProvince NVARCHAR(100) NULL,
    PostalCode NVARCHAR(30) NULL,
    Country NVARCHAR(100) NOT NULL,

    IsDefault BIT NOT NULL DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_CustomerAddresses_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO


-- =========================================================
-- Vendors
-- =========================================================

CREATE TABLE Vendors (
    VendorID INT IDENTITY(1,1) PRIMARY KEY,

    VendorName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    Phone NVARCHAR(30) NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME()
);
GO


-- =========================================================
-- Vendor Details
-- Vendor 1 : 0..1 VendorDetails
-- VendorID is both PK and FK
-- =========================================================

CREATE TABLE VendorDetails (
    VendorID INT PRIMARY KEY,

    BusinessName NVARCHAR(150) NOT NULL,
    TaxNumber NVARCHAR(100) NULL,

    AddressLine1 NVARCHAR(150) NOT NULL,
    AddressLine2 NVARCHAR(150) NULL,

    City NVARCHAR(100) NOT NULL,
    StateProvince NVARCHAR(100) NULL,
    PostalCode NVARCHAR(30) NULL,
    Country NVARCHAR(100) NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_VendorDetails_Vendors
        FOREIGN KEY (VendorID)
        REFERENCES Vendors(VendorID)
);
GO


-- =========================================================
-- Categories
-- =========================================================

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,

    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500) NULL,

    IsActive BIT NOT NULL DEFAULT 1
);
GO


-- =========================================================
-- Products
-- Vendor 1 : N Products
-- =========================================================

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,

    VendorID INT NOT NULL,

    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(1000) NULL,

    Price DECIMAL(10,2) NOT NULL,

    StockQuantity INT NOT NULL DEFAULT 0,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Products_Vendors
        FOREIGN KEY (VendorID)
        REFERENCES Vendors(VendorID),

    CONSTRAINT CK_Products_Price
        CHECK (Price >= 0),

    CONSTRAINT CK_Products_StockQuantity
        CHECK (StockQuantity >= 0)
);
GO


-- =========================================================
-- Product Categories
-- Products M : N Categories
-- =========================================================

CREATE TABLE ProductCategories (
    ProductID INT NOT NULL,
    CategoryID INT NOT NULL,

    CONSTRAINT PK_ProductCategories
        PRIMARY KEY (ProductID, CategoryID),

    CONSTRAINT FK_ProductCategories_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    CONSTRAINT FK_ProductCategories_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);
GO


-- =========================================================
-- Orders
-- Customer 1 : N Orders
-- =========================================================

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,

    CustomerID INT NOT NULL,

    OrderDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    Status NVARCHAR(50) NOT NULL
        DEFAULT 'Pending',

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    CONSTRAINT CK_Orders_Status
        CHECK (
            Status IN (
                'Pending',
                'Paid',
                'Processing',
                'Shipped',
                'Completed',
                'Cancelled'
            )
        )
);
GO


-- =========================================================
-- Order Items
-- Order   1 : N OrderItems
-- Product 1 : N OrderItems
--
-- UnitPrice = actual price at purchase time
-- =========================================================

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,

    OrderID INT NOT NULL,
    ProductID INT NOT NULL,

    Quantity INT NOT NULL,

    UnitPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),

    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    CONSTRAINT CK_OrderItems_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_OrderItems_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT UQ_OrderItems_Order_Product
        UNIQUE (OrderID, ProductID)
);
GO


-- =========================================================
-- Payments
-- Order 1 : N Payments
--
-- Allows failed payment + retry
-- =========================================================

CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,

    OrderID INT NOT NULL,

    Amount DECIMAL(10,2) NOT NULL,

    PaymentMethod NVARCHAR(30) NOT NULL,

    Status NVARCHAR(20) NOT NULL
        DEFAULT 'Pending',

    PaymentDate DATETIME2 NULL,

    TransactionReference NVARCHAR(100) NULL,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),

    CONSTRAINT CK_Payments_Amount
        CHECK (Amount >= 0),

    CONSTRAINT CK_Payments_Method
        CHECK (
            PaymentMethod IN (
                'CreditCard',
                'DebitCard',
                'PayPal',
                'BankTransfer',
                'Cash'
            )
        ),

    CONSTRAINT CK_Payments_Status
        CHECK (
            Status IN (
                'Pending',
                'Completed',
                'Failed',
                'Refunded'
            )
        )
);
GO


-- =========================================================
-- Shipments
-- Order  1 : N Shipments
-- Vendor 1 : N Shipments
--
-- VendorID supports multi-vendor orders
-- =========================================================

CREATE TABLE Shipments (
    ShipmentID INT IDENTITY(1,1) PRIMARY KEY,

    OrderID INT NOT NULL,
    VendorID INT NOT NULL,

    ShippedDate DATETIME2 NULL,

    TrackingNumber NVARCHAR(100) NULL,
    Carrier NVARCHAR(100) NULL,

    DeliveryDate DATETIME2 NULL,

    Status NVARCHAR(20) NOT NULL
        DEFAULT 'Pending',

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Shipments_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),

    CONSTRAINT FK_Shipments_Vendors
        FOREIGN KEY (VendorID)
        REFERENCES Vendors(VendorID),

    CONSTRAINT CK_Shipments_Status
        CHECK (
            Status IN (
                'Pending',
                'Shipped',
                'InTransit',
                'Delivered',
                'Returned'
            )
        ),

    CONSTRAINT CK_Shipments_Dates
        CHECK (
            DeliveryDate IS NULL
            OR (
                ShippedDate IS NOT NULL
                AND DeliveryDate >= ShippedDate
            )
        )
);
GO


-- =========================================================
-- Reviews
-- Customer 1 : N Reviews
-- Product  1 : N Reviews
--
-- One customer can review a product once
-- =========================================================

CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,

    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,

    Rating TINYINT NOT NULL,

    Comment NVARCHAR(1000) NULL,

    ReviewDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Reviews_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    CONSTRAINT FK_Reviews_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    CONSTRAINT CK_Reviews_Rating
        CHECK (Rating BETWEEN 1 AND 5),

    CONSTRAINT UQ_Reviews_Customer_Product
        UNIQUE (CustomerID, ProductID)
);
GO


-- =========================================================
-- Price History
-- Product 1 : N PriceHistory
--
-- Products.Price = current price
-- PriceHistory   = historical prices
-- =========================================================

CREATE TABLE PriceHistory (
    PriceHistoryID INT IDENTITY(1,1) PRIMARY KEY,

    ProductID INT NOT NULL,

    Price DECIMAL(10,2) NOT NULL,

    EffectiveFrom DATETIME2 NOT NULL,
    EffectiveTo DATETIME2 NULL,

    CONSTRAINT FK_PriceHistory_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    CONSTRAINT CK_PriceHistory_Price
        CHECK (Price >= 0),

    CONSTRAINT CK_PriceHistory_Dates
        CHECK (
            EffectiveTo IS NULL
            OR EffectiveTo > EffectiveFrom
        ),

    CONSTRAINT UQ_PriceHistory_Product_EffectiveFrom
        UNIQUE (ProductID, EffectiveFrom)
);
GO


PRINT 'Database schema created successfully.';
GO