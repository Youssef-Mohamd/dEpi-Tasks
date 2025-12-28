USE AdventureWorks2019

--1.1 List all employees hired after January 1, 2012, showing their ID, first name, last name, and hire date, ordered by hire date descending.

SELECT NationalIDNumber, FirstName, LastName, HireDate
FROM HumanResources.Employee E
JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
WHERE HireDate > '2012-01-01'
ORDER BY HireDate DESC;

--1.2 List products with a list price between $100 and $500, showing product ID, name, list price, and product number, ordered by list price ascending.
SELECT ProductID, Name, ListPrice, ProductNumber
  FROM Production.Product
WHERE ListPrice BETWEEN 100 AND 500
  ORDER BY ListPrice ASC;


--1.3 List customers from the cities 'Seattle' or 'Portland', showing customer ID, first name, last name, and city, using appropriate joins.

SELECT C.CustomerID, P.FirstName, P.LastName, A.City
FROM Sales.Customer C
JOIN Person.Person P ON C.PersonID = P.BusinessEntityID
JOIN Person.BusinessEntityAddress BEA ON C.PersonID = BEA.BusinessEntityID
JOIN Person.Address A ON BEA.AddressID = A.AddressID
WHERE A.City IN ('Seattle', 'Portland');





--1.4 List the top 15 most expensive products currently being sold, showing name, list price, product number, and category name, excluding discontinued products.


    SELECT TOP 15 P.Name, P.ListPrice, P.ProductNumber, PC.Name AS CategoryName
FROM Production.Product P
JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
WHERE P.SellEndDate IS NULL
ORDER BY P.ListPrice DESC;


--2.1 List products whose name contains 'Mountain' and color is 'Black', showing product ID, name, color, and list price.
    
	SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Name LIKE '%Mountain%' AND Color = 'Black';

--2.2 List employees born between January 1, 1970, and December 31, 1985, showing full name, birth date, and age in years.

SELECT 
  P.FirstName + ' ' + P.LastName AS FullName,   E.BirthDate
FROM HumanResources.Employee E
 JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.BirthDate BETWEEN '1970-01-01' AND '1985-12-31';

--2.3 List orders placed in the fourth quarter of 2013, showing order ID, order date, customer ID, and total due.
     
	 SELECT SalesOrderID, OrderDate, CustomerID, TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2013-10-01' AND '2013-12-31';


--2.4 List products with a null weight but a non-null size, showing product ID, name, weight, size, and product number.

      SELECT SalesOrderID, OrderDate, CustomerID, TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2013-10-01' AND '2013-12-31';


--3.3 List the top 10 customers by total order count, including customer name.

     SELECT TOP 10
    C.CustomerID,
  P.FirstName + ' ' + P.LastName AS CustomerName,
  COUNT(SH.SalesOrderID) AS OrderCount
FROM Sales.Customer C
JOIN Person.Person P ON C.PersonID = P.BusinessEntityID
JOIN Sales.SalesOrderHeader SH ON C.CustomerID = SH.CustomerID
GROUP BY C.CustomerID, P.FirstName, P.LastName
ORDER BY OrderCount DESC;

--3.4 Show monthly sales totals for 2013, displaying the month name and total amount.

SELECT 
   DATENAME(MONTH, OrderDate) AS MonthName,   SUM(TotalDue) AS MonthlySales
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY DATENAME(MONTH, OrderDate), MONTH(OrderDate)
ORDER BY MONTH(OrderDate);

--4.1 Find all products launched in the same year as 'Mountain-100 Black, 42'. Show product ID, name, sell start date, and year.

     SELECT ProductID, Name, SellStartDate, YEAR(SellStartDate) AS StartYear
   FROM Production.Product
   WHERE YEAR(SellStartDate) = (
    SELECT YEAR(SellStartDate)
    FROM Production.Product
    WHERE Name = 'Mountain-100 Black, 42'
);

--4.2 Find employees who were hired on the same date as someone else. Show employee names, shared hire date, and the count of employees hired that day.
   

      --5 CREATE TABLE 

	  CREATE TABLE Sales.ProductReviews (
    ReviewID INT IDENTITY PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewDate DATE DEFAULT GETDATE(),
    ReviewText NVARCHAR(1000),
    VerifiedPurchase BIT DEFAULT 0,
    HelpfulVotes INT DEFAULT 0,
    CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES Production.Product(ProductID),
    CONSTRAINT FK_Customer FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID),
    CONSTRAINT UQ_ProductCustomer UNIQUE(ProductID, CustomerID)
);


--6.1 Add a column named LastModifiedDate to the Production.Product table, with a default value of the current date and time.

ALTER TABLE Production.Product
ADD LastModifiedDate DATETIME DEFAULT GETDATE();

--6.2 Create a non-clustered index on the LastName column of the Person.Person table, including FirstName and MiddleName

CREATE NONCLUSTERED INDEX Indx_LastName
ON Person.Person(LastName)
INCLUDE (FirstName, MiddleName);

--6.3 Add a check constraint to the Production.Product table to ensure that ListPrice is greater than StandardCost.

      ALTER TABLE Production.Product
ADD CONSTRAINT ChecK_ListPrice CHECK (ListPrice > StandardCost);

--1 Insert three sample records into Sales.ProductReviews using existing product and customer IDs, with varied ratings and meaningful review text

INSERT INTO Sales.ProductReviews (ProductID, CustomerID, Rating, ReviewText, VerifiedPurchase, HelpfulVotes)
VALUES
(707, 30118, 5, 'Excellent !', 1, 10),
(709, 30134, 3, 'Good ', 1, 5),
(711, 30127, 4, 'Smooth ride', 1, 8);


--7.2 Insert a new product category named 'Electronics' and a corresponding product subcategory named 'Smartphones' under Electronics

INSERT INTO Production.ProductCategory (Name)
VALUES ('Electronics');


--8 Update the ModifiedDate to the current date for all products where ListPrice is greater than $1000 and SellEndDate is null.

UPDATE Production.Product
SET LastModifiedDate = GETDATE()
WHERE ListPrice > 1000 AND SellEndDate IS NULL;


--8.2 Increase the ListPrice by 15% for all products in the 'Bikes' category and update the ModifiedDate

UPDATE Production.Product
SET ListPrice = ListPrice * 1.15,
    LastModifiedDate = GETDATE()
FROM Production.Product 

--8.3 Update the JobTitle to 'Senior' plus the existing job title for employees hired before January 1, 2010.

UPDATE HumanResources.Employee
SET JobTitle = 'Senior '  
WHERE HireDate < '2010-01-01';

--9.1 Delete all product reviews with a rating of 1 and helpful votes equal to 0.

DELETE FROM Sales.ProductReviews
WHERE Rating = 1 AND HelpfulVotes = 0;

--9.2 Delete products that have never been ordered, using a NOT EXISTS condition with Sales.SalesOrderDetail.

    DELETE FROM Production.Product
WHERE NOT EXISTS (
    SELECT *
    FROM Sales.SalesOrderDetail
    
);

--10 
SELECT    YEAR(OrderDate) AS OrderYear,
    SUM(TotalDue) AS TotalSales,
    AVG(TotalDue) AS AvgOrderValue,
    COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) BETWEEN 2011 AND 2014
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

--10.2

SELECT 
    C.CustomerID,
    COUNT(S.SalesOrderID) AS TotalOrders,
    SUM(S.TotalDue) AS TotalAmount,
    AVG(S.TotalDue) AS AvgOrderValue,
    MIN(S.OrderDate) AS FirstOrderDate,
    MAX(S.OrderDate) AS LastOrderDate
FROM Sales.Customer C
JOIN Sales.SalesOrderHeader S ON C.CustomerID = S.CustomerID
GROUP BY C.CustomerID;

--10.4

SELECT 
        MONTH(OrderDate) AS MonthNum,
        DATENAME(MONTH, OrderDate) AS MonthName,
        SUM(TotalDue) AS MonthlyTotal
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2013
    GROUP BY MONTH(OrderDate), DATENAME(MONTH, OrderDate)

	--11

	SELECT 
    P.FirstName + ' ' + P.LastName AS FullName,
    DATEDIFF(YEAR, E.BirthDate, GETDATE()) - 
        CASE WHEN MONTH(E.BirthDate) > MONTH(GETDATE()) 
                  OR (MONTH(E.BirthDate) = MONTH(GETDATE()) AND DAY(E.BirthDate) > DAY(GETDATE()))
             THEN 1 ELSE 0 END AS Age,
    DATEDIFF(YEAR, E.HireDate, GETDATE()) AS YearsOfService,
    FORMAT(E.HireDate, 'MMM dd, yyyy') AS HireDateFormatted,
    DATENAME(MONTH, E.BirthDate) AS BirthMonth
FROM HumanResources.Employee E
JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID;
--11.2
SELECT 
    UPPER(P.LastName) + ', ' + UPPER(LEFT(P.FirstName,1)) + LOWER(SUBSTRING(P.FirstName,2,LEN(P.FirstName))) + 
        CASE WHEN P.MiddleName IS NOT NULL THEN ' ' + UPPER(LEFT(P.MiddleName,1)) + '.' ELSE '' END AS FormattedName,
    RIGHT(EmailAddress, LEN(EmailAddress) - CHARINDEX('@', EmailAddress)) AS EmailDomain
FROM Person.Person P
JOIN Person.EmailAddress EA ON P.BusinessEntityID = EA.BusinessEntityID;

--11.3
SELECT 
    Name,
    ROUND(Weight, 1) AS WeightKg,
    ROUND(Weight * 2.20462, 1) AS WeightLb,
    CASE WHEN Weight IS NOT NULL AND Weight > 0 THEN ROUND(ListPrice / (Weight * 2.20462), 2) ELSE NULL END AS PricePerPound
FROM Production.Product;

--12.1 
SELECT DISTINCT 
    P.Name AS ProductName,
    PC.Name AS Category,
    PSC.Name AS Subcategory,
    V.Name AS VendorName
FROM Production.Product P
JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID
JOIN Purchasing.ProductVendor PV ON P.ProductID = PV.ProductID
JOIN Purchasing.Vendor V ON PV.BusinessEntityID = V.BusinessEntityID;

--12.2   Show order details including order ID, customer name, salesperson name, territory name, product name, quantity, and line total.

 SELECT 
    SOH.SalesOrderID,
    FirstName + ' ' + LastName AS CustomerName,
    FirstName + ' ' + LastName AS SalespersonName,
   Name AS TerritoryName,
    Name AS ProductName,
    OrderQty,
    LineTotal
FROM Sales.SalesOrderHeader SOH

--13

SELECT 
    P.Name AS ProductName,
    PC.Name AS Category,
    ISNULL(SUM(SD.OrderQty), 0) AS TotalSold,
    ISNULL(SUM(SD.LineTotal), 0) AS TotalRevenue
FROM Production.Product P
LEFT JOIN Sales.SalesOrderDetail SD ON P.ProductID = SD.ProductID
LEFT JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
LEFT JOIN Production.ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY P.Name, PC.Name;

--13.2 Show all sales territories with their assigned employees, including unassigned territories. Show territory name, employee name (null if unassigned), and sales year-to-date

SELECT 
    ST.Name AS TerritoryName,
    P.FirstName + ' ' + P.LastName AS EmployeeName,
    S.SalesYTD
FROM Sales.SalesTerritory ST
LEFT JOIN Sales.SalesPerson S ON ST.TerritoryID = S.TerritoryID
LEFT JOIN Person.Person P ON S.BusinessEntityID = P.BusinessEntityID;

--15.1

CREATE VIEW vw_ProductCatalog AS
SELECT 
    P.ProductID,
    P.Name,
    P.ProductNumber,
    PC.Name AS Category,
    PSC.Name AS Subcategory,
    P.ListPrice,
    P.StandardCost,
    ROUND(CASE WHEN P.StandardCost > 0 THEN ((P.ListPrice - P.StandardCost) / P.StandardCost) * 100 ELSE 0 END, 2) AS ProfitMargin,
    P.SafetyStockLevel + P.ReorderPoint AS InventoryLevel,
    CASE WHEN P.SellEndDate IS NULL THEN 'Active' ELSE 'Discontinued' END AS Status
FROM Production.Product P
LEFT JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
LEFT JOIN Production.ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID;

--15.2 

    CREATE VIEW vw_SalesAnalysis AS
SELECT 
    YEAR(SO.OrderDate) AS SalesYear,
    DATENAME(MONTH, SO.OrderDate) AS SalesMonth,
    ST.Name AS Territory,
    SUM(SO.TotalDue) AS TotalSales,
    COUNT(SO.SalesOrderID) AS OrderCount,
    AVG(SO.TotalDue) AS AvgOrderValue,
    MAX(PR.Name) AS TopProduct 
FROM Sales.SalesOrderHeader SO
JOIN Sales.SalesOrderDetail SOD ON SO.SalesOrderID = SOD.SalesOrderID
JOIN Production.Product PR ON SOD.ProductID = PR.ProductID
LEFT JOIN Sales.SalesTerritory ST ON SO.TerritoryID = ST.TerritoryID
GROUP BY YEAR(SO.OrderDate), DATENAME(MONTH, SO.OrderDate), ST.Name;

--16 

SELECT 
    CASE 
        WHEN TotalDue > 5000 THEN 'Large'
        WHEN TotalDue >= 1000 THEN 'Medium'
        ELSE 'Small'
    END AS OrderSize,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS Percentage
FROM Sales.SalesOrderHeader
GROUP BY 
    CASE 
        WHEN TotalDue > 5000 THEN 'Large'
        WHEN TotalDue >= 1000 THEN 'Medium'
        ELSE 'Small'
    END;


--17

SELECT 
    Name,
    ISNULL(CAST(Weight AS VARCHAR), 'Not Specified') AS Weight,
    ISNULL(Size, 'Standard') AS Size,
    ISNULL(Color, 'Natural') AS Color
FROM Production.Product;

--17?2


   SELECT 
    P.FirstName + ' ' + P.LastName AS CustomerName,
    COALESCE(EA.EmailAddress, PP.PhoneNumber, A.AddressLine1) AS PreferredContact
FROM Person.Person P
LEFT JOIN Person.EmailAddress EA ON P.BusinessEntityID = EA.BusinessEntityID
LEFT JOIN Person.PersonPhone PP ON P.BusinessEntityID = PP.BusinessEntityID
LEFT JOIN Person.BusinessEntityAddress BEA ON P.BusinessEntityID = BEA.BusinessEntityID
LEFT JOIN Person.Address A ON BEA.AddressID = A.AddressID;


--17.3 Find products where weight is null but size is not null, and also find products where both weight and size are null. Discuss the impact on inventory management.

   
   SELECT 
    ProductID,
	Name,
	Weight, 
	Size,
    CASE 
        WHEN Weight IS NULL AND Size IS NOT NULL THEN 'Missing Weight Only'
        WHEN Weight IS NULL AND Size IS NULL THEN 'Missing Both'
        ELSE 'OK'
    END AS InventoryStatus
FROM Production.Product
WHERE Weight IS NULL;






