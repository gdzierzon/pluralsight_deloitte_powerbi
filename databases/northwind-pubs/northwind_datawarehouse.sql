

SET NOCOUNT ON
GO

USE master
GO
if exists (select * from sysdatabases where name='NorthwindWarehouse')
		drop database NorthwindDW
go

CREATE DATABASE NorthwindDW
GO

USE NorthwindDW
GO


/****** Object:  Table [dbo].[DimCustomer]    Script Date: 9/12/2023 4:38:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCustomer](
	[CustomerKey] [int] IDENTITY(1001,1) NOT NULL,
	[CustomerId] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](50) NOT NULL,
	[ContactName] [nvarchar](50) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](60) NOT NULL,
	[City] [nvarchar](15) NOT NULL,
	[State] [nvarchar](15) NOT NULL,
	[Zip] [nvarchar](10) NOT NULL,
	[Country] [nvarchar](24) NOT NULL,
 CONSTRAINT [PK_DimCustomer] PRIMARY KEY CLUSTERED 
(
	[CustomerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimDate]    Script Date: 9/12/2023 4:38:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDate](
	[DateKey] [int] NOT NULL,
	[DateValue] [date] NOT NULL,
	[Year] [int] NOT NULL,
	[Quater] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [varchar](10) NOT NULL,
	[Day] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
	[DayOfWeekName] [varchar](10) NOT NULL,
 CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimEmployee]    Script Date: 9/12/2023 4:38:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimEmployee](
	[EmployeeKey] [int] IDENTITY(3001,1) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[Title] [nvarchar](30) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[HireDate] [date] NOT NULL,
 CONSTRAINT [PK_DimEmployee] PRIMARY KEY CLUSTERED 
(
	[EmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimProduct]    Script Date: 9/12/2023 4:38:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimProduct](
	[ProductKey] [int] IDENTITY(2001,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[CategoryName] [nvarchar](50) NOT NULL,
	[ListPrice] [money] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DimProduct] PRIMARY KEY CLUSTERED 
(
	[ProductKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimShipper]    Script Date: 9/12/2023 4:38:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimShipper](
	[ShipperKey] [int] IDENTITY(5001,1) NOT NULL,
	[ShipperId] [int] NOT NULL,
	[ShipperName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DimShipper] PRIMARY KEY CLUSTERED 
(
	[ShipperKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimSupplier]    Script Date: 9/12/2023 4:38:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSupplier](
	[SupplierKey] [int] IDENTITY(4001,1) NOT NULL,
	[SupplierId] [int] NOT NULL,
	[SupplierName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DimSupplier] PRIMARY KEY CLUSTERED 
(
	[SupplierKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactSales]    Script Date: 9/12/2023 4:38:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactSales](
	[CustomerKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[ShipperKey] [int] NOT NULL,
	[SupplierKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[UnitSalesAmount] [money] NOT NULL,
	[UnitPriceDiscountPercent] [decimal](10, 2) NOT NULL,
	[UnitPriceDiscountAmount] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	[GrossSalesAmount] [money] NOT NULL,
	[TotalDiscountAmount] [money] NOT NULL,
	[NetSalesAmount] [money] NOT NULL,
	[FreightAmount] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_DimCustomer] FOREIGN KEY([CustomerKey])
REFERENCES [dbo].[DimCustomer] ([CustomerKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_FactSales_DimCustomer]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_DimDate] FOREIGN KEY([OrderDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_FactSales_DimDate]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_DimEmployee] FOREIGN KEY([EmployeeKey])
REFERENCES [dbo].[DimEmployee] ([EmployeeKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_FactSales_DimEmployee]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_DimProduct] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_FactSales_DimProduct]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_DimShipper] FOREIGN KEY([ShipperKey])
REFERENCES [dbo].[DimShipper] ([ShipperKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_FactSales_DimShipper]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_FactSales_DimSupplier] FOREIGN KEY([SupplierKey])
REFERENCES [dbo].[DimSupplier] ([SupplierKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_FactSales_DimSupplier]
GO

-- INSERT DATA
INSERT INTO DimCustomer
SELECT CustomerID
	, CompanyName
	, ContactName
	, ContactTitle
	, Address
	, City
	, ISNULL(Region, 'Unknown') AS State
	, ISNULL(PostalCode, 'Unknown') AS Zip
	, Country
FROM Northwind.dbo.Customers
GO


INSERT INTO NorthwindDW.dbo.DimDate
SELECT DISTINCT 
	CAST(
		CAST(YEAR(OrderDate) AS CHAR(4))
		+ CASE LEN(CAST(MONTH(OrderDate) AS CHAR(2)))
			WHEN 1 THEN '0' + CAST(MONTH(OrderDate) AS CHAR(1))
			ELSE CAST(MONTH(OrderDate) AS CHAR(2))
		End
		+ CASE LEN(CAST(DAY(OrderDate) AS CHAR(2)))
			WHEN 1 THEN '0' + CAST(DAY(OrderDate) AS CHAR(1))
			ELSE CAST(DAY(OrderDate) AS CHAR(2))
		END
    AS INT) AS DateKey
	, OrderDate
	, YEAR(OrderDate) AS Year
	, CASE 
		WHEN MONTH(OrderDate) IN (1,2,3) THEN 1
		WHEN MONTH(OrderDate) IN (4,5,6) THEN 2
		WHEN MONTH(OrderDate) IN (7,8,9) THEN 3
		ELSE 4
	END AS Quarter
	, Month(OrderDate) AS Month
	, DATENAME(MONTH, OrderDate) AS MonthName
	, DAY(OrderDate) AS Day
	, DATEPART(WEEKDAY, OrderDate) AS DayOfWeek
	, DATENAME(WEEKDAY, OrderDate) AS DayOfWeekName
FROM Northwind.dbo.Orders


GO

INSERT INTO NorthwindDW.dbo.DimEmployee
SELECT EmployeeID
	, FirstName
	, LastName
	, Title
	, cast(BirthDate AS date) AS BirthDate
	, CAST(HireDate AS DATE) AS HireDate
FROM Northwind.dbo.Employees

GO


INSERT INTO NorthwindDW.dbo.DimProduct
SELECT p.ProductID
	, p.ProductName
	, c.CategoryName
	, p.UnitPrice
	, CASE p.Discontinued
		WHEN 1 THEN 0
		ELSE 1
	END AS IsActive
FROM Northwind.dbo.Products AS p
INNER JOIN Northwind.dbo.Categories AS c
	ON c.CategoryID = p.CategoryID

GO


INSERT INTO NorthwindDW.dbo.DimShipper
SELECT ShipperID
	, CompanyName
FROM Northwind.dbo.Shippers

GO


INSERT INTO NorthwindDW.dbo.DimSupplier
SELECT SupplierID
	, CompanyName
FROM Northwind.dbo.Suppliers

GO

INSERT INTO NorthwindDW.dbo.FactSales
SELECT c.CustomerKey
	, d.DateKey AS OrderDateKey
	, p.ProductKey
	, sh.ShipperKey
	, su.SupplierKey
	, e.EmployeeKey
	, od.UnitPrice 
	, od.Discount
	, od.UnitPrice * od.Discount AS UnitDiscount
	, od.Quantity
	, od.UnitPrice * od.Quantity AS Gross
	, (od.UnitPrice * od.Quantity) * od.Discount AS TotalDiscount
	, (od.UnitPrice * od.Quantity) * (1- od.Discount) AS GrossSale
	, o.Freight
FROM Northwind.dbo.Orders AS o
INNER JOIN Northwind.dbo.[Order Details] AS od
	ON od.OrderID = o.OrderID
INNER JOIN NorthwindDW.dbo.DimCustomer AS c
	ON o.CustomerID = c.CustomerId
INNER JOIN NorthwindDW.dbo.DimDate AS d
	ON o.OrderDate = d.DateValue
INNER JOIN NorthwindDW.dbo.DimProduct AS p
	ON od.ProductID = p.ProductId
INNER JOIN NorthwindDW.dbo.DimShipper AS sh
	ON o.ShipVia = sh.ShipperId
INNER JOIN Northwind.dbo.Products AS pp
	ON od.ProductID = pp.ProductID
INNER JOIN NorthwindDW.dbo.DimSupplier AS su
	ON pp.SupplierID = su.SupplierId
INNER JOIN NorthwindDW.dbo.DimEmployee AS e
	ON o.EmployeeID= e.EmployeeId

GO
