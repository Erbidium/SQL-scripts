USE [master]
GO

USE [FreightTransportationDB]
GO

DROP TABLE Route
GO

DROP TABLE Transportation
GO

DROP TABLE Driver
GO

DROP TABLE Premium
GO

DROP TABLE Payment
GO


ALTER TABLE Driver
DROP CONSTRAINT Fk_Driver_Premium_Id
GO

ALTER TABLE Driver
DROP CONSTRAINT Fk_Driver_Payment_Id

GO


ALTER TABLE Transportation
DROP CONSTRAINT Fk_Transportation_Driver_Id
GO

ALTER TABLE Transportation
DROP CONSTRAINT Fk_Transportation_Premium_Id
GO


ALTER TABLE Route
DROP CONSTRAINT Fk_Route_Transportation_id
GO

ALTER TABLE Route
DROP CONSTRAINT Fk_Route_Payment_Id
GO
