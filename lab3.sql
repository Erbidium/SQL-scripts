USE [master]
GO

USE [FreightTransportationDB]
GO

--1) Створити запити для вибірки даних з використанням (разом 15 запитів):
--a. Найпростіших умов
SELECT *
FROM Driver
WHERE CategoriesOfLicences='A, B, C'
ORDER BY Experience
GO

SELECT *
FROM Transportation
WHERE FkPremiumId = 1
GO

--b. Операторів порівняння
SELECT Name, PerfectDistance Distance
FROM Route
WHERE PerfectDistance > 1000
ORDER BY PerfectDistance DESC
GO

SELECT *
FROM Premium
WHERE PremiumId >=5
GO

--c. Умов з використанням логічних операторів AND, OR та NOT.
SELECT Surname, Experience
FROM Driver
WHERE Experience > 5 AND Experience <= 15
GO

SELECT *
FROM Route
WHERE FixedPriceInUAH >8000 OR FixedPriceInUAH < 4000
GO

--d. Умов з використанням комбінацій логічних операторів
SELECT *
FROM Driver
WHERE NOT Experience = 3 AND (EXPERIENCE <5 OR EXPERIENCE >10)
GO

SELECT Name
FROM Driver
WHERE Name = 'Parry' OR Name = 'Lennie'
GO

--e. З використанням виразів над стовпцями, як в якості новостворених стовпців, так і умовах
SELECT TRIM(Name) + ' ' + TRIM(Surname) + ' ' + TRIM(Patronymic) as FIO, Experience
from Driver where (Experience * 2 > 6)
GO

SELECT Name, Experience * 2 as [Doubled experience]
FROM Driver
WHERE DriverId < Experience
GO

SELECT Name, ABS(PerfectDistance - ActualDistance) [Distance difference]
FROM Route, Transportation
GO

--f. Використання операторів:
--i. Приналежності множині
SELECT *
FROM Driver
WHERE Name IN ('Teador', 'Kelcie', 'Trefor', 'Flem')
GO

SELECT *
FROM Route
WHERE Name NOT IN ('Macon - Macon', 'Shangdu - Shangdu', 'Borovany - Borovany')
GO

--ii. Приналежності діапазону
SELECT *
FROM Route
WHERE FixedPriceInUAH BETWEEN 4000 AND 7000
GO

SELECT *
FROM Transportation
WHERE ActualDistance NOT BETWEEN 300 AND 1500
GO

--iii. Відповідності шаблону
SELECT Name
FROM Driver
Where Name LIKE '%Randy'
GO

--iv. Відповідності регулярному виразу
SELECT Name
FROM Driver
WHERE Name LIKE '[A-Z]%a%[n|y]'
GO

--v. Перевірка на невизначене значення
SELECT FkRouteName as [Route name]
FROM Transportation
WHERE FkPremiumId IS NULL
GO

SELECT *
FROM Transportation
WHERE FkPremiumId IS NOT NULL AND DateOfDispatch>'2014-08-01'
GO

--2) Створити запити з використанням підзапитів та з’єднань (разом 15
--запитів) (в запити повинні реалізовуватись до 3 та більше таблиць):
--a. Використання підзапитів в рядку вибірки полів та вибірки з таблиць
SELECT tab.Name AS [Route name]
FROM (SELECT Name, ActualDistance FROM Route, Transportation WHERE Route.PerfectDistance>400 AND FkRouteName=Route.Name ) tab
WHERE ActualDistance > 500
GO

SELECT (Select TOP(1) Name FROM Driver wHERE Experience>4 order by Experience) as [Best driver], (SELECT MAX(AmountInUAH) FROM Premium) as [Max premium],
(SELECT AVG(PerfectDistance) FROM Route) as [Average distance of route]
GO

--b. Використання підзапитів в умовах з конструкціями EXISTS, IN
SELECT Name, Surname, Patronymic
FROM Driver
WHERE EXISTS
(SELECT FkTransportationId FROM TransportationsJournal WHERE DriverId=FkDriverId)
GO

SELECT *
FROM Premium
WHERE Premium.PremiumId IN (SELECT PremiumId FROM Transportation JOIN Premium ON PremiumId=FkPremiumId)
GO

--c. Декартовий добуток
SELECT Driver.Name [Driver name], Route.Name [Route name], AmountInUAH
FROM Driver, Route, Premium
GO

SELECT DateOfDispatch, FkRouteName as RouteName, Driver.Name
FROM Transportation
CROSS JOIN Route
CROSS JOIN Driver
GO

--d. З’єднання декількох таблиць (більше 2) за рівністю
SELECT TransportationId, Name, Surname, FkRouteName RouteName
FROM TransportationsJournal, Transportation, Driver
WHERE FkTransportationId=TransportationId AND FkDriverId = DriverId
GO

SELECT *
FROM TransportationsJournal, Transportation, Driver, Route, Premium
WHERE FkTransportationId=TransportationId AND FkDriverId = DriverId AND Route.Name=FkRouteName AND PremiumId=FkPremiumId
GO

--e. З’єднання декількох таблиць (більше 2) за рівністю та умовою
--відбору
SELECT DateOfArrival, ActualDistance, Driver.Name [Driver name], Experience
FROM TransportationsJournal, Transportation, Driver, Route, Premium
WHERE (ActualDistance>400 OR Experience>1) AND FkTransportationId=TransportationId AND FkDriverId = DriverId AND Route.Name=FkRouteName AND PremiumId=FkPremiumId
GO

--f. Внутрішнього з’єднання
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

--g. Лівого зовнішнього з’єднання
SELECT DateOfDispatch, AmountInUAH
FROM TransportationsJournal
JOIN Transportation ON FkTransportationId=TransportationId
LEFT JOIN Premium ON PremiumId=FkPremiumId
GO

SELECT Name Surname, FkTransportationId TransportationId
FROM Driver
lEFT JOIN TransportationsJournal ON DriverId=FkDriverId
GO

--h. Правого зовнішнього з’єднання
SELECT TransportationId, Name, Surname, FkRouteName RouteName
FROM TransportationsJournal
INNER JOIN Transportation ON FkTransportationId=TransportationId
RIGHT JOIN Driver ON FkDriverId = DriverId
GO

--i. Об’єднання таблиць
SELECT Name, PerfectDistance Number
FROM Route
UNION
SELECT Name, Experience Number
FROM Driver
UNION
SELECT FkRouteName Name, ActualDistance Number
FROM Transportation
GO