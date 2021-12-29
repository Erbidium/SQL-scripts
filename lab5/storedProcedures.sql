USE [FreightTransportationDB]
GO

--a
CREATE TYPE TempTable AS TABLE(Name nvarchar(50), PerfectDistance int, FixedPriceInUAH money)

CREATE PROCEDURE InsertRoutes @tempRoutes TempTable readonly
AS
INSERT INTO Route(Name, PerfectDistance, FixedPriceInUAH)
SELECT Name, PerfectDistance, FixedPriceInUAH
FROM @tempRoutes


DECLARE @temp AS TempTable

INSERT INTO @temp(Name, PerfectDistance, FixedPriceInUAH)
VALUES
('Kyiv - Lviv', 541, 4000),
('Odessa - Lviv', 442, 10000),
('Kyiv - Los-Santos', 50, 600),
('Shepetivka - Lviv', 300, 3000)


SELECT * FROM @temp

EXEC InsertRoutes @temp

SELECT * FROM Route


--b
CREATE PROCEDURE ShowIfTransportationHasPremium @TransportationId int
AS
BEGIN
	DECLARE @PremiumId int
	SET @PremiumId = (SELECT FkPremiumId
	FROM Transportation
	WHERE TransportationId = @TransportationId)
	IF @PremiumId IS NOT NULL
		SELECT AmountInUAH [Premium amount in UAH] FROM Premium WHERE PremiumId=@PremiumId
	ELSE
		SELECT 'Premium is not found' [Premium amount in UAH]
END

EXEC ShowIfTransportationHasPremium 6

SELECT * FROM Transportation

DROP PROCEDURE ShowIfTransportationHasPremium

--ñ
CREATE PROCEDURE showDriversWithAllCategories
AS
BEGIN
DECLARE @id int = 0
DECLARE @DriversNumber int = (SELECT COUNT(*) FROM Driver)

WHILE @id<@DriversNumber
BEGIN
DECLARE @FittingDrivers TABLE(DriverId int, Name nvarchar(50), Surname nvarchar(50), Patronymic nvarchar(50), Experience int, CategoriesOfLicences nvarchar(50))
IF 'A, B, C' = (SELECT CategoriesOfLicences FROM Driver WHERE DriverId = @id)
	INSERT INTO @FittingDrivers SELECT * FROM Driver WHERE DriverId=@id
	SET @id = @id + 1
END
SELECT * FROM @FittingDrivers
END

SELECT * FROM Driver

EXEC showDriversWithAllCategories

DROP PROCEDURE showDriversWithAllCategories

--d
CREATE PROCEDURE SelectRoutesWithPriceInRange
AS
BEGIN
	SELECT Name, FixedPriceInUAH
	FROM Route
	WHERE FixedPriceInUAH BETWEEN 4000 AND 7000
END

EXEC SelectRoutesWithPriceInRange

--e
CREATE PROCEDURE SelectEnoughExperiencedDrivers
@RequiredExperience int
AS
BEGIN
	SELECT *
	FROM Driver
	WHERE Experience>@RequiredExperience
END

EXEC SelectEnoughExperiencedDrivers 10

--f
CREATE PROCEDURE GetNumberOfDriversWhoHasCategory @Categories nvarchar(50)
AS
BEGIN
DECLARE @DriversNumber int
SET @DriversNumber=(SELECT COUNT(*) FROM Driver WHERE CategoriesOfLicences=@Categories)
RETURN @DriversNumber
END

DECLARE @Number int
EXEC @Number = GetNumberOfDriversWhoHasCategory 'A, B'

SELECT @Number [Number of drivers, who has categories A, B]

--g
CREATE PROCEDURE UpdateRoutePrice @RouteName nvarchar(50), @NewPriceInUAH money
AS
BEGIN
	UPDATE Route SET FixedPriceInUAH=@NewPriceInUAH WHERE Name=@RouteName
END

EXEC UpdateRoutePrice 'Baiyang - Baiyang', 5000

SELECT * FROM Route

--h
CREATE PROCEDURE selectDriversAndRoutesOfTransportations
AS
BEGIN
	SELECT TransportationId, Name, Surname, FkRouteName RouteName
	FROM TransportationsJournal
	JOIN Transportation ON FkTransportationId=TransportationId
	JOIN Driver ON FkDriverId = DriverId
END

EXEC selectDriversAndRoutesOfTransportations


