-- =========================================================
-- SeedData.sql
-- Multi-Vendor E-Commerce Database
-- SQL Server
-- =========================================================

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;


    -- =========================================================
    -- Prevent duplicate seeding
    -- =========================================================

    IF EXISTS (SELECT 1 FROM Customers)
       OR EXISTS (SELECT 1 FROM Vendors)
       OR EXISTS (SELECT 1 FROM Categories)
       OR EXISTS (SELECT 1 FROM Products)
       OR EXISTS (SELECT 1 FROM Orders)
    BEGIN
        RAISERROR(
            'Seed data already exists. Run this script only on an empty schema.',
            16,
            1
        );

        ROLLBACK TRANSACTION;
        RETURN;
    END;


    -- =========================================================
    -- 1. Vendors
    -- Required: 5
    -- =========================================================

    INSERT INTO Vendors
    (
        VendorName,
        Email,
        Phone,
        IsActive
    )
    VALUES
    ('TechNova Store',
     'sales@technova.test',
     '+970-599-100001',
     1),

    ('HomeSphere Market',
     'sales@homesphere.test',
     '+970-599-100002',
     1),

    ('UrbanStyle Fashion',
     'sales@urbanstyle.test',
     '+970-599-100003',
     1),

    ('ActiveLife Supply',
     'sales@activelife.test',
     '+970-599-100004',
     1),

    ('FutureGoods Outlet',
     'sales@futuregoods.test',
     '+970-599-100005',
     0);


    -- =========================================================
    -- 2. VendorDetails
    -- =========================================================

    INSERT INTO VendorDetails
    (
        VendorID,
        BusinessName,
        TaxNumber,
        AddressLine1,
        AddressLine2,
        City,
        StateProvince,
        PostalCode,
        Country
    )
    VALUES
    (
        1,
        'TechNova Trading Co.',
        'TN-10001',
        '15 Technology St.',
        NULL,
        'Ramallah',
        'West Bank',
        'P600',
        'Palestine'
    ),

    (
        2,
        'HomeSphere Market Co.',
        'HS-10002',
        '22 Market Rd.',
        NULL,
        'Nablus',
        'West Bank',
        'P400',
        'Palestine'
    ),

    (
        3,
        'UrbanStyle Fashion Co.',
        'US-10003',
        '31 Fashion Ave.',
        NULL,
        'Hebron',
        'West Bank',
        'P700',
        'Palestine'
    ),

    (
        4,
        'ActiveLife Supply Co.',
        'AL-10004',
        '44 Fitness St.',
        NULL,
        'Bethlehem',
        'West Bank',
        'P300',
        'Palestine'
    ),

    (
        5,
        'FutureGoods Outlet Co.',
        'FG-10005',
        '55 Outlet Blvd.',
        NULL,
        'Jenin',
        'West Bank',
        'P200',
        'Palestine'
    );


    -- =========================================================
    -- 3. Categories
    -- Required: 8
    -- =========================================================

    INSERT INTO Categories
    (
        CategoryName,
        Description,
        IsActive
    )
    VALUES
    (
        'Electronics',
        'Consumer electronic products',
        1
    ),

    (
        'Computers & Accessories',
        'Computer hardware and accessories',
        1
    ),

    (
        'Home & Kitchen',
        'Home and kitchen products',
        1
    ),

    (
        'Fashion',
        'Clothing and fashion products',
        1
    ),

    (
        'Sports & Outdoors',
        'Sports, fitness and outdoor products',
        1
    ),

    (
        'Books & Office',
        'Books, stationery and office products',
        1
    ),

    (
        'Clearance',
        'Clearance products with no seeded sales',
        1
    ),

    (
        'Seasonal',
        'Seasonal products',
        1
    );


    -- =========================================================
    -- 4. Customers
    -- Required: 20
    --
    -- Customers 16-18:
    -- old orders only
    --
    -- Customers 19-20:
    -- no orders
    -- =========================================================

    INSERT INTO Customers
    (
        FirstName,
        LastName,
        Email,
        PhoneNumber,
        DateOfBirth,
        IsActive
    )
    VALUES
    ('Adam', 'Khalil',
     'adam.khalil@test.com',
     '+970-599-200001',
     '1998-02-14',
     1),

    ('Lina', 'Nasser',
     'lina.nasser@test.com',
     '+970-599-200002',
     '2000-06-21',
     1),

    ('Omar', 'Saleh',
     'omar.saleh@test.com',
     '+970-599-200003',
     '1997-11-08',
     1),

    ('Sara', 'Haddad',
     'sara.haddad@test.com',
     '+970-599-200004',
     '2001-03-17',
     1),

    ('Yousef', 'Mansour',
     'yousef.mansour@test.com',
     '+970-599-200005',
     '1999-09-09',
     1),

    ('Maya', 'Awad',
     'maya.awad@test.com',
     '+970-599-200006',
     '2002-01-30',
     1),

    ('Ahmad', 'Darwish',
     'ahmad.darwish@test.com',
     '+970-599-200007',
     '1996-04-12',
     1),

    ('Noor', 'Hamdan',
     'noor.hamdan@test.com',
     '+970-599-200008',
     '2000-12-05',
     1),

    ('Kareem', 'AbuAli',
     'kareem.abuali@test.com',
     '+970-599-200009',
     '1998-07-24',
     1),

    ('Hala', 'Qasem',
     'hala.qasem@test.com',
     '+970-599-200010',
     '2001-10-15',
     1),

    ('Tareq', 'Sabbagh',
     'tareq.sabbagh@test.com',
     '+970-599-200011',
     '1995-05-19',
     1),

    ('Rana', 'Zaid',
     'rana.zaid@test.com',
     '+970-599-200012',
     '1999-08-28',
     1),

    ('Sami', 'Khatib',
     'sami.khatib@test.com',
     '+970-599-200013',
     '1997-02-02',
     1),

    ('Dana', 'Yasin',
     'dana.yasin@test.com',
     '+970-599-200014',
     '2002-04-23',
     1),

    ('Fadi', 'Jaber',
     'fadi.jaber@test.com',
     '+970-599-200015',
     '1996-12-11',
     1),

    ('Nadia', 'Shahin',
     'nadia.shahin@test.com',
     '+970-599-200016',
     '1994-03-08',
     0),

    ('Majd', 'Rashed',
     'majd.rashed@test.com',
     '+970-599-200017',
     '1993-06-16',
     0),

    ('Reem', 'Barakat',
     'reem.barakat@test.com',
     '+970-599-200018',
     '1995-09-27',
     0),

    ('Ali', 'Khoury',
     'ali.khoury@test.com',
     '+970-599-200019',
     '2001-01-07',
     1),

    ('Leen', 'Saeed',
     'leen.saeed@test.com',
     '+970-599-200020',
     '2002-11-29',
     1);


    -- =========================================================
    -- 5. CustomerAddresses
    -- Required: 30
    -- =========================================================

    INSERT INTO CustomerAddresses
    (
        CustomerID,
        AddressLine1,
        AddressLine2,
        City,
        StateProvince,
        PostalCode,
        Country,
        IsDefault
    )
    VALUES
    (1, '101 Main St.', NULL,
     'Ramallah', 'West Bank', 'P601',
     'Palestine', 1),

    (2, '102 Main St.', NULL,
     'Nablus', 'West Bank', 'P401',
     'Palestine', 1),

    (3, '103 Main St.', NULL,
     'Hebron', 'West Bank', 'P701',
     'Palestine', 1),

    (4, '104 Main St.', NULL,
     'Bethlehem', 'West Bank', 'P301',
     'Palestine', 1),

    (5, '105 Main St.', NULL,
     'Jenin', 'West Bank', 'P201',
     'Palestine', 1),

    (6, '106 Main St.', NULL,
     'Tulkarm', 'West Bank', 'P501',
     'Palestine', 1),

    (7, '107 Main St.', NULL,
     'Ramallah', 'West Bank', 'P602',
     'Palestine', 1),

    (8, '108 Main St.', NULL,
     'Nablus', 'West Bank', 'P402',
     'Palestine', 1),

    (9, '109 Main St.', NULL,
     'Hebron', 'West Bank', 'P702',
     'Palestine', 1),

    (10, '110 Main St.', NULL,
     'Bethlehem', 'West Bank', 'P302',
     'Palestine', 1),

    (11, '111 Main St.', NULL,
     'Jenin', 'West Bank', 'P202',
     'Palestine', 1),

    (12, '112 Main St.', NULL,
     'Tulkarm', 'West Bank', 'P502',
     'Palestine', 1),

    (13, '113 Main St.', NULL,
     'Ramallah', 'West Bank', 'P603',
     'Palestine', 1),

    (14, '114 Main St.', NULL,
     'Nablus', 'West Bank', 'P403',
     'Palestine', 1),

    (15, '115 Main St.', NULL,
     'Hebron', 'West Bank', 'P703',
     'Palestine', 1),

    (16, '116 Main St.', NULL,
     'Bethlehem', 'West Bank', 'P303',
     'Palestine', 1),

    (17, '117 Main St.', NULL,
     'Jenin', 'West Bank', 'P203',
     'Palestine', 1),

    (18, '118 Main St.', NULL,
     'Tulkarm', 'West Bank', 'P503',
     'Palestine', 1),

    (19, '119 Main St.', NULL,
     'Ramallah', 'West Bank', 'P604',
     'Palestine', 1),

    (20, '120 Main St.', NULL,
     'Nablus', 'West Bank', 'P404',
     'Palestine', 1),

    (1, '201 Work St.', 'Office 1',
     'Ramallah', 'West Bank', 'P611',
     'Palestine', 0),

    (2, '202 Work St.', 'Office 2',
     'Nablus', 'West Bank', 'P411',
     'Palestine', 0),

    (3, '203 Work St.', 'Office 3',
     'Hebron', 'West Bank', 'P711',
     'Palestine', 0),

    (4, '204 Work St.', 'Office 4',
     'Bethlehem', 'West Bank', 'P311',
     'Palestine', 0),

    (5, '205 Work St.', 'Office 5',
     'Jenin', 'West Bank', 'P211',
     'Palestine', 0),

    (6, '206 Work St.', 'Office 6',
     'Tulkarm', 'West Bank', 'P511',
     'Palestine', 0),

    (7, '207 Work St.', 'Office 7',
     'Ramallah', 'West Bank', 'P612',
     'Palestine', 0),

    (8, '208 Work St.', 'Office 8',
     'Nablus', 'West Bank', 'P412',
     'Palestine', 0),

    (9, '209 Work St.', 'Office 9',
     'Hebron', 'West Bank', 'P712',
     'Palestine', 0),

    (10, '210 Work St.', 'Office 10',
     'Bethlehem', 'West Bank', 'P312',
     'Palestine', 0);


    -- =========================================================
    -- 6. Products
    -- Required: 50
    --
    -- Products 41-50 intentionally remain unsold
    -- =========================================================

    INSERT INTO Products
    (
        VendorID,
        ProductName,
        Description,
        Price,
        StockQuantity,
        IsActive
    )
    VALUES

    -- Vendor 1
    (1, 'Wireless Mouse',
     '2.4GHz wireless mouse',
     25.99, 45, 1),

    (1, 'Mechanical Keyboard',
     'Mechanical keyboard',
     69.99, 30, 1),

    (1, 'USB-C Hub',
     'Multi-port USB-C hub',
     39.99, 8, 1),

    (1, 'HD Webcam',
     '1080p webcam',
     59.99, 18, 1),

    (1, 'Studio Headphones',
     'Over-ear headphones',
     89.99, 12, 1),

    (1, 'SSD 500GB',
     '500GB solid state drive',
     74.99, 6, 1),

    (1, 'Laptop Stand',
     'Adjustable laptop stand',
     34.99, 25, 1),

    (1, '24-inch Monitor',
     'Full HD monitor',
     149.99, 9, 1),

    (1, 'Power Bank',
     '10000mAh power bank',
     49.99, 40, 1),

    (1, 'Bluetooth Speaker',
     'Portable speaker',
     44.99, 22, 1),

    -- Vendor 2
    (2, 'Coffee Maker',
     'Compact coffee maker',
     79.99, 15, 1),

    (2, 'Electric Kettle',
     'Fast-boil electric kettle',
     32.50, 7, 1),

    (2, 'Air Fryer',
     'Digital air fryer',
     119.00, 11, 1),

    (2, 'Blender',
     'Multi-speed kitchen blender',
     64.50, 20, 1),

    (2, 'Toaster',
     'Two-slice toaster',
     29.99, 35, 1),

    (2, 'Cookware Set',
     'Non-stick cookware set',
     139.99, 5, 1),

    (2, 'Desk Lamp',
     'LED desk lamp',
     24.99, 50, 1),

    (2, 'Storage Box',
     'Large storage organizer',
     18.99, 60, 1),

    (2, 'Vacuum Cleaner',
     'Compact vacuum cleaner',
     129.99, 8, 1),

    (2, 'Water Filter Jug',
     'Filtered water jug',
     27.99, 28, 1),

    -- Vendor 3
    (3, 'Classic T-Shirt',
     'Cotton t-shirt',
     19.99, 80, 1),

    (3, 'Denim Jeans',
     'Classic denim jeans',
     49.99, 40, 1),

    (3, 'Running Shoes',
     'Lightweight running shoes',
     84.99, 9, 1),

    (3, 'Casual Jacket',
     'Light casual jacket',
     94.99, 16, 1),

    (3, 'Baseball Cap',
     'Adjustable baseball cap',
     17.99, 55, 1),

    (3, 'Leather Belt',
     'Classic leather belt',
     29.99, 30, 1),

    (3, 'Hoodie',
     'Fleece hoodie',
     54.99, 24, 1),

    (3, 'Backpack',
     'Everyday backpack',
     59.99, 14, 1),

    (3, 'Sports Socks',
     'Pack of sports socks',
     14.99, 75, 1),

    (3, 'Winter Scarf',
     'Warm winter scarf',
     22.99, 26, 1),

    -- Vendor 4
    (4, 'Yoga Mat',
     'Non-slip yoga mat',
     28.99, 33, 1),

    (4, 'Dumbbell Set',
     'Adjustable dumbbell set',
     99.99, 7, 1),

    (4, 'Resistance Bands',
     'Resistance band set',
     21.99, 45, 1),

    (4, 'Football',
     'Training football',
     26.99, 18, 1),

    (4, 'Basketball',
     'Indoor/outdoor basketball',
     31.99, 19, 1),

    (4, 'Camping Lantern',
     'Rechargeable camping lantern',
     37.99, 13, 1),

    (4, 'Water Bottle',
     'Insulated sports bottle',
     23.99, 70, 1),

    (4, 'Fitness Tracker',
     'Entry-level fitness tracker',
     67.99, 8, 1),

    (4, 'Jump Rope',
     'Speed jump rope',
     12.99, 65, 1),

    (4, 'Camping Chair',
     'Foldable camping chair',
     46.99, 10, 1),

    -- Vendor 5 - Unsold
    (5, 'Outlet Gadget A',
     'Clearance gadget',
     15.99, 20, 1),

    (5, 'Outlet Gadget B',
     'Clearance gadget',
     18.99, 20, 1),

    (5, 'Outlet Home Set',
     'Clearance home item',
     25.99, 20, 1),

    (5, 'Outlet Bag',
     'Clearance bag',
     29.99, 20, 1),

    (5, 'Outlet Bottle',
     'Clearance bottle',
     11.99, 20, 1),

    (5, 'Outlet Lamp',
     'Clearance lamp',
     16.99, 20, 1),

    (5, 'Outlet Shirt',
     'Clearance shirt',
     13.99, 20, 1),

    (5, 'Outlet Book Set',
     'Clearance book set',
     21.99, 20, 1),

    (5, 'Outlet Fitness Kit',
     'Clearance fitness kit',
     24.99, 20, 1),

    (5, 'Winter Gift Box',
     'Seasonal unsold product',
     39.99, 20, 0);


    -- =========================================================
    -- 7. ProductCategories
    -- =========================================================

    INSERT INTO ProductCategories
    (
        ProductID,
        CategoryID
    )
    VALUES
    (1,1),(1,2),
    (2,1),(2,2),
    (3,1),(3,2),
    (4,1),(4,2),
    (5,1),

    (6,1),(6,2),
    (7,2),
    (8,1),(8,2),
    (9,1),
    (10,1),

    (11,3),
    (12,3),
    (13,3),
    (14,3),
    (15,3),
    (16,3),
    (17,3),(17,6),
    (18,3),
    (19,3),
    (20,3),

    (21,4),
    (22,4),
    (23,4),(23,5),
    (24,4),
    (25,4),
    (26,4),
    (27,4),
    (28,4),(28,6),
    (29,4),(29,5),
    (30,4),

    (31,5),
    (32,5),
    (33,5),
    (34,5),
    (35,5),
    (36,5),
    (37,5),
    (38,1),(38,5),
    (39,5),
    (40,5),

    (41,7),
    (42,7),
    (43,7),
    (44,7),
    (45,7),
    (46,7),
    (47,7),
    (48,7),
    (49,7),

    (50,8);


    -- =========================================================
    -- 8. Orders
    -- Required: 100+
    -- Generated: 120
    -- =========================================================

    DECLARE @i INT = 1;
    DECLARE @CustomerID INT;
    DECLARE @OrderDate DATETIME2;
    DECLARE @Status NVARCHAR(50);
    DECLARE @MonthOffset INT;
    DECLARE @MonthStart DATE;


    WHILE @i <= 120
    BEGIN

        -- Orders 1-90
        -- Completed orders for customers 1-15
        -- across six calendar months

        IF @i <= 90
        BEGIN
            SET @CustomerID =
                ((@i - 1) % 15) + 1;

            SET @MonthOffset =
                (@i - 1) / 15;

            SET @MonthStart =
                DATEADD
                (
                    MONTH,
                    -@MonthOffset,
                    DATEFROMPARTS
                    (
                        YEAR(SYSUTCDATETIME()),
                        MONTH(SYSUTCDATETIME()),
                        1
                    )
                );

            SET @OrderDate =
                DATEADD
                (
                    DAY,
                    ((@i - 1) % 15),
                    CAST(@MonthStart AS DATETIME2)
                );

            SET @Status = 'Completed';
        END


        -- Orders 91-100
        -- Cancelled

        ELSE IF @i <= 100
        BEGIN
            SET @CustomerID =
                ((@i - 91) % 10) + 1;

            SET @OrderDate =
                DATEADD
                (
                    DAY,
                    -(@i - 90),
                    SYSUTCDATETIME()
                );

            SET @Status = 'Cancelled';
        END


        -- Orders 101-104
        -- Pending

        ELSE IF @i <= 104
        BEGIN
            SET @CustomerID =
                ((@i - 101) % 4) + 1;

            SET @OrderDate =
                DATEADD
                (
                    DAY,
                    -(@i - 100),
                    SYSUTCDATETIME()
                );

            SET @Status = 'Pending';
        END


        -- Orders 105-108
        -- Shipped

        ELSE IF @i <= 108
        BEGIN
            SET @CustomerID =
                ((@i - 105) % 4) + 5;

            SET @OrderDate =
                DATEADD
                (
                    DAY,
                    -(@i - 104),
                    SYSUTCDATETIME()
                );

            SET @Status = 'Shipped';
        END


        -- Orders 109-120
        -- Old completed orders for inactive customers 16-18

        ELSE
        BEGIN
            SET @CustomerID =
                16 + ((@i - 109) % 3);

            SET @MonthOffset =
                6 + ((@i - 109) / 3);

            SET @MonthStart =
                DATEADD
                (
                    MONTH,
                    -@MonthOffset,
                    DATEFROMPARTS
                    (
                        YEAR(SYSUTCDATETIME()),
                        MONTH(SYSUTCDATETIME()),
                        1
                    )
                );

            SET @OrderDate =
                DATEADD
                (
                    DAY,
                    5 + ((@i - 109) % 3),
                    CAST(@MonthStart AS DATETIME2)
                );

            SET @Status = 'Completed';
        END;


        INSERT INTO Orders
        (
            CustomerID,
            OrderDate,
            Status
        )
        VALUES
        (
            @CustomerID,
            @OrderDate,
            @Status
        );


        SET @i = @i + 1;
    END;


    -- =========================================================
    -- 9. OrderItems
    -- Required: 300+
    -- Generated: 360
    --
    -- 3 products per order.
    -- Products 41-50 remain unsold.
    -- =========================================================

    SET @i = 1;

    DECLARE @Product1 INT;
    DECLARE @Product2 INT;
    DECLARE @Product3 INT;


    WHILE @i <= 120
    BEGIN

        SET @Product1 =
            ((@i - 1) % 40) + 1;

        SET @Product2 =
            ((@i + 12) % 40) + 1;

        SET @Product3 =
            ((@i + 25) % 40) + 1;


        INSERT INTO OrderItems
        (
            OrderID,
            ProductID,
            Quantity,
            UnitPrice
        )
        SELECT
            @i,
            ProductID,
            1,
            Price
        FROM Products
        WHERE ProductID = @Product1;


        INSERT INTO OrderItems
        (
            OrderID,
            ProductID,
            Quantity,
            UnitPrice
        )
        SELECT
            @i,
            ProductID,
            1,
            Price
        FROM Products
        WHERE ProductID = @Product2;


        INSERT INTO OrderItems
        (
            OrderID,
            ProductID,
            Quantity,
            UnitPrice
        )
        SELECT
            @i,
            ProductID,
            1,
            Price
        FROM Products
        WHERE ProductID = @Product3;


        SET @i = @i + 1;
    END;


    -- =========================================================
    -- 10. Payments
    -- Required: 100+
    -- Generated: 125
    --
    -- One payment per order
    -- + five failed retry attempts.
    -- =========================================================

    INSERT INTO Payments
    (
        OrderID,
        Amount,
        PaymentMethod,
        Status,
        PaymentDate,
        TransactionReference
    )
    SELECT
        o.OrderID,

        SUM
        (
            oi.Quantity * oi.UnitPrice
        ),

        CASE o.OrderID % 5
            WHEN 0 THEN 'CreditCard'
            WHEN 1 THEN 'DebitCard'
            WHEN 2 THEN 'PayPal'
            WHEN 3 THEN 'BankTransfer'
            ELSE 'Cash'
        END,

        CASE
            WHEN o.Status = 'Cancelled'
                THEN 'Failed'

            WHEN o.Status = 'Pending'
                THEN 'Pending'

            ELSE 'Completed'
        END,

        CASE
            WHEN o.Status = 'Pending'
                THEN NULL

            ELSE
                DATEADD
                (
                    HOUR,
                    2,
                    o.OrderDate
                )
        END,

        CONCAT
        (
            'TXN-MAIN-',
            RIGHT
            (
                '0000'
                + CAST(o.OrderID AS VARCHAR(4)),
                4
            )
        )

    FROM Orders o

    INNER JOIN OrderItems oi
        ON oi.OrderID = o.OrderID

    GROUP BY
        o.OrderID,
        o.Status,
        o.OrderDate;


    -- Five failed retry attempts

    INSERT INTO Payments
    (
        OrderID,
        Amount,
        PaymentMethod,
        Status,
        PaymentDate,
        TransactionReference
    )
    SELECT
        o.OrderID,

        SUM
        (
            oi.Quantity * oi.UnitPrice
        ),

        'CreditCard',

        'Failed',

        DATEADD
        (
            MINUTE,
            30,
            o.OrderDate
        ),

        CONCAT
        (
            'TXN-RETRY-',
            RIGHT
            (
                '0000'
                + CAST(o.OrderID AS VARCHAR(4)),
                4
            )
        )

    FROM Orders o

    INNER JOIN OrderItems oi
        ON oi.OrderID = o.OrderID

    WHERE o.OrderID BETWEEN 1 AND 5

    GROUP BY
        o.OrderID,
        o.OrderDate;


    -- =========================================================
    -- 11. Shipments
    -- Required: 50+
    -- Generated: 60
    -- =========================================================

    SET @i = 1;

    DECLARE @ShipmentProductID INT;
    DECLARE @ShipmentVendorID INT;
    DECLARE @ShipmentOrderDate DATETIME2;


    WHILE @i <= 60
    BEGIN

        SET @ShipmentProductID =
            ((@i - 1) % 40) + 1;


        SELECT
            @ShipmentVendorID = VendorID
        FROM Products
        WHERE ProductID = @ShipmentProductID;


        SELECT
            @ShipmentOrderDate = OrderDate
        FROM Orders
        WHERE OrderID = @i;


        INSERT INTO Shipments
        (
            OrderID,
            VendorID,
            ShippedDate,
            TrackingNumber,
            Carrier,
            DeliveryDate,
            Status
        )
        VALUES
        (
            @i,

            @ShipmentVendorID,

            DATEADD
            (
                DAY,
                1,
                @ShipmentOrderDate
            ),

            CONCAT
            (
                'TRK-',
                RIGHT
                (
                    '00000'
                    + CAST(@i AS VARCHAR(5)),
                    5
                )
            ),

            CASE @i % 3
                WHEN 0 THEN 'DHL'
                WHEN 1 THEN 'Aramex'
                ELSE 'FedEx'
            END,

            DATEADD
            (
                DAY,
                4,
                @ShipmentOrderDate
            ),

            'Delivered'
        );


        SET @i = @i + 1;
    END;


    -- =========================================================
    -- 12. Reviews
    -- Required: 50+
    -- Generated: 60
    --
    -- Products 1-30 receive reviews.
    -- Products 31-50 remain unreviewed.
    -- =========================================================

    SET @i = 1;

    DECLARE @ReviewCustomerID INT;
    DECLARE @ReviewProductID INT;


    WHILE @i <= 60
    BEGIN

        SET @ReviewCustomerID =
            ((@i - 1) % 18) + 1;

        SET @ReviewProductID =
            ((@i - 1) % 30) + 1;


        INSERT INTO Reviews
        (
            ProductID,
            CustomerID,
            Rating,
            Comment,
            ReviewDate
        )
        VALUES
        (
            @ReviewProductID,

            @ReviewCustomerID,

            CAST
            (
                ((@i - 1) % 5) + 1
                AS TINYINT
            ),

            CONCAT
            (
                'Seed review ',
                @i,
                ' for product ',
                @ReviewProductID
            ),

            DATEADD
            (
                DAY,
                -@i,
                SYSUTCDATETIME()
            )
        );


        SET @i = @i + 1;
    END;


    -- =========================================================
    -- 13. PriceHistory
    -- Required: 75+
    -- Generated: 100
    --
    -- Two historical records per product.
    -- Every fifth product keeps the same price.
    -- Other products have a historical price change.
    -- =========================================================

    INSERT INTO PriceHistory
    (
        ProductID,
        Price,
        EffectiveFrom,
        EffectiveTo
    )
    SELECT
        ProductID,

        CASE
            WHEN ProductID % 5 = 0
                THEN Price

            ELSE
                CAST
                (
                    ROUND
                    (
                        Price * 0.90,
                        2
                    )
                    AS DECIMAL(10,2)
                )
        END,

        DATEADD
        (
            DAY,
            -365,
            SYSUTCDATETIME()
        ),

        DATEADD
        (
            DAY,
            -180,
            SYSUTCDATETIME()
        )

    FROM Products;


    INSERT INTO PriceHistory
    (
        ProductID,
        Price,
        EffectiveFrom,
        EffectiveTo
    )
    SELECT
        ProductID,
        Price,

        DATEADD
        (
            DAY,
            -180,
            SYSUTCDATETIME()
        ),

        NULL

    FROM Products;


    -- =========================================================
    -- Commit
    -- =========================================================

    COMMIT TRANSACTION;

    PRINT 'Seed data inserted successfully.';

END TRY


BEGIN CATCH

    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
    END;

    DECLARE @ErrorMessage NVARCHAR(4000);

    SET @ErrorMessage = ERROR_MESSAGE();

    RAISERROR
    (
        @ErrorMessage,
        16,
        1
    );

END CATCH;


-- =========================================================
-- Verification
-- =========================================================

SELECT
    'Customers' AS Entity,
    COUNT(*) AS RecordCount
FROM Customers

UNION ALL

SELECT
    'CustomerAddresses',
    COUNT(*)
FROM CustomerAddresses

UNION ALL

SELECT
    'Vendors',
    COUNT(*)
FROM Vendors

UNION ALL

SELECT
    'VendorDetails',
    COUNT(*)
FROM VendorDetails

UNION ALL

SELECT
    'Categories',
    COUNT(*)
FROM Categories

UNION ALL

SELECT
    'Products',
    COUNT(*)
FROM Products

UNION ALL

SELECT
    'ProductCategories',
    COUNT(*)
FROM ProductCategories

UNION ALL

SELECT
    'Orders',
    COUNT(*)
FROM Orders

UNION ALL

SELECT
    'OrderItems',
    COUNT(*)
FROM OrderItems

UNION ALL

SELECT
    'Payments',
    COUNT(*)
FROM Payments

UNION ALL

SELECT
    'Shipments',
    COUNT(*)
FROM Shipments

UNION ALL

SELECT
    'Reviews',
    COUNT(*)
FROM Reviews

UNION ALL

SELECT
    'PriceHistory',
    COUNT(*)
FROM PriceHistory;