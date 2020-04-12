USE [GROCERY_STORE_INVENTORY_MANAGEMENT];

-- Compute columns in Sale table by functions
DROP FUNCTION IF EXISTS CalcSubTotal;
GO

CREATE FUNCTION CalcSubTotal
	(@SaleID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @SubTotal MONEY = 
		(SELECT SUM(sli.LineItemPrice)
		 FROM Sale s JOIN SaleLineItem sli
		 ON s.SaleID = sli.SaleID
		 WHERE s.SaleID = @SaleID);
	SET @SubTotal = ISNULL(@SubTotal, 0);
	RETURN @SubTotal;
END;
GO

UPDATE Sale
SET SubTotal = dbo.CalcSubTotal(SaleID);

DROP FUNCTION IF EXISTS CalcTax;
GO

CREATE FUNCTION CalcTax
	(@SaleID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @Tax MONEY = 
		(SELECT 0.0625 * SUM(sli.LineItemPrice)
		 FROM Sale s JOIN SaleLineItem sli
		 ON s.SaleID = sli.SaleID
		 WHERE s.SaleID = @SaleID);
	SET @Tax = ISNULL(@Tax, 0);
	RETURN @Tax;
END;
GO

UPDATE Sale
Set Tax = dbo.CalcTax(SaleID);

DROP FUNCTION IF EXISTS CalcTotal;
GO

CREATE FUNCTION CalcTotal
	(@SaleID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @Total MONEY = 
		(SELECT SubTotal + Tax
		 FROM Sale
		 WHERE SaleID = @SaleID);
	SET @Total = ISNULL(@Total, 0);
	RETURN @Total;
END;
GO

UPDATE Sale
SET Total = dbo.CalcTotal(SaleID);

SELECT * FROM Sale;

-- Check that inventory is not out before purchasing
DROP FUNCTION IF EXISTS CheckStock;
GO

CREATE FUNCTION CheckStock
	(@ProductID INT)
RETURNS INT
AS
BEGIN
	DECLARE @Stock INT = 0;
	SELECT @Stock = COUNT(ProductID)
	FROM Inventory
	WHERE ProductID = @ProductID
	AND Quantity = 0;
	RETURN @Stock;
END;
GO

ALTER TABLE SaleLineItem ADD CONSTRAINT OutOfStock CHECK (dbo.CheckStock(ProductID) = 0);

-- Test constraint (Assuming StoreID = 1 and ProductID = 1 is not inserted already)
INSERT INTO Inventory (StoreID, ProductID, UnitPrice, Quantity)
VALUES (1, 1, '$1.00', 0);

INSERT INTO SaleLineItem (SaleID, ProductID, Quantity)
VALUES (1, 1, 10);