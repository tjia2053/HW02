-- T1. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set 
SELECT cr.CountryRegionCode Country, sp.StateProvinceCode Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp 
ON cr.Name = sp.Name

-- T2. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set
SELECT cr.CountryRegionCode Country, sp.StateProvinceCode Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp 
ON cr.Name = sp.Name
WHERE cr.CountryRegionCode='GE' OR cr.CountryRegionCode='CA'

-- ***T3. List all Products that has been sold at least once in last 25 years. 
SELECT b.ProductID, a.OrderDate, DATEDIFF(YEAR,a.OrderDate,2022)
FROM Orders AS a Left JOIN [Order Details] AS b 
ON a.OrderID=b.OrderID
WHERE DATEDIFF(YEAR,a.OrderDate,2022)<25

-- T5. List all city names and number of customers in that city.   
SELECT City, COUNT(CustomerID) AS num_customer 
FROM Customers
GROUP BY City

-- T6. List city names which have more than 2 customers, and number of customers in that city 
SELECT City, COUNT(CustomerID) AS num_customer 
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID)>2

-- T7. Display the names of all customers  along with the  count of products they bought
SELECT a.CompanyName, COUNT(c.Quantity) count_product
FROM Customers a LEFT JOIN Orders b ON a.CustomerID=b.CustomerID LEFT JOIN [Order Details] c ON b.OrderID=c.OrderID
GROUP BY a.CompanyName

-- T8. Display the customer ids who bought more than 100 Products with count of products.
SELECT a.CustomerID, COUNT(c.Quantity) count_product
FROM Customers a LEFT JOIN Orders b ON a.CustomerID=b.CustomerID LEFT JOIN [Order Details] c ON b.OrderID=c.OrderID
GROUP BY a.CustomerID
HAVING COUNT(c.Quantity)>100

-- T9. List all of the possible ways that suppliers can ship their products. Display the results as:      Supplier Company Name                Shipping Company Name
SELECT e.CompanyName AS [Supplies Company Name], a.CompanyName AS [Shipping Company Name]
FROM Shippers a LEFT JOIN Orders b ON a.ShipperID=b.ShipVia 
LEFT JOIN [Order Details] c ON b.OrderID=c.OrderID
LEFT JOIN Products d ON c.ProductID=d.ProductID
LEFT JOIN Suppliers e ON d.SupplierID=e.SupplierID

-- T10. Display the products order each day. Show Order date and Product Name.
SELECT DISTINCT a.OrderDate [Order Date], c.[ProductName] AS [Product Name]
FROM Orders a LEFT JOIN [Order Details] b ON a.OrderID=b.OrderID
LEFT JOIN Products c ON b.ProductID=c.ProductID
ORDER BY a.OrderDate

-- T11. Displays pairs of employees who have the same job title.  ####
SELECT DISTINCT a.EmployeeID, b.EmployeeID
FROM Employees a JOIN Employees b 
ON a.Title=b.Title
WHERE a.EmployeeID!=b.EmployeeID

-- T12. Display all the Managers who have more than 2 employees reporting to them.
SELECT b.EmployeeID Manager
FROM Employees a LEFT JOIN Employees b  
ON a.ReportsTo=b.EmployeeID
GROUP BY b.EmployeeID 
HAVING COUNT(a.EmployeeID)>2

-- ***T13. Display the customers and suppliers by city. The results should have the following columns: City, Name, Contact Name,Type (Customer or Supplier)
SELECT *
FROM ((SELECT City City, CompanyName Name, ContactName [Contact Name], 'Customer' Type FROM Customers) 
UNION 
(SELECT City, CompanyName, ContactName, 'Supplier' FROM Suppliers) 
) t
ORDER BY t.City

-- T14. List all cities that have both Employees and Customers.
SELECT DISTINCT a.City City
FROM Employees a INNER JOIN Customers b  
ON a.City=b.City

-- T15. List all cities that have Customers but no Employee.
-- a. Use sub-query
SELECT DISTINCT City  
FROM Customers
WHERE City NOT IN (
    SELECT DISTINCT City FROM Employees
)
-- b. Do not use sub-query
SELECT DISTINCT a.City City 
FROM Customers a LEFT JOIN Employees b 
ON a.City=b.City 
WHERE b.City IS NULL

-- T16. List all products and their total order quantities throughout all orders.
SELECT ProductID, SUM(Quantity) total_quantities
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID

-- *T17. List all Customer Cities that have at least two customers.
SELECT City  
FROM Customers   
GROUP BY City    
HAVING COUNT(CustomerID)>=2

-- *T18. List all Customer Cities that have ordered at least two different kinds of products.
SELECT a.City 
FROM Customers a LEFT JOIN Orders b ON a.CustomerID=b.CustomerID 
LEFT JOIN [Order Details] c ON b.OrderID=c.OrderID 
GROUP BY a.City 
HAVING COUNT(DISTINCT c.ProductID)>=2

-- ***T19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT b.ProductID, SUM(b.Price)/SUM(b.Quantity) average_price,
FROM Orders a LEFT JOIN (
    SELECT UnitPrice*Quantity Price, Quantity, OrderID, ProductID FROM [Order Details]
) b 
ON a.OrderID=b.OrderID 
GROUP BY b.ProductID 
ORDER BY SUM(b.Quantity) DESC
LIMIT 5

-- ***T20. List one city, if exists, which is the city from where the employee sold most orders (not the product quantity), and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT e.City
FROM (
    SELECT a.ShipCity City, SUM(b.Quantity) total_quantity
    FROM Orders a LEFT JOIN [Order Details] b 
    ON a.OrderID=b.OrderID
    GROUP BY a.ShipCity 
) e
INNER JOIN(
    SELECT c.City City, COUNT(d.OrderID) total_orders
    FROM Employees c LEFT JOIN Orders d 
    ON c.EmployeeID=d.EmployeeID
    GROUP BY c.City
) f
ON e.City=f.City
WHERE e.total_quantity=MAX(e.total_quantity) AND f.total_orders=MAX(f.total_orders)

-- T21. How do you remove the duplicates record of a table?
-- Use DISTINCT
-- Use UNION instead of UNION ALL











































