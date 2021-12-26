USE [FreightTransportationDB]
GO

--a
CREATE FUNCTION TransportationRoute (@id int)
RETURNS nvarchar(50)
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @RouteName nvarchar(50)
	SELECT @RouteName=FkRouteName FROM Transportation
	WHERE @id=TransportationId

	return (@RouteName)
END

SELECT dbo.TransportationRoute(5)

--b
CREATE FUNCTION GetTransportationInfo(@id int)
RETURNS TABLE
AS
RETURN( SELECT TransportationId, Route.Name, Driver.Name [Driver name], Driver.Experience, CategoriesOfLicences, AmountInUAH [Premium in UAH], Route.PerfectDistance, Route.FixedPriceInUAH
FROM TransportationsJournal
JOIN Transportation ON FkTransportationId=TransportationId
JOIN Driver ON FkDriverId = DriverId
JOIN Route ON Route.Name=FkRouteName
LEFT JOIN Premium ON PremiumId=FkPremiumId
WHERE TransportationId = @id)

SELECT * FROM GetTransportationInfo(5)

--c
CREATE FUNCTION GetDriverRoutes(@id int)
RETURNS @DriverRoutes TABLE ( [Driver name] nvarchar(50), [Route name] nvarchar(50), AmountInUAH money)
AS
BEGIN
	INSERT INTO @DriverRoutes SELECT Driver.Name, Route.Name, AmountInUAH
								FROM Driver
								JOIN TransportationsJournal ON DriverId=FkDriverId
								JOIN Transportation ON TransportationId=FkTransportationId
								JOIN Route ON FkRouteName=Route.Name
								LEFT JOIN Premium ON FkPremiumId=PremiumId
	RETURN
END

SELECT * FROM GetDriverRoutes(4)
