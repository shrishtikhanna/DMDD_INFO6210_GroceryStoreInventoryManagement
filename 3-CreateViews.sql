USE [GROCERY_STORE_INVENTORY_MANAGEMENT];

DROP VIEW IF EXISTS EmployeeContacts;
DROP VIEW IF EXISTS ShipmentInfo;
DROP VIEW IF EXISTS InventoryAmounts;
GO

-- Create a view of all employees contact information for sending out memos and getting in touch with employees
CREATE VIEW EmployeeContacts
	AS
	SELECT e.EmployeeID, p.FirstName, p.LastName, p.PhoneNumber, p.Email, 
		   DATEDIFF(year, p.BirthDate, GETDATE()) AS [Age], e.StoreID, e.JobTitle, d.DepartmentName, a.AddressLine1, a.AddressLine2, a.City, a.State, a.ZipCode, a.Country
	FROM Employee e JOIN Person p
	ON e.PersonID = p.PersonID
	JOIN Department d
	ON e.DepartmentID = d.DepartmentID
	JOIN Address a
	ON p.AddressID = a.AddressID;
GO

SELECT * FROM EmployeeContacts;
GO

-- Create a view of all shipment info for shipments that have come into the various stores
CREATE VIEW ShipmentInfo
	AS
	SELECT sh.ShipmentID, o.OrderID, sh.DeliveryDate, sh.TrackingNumber, p.LastName AS [ReceivingEmployee], o.OrderTotal, su.SupplierName, st.StoreID
	FROM Shipment sh JOIN [Order] o
	ON sh.OrderID = o.OrderID
	JOIN Supplier su
	ON su.SupplierID = o.SupplierID
	JOIN Store st
	ON st.StoreID = o.StoreID
	JOIN Employee e
	ON e.EmployeeID = sh.ReceivedbyEmployeeID
	JOIN Person p
	ON p.PersonID = e.PersonID;
GO

SELECT * FROM ShipmentInfo;
GO

-- Create a view of the stock inventory available in each store
CREATE VIEW InventoryAmounts
	AS
	SELECT s.StoreID, pe.LastName AS [Manager], pr.ProductName, pr.Brand, pc.ProductCategoryName, i.UnitPrice, i.Quantity, 
		   DATEDIFF(day, GETDATE(), i.ExpirationDate) AS [DaysUntilExpiration], pr.Description
	FROM Inventory i JOIN Store s
	ON i.StoreID = s.StoreID
	JOIN Employee e
	ON e.StoreID = s.StoreID
	JOIN Person pe
	ON pe.PersonID = e.PersonID
	JOIN Product pr
	ON pr.ProductID = i.ProductID
	JOIN ProductCategory pc
	ON pc.ProductCategoryID = pr.ProductCategoryID;
GO

SELECT * FROM InventoryAmounts;