USE[GROCERY_STORE_INVENTORY_MANAGEMENT];
GO

--DROP KEYS AND CERTS
IF EXISTS( SELECT COUNT(*) FROM sys.symmetric_keys WHERE name = 'SymKey_test')
	DROP SYMMETRIC KEY SymKey_test;
IF EXISTS( SELECT COUNT(*) FROM sys.certificates WHERE name = 'Certificate_test')
	DROP CERTIFICATE Certificate_test;
IF EXISTS( SELECT COUNT(*) FROM sys.symmetric_keys WHERE name = 'SymKey_test')
	DROP MASTER KEY;

--CREATE MASTER KEY
CREATE MASTER KEY ENCRYPTION BY PASSWORD='12345678';
GO

SELECT name KeyName, 
	symmetric_key_id KeyID,
	Key_length KeyLength,
	algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

-- CREATE CERTIFICATE
CREATE CERTIFICATE Certificate_test WITH SUBJECT = 'Protect my data';
GO

SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;

--CREATE SYMMETRIC KEY
CREATE SYMMETRIC KEY SymKey_test WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Certificate_test;
GO

SELECT name KeyName, 
	symmetric_key_id KeyID,
	Key_length KeyLength,
	algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

IF COL_LENGTH('Employee', 'SSN_encrypt') IS NOT NULL
	ALTER TABLE [GROCERY_STORE_INVENTORY_MANAGEMENT].[dbo].[Employee] DROP COLUMN SSN_encrypt;
GO

ALTER TABLE [GROCERY_STORE_INVENTORY_MANAGEMENT].[dbo].[Employee] ADD SSN_encrypt varbinary(MAX);

--ENCRYPT SSN COLUMN
OPEN SYMMETRIC KEY SymKey_test
	DECRYPTION BY CERTIFICATE Certificate_test;
GO

UPDATE [GROCERY_STORE_INVENTORY_MANAGEMENT].[dbo].[Employee]
		SET SSN_encrypt = EncryptByKey (Key_GUID('SymKey_test'), SSN)
        FROM [GROCERY_STORE_INVENTORY_MANAGEMENT].[dbo].[Employee];
GO		

CLOSE SYMMETRIC KEY SymKey_test;
GO

SELECT * FROM [dbo].[Employee];

--DECRYPT SSN COLUMN
OPEN SYMMETRIC KEY SymKey_test
	DECRYPTION BY CERTIFICATE Certificate_test;

SELECT EmployeeID, Passcode, SSN_encrypt AS 'Encrypted SSN',
CONVERT(varchar, DecryptByKey(SSN_encrypt)) AS 'Decrypted SSN'
FROM [dbo].[Employee];




