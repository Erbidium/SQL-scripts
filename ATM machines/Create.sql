USE [master]
GO

USE [ATMMachines]
GO

CREATE TABLE ATM(
	ATMId int IDENTITY(1,1) PRIMARY KEY,
	PlacementRegion nvarchar(50) NOT NULL,
)
GO

CREATE TABLE Owner(
	OwnerId int IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(50) NOT NULL,
	Surname nvarchar(50) NOT NULL,
	Patronymic nvarchar(50) NULL,
	PhoneNumber varchar(50) NOT NULL
)
GO

CREATE TABLE Account(
	AccountId int IDENTITY(1,1) PRIMARY KEY,
	FkOwnerId INT NOT NULL FOREIGN KEY REFERENCES Owner(OwnerId),
	AmountOfMoneyInUAH money NOT NULL
	CONSTRAINT "CK_Accounts_AmountOfMoneyInUAH" CHECK(AmountOfMoneyInUAH>=0)
	CONSTRAINT "DF_Accounts_AmountOfMoneyInUAH" DEFAULT(0),
)
GO

CREATE TABLE Transactions(
	FkATMId int NOT NULL FOREIGN KEY REFERENCES ATM(ATMId),
	FkAccountId INT NOT NULL FOREIGN KEY REFERENCES Account(AccountId),
	TimeOfCompletion DateTime NOT NULL,
	TypeOfOperation nvarchar(50) NOT NULL,
	MoneyDiffInUAH money NOT NULL
	CONSTRAINT CompKey_Transactions PRIMARY KEY (FkATMId, FkAccountId, TimeOfCompletion )
)
GO