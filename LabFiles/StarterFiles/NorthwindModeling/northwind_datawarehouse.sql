USE master
GO


--drop database if it exists
IF DB_ID('NorthwindDW') IS NOT NULL
BEGIN
	ALTER DATABASE NorthwindDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE NorthwindDW
END
GO

CREATE DATABASE NorthwindDW
GO

USE NorthwindDW
GO


CREATE TABLE [dbo].[DimCustomer](
	[CustomerKey] [int] IDENTITY(1001,1) NOT NULL PRIMARY KEY,
	[CustomerId] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](50) NOT NULL,
	[ContactName] [nvarchar](50) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](60) NOT NULL,
	[City] [nvarchar](15) NOT NULL,
	[State] [nvarchar](15) NOT NULL,
	[Zip] [nvarchar](10) NOT NULL,
	[Country] [nvarchar](24) NOT NULL
)
GO

CREATE TABLE [dbo].[DimDate](
	[DateKey] [int] NOT NULL PRIMARY KEY,
	[DateValue] [date] NOT NULL,
	[Year] [int] NOT NULL,
	[Quarter] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [varchar](10) NOT NULL,
	[Day] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
	[DayOfWeekName] [varchar](10) NOT NULL
)
GO


CREATE TABLE [dbo].[DimEmployee](
	[EmployeeKey] [int] IDENTITY(3001,1) NOT NULL PRIMARY KEY,
	[EmployeeId] [int] NOT NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[Title] [nvarchar](30) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[HireDate] [date] NOT NULL
)
GO

CREATE TABLE [dbo].[DimEmployeeTerritory]
(
	[EmployeeTerritoryKey] [INT] IDENTITY (1,1) PRIMARY KEY,
	[EmployeeKey] [INT] NOT NULL REFERENCES dbo.DimEmployee(EmployeeKey),
	Territory NVARCHAR(50) NOT NULL,
	Region NVARCHAR(50) NOT NULL
)
GO


CREATE TABLE [dbo].[DimProduct](
	[ProductKey] [int] IDENTITY(2001,1) NOT NULL PRIMARY KEY,
	[ProductId] [int] NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[CategoryName] [nvarchar](50) NOT NULL,
	[ListPrice] [money] NOT NULL,
	[IsActive] [bit] NOT NULL
)
GO

CREATE TABLE [dbo].[DimShipper](
	[ShipperKey] [int] IDENTITY(5001,1) NOT NULL PRIMARY KEY,
	[ShipperId] [int] NOT NULL,
	[ShipperName] [nvarchar](50) NOT NULL
)
GO

CREATE TABLE [dbo].[DimSupplier](
	[SupplierKey] [int] IDENTITY(4001,1) NOT NULL PRIMARY KEY,
	[SupplierId] [int] NOT NULL,
	[SupplierName] [nvarchar](50) NOT NULL
)
GO

CREATE TABLE [dbo].[FactSales](
	[CustomerKey] [int] NOT NULL REFERENCES dbo.DimCustomer(CustomerKey),
	[OrderDateKey] [int] NOT NULL REFERENCES dbo.DimDate(DateKey),
	[ProductKey] [int] NOT NULL REFERENCES dbo.DimProduct(ProductKey),
	[ShipperKey] [int] NOT NULL REFERENCES dbo.DimShipper(ShipperKey),
	[SupplierKey] [int] NOT NULL REFERENCES dbo.DimSupplier(SupplierKey),
	[EmployeeKey] [int] NOT NULL REFERENCES dbo.DimEmployee(EmployeeKey),
	[OrderId] [INT] NOT NULL,
	[UnitSalesAmount] [money] NOT NULL,
	[UnitPriceDiscountPercent] [decimal](10, 2) NOT NULL,
	[UnitPriceDiscountAmount] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	[GrossSalesAmount] [money] NOT NULL,
	[TotalDiscountAmount] [money] NOT NULL,
	[NetSalesAmount] [money] NOT NULL,
	[FreightAmount] [money] NOT NULL
) 
GO