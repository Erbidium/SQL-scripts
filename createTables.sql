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
	CategoriesOfLicences varchar(50) NOT NULL,
	FkPremiumId INT NULL,
	FkPaymentId INT NOT NULL
)
GO

CREATE TABLE Route(
	Name nvarchar(50) NOT NULL PRIMARY KEY,
	PerfectDistance int NOT NULL
	CONSTRAINT "CK_Route_Perfect_Distance" CHECK (PerfectDistance>=0)
	CONSTRAINT "DF_Route_Perfect_Distance" DEFAULT(0),
	FkTransportationId INT NOT NULL,
	FkPaymentId INT UNIQUE NOT NULL
)
GO

CREATE TABLE Transportation(
	TransportationId int IDENTITY(1,1) PRIMARY KEY,
	DateOfDispatch date NOT NULL,
	DateOfArrival date NOT NULL,
	ActualDistance int NOT NULL 
	CONSTRAINT "CK_Transportation_Actual_Distance" CHECK(ActualDistance>=0)
	CONSTRAINT "DF_Transportation_Actual_Distance" DEFAULT(0),
	FkDriverId INT NOT NULL,
	FkPremiumId INT NULL
)
GO

CREATE TABLE Premium(
	PremiumId int IDENTITY(1,1) PRIMARY KEY,
	AmountInUAH money NOT NULL
	CONSTRAINT "CK_Premium_AmountInUAH" CHECK(AmountInUAH>=0)
	CONSTRAINT "DF_Premium_AmountInUAH" DEFAULT(0)
)
GO

CREATE TABLE Payment(
	PaymentId int IDENTITY(1,1) PRIMARY KEY,
	FixedPriceInUAH money NOT NULL
	CONSTRAINT "CK_Payment_FixedPriceInUAH" CHECK(FixedPriceInUAH>=0)
	CONSTRAINT "DF_Payment_FixedPriceInUAH" DEFAULT(0)
)
GO