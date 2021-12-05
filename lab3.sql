USE [master]
GO

USE [FreightTransportationDB]
GO

-- simple conditions
SELECT *
FROM Driver
WHERE CategoriesOfLicences='A, B, C'
ORDER BY Experience
GO

SELECT *
FROM Transportation
WHERE FkPremiumId = 1
GO

-- comparison operators
SELECT Name, PerfectDistance Distance
FROM Route
WHERE PerfectDistance > 1000
ORDER BY PerfectDistance DESC
GO

SELECT *
FROM Premium
WHERE AmountInUAH >=1000
GO

--c. conditions with logical operators AND, OR, NOT
SELECT Surname, Experience
FROM Driver
WHERE Experience > 5 AND Experience <= 15
GO

SELECT *
FROM Route
WHERE FixedPriceInUAH >8000 OR FixedPriceInUAH < 4000
GO

--d. conditions with combinations of logical operators
SELECT *
FROM Driver
WHERE NOT Experience = 3 AND (EXPERIENCE <5 OR EXPERIENCE >10) AND CategoriesOfLicences='A, B'
GO

SELECT *
FROM Driver
WHERE Name = 'Parry' OR Name = 'Lennie'
GO

--e. Using expressions over columns, both as newly created columns and conditions
SELECT TRIM(Name) + ' ' + TRIM(Surname) + ' ' + TRIM(Patronymic) as FIO, Experience
from Driver where (Experience * 2 > 6)
GO

SELECT Name, Experience * 2 as [Doubled experience]
FROM Driver
WHERE Experience > 5
GO

SELECT Name, ABS(PerfectDistance - ActualDistance) [Distance difference]
FROM Route, Transportation
WHERE Route.Name=Transportation.FkRouteName
GO

--f. Use of operators:
--i. Belonging to set
SELECT *
FROM Driver
WHERE Name IN ('Teador', 'Kelcie', 'Trefor', 'Flem')
GO

SELECT *
FROM Route
WHERE Name NOT IN ('Macon - Macon', 'Shangdu - Shangdu', 'Borovany - Borovany')
GO

--ii. Belonging to range
SELECT Name, FixedPriceInUAH
FROM Route
WHERE FixedPriceInUAH BETWEEN 4000 AND 7000
GO

SELECT *
FROM Transportation
WHERE ActualDistance NOT BETWEEN 300 AND 1500
GO

--iii. Mathcing template
SELECT Name
FROM Driver
Where Name LIKE '%Randy'
GO

--iv. Matching regular expression
SELECT Name
FROM Driver
WHERE Name LIKE '[A-Z]%a%[n|y]'
GO

--v. Checking on NULL
SELECT FkRouteName as [Route name]
FROM Transportation
WHERE FkPremiumId IS NULL
GO

SELECT *
FROM Transportation
WHERE FkPremiumId IS NOT NULL AND DateOfDispatch>'2014-08-01'
GO

--2) Create queries using subqueries and connections (15 queries in total) (up to 3 or more tables must be implemented in queries):
--a. Use subqueries in the field of selection fields and selection from tables
SELECT tab.Name AS [Route name]
FROM (SELECT Name, ActualDistance FROM Route, Transportation WHERE Route.PerfectDistance>400 AND FkRouteName=Route.Name ) tab
WHERE ActualDistance > 500
GO

SELECT DateOfArrival, (SELECT Name FROM Route WHERE FkRouteName=Name) as [Route Name]
FROM Transportation
WHERE DateOfArrival>'2014-05-26'


--b. Use of subqueries in conditions with EXISTS, IN
SELECT Name, Surname, Patronymic
FROM Driver
WHERE EXISTS
(SELECT FkTransportationId FROM TransportationsJournal WHERE DriverId=FkDriverId)
GO

SELECT *
FROM Premium
WHERE PremiumId in(SELECT FkPremiumId FROM Transportation WHERE FkPremiumId IS NOT NULL)
GO

--c. Cartesian product
SELECT Driver.Name [Driver name], Route.Name [Route name], AmountInUAH
FROM Driver, Route, Premium
GO

SELECT DateOfDispatch, FkRouteName as RouteName, Driver.Name
FROM Transportation
CROSS JOIN Route
CROSS JOIN Driver
GO

--d. Connection of several tables (more than 2) according to equality
SELECT TransportationId, Name, Surname, FkRouteName RouteName
FROM TransportationsJournal, Transportation, Driver
WHERE FkTransportationId=TransportationId AND FkDriverId = DriverId
GO

SELECT *
FROM TransportationsJournal, Transportation, Driver, Route, Premium
WHERE FkTransportationId=TransportationId AND FkDriverId = DriverId AND Route.Name=FkRouteName AND PremiumId=FkPremiumId
GO

--e. Connection of several tables (more than 2) according to equality and selection condition
SELECT DateOfArrival, ActualDistance, Driver.Name [Driver name], Experience
FROM TransportationsJournal, Transportation, Driver, Route, Premium
WHERE (ActualDistance>400 OR Experience>1) AND FkTransportationId=TransportationId AND FkDriverId = DriverId AND Route.Name=FkRouteName AND PremiumId=FkPremiumId
GO

--f. inner join
SELECT TransportationId, Name, Surname, FkRouteName RouteName
FROM TransportationsJournal
INNER JOIN Transportation ON FkTransportationId=TransportationId
INNER JOIN Driver ON FkDriverId = DriverId
GO

SELECT *
FROM TransportationsJournal
JOIN Transportation ON FkTransportationId=TransportationId
JOIN Driver ON FkDriverId = DriverId
JOIN Route ON Route.Name=FkRouteName
JOIN Premium ON PremiumId=FkPremiumId
GO

--g. left outer join
SELECT DateOfDispatch, AmountInUAH, FkDriverId as DriverId
FROM TransportationsJournal
JOIN Transportation ON FkTransportationId=TransportationId
LEFT JOIN Premium ON PremiumId=FkPremiumId
GO

SELECT Name, Surname, FkRouteName as Route
FROM Driver
LEFT JOIN TransportationsJournal ON DriverId=FkDriverId
LEFT JOIN Transportation ON TransportationId=FkTransportationId
GO

--h. right outer join
SELECT Name, Surname, TransportationId, FkRouteName RouteName
FROM TransportationsJournal
INNER JOIN Transportation ON FkTransportationId=TransportationId
RIGHT JOIN Driver ON FkDriverId = DriverId
GO

--i. tables union
SELECT Name, PerfectDistance Number
FROM Route
UNION
SELECT Name, Experience Number
FROM Driver
UNION
SELECT FkRouteName Name, ActualDistance Number
FROM Transportation
GO