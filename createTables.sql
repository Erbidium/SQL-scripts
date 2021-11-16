USE [master]
GO

USE [FreightTransportationDB]
GO

CREATE TABLE Driver(
	DriverId int IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(50) NOT NULL,
	Surname nvarchar(50) NOT NULL,
	Patronymic nvarchar(50) NULL,
	Experience smallint NOT NULL
	CONSTRAINT "CK_Driver_Experience" CHECK (Experience>=0)
	CONSTRAINT "DF_Driver_Experience" DEFAULT(0),
	CategoriesOfLicences varchar(50) NOT NULL
)
GO

DROP TABLE Driver
GO



CREATE TABLE Route(
	Name nvarchar(50) NOT NULL PRIMARY KEY,
	PerfectDistance int NOT NULL
	CONSTRAINT "CK_Route_Perfect_Distance" CHECK (PerfectDistance>=0)
	CONSTRAINT "DF_Route_Perfect_Distance" DEFAULT(0),
	FixedPriceInUAH money NOT NULL
	CONSTRAINT "CK_Payment_FixedPriceInUAH" CHECK(FixedPriceInUAH>=0)
	CONSTRAINT "DF_Payment_FixedPriceInUAH" DEFAULT(0),
)
GO

DROP TABLE Route
GO



CREATE TABLE Transportation(
	TransportationId int IDENTITY(1,1) PRIMARY KEY,
	DateOfDispatch date NOT NULL,
	DateOfArrival date NOT NULL,
	ActualDistance int NOT NULL 
	CONSTRAINT "CK_Transportation_Actual_Distance" CHECK(ActualDistance>=0)
	CONSTRAINT "DF_Transportation_Actual_Distance" DEFAULT(0),
	FkRouteName nvarchar(50) NOT NULL FOREIGN KEY REFERENCES Route(Name)
)
GO

DROP TABLE Transportation
GO


CREATE TABLE TransportationsJournal(
	TransportationFieldId int IDENTITY(1,1) PRIMARY KEY,
	TransportationId int NOT NULL FOREIGN KEY REFERENCES Transportation(TransportationId),
	FkDriverId INT NOT NULL FOREIGN KEY REFERENCES Driver(DriverId),
	FkPremiumId INT NULL FOREIGN KEY REFERENCES Premium(PremiumId)
)
GO

DROP TABLE TransportationsJournal
GO

CREATE TABLE Premium(
	PremiumId int IDENTITY(1,1) PRIMARY KEY,
	AmountInUAH money NOT NULL
	CONSTRAINT "CK_Premium_AmountInUAH" CHECK(AmountInUAH>=0)
	CONSTRAINT "DF_Premium_AmountInUAH" DEFAULT(0)
)
GO

DROP TABLE Premium
GO