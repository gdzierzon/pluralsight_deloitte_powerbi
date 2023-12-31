USE NorthwindDW
GO

-- INSERT Dimensions FIRST

-- DimCustomer
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

-- Date dimensions are special because all of the columns are 
-- inferred from a date
DECLARE @OrderDate DATE = '1/1/1996'
DECLARE @MaxOrderDate DATE = '12/31/1998'

WHILE @OrderDate <= @MaxOrderDate
BEGIN

	INSERT INTO NorthwindDW.dbo.DimDate
	SELECT  
		CAST(
			CAST(YEAR(@OrderDate) AS CHAR(4))
			+ CASE LEN(CAST(MONTH(@OrderDate) AS CHAR(2)))
				WHEN 1 THEN '0' + CAST(MONTH(@OrderDate) AS CHAR(1))
				ELSE CAST(MONTH(@OrderDate) AS CHAR(2))
			End
			+ CASE LEN(CAST(DAY(@OrderDate) AS CHAR(2)))
				WHEN 1 THEN '0' + CAST(DAY(@OrderDate) AS CHAR(1))
				ELSE CAST(DAY(@OrderDate) AS CHAR(2))
			END
		AS INT) AS DateKey
		, @OrderDate
		, YEAR(@OrderDate) AS Year
		, CASE 
			WHEN MONTH(@OrderDate) IN (1,2,3) THEN 1
			WHEN MONTH(@OrderDate) IN (4,5,6) THEN 2
			WHEN MONTH(@OrderDate) IN (7,8,9) THEN 3
			ELSE 4
		END AS Quarter
		, Month(@OrderDate) AS Month
		, DATENAME(MONTH, @OrderDate) AS MonthName
		, DAY(@OrderDate) AS Day
		, DATEPART(WEEKDAY, @OrderDate) AS DayOfWeek
		, DATENAME(WEEKDAY, @OrderDate) AS DayOfWeekName

	SET @OrderDate = DATEADD(DAY, 1, @OrderDate)
END

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


INSERT INTO NorthwindDW.dbo.DimEmployeeTerritory
SELECT de.EmployeeKey
	, t.TerritoryDescription
	, r.RegionDescription
FROM Northwind.dbo.Employees AS e
INNER JOIN Northwind.dbo.EmployeeTerritories AS et ON et.EmployeeID = e.EmployeeID
INNER JOIN Northwind.dbo.Territories AS t ON t.TerritoryID = et.TerritoryID
INNER JOIN Northwind.dbo.Region AS r ON r.RegionID = t.RegionID
INNER JOIN NorthwindDW.dbo.DimEmployee AS de ON e.EmployeeID = de.EmployeeId
GO


-- We decided to not maintain a separate
-- Categories table, but to put the category name
-- into the Product dimension
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


-- Fact tables are ALWAYS populated AFTER
-- all of the dimension tables
-- because they are dependent on the Dimension Key fields
INSERT INTO NorthwindDW.dbo.FactSales
SELECT c.CustomerKey
	, d.DateKey AS OrderDateKey
	, p.ProductKey
	, sh.ShipperKey
	, su.SupplierKey
	, e.EmployeeKey
	, o.OrderID
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
