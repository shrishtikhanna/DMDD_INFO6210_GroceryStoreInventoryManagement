USE [GROCERY_STORE_INVENTORY_MANAGEMENT];

-- Allows use of NEWID() in a function
DROP VIEW IF EXISTS getNewID;
GO
CREATE VIEW getNewID AS SELECT NEWID() AS new_id;
GO

-- Generates a random date
DROP FUNCTION IF EXISTS randomDate;
GO
CREATE FUNCTION randomDate
    (@start DATE, @range INT)
RETURNS DATE
AS
BEGIN
	DECLARE @random UNIQUEIDENTIFIER
	SET @random = (SELECT new_id FROM getNewID)
	DECLARE @resultvar DATE
	SET @resultvar = (SELECT DATEADD(DAY, ABS(CHECKSUM(@random) % @range ), @start))
	RETURN @resultvar
END;
GO

-- Returns an AddressID which isn't already referenced by a Person
DROP VIEW IF EXISTS uniquePersonAddress;
GO
CREATE VIEW uniquePersonAddress AS
	SELECT TOP 1 AddressID FROM Address WHERE AddressID NOT IN (SELECT AddressID FROM Person) ORDER BY NEWID();
GO

-- Returns an AddressID which isn't already referenced by a Store
DROP VIEW IF EXISTS uniqueStoreAddress;
GO
CREATE VIEW uniqueStoreAddress AS
	SELECT TOP 1 AddressID FROM Address WHERE AddressID NOT IN (SELECT AddressID FROM Store) ORDER BY NEWID();
GO

-- Returns an AddressID which isn't already referenced by a Supplier
DROP VIEW IF EXISTS uniqueSupplierAddress;
GO
CREATE VIEW uniqueSupplierAddress AS
	SELECT TOP 1 AddressID FROM Address WHERE AddressID NOT IN (SELECT AddressID FROM Supplier) ORDER BY NEWID();
GO

-- Returns a PersonID which isn't already referenced by a Customer
DROP VIEW IF EXISTS uniqueCustomerPerson;
GO
CREATE VIEW uniqueCustomerPerson AS
	SELECT TOP 1 PersonID FROM Person WHERE PersonID NOT IN (SELECT PersonID FROM Customer) ORDER BY NEWID();
GO

-- Returns a PersonID which isn't already referenced by an Employee
DROP VIEW IF EXISTS uniqueEmployeePerson;
GO
CREATE VIEW uniqueEmployeePerson AS
	SELECT TOP 1 PersonID FROM Person WHERE PersonID NOT IN (SELECT PersonID FROM Employee) ORDER BY NEWID();
GO

-- Returns a random StoreID
DROP VIEW IF EXISTS randomStore;
GO
CREATE VIEW randomStore AS
    SELECT TOP 1 StoreID FROM Store ORDER BY NEWID();
GO

-- Returns a random CustomerID
DROP VIEW IF EXISTS randomCustomer;
GO
CREATE VIEW randomCustomer AS
    SELECT TOP 1 CustomerID FROM Customer ORDER BY NEWID();
GO

-- Returns a random DepartmentID
DROP VIEW IF EXISTS randomDepartment;
GO
CREATE VIEW randomDepartment AS
    SELECT TOP 1 DepartmentID FROM Department ORDER BY NEWID();
GO

-- Returns a random SupplierID
DROP VIEW IF EXISTS randomSupplier;
GO
CREATE VIEW randomSupplier AS
    SELECT TOP 1 SupplierID FROM Supplier ORDER BY NEWID();
GO
-- Returns a random OrderID
DROP VIEW IF EXISTS randomOrder;
GO
CREATE VIEW randomOrder AS
    SELECT TOP 1 OrderID FROM [Order] ORDER BY NEWID();
GO

-- Returns a random ProductID not already in
-- inventory of given store
DROP FUNCTION IF EXISTS randomProductInventory;
GO
CREATE FUNCTION randomProductInventory
    (@storeid INT)
RETURNS INT
AS
BEGIN
	DECLARE @resultvar INT
	SET @resultvar = (SELECT TOP 1 p.ProductID
    FROM Product p
    WHERE p.ProductID NOT IN (
        SELECT i.ProductID
        FROM Inventory i
        WHERE i.StoreID = @storeid
    ) ORDER BY (SELECT new_id FROM getNewID))
    RETURN @resultvar
END;
GO

-- Returns a random ProductID not already in
-- lineitem of given sale
DROP FUNCTION IF EXISTS randomProductSale;
GO
CREATE FUNCTION randomProductSale
    (@saleid INT)
RETURNS INT
AS
BEGIN
	DECLARE @resultvar INT
	SET @resultvar = (SELECT TOP 1 p.ProductID
    FROM Product p
    WHERE p.ProductID NOT IN (
        SELECT sli.ProductID
        FROM SaleLineItem sli
        WHERE sli.SaleID = @saleid
    ) ORDER BY (SELECT new_id FROM getNewID))
    RETURN @resultvar
END;
GO

-- Returns a random ProductID not already in
-- lineitem of given order
DROP FUNCTION IF EXISTS randomProductOrder;
GO
CREATE FUNCTION randomProductOrder
    (@orderid INT)
RETURNS INT
AS
BEGIN
	DECLARE @resultvar INT
	SET @resultvar = (SELECT TOP 1 p.ProductID
    FROM Product p
    WHERE p.ProductID NOT IN (
        SELECT oli.ProductID
        FROM OrderLineItem oli
        WHERE oli.OrderID = @orderid
    ) ORDER BY (SELECT new_id FROM getNewID))
    RETURN @resultvar
END;
GO

-- Returns a random EmployeeID for given Store
DROP FUNCTION IF EXISTS randomStoreEmployee;
GO
CREATE FUNCTION randomStoreEmployee
    (@storeid INT)
RETURNS INT
AS
BEGIN
	DECLARE @resultvar INT
	SET @resultvar = (SELECT TOP 1 EmployeeID
    FROM Employee
    WHERE StoreID = @storeid
    ORDER BY (SELECT new_id FROM getNewID))
    RETURN @resultvar
END;
GO

-- Returns a random EmployeeID for given Order
DROP FUNCTION IF EXISTS randomOrderEmployee;
GO
CREATE FUNCTION randomOrderEmployee
    (@orderid INT)
RETURNS INT
AS
BEGIN
	DECLARE @resultvar INT
	SET @resultvar = (SELECT TOP 1 EmployeeID
    FROM Employee
    WHERE StoreID = (SELECT StoreID FROM [Order] WHERE OrderID = @orderid)
    ORDER BY (SELECT new_id FROM getNewID))
    RETURN @resultvar
END;
GO

-- Insert 100 Addresses
INSERT INTO Address([AddressLine1],[AddressLine2],[City],[State],[Country],[ZipCode]) VALUES
    ('5526 Imperdiet Rd.','P.O. Box 963','San Diego','California','United States','93381'),
    ('1412 Et Ave','Ap #422','Bellevue','Washington','United States','42248'),
    ('3961 Aenean Ave','Ap #107','Duluth','Minnesota','United States','78572'),
    ('496-1324 Sed Street',NULL,'Baltimore','Maryland','United States','40811'),
    ('6507 Libero St.','Ap #683','Pittsburgh','Pennsylvania','United States','81522'),
    ('5481 Enim Road','Ap #868','Laramie','Wyoming','United States','53353'),
    ('1051 Ante. Ave','Ap #387','Annapolis','Maryland','United States','86562'),
    ('4741 Diam St.','Ap #880','Little Rock','Arkansas','United States','72533'),
    ('3651 Ac Street','Ap #894','Sioux City','Iowa','United States','59347'),
    ('2695 Lorem, Road','P.O. Box 820','South Bend','Indiana','United States','11820'),
    ('7310 Semper. Rd.','P.O. Box 479','Topeka','Kansas','United States','57481'),
    ('642-5644 Vulputate, Av.',NULL,'Jonesboro','Arkansas','United States','71920'),
    ('222-4869 Accumsan Ave',NULL,'Henderson','Nevada','United States','80703'),
    ('1489 Et Rd.',NULL,'Warren','Michigan','United States','46046'),
    ('413-3009 Ante St.',NULL,'Colchester','Vermont','United States','42641'),
    ('6165 Elit St.',NULL,'Nampa','Idaho','United States','28448'),
    ('2963 Cras Avenue',NULL,'Bozeman','Montana','United States','49859'),
    ('7255 Enim. Street','Ap #955','Kenosha','Wisconsin','United States','15549'),
    ('8912 Magna Avenue',NULL,'Anchorage','Alaska','United States','99799'),
    ('4713 Enim Road','P.O. Box 953','Los Angeles','California','United States','94899'),
    ('603-7678 Sodales Rd.',NULL,'Cincinnati','Ohio','United States','55436'),
    ('2572 Sapien, Road','P.O. Box 633','Jonesboro','Arkansas','United States','71999'),
    ('684-7696 Non Avenue',NULL,'Kansas City','Kansas','United States','23580'),
    ('4258 Malesuada St.','P.O. Box 406','Helena','Montana','United States','29484'),
    ('6182 Eu Ave',NULL,'Shreveport','Louisiana','United States','14347'),
    ('5023 Et Rd.','P.O. Box 612','Gary','Indiana','United States','81990'),
    ('1967 Mauris Rd.','Ap #262','San Jose','California','United States','91087'),
    ('6467 Nulla St.','P.O. Box 762','Bear','Delaware','United States','38262'),
    ('3046 Tellus Av.','Ap #538','Boise','Idaho','United States','20579'),
    ('1464 Ultrices Ave.',NULL,'Great Falls','Montana','United States','78444'),
    ('9486 Et Road','P.O. Box 689','New Orleans','Louisiana','United States','43998'),
    ('5843 Nulla Rd.','Ap #487','Springfield','Illinois','United States','14869'),
    ('7605 Maecenas Av.','Ap #648','Glendale','Arizona','United States','85813'),
    ('6761 Sem Rd.',NULL,'Fayetteville','Arkansas','United States','71544'),
    ('6116 Ut St.','Ap #948','Auburn','Maine','United States','52636'),
    ('3963 Convallis Street','P.O. Box 611','Davenport','Iowa','United States','61771'),
    ('668-7265 Dolor. Road',NULL,'Spokane','Washington','United States','10105'),
    ('5095 Pede Street','Ap #459','Cincinnati','Ohio','United States','79657'),
    ('1551 Ornare Street',NULL,'Eugene','Oregon','United States','43688'),
    ('7710 Curabitur Ave',NULL,'Chesapeake','Virginia','United States','95120'),
    ('979-2782 Lacinia St.',NULL,'North Las Vegas','Nevada','United States','26556'),
    ('3992 Sit Ave','Ap #729','Dallas','Texas','United States','60060'),
    ('689-9392 Cursus Street',NULL,'Rock Springs','Wyoming','United States','30519'),
    ('9090 Lacus. Rd.','P.O. Box 601','Houston','Texas','United States','59059'),
    ('1299 Neque Av.','Allentown','Ap #199','Pennsylvania','United States','59381'),
    ('7100 Hendrerit Road','P.O. Box 662','Frederick','Maryland','United States','28471'),
    ('4011 Ipsum St.','P.O. Box 994','Hartford','Connecticut','United States','65085'),
    ('8937 Cursus Ave','P.O. Box 969','Pike Creek','Delaware','United States','64015'),
    ('6776 Quisque St.','P.O. Box 640','Honolulu','Hawaii','United States','78223'),
    ('6531 Non, Ave','Ap #255','Hartford','Connecticut','United States','23534'),
    ('4100 Eget St.',NULL,'Nashville','Tennessee','United States','43850'),
    ('8641 Duis Street','Ap #318','Fort Collins','Colorado','United States','13158'),
    ('284-1935 Gravida Street',NULL,'Newark','Delaware','United States','23039'),
    ('9726 Lacus. Avenue',NULL,'Erie','Pennsylvania','United States','71811'),
    ('5977 Aliquam Av.','Ap #922','Wyoming','Wyoming','United States','49958'),
    ('7730 Sagittis St.','Ap $496','Jacksonville','Florida','United States','96302'),
    ('9786 Mollis. Ave',NULL,'Rock Springs','Wyoming','United States','72874'),
    ('867 Egestas Rd.',NULL,'Helena','Montana','United States','97535'),
    ('9052 Ullamcorper Rd.',NULL,'Newark','Delaware','United States','24136'),
    ('3007 Tincidunt St.',NULL,'Chicago','Illinois','United States','96130'),
    ('5562 Fusce Rd.',NULL,'Portland','Maine','United States','56285'),
    ('6084 Tellus, St.','Ap #983','Harrisburg','Pennsylvania','United States','17121'),
    ('890 Lectus St.','P.O. Box 632','Kailua','Hawaii','United States','53124'),
    ('7174 Dolor. Street','Ap #765','Bloomington','Minnesota','United States','77572'),
    ('7030 Ac St.','Ap #145','Lewiston','Maine','United States','67199'),
    ('338 Phasellus St.','Ap #579','Kapolei','Hawaii','United States','61275'),
    ('184 Mauris Rd.','Ap #131','Cleveland','Ohio','United States','59405'),
    ('960-9748 Arcu Av.',NULL,'Lewiston','Maine','United States','71339'),
    ('2691 Nec Rd.',NULL,'Knoxville','Tennessee','United States','52705'),
    ('5129 Nullam Rd.','Ap #832','Jacksonville','Florida','United States','59804'),
    ('7653 Suspendisse Av.','P.O. Box 325','Oklahoma City','Oklahoma','United States','90026'),
    ('6058 Nunc Road','Ap #443','Frederick','Maryland','United States','10154'),
    ('8089 Sed St.','P.O. Box 427','Hattiesburg','Mississippi','United States','37092'),
    ('889-1798 Non Street',NULL,'Green Bay','Wisconsin','United States','41245'),
    ('460-9655 Ipsum Road',NULL,'Salt Lake City','Utah','United States','37218'),
    ('503-2993 Enim St.',NULL,'Columbia','Maryland','United States','26524'),
    ('1476 Cursus Road','Ap #586','Columbus','Ohio','United States','33426'),
    ('9419 Felis Road','P.O. Box 567','San Jose','California','United States','95135'),
    ('1431 Nec, Rd.','Ap #846','Reno','Nevada','United States','52892'),
    ('921-7106 Mus Road',NULL,'Joliet','Illinois','United States','10404'),
    ('6884 Eu Avenue','P.O. Box 948','Chesapeake','Virginia','United States','17593'),
    ('8368 Lacus. Street','Ap #818','Bellevue','Nebraska','United States','82384'),
    ('4376 Egestas, Rd.','Ap #572','Lexington','Kentucky','United States','33335'),
    ('435-6623 Nunc Road',NULL,'Kansas City','Kansas','United States','46510'),
    ('1045 Sed St.',NULL,'Rockville','Maryland','United States','84232'),
    ('155-844 Orci Ave',NULL,'Springfield','Missouri','United States','53475'),
    ('383-9251 Justo St.',NULL,'Oklahoma City','Oklahoma','United States','45201'),
    ('6473 Eu Rd.','Ap #833','San Antonio','Texas','United States','13511'),
    ('945 Arcu Ave','P.O. Box 561','Wyoming','Wyoming','United States','87110'),
    ('3286 Nisi Rd.',NULL,'Kenosha','Wisconsin','United States','53225'),
    ('5134 Massa Avenue',NULL,'Jonesboro','Arkansas','United States','71973'),
    ('627 Est Avenue','Ap #728','Salem','Oregon','United States','20438'),
    ('4262 Aliquet Street','Ap #429','West Jordan','Utah','United States','81589'),
    ('2395 Sed, St.','Ap #510','Worcester','Massachusetts','United States','42598'),
    ('725-8735 Consectetuer Road',NULL,'Houston','Texas','United States','98140'),
    ('9620 Nec Av.',NULL,'Athens','Georgia','United States','39402'),
    ('3448 Sed St.',NULL,'Laramie','Wyoming','United States','52326'),
    ('5016 Eget Av.',NULL,'Glendale','Arizona','United States','86817'),
    ('385-2354 Purus St.',NULL,'Henderson','Nevada','United States','18530'),
    ('8011 At Avenue',NULL,'Baltimore','Maryland','United States','10294');

-- Insert 50 Persons with random unique AddressID and random BirthDate from 1950 - 2005
CREATE TABLE #TempPerson 
(
	PersonID INT,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Gender VARCHAR(10),
	PhoneNumber VARCHAR(20),
	Email VARCHAR(100)
)

INSERT INTO #TempPerson([PersonID],[FirstName],[LastName],[Gender],[PhoneNumber],[Email]) VALUES
    (1,'Jacob','Blake','male','(227) 204-3104','eu.turpis.Nulla@vitaemauris.net'),
    (2,'Kennan','Maxwell','male','(601) 473-2025','cursus.Integer.mollis@dapibus.org'),
    (3,'Harper','Fisher','female','(209) 653-6112','feugiat@urnaUttincidunt.co.uk'),
    (4,'Laura','Sparks','female','(660) 606-3095','elit@musProin.ca'),
    (5,'Nissim','Bradley','male','(808) 515-7539','neque.et.nunc@eratSed.org'),
    (6,'Cadman','Mann','male','(800) 987-0463','mauris.aliquam.eu@interdum.com'),
    (7,'Stone','Branch','male','(266) 932-3243','Cras@convallis.com'),
    (8,'Michelle','Cruz','female','(704) 810-1839','ultricies@dolorFuscemi.ca'),
    (9,'Timon','Bell','male','(255) 326-3293','Donec.feugiat@torquent.com'),
    (10,'Alden','Burch','male','(749) 218-5475','mollis.Duis@Morbi.net'),
    (11,'Mariko','Grant','male','(985) 586-9947','semper.auctor.Mauris@Fuscealiquetmagna.co.uk'),
    (12,'Aidan','Richardson','male','(633) 717-0571','nec.ante.Maecenas@sitamet.co.uk'),
    (13,'Colleen','Mcpherson','female','(432) 824-1343','euismod@sempercursus.org'),
    (14,'Amela','Kerr','female','(892) 461-4592','pede.nonummy@consequatnec.co.uk'),
    (15,'Arthur','Castillo','male','(988) 654-2811','pretium@pedenonummy.net'),
    (16,'Lawrence','Dodson','male','(417) 886-8181','Proin.ultrices@maurisid.edu'),
    (17,'Tamekah','Rush','female','(337) 157-0044','egestas.nunc.sed@liberomaurisaliquam.com'),
    (18,'Jada','Trujillo','female','(191) 975-2158','ut@Aliquamvulputateullamcorper.co.uk'),
    (19,'Zelda','Higgins','female','(488) 460-9317','risus.Donec.nibh@justofaucibus.net'),
    (20,'Lucian','Cotton','male','(302) 180-1657','arcu.Vestibulum@lorem.co.uk'),
    (21,'Whoopi','Guy','female','(739) 123-1997','semper@gravidasit.com'),
    (22,'Hollee','Bradley','female','(548) 152-6276','ultrices.Duis@temporarcuVestibulum.net'),
    (23,'Adena','Mathews','female','(898) 760-9815','nunc.risus.varius@laoreetlectus.net'),
    (24,'Kerry','Mcclure','female','(838) 536-2883','sagittis@Mauris.net'),
    (25,'Darius','Taylor','male','(204) 877-0856','Curabitur.massa.Vestibulum@nisiMaurisnulla.com'),
    (26,'Charlotte','Gonzales','female','(143) 379-1674','ac.arcu.Nunc@pellentesqueegetdictum.edu'),
    (27,'Joy','Warren','female','(536) 244-0934','massa.Integer.vitae@mauris.com'),
    (28,'Edward','Lynch','male','(214) 726-3253','Nunc.laoreet.lectus@loremsitamet.edu'),
    (29,'Burton','Rowe','male','(906) 759-9948','Lorem.ipsum.dolor@Praesenteu.co.uk'),
    (30,'Jena','Pearson','female','(139) 868-4382','vel@at.co.uk'),
    (31,'Alexis','Harrison','female','(953) 444-1293','urna@in.com'),
    (32,'Tallulah','Combs','male','(593) 450-8854','lobortis.tellus@Donecvitaeerat.edu'),
    (33,'Clayton','Booker','male','(648) 993-3598','Morbi@Quisqueporttitor.com'),
    (34,'Mara','Kelley','female','(797) 112-6761','semper.tellus.id@commodoauctorvelit.co.uk'),
    (35,'Dacey','Dotson','male','(780) 287-1949','feugiat.Sed.nec@pedemalesuadavel.co.uk'),
    (36,'Tate','Harris','male','(868) 800-4584','ac@idmagna.ca'),
    (37,'Lacey','Murray','female','(582) 982-5530','amet.consectetuer@sed.net'),
    (38,'Dieter','Roman','male','(118) 382-0008','arcu.et@ullamcorpereu.co.uk'),
    (39,'Ivor','Gay','male','(240) 402-9329','Pellentesque.ultricies.dignissim@mattis.net'),
    (40,'Sophia','Herman','female','(681) 387-2485','id@Aenean.org'),
    (41,'Kyle','Holcomb','male','(504) 685-5491','placerat@IntegermollisInteger.edu'),
    (42,'Vivian','Hensley','female','(896) 108-5155','a.nunc.In@porttitorvulputateposuere.ca'),
    (43,'Knox','Stein','male','(456) 589-7451','diam.at@amet.edu'),
    (44,'Daniel','Cooper','male','(963) 984-2962','tellus.Phasellus.elit@sitamet.ca'),
    (45,'Idola','Bentley','female','(459) 208-6973','non@augueutlacus.org'),
    (46,'Athena','Burgess','female','(199) 959-2509','Nullam.feugiat.placerat@Fusce.org'),
    (47,'Uma','Velasquez','female','(383) 558-9524','malesuada@Integer.org'),
    (48,'Brielle','Hughes','female','(550) 906-8213','augue.id.ante@tellusNunclectus.org'),
    (49,'August','Pickett','female','(447) 716-1223','ante.iaculis@auctor.edu'),
    (50,'Florence','Rojas','female','(984) 775-2660','arcu.Vivamus.sit@gravida.ca');

DECLARE @personcounter INT
SET @personcounter = 0
WHILE @personcounter <> 50
	BEGIN
	 	SET @personcounter = @personcounter + 1
        INSERT INTO Person([AddressId],[FirstName],[LastName],[BirthDate],[Gender],[PhoneNumber],[Email]) 
		SELECT (SELECT * FROM uniquePersonAddress), [FirstName],[LastName],(SELECT dbo.randomDate('1950-01-01', 20075)),[Gender],[PhoneNumber],[Email] FROM #TempPerson	
		WHERE [PersonID] = @personcounter;
 	END

DROP TABLE #TempPerson

-- Insert 10 Stores with random unique AddressID
CREATE TABLE #TempStore
(
	StoreID INT,
	PhoneNumber VARCHAR(20)
)

INSERT INTO #TempStore([StoreID],[PhoneNumber]) VALUES
    (1,'(332) 753-7547'),
    (2,'(426) 103-0328'),
    (3,'(449) 216-6115'),
    (4,'(997) 424-8380'),
    (5,'(377) 562-8889'),
    (6,'(969) 724-1963'),
    (7,'(431) 802-8622'),
    (8,'(641) 340-5310'),
    (9,'(824) 307-1599'),
    (10,'(608) 179-1411');

DECLARE @storecounter INT
SET @storecounter = 0
WHILE @storecounter <> 10
	BEGIN
	 	SET @storecounter = @storecounter + 1
        INSERT INTO Store([AddressId],[PhoneNumber]) 
		SELECT (SELECT * FROM uniqueStoreAddress), [PhoneNumber] FROM #TempStore
		WHERE [StoreID] = @storecounter;
 	END

DROP TABLE #TempStore

-- Insert 50 Customers with random unique PersonID and random LastSaleDate from 2010 - 2020
DECLARE @customercounter INT
SET @customercounter = 0
WHILE @customercounter <> 50
	BEGIN
	 	SET @customercounter = @customercounter + 1
        INSERT INTO Customer([PersonID],[LastSaleDate]) VALUES
            ((SELECT * FROM uniqueCustomerPerson),(SELECT dbo.randomDate('2010-01-01', 3650)))
 	END

-- Insert 10 Departments
INSERT INTO Department([DepartmentName]) VALUES
    ('Dairy'),
    ('Deli'),
    ('Produce'),
    ('Baking'),
    ('Butcher'),
    ('Seafood'),
    ('Bakery'),
    ('Cashier'),
    ('Maintenance'),
    ('Warehouse');

-- Insert 50 Employees
CREATE TABLE #TempEmployee
(
	EmployeeID INT,
	StoreID INT,
	SSN VARCHAR(9),
	Passcode VARCHAR(4),
	JobTitle VARCHAR(100),
	DepartmentID INT,
	Salary MONEY,
	StartDate DATE,
	EndDate DATE
)

INSERT INTO #TempEmployee([EmployeeID],[StoreID],[SSN],[Passcode],[Salary],[StartDate],[EndDate],[JobTitle],[DepartmentID]) VALUES
    (1,(SELECT * FROM randomStore),521098446,2381,'$19676.29',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (2,(SELECT * FROM randomStore),469237270,6692,'$12961.65',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (3,(SELECT * FROM randomStore),321913153,5793,'$16279.60',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (4,(SELECT * FROM randomStore),146961760,2258,'$14346.04',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (5,(SELECT * FROM randomStore),502622907,4545,'$13673.62',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (6,(SELECT * FROM randomStore),115570908,3334,'$12922.81',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (7,(SELECT * FROM randomStore),135687952,4617,'$15145.80',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (8,(SELECT * FROM randomStore),963176508,2861,'$18330.93',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (9,(SELECT * FROM randomStore),547594464,3418,'$16843.01',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (10,(SELECT * FROM randomStore),840103580,5593,'$10780.61',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (11,(SELECT * FROM randomStore),991486116,3118,'$14085.64',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (12,(SELECT * FROM randomStore),860242379,2000,'$16883.15',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (13,(SELECT * FROM randomStore),100104630,3573,'$13900.24',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (14,(SELECT * FROM randomStore),379491880,5844,'$16350.04',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (15,(SELECT * FROM randomStore),096912717,5077,'$16665.38',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (16,(SELECT * FROM randomStore),921202419,8955,'$19604.76',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (17,(SELECT * FROM randomStore),216445166,8889,'$17073.33',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (18,(SELECT * FROM randomStore),720685166,1170,'$19096.92',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (19,(SELECT * FROM randomStore),229532420,6252,'$10651.61',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (20,(SELECT * FROM randomStore),898504297,1637,'$19870.29',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (21,(SELECT * FROM randomStore),297086645,4226,'$19686.83',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (22,(SELECT * FROM randomStore),233541255,3977,'$11731.08',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (23,(SELECT * FROM randomStore),239698338,7089,'$13528.55',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (24,(SELECT * FROM randomStore),063986951,7552,'$17431.03',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (25,(SELECT * FROM randomStore),924884564,4314,'$11407.54',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (26,(SELECT * FROM randomStore),977152069,4368,'$11104.13',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (27,(SELECT * FROM randomStore),764509715,7293,'$16392.63',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (28,(SELECT * FROM randomStore),790590786,9237,'$17549.96',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (29,(SELECT * FROM randomStore),140593889,3078,'$15435.33',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (30,(SELECT * FROM randomStore),282064674,1764,'$18657.14',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (31,(SELECT * FROM randomStore),816089960,2521,'$13109.52',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (32,(SELECT * FROM randomStore),709286216,5617,'$12413.94',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (33,(SELECT * FROM randomStore),510384268,5866,'$13814.70',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (34,(SELECT * FROM randomStore),529403723,6372,'$18343.48',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (35,(SELECT * FROM randomStore),930256973,3541,'$13756.83',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (36,(SELECT * FROM randomStore),491445941,5141,'$18836.14',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (37,(SELECT * FROM randomStore),780428146,6217,'$19344.86',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (38,(SELECT * FROM randomStore),884922155,6733,'$17926.73',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (39,(SELECT * FROM randomStore),896294035,3977,'$11791.76',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (40,(SELECT * FROM randomStore),098281344,4691,'$11730.65',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (41,(SELECT * FROM randomStore),705469191,1405,'$11212.14',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (42,(SELECT * FROM randomStore),883459537,1651,'$13389.58',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (43,(SELECT * FROM randomStore),839616558,9215,'$14151.94',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (44,(SELECT * FROM randomStore),414003021,7184,'$13153.80',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (45,(SELECT * FROM randomStore),924018993,4849,'$16270.64',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (46,(SELECT * FROM randomStore),125817754,6623,'$19646.28',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (47,(SELECT * FROM randomStore),875623315,5106,'$19700.92',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (48,(SELECT * FROM randomStore),807594415,2480,'$19991.33',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (49,(SELECT * FROM randomStore),605012812,1530,'$17133.89',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment)),
    (50,(SELECT * FROM randomStore),258481656,1812,'$19757.95',(SELECT dbo.randomDate('1989-01-01', 3650)),(SELECT dbo.randomDate('2000-01-01', 3650)), 'title', (SELECT * FROM randomDepartment));

DECLARE @employeecounter INT
SET @employeecounter = 0
WHILE @employeecounter <> 50
	BEGIN
	 	SET @employeecounter = @employeecounter + 1
        INSERT INTO Employee([PersonID],[StoreID],[SSN],[Passcode],[Salary],[StartDate],[EndDate],[JobTitle],[DepartmentID]) 
		SELECT (SELECT * FROM uniqueEmployeePerson), [StoreID],[SSN],[Passcode],[Salary],[StartDate],[EndDate],[JobTitle],[DepartmentID] FROM #TempEmployee
		WHERE [EmployeeID] = @employeecounter;
 	END

DROP TABLE #TempEmployee

-- Insert ProductCategories
INSERT INTO ProductCategory([ProductCategoryName]) VALUES
    ('Cheese'),
    ('Cereal'),
    ('Beef'),
    ('Chicken'),
    ('Tea'),
    ('Vegetable'),
    ('Fruit'),
    ('Chips'),
    ('Soda'),
    ('Frozen Pizza');

-- Insert Products
INSERT INTO Product([ProductName],[ProductCategoryID],[UPC]) VALUES
    ('Cheddar', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Cheese'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Mozzarella', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Cheese'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Swiss', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Cheese'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Provolone', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Cheese'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Cinnamon Toast Crunch', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Cereal'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Fruit Loops', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Cereal'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Lucky Charms', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Cereal'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Ground Beef', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Beef'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Pot Roast', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Beef'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Sirloin Tips', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Beef'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Boneless Skinless Thighs', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Chicken'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('English Breakfast', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Tea'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Earl Grey', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Tea'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Carrot', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Vegetable'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Cucumber', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Vegetable'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Raddish', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Vegetable'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Iceburg Lettuce', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Vegetable'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Apple', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Fruit'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Orange', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Fruit'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Banana', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Fruit'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Doritos', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Chips'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Scoops', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Chips'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Coca-Cola', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Soda'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Sprite', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Soda'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Dr. Pepper', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Soda'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Root Beer', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Soda'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000),
    ('Digiorno', (SELECT ProductCategoryID FROM ProductCategory WHERE ProductCategoryName = 'Frozen Pizza'), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000);

-- Insert Inventory
DECLARE @inventorycounter INT
SET @inventorycounter = 0
WHILE @inventorycounter <> 100
	BEGIN
	 	SET @inventorycounter = @inventorycounter + 1
        DECLARE @storeid INT
        SET @storeid = (SELECT * FROM randomStore)
        INSERT INTO Inventory([StoreID],[ProductID],[UnitPrice],[Quantity],[ExpirationDate]) VALUES
            (@storeid,(SELECT dbo.randomProductInventory(@storeid)), CAST(ROUND((RAND()*(30-1)+1),2) AS MONEY), FLOOR(RAND()*(300)), (SELECT dbo.randomDate(GETDATE(), 60)))
 	END;
GO

-- Insert Sales
DROP TRIGGER IF EXISTS dbo.saleTotals;
GO
CREATE TRIGGER dbo.saleTotals
	ON SaleLineItem
	FOR INSERT, UPDATE, DELETE
AS
BEGIN
	UPDATE
		Sale
	SET
		SubTotal = (
			SELECT SUM(LineItemPrice)
            FROM SaleLineItem sli
            WHERE sli.SaleID = SaleID
		),
        Tax = (
            SELECT .0625 * SUM(LineItemPrice)
            FROM SaleLineItem sli
            WHERE sli.SaleID = SaleID
        ),
        Total = (
            SELECT (.0625 * SUM(LineItemPrice)) + SUM(LineItemPrice)
            FROM SaleLineItem sli
            WHERE sli.SaleID = SaleID            
        )
END;
GO

DECLARE @counter INT
SET @counter = 0
WHILE @counter <> 200
	BEGIN
	 	SET @counter = @counter + 1

        DECLARE @storeid INT
        SET @storeid = (SELECT * FROM randomStore)

        INSERT INTO Sale([StoreID],[EmployeeID],[CustomerID],[SaleDate]) VALUES
            (@storeid, (SELECT dbo.randomStoreEmployee(@storeid)), (SELECT * FROM randomCustomer), (SELECT dbo.randomDate('1950-01-01', 20075)))

 	END;
GO

-- Insert SaleLineItems
DECLARE @saleid INT
SET @saleid = 0
WHILE @saleid < (SELECT COUNT(*) FROM Sale)
	BEGIN
	 	SET @saleid = @saleid + 1

        DECLARE @innercounter INT
        SET @innercounter = 0
        DECLARE @random INT
        SET @random = FLOOR(RAND()*((SELECT COUNT(*) FROM Product)))
        WHILE @innercounter < @random
            BEGIN
                SET @innercounter = @innercounter + 1
                INSERT INTO SaleLineItem([SaleID],[ProductID],[Quantity],[LineItemPrice]) VALUES
                    (@saleid, (SELECT dbo.randomProductSale(@saleid)), FLOOR(RAND()*(50)), ROUND(RAND()*(10), 2))
            END
 	END;
GO

-- Insert Suppliers
CREATE TABLE #TempSupplier
(
	SupplierID INT,
	SupplierName VARCHAR(250),
	PhoneNumber VARCHAR(20),
	EmailID VARCHAR(100)
)

INSERT INTO #TempSupplier([SupplierID],[SupplierName],[PhoneNumber],[EmailID]) VALUES
    (1,'Colonie Foods', '(123) 456-7890', 'coloniefoods@example.com'),
    (2,'Marks Wholesale', '(123) 456-7890', 'markswholesale@example.com'),
    (3,'Sysco', '(123) 456-7890', 'sysco@example.com'),
    (4,'Organics R Us', '(123) 456-7890', 'organicsrus@example.com'),
    (5,'Food 4 U', '(123) 456-7890', 'food4u@example.com'),
    (6,'Grub Suppliers', '(123) 456-7890', 'grubsuppliers@example.com'),
    (7,'Veggies Delivered', '(123) 456-7890', 'veggiesdelivered@example.com'),
    (8,'Butcher Boy', '(123) 456-7890', 'butcherboy@example.com'),
    (9,'Kraft', '(123) 456-7890', 'kraft@example.com'),
    (10,'General Mills', '(123) 456-7890', 'generalmills@example.com');

DECLARE @suppliercounter INT
SET @suppliercounter = 0
WHILE @suppliercounter <> 10
	BEGIN
	 	SET @suppliercounter = @suppliercounter + 1
        INSERT INTO Supplier([AddressID],[SupplierName],[PhoneNumber],[EmailID]) 
		SELECT (SELECT * FROM uniqueSupplierAddress), [SupplierName],[PhoneNumber],[EmailID] FROM #TempSupplier
		WHERE [SupplierID] = @suppliercounter;
 	END

DROP TABLE #TempSupplier

-- Insert Orders
DROP TRIGGER IF EXISTS dbo.orderTotals;
GO
CREATE TRIGGER dbo.orderTotals
	ON OrderLineItem
	FOR INSERT, UPDATE, DELETE
AS
BEGIN
	UPDATE
		o
	SET
		o.OrderTotal = i.LineItemPrice + o.OrderTotal
		FROM Inserted i JOIN [Order] o ON i.OrderID = o.OrderID
END;
GO

DECLARE @counter INT
SET @counter = 0
WHILE @counter <> 20
	BEGIN
	 	SET @counter = @counter + 1

        DECLARE @storeid INT
        SET @storeid = (SELECT * FROM randomStore)

        INSERT INTO [Order]([StoreID],[OrderDate],[SupplierID]) VALUES
            (@storeid, (SELECT dbo.randomDate('1950-01-01', 20075)), (SELECT * FROM randomSupplier))

 	END;
GO

-- Insert OrderLineItems
DECLARE @orderid INT
SET @orderid = 0
WHILE @orderid < (SELECT COUNT(*) FROM [Order])
	BEGIN
	 	SET @orderid = @orderid + 1

        DECLARE @innercounter INT
        SET @innercounter = 0
        DECLARE @random INT
        SET @random = FLOOR(RAND()*((SELECT COUNT(*) FROM Product)))
        WHILE @innercounter < @random
            BEGIN
                SET @innercounter = @innercounter + 1
                INSERT INTO OrderLineItem([OrderID],[ProductID],[Quantity],[LineItemPrice]) VALUES
                    (@orderid, (SELECT dbo.randomProductOrder(@orderid)), FLOOR(RAND()*(50)), ROUND(RAND()*(10), 2))
            END
 	END;
GO

-- Insert Shipments
DECLARE @counter INT
SET @counter = 0
WHILE @counter <> 20
	BEGIN
	 	SET @counter = @counter + 1

        DECLARE @orderid INT
        SET @orderid = (SELECT * FROM randomOrder)

        INSERT INTO Shipment([OrderID],[DeliveryDate],[TrackingNumber],[ReceivedByEmployeeID]) VALUES
            (@orderid, (SELECT dbo.randomDate('2006-01-01', 900)), CONVERT(NUMERIC(12,0),RAND()*899999999999)+100000000000, (SELECT dbo.randomOrderEmployee(@orderid)))
 	END;
GO
