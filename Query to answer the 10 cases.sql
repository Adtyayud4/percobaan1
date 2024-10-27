-- 1 
SELECT 
	REPLACE(s.StaffID, 'ST', 'Staff') AS StaffID, 
	UPPER(StaffName) AS StaffName, 
	COUNT(SaleID) AS [Total Sales]
FROM MsStaff s
JOIN SaleHeader sh
	ON s.StaffID = sh.StaffID
JOIN MsCustomer c
	ON sh.CustomerID = c.CustomerID
WHERE s.StaffGender = 'Male' AND c.CustomerGender = 'Female'
GROUP BY UPPER(StaffName), REPLACE(s.StaffID, 'ST', 'Staff')

--2 

SELECT
	ph.PurchaseID,
	[PurchaseDate] = CONVERT(VARCHAR, PurchaseDate, 103),
	[Total Game Type] = COUNT(DISTINCT gt.GameTypeID)
FROM PurchaseHeader ph
JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
JOIN MsGame g ON pd.GameID = g.GameID
JOIN MsGameType gt ON g.GameTypeID = gt.GameTypeID
WHERE YEAR(PurchaseDate) = 2019
GROUP BY ph.PurchaseID, 
CONVERT(VARCHAR, PurchaseDate, 103)
HAVING COUNT(DISTINCT gt.GameTypeID) > 2

-- 3
SELECT DISTINCT
	[CustomerCode] = REVERSE(c.CustomerID),
	[CustomerName] = UPPER(CustomerName),
	[TotalTransaction] = COUNT(sh.SaleID),
	[MinimumPurchase] = MIN(sd.Quantity)
FROM MsCustomer c
JOIN SaleHeader sh ON c.CustomerID = sh.CustomerID
JOIN SaleDetail sd ON sh.SaleID = sd.SaleID
WHERE LEFT(CustomerName, 1) = 'M'
GROUP BY REVERSE(c.CustomerID), UPPER(CustomerName)
HAVING COUNT(sh.SaleID) > 1


-- 4 
SELECT
	s.SupplierID,
	[SupplierName] = CONCAT(SupplierName, ' Inc.'),
	[TotalGamesSold] = SUM(pd.Quantity),
	[MaximumGamesSold] = MAX(pd.Quantity)
FROM MsSupplier s
JOIN PurchaseHeader ph ON s.SupplierID = ph.SupplierID
JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
WHERE SupplierAddress LIKE '%Drive%'
AND CAST(RIGHT(s.SupplierID, 3) AS INT) % 2 = 1
GROUP BY s.SupplierID, CONCAT(SupplierName, ' Inc.')


-- 5
SELECT
	PurchaseID,
	s.SupplierID,
	SupplierName,
	[StaffFirstName] = SUBSTRING(StaffName, 1, CHARINDEX(' ', StaffName + ' ') -1),
	StaffDoB
FROM MsSupplier s
JOIN PurchaseHeader ph ON s.SupplierID = ph.SupplierID
JOIN MsStaff st ON ph.StaffID = st.StaffID, (
	SELECT AVG(StaffSalary) AS AverageSalary
	FROM MsStaff
) AS x
WHERE StaffSalary > x.AverageSalary
AND YEAR(StaffDoB) > 2000


-- 6 
SELECT
	sh.SaleID,
	SaleDate,
	[CustomerName] = LOWER(CustomerName)
FROM MsCustomer c
JOIN SaleHeader sh ON c.CustomerID = sh.CustomerID
JOIN SaleDetail sd ON sh.SaleID = sd.SaleID, (
	SELECT AVG(Quantity) AS AvgTransactionQuantity
	FROM SaleDetail
) AS x
WHERE DATEDIFF(year, CustomerDoB, GETDATE()) < 24
AND Quantity > x.AvgTransactionQuantity


-- 7
SELECT
	[PurchasedDay] = DATENAME(WEEKDAY, PurchaseDate),
	[GameID] = REPLACE(g.GameID, 'GA', 'Game'),
	[GameReleasedYear] = YEAR(GameReleaseDate),
	[TotalPurchased] = COUNT(pd.PurchaseID)
FROM PurchaseHeader ph
JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
JOIN MsGame g ON pd.GameID = g.GameID, (
	SELECT AVG(GamePrice) AS AveragePrice
	FROM MsGame
) AS x
WHERE GamePrice > x.AveragePrice
AND DATENAME(QUARTER, GameReleaseDate) = 2
GROUP BY DATENAME(WEEKDAY, PurchaseDate), REPLACE(g.GameID, 'GA', 'Game'), YEAR(GameReleaseDate)

-- 8
SELECT
	[SalesID] = LOWER(sh.SaleID),
	[SalesDate] = CONVERT(VARCHAR, SaleDate, 105),
	[TotalSalesCost] = CONCAT('Rp. ', FORMAT(SUM(Quantity * GamePrice),'#,0'))
FROM MsStaff s
JOIN SaleHeader sh ON s.StaffID = sh.StaffID
JOIN SaleDetail sd ON sh.SaleID = sd.SaleID
JOIN MsGame g ON sd.GameID = g.GameID, (
	SELECT AVG(StaffSalary) AS AverageSalary
	FROM MsStaff
) AS x
WHERE StaffSalary > x.AverageSalary
AND DATENAME(MONTH, SaleDate) = 'February'
GROUP BY  LOWER(sh.SaleID), CONVERT(VARCHAR, SaleDate, 105)


-- 9 

CREATE VIEW Customer_Quarterly_Transaction_View AS
SELECT 
	c.CustomerID, 
	CustomerName,
	[TotalTransaction] = COUNT(sh.SaleID),
	[MaximumPurchaseQuantity] = CONCAT(CAST(MAX(Quantity) AS VARCHAR), ' Pc(s)')
FROM MsCustomer c 
JOIN SaleHeader sh ON c.CustomerID = sh.CustomerID
JOIN MsStaff s ON sh.StaffID = s.StaffID
JOIN SaleDetail sd ON sh.SaleID = sd.SaleID
WHERE YEAR(SaleDate) = 2021
AND StaffGender = 'Female'
GROUP BY c.CustomerID, CustomerName

SELECT * FROM Customer_Quarterly_Transaction_View

-- 10
CREATE VIEW QuarterlySalesReport AS
SELECT 
	[TotalSales] = CONCAT('Rp. ', FORMAT(SUM(Quantity * GamePrice), '#,0')),
	[AverageSales] = CONCAT('Rp. ', FORMAT(AVG(Quantity * GamePrice), '#,0'))
FROM SaleHeader sh
JOIN SaleDetail sd ON sh.SaleID = sd.SaleID
JOIN MsGame g ON sd.GameID = g.GameID
WHERE DATENAME(QUARTER, SaleDate) = 1
AND GamePrice > 200000

SELECT * FROM QuarterlySalesReport

