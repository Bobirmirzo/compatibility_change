USE AdventureWorksDW2016_EXT

SELECT ROUND(SUM(SalesAmount), 2) AS [Total Sales]
FROM FactInternetSales
GO

SELECT CalendarYear AS Year, ROUND(SUM(SalesAmount), 2) AS [Total Sales]
FROM FactInternetSales  f
JOIN DimDate d ON d.DateKey = f.OrderDateKey
WHERE CalendarYear>2000
GROUP BY CalendarYear
ORDER BY [Total Sales] DESC
GO

SELECT CONCAT(firstname,' ', LastName) AS [Customer Name], round(AVG(salesAmount),1) as AverageSales
FROM dimcustomer c
INNER JOIN FactInternetSales s
ON c.CustomerKey = s.CustomerKey
GROUP BY CONCAT(firstname,' ', LastName)
ORDER BY [Customer Name]
GO 

SELECT Englishproductcategoryname [Product Category], COUNT( EnglishProductName) AS [Number of Products in Category]
FROM dimproductcategory c
INNER JOIN
 (SELECT EnglishProductName, productcategorykey
 FROM DimProduct p
 INNER JOIN DimProductSubcategory ps
 ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
 GROUP BY EnglishProductName, ProductCategoryKey) ps
ON c.ProductCategoryKey = ps.ProductCategoryKey
GROUP BY  Englishproductcategoryname
GO

SELECT TOP 10 firstname + ' ' + lastname AS [Customer Name], ROUND(SUM(SalesAmount), 2) as [Total Sales]
FROM DimCustomer d
JOIN FactInternetSales f ON f.CustomerKey = d.CustomerKey
GROUP BY firstname + ' ' + lastname
ORDER BY [Total Sales] DESC
GO

SELECT TOP 10 CONCAT(firstname, ' ',  lastname) as [Customer Name], SUM(orderquantity) as Orders
FROM FactInternetSales f
JOIN DimCustomer c ON c.CustomerKey = f.CustomerKey
GROUP BY CONCAT(firstname, ' ', lastname)
ORDER BY Orders DESC
Go

SELECT TOP 10 FirstName + ' ' + LastName as [Empolyee Name], 
SalesTerritoryCountry AS [Sales Country], ROUND(SUM(salesamount), 2) as [Total Sales]
FROM FactInternetSales AS f
JOIN DimSalesTerritory AS t 
ON f.SalesTerritoryKey = t.SalesTerritoryKey
JOIN DimEmployee AS e 
ON e.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY SalesTerritoryCountry, FirstName + ' ' + LastName
ORDER BY [Total Sales] DESC
GO

SELECT CONCAT(firstname, ' ',  lastname) as [Customer Name], ROUND(SUM(SALESAMOUNT), 2) AS [Total Sales],
CASE WHEN SUM(SALESAMOUNT) > 10000 THEN 'Diamond'
  WHEN SUM(SALESAMOUNT) BETWEEN 5000 AND 9999 THEN 'Gold'
  WHEN SUM(SALESAMOUNT) BETWEEN 1000 AND 4999 THEN 'Silver'
  ELSE 'Bronze'
  END AS Rank
FROM FactInternetSales f
JOIN DimCustomer c ON c.CustomerKey = f.CustomerKey
GROUP BY CONCAT(firstname, ' ',  lastname)
ORDER BY [Total Sales] DESC
Go

SELECT Total_orders, COUNT(*) AS [ Number of customer]
FROM (SELECT c.customerkey, COUNT(salesordernumber) AS  total_orders
  FROM FactInternetSales f
  JOIN DimCustomer c 
  ON c.CustomerKey = f.CustomerKey
  GROUP BY c.customerkey) a
GROUP BY total_orders
ORDER BY [ Number of customer] DESC
GO