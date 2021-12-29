USE [master]
GO

USE [FreightTransportationDB]
GO

--1)
--a
SELECT COUNT(*) NumberExperiencedDrivers
FROM Driver
WHERE Experience > 10
GO

SELECT Name, Surname, COUNT(*) AS NumberOfPerformedTransportations
FROM TransportationsJournal
JOIN Driver ON DriverId=FkDriverId
GROUP BY DriverId, Name, Surname
GO

SELECT TransportationId, FKRouteName AS Name, COUNT(DISTINCT FkPremiumId) AS NumberOfPremiumsOnTransportation
FROM TransportationsJournal
JOIN Transportation ON TransportationId=FkTransportationId
GROUP BY TransportationId, FkRouteName
GO


--b
SELECT FkRouteName as [Transportation route], SUM(ActualDistance) as [Kilometers traveled]
FROM Transportation
GROUP BY FkRouteName
GO

--c
SELECT UPPER(LEFT(Surname, 1)+LEFT(Name, 1)+LEFT(Patronymic, 1)) as FIO
FROM Driver
Where CategoriesOfLicences = 'A, B'
GO

SELECT LOWER(Name), PerfectDistance
FROM Route
WHERE PerfectDistance > 500
GO

SELECT Name, Surname, LOWER(CategoriesOfLicences) as CategoriesOfLicenses
FROM Driver
WHERE Experience < 8
GO


--d
SELECT Name, PerfectDistance, ABS(DateDiff(m, DateOfDispatch, DateOfArrival)) as TimeOfCompletion
FROM TransportationsJournal, Transportation, Route
WHERE FkTransportationId=TransportationId  AND FkRouteName=Name
GO

SELECT FkRouteName Name, DatePart(dw, DateOfDispatch) WeekDayOfDispatch
FROM TransportationsJournal, Transportation
WHERE FkTransportationId=TransportationId AND MONTH(DateOfDispatch)<MONTH(GETDATE())
GO

--e
SELECT CategoriesOfLicences, COUNT(*) AS [Number of drivers with these categories]
FROM Driver
GROUP BY CategoriesOfLicences
GO


--f
SELECT TransportationId, FkRouteName [Transportation route], COUNT(FkDriverId) [Drivers in transportation]
FROM TransportationsJournal
JOIN Transportation ON TransportationId=FkTransportationId
GROUP BY TransportationId, FkRouteName
GO


--g
SELECT FkRouteName as [Transportation route], SUM(ActualDistance) as [Kilometers traveled]
FROM Transportation
GROUP BY FkRouteName
HAVING SUM(ActualDistance)>1000
GO


--h
SELECT 1 AS EnoughExperiencedDriveExists, MAX(Experience) as Experience, 5 AS RequiredExperience
FROM Driver
HAVING MAX(Experience) > 40

SELECT SUM(PerfectDistance) as TotalPerfectDistance
FROM Route
HAVING SUM(PerfectDistance)>30000
GO


--i
SELECT Name, Surname, Experience
FROM Driver
ORDER BY Experience DESC
GO



--2)
--a
CREATE VIEW TransportationsInfo AS
SELECT DateOfDispatch, DateOfArrival, FkRouteName, Name as DriverName, Surname, Patronymic, Experience
FROM TransportationsJournal
JOIN Transportation ON FkTransportationId=TransportationId
JOIN Driver ON FkDriverId=DriverId
GO

DROP VIEW TransportationsInfo
GO

SELECT *
FROM TransportationsInfo
GO

--b
CREATE VIEW DriversOnRoutes AS
SELECT DriverName, Surname, Patronymic, Experience, Name as RouteName, FixedPriceInUAH
FROM TransportationsInfo
JOIN Route ON Route.Name=FkRouteName
GO

DROP VIEW DriversOnRoutes
GO

SELECT *
FROM DriversOnRoutes
GO

--c
ALTER VIEW TransportationsInfo AS
SELECT DateOfDispatch, DateOfArrival, FkRouteName, Name as DriverName, Surname, Patronymic, Experience, CategoriesOfLicences
FROM TransportationsJournal
JOIN Transportation ON FkTransportationId=TransportationId
JOIN Driver ON FkDriverId=DriverId
WHERE Experience > 2 AND CategoriesOfLicences lIKE '%A%'
GO

ALTER VIEW DriversOnRoutes AS
SELECT DriverName, Surname, Patronymic, Experience, Name as RouteName, FixedPriceInUAH
FROM TransportationsInfo
JOIN Route ON Route.Name=FkRouteName
WHERE FixedPriceInUAH > 7000
GO

--d

sp_help TransportationsInfo 
GO

sp_helptext TransportationsInfo 
GO

sp_depends TransportationsInfo
GO

sp_help DriversOnRoutes
GO

sp_helptext DriversOnRoutes
GO

sp_depends DriversOnRoutes
GO






