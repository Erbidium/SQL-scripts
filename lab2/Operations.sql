USE [master]
GO

USE [FreightTransportationDB]
GO

DELETE FROM TransportationsJournal WHERE FkDriverId=1
GO

DELETE FROM Route WHERE Name='Montijo - Montijo'
GO

ALTER TABLE Driver
DROP COLUMN Name
GO

ALTER TABLE Transportation
DROP COLUMN DateOfDispatch
GO

ALTER TABLE Driver
ADD Email nvarchar(50)
GO

ALTER TABLE Transportation
ADD NumberOfVisitedCities smallint
GO

UPDATE Driver
SET Surname='Freeman'
GO

UPDATE Driver
SET Patronymic='Johnson'
WHERE Experience>4
GO

ALTER TABLE Driver
ALTER COLUMN Patronymic nvarchar(50) NULL
GO

ALTER TABLE Driver
ADD CONSTRAINT Driver_Patronymic_Default
DEFAULT 'Billy' FOR Patronymic
GO

ALTER TABLE Driver
DROP CONSTRAINT Driver_Patronymic_Default
GO