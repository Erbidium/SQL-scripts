USE [master]
GO

USE [FreightTransportationDB]
GO

INSERT INTO
Driver (Name, Surname, Patronymic, Experience, CategoriesOfLicences)
VALUES
('Filippo', 'Yellowlees', 'Raccio', 1, 'A, B, C'),
('Clarance', 'Fontelles', 'Javes', 2, 'A, B'),
('Shaylynn', 'Durtnall', 'Lacroix', 3, 'A'),
('Teador', 'Ilsley', 'Kinningley', 4, 'A, C'),
('Parry', 'Sywell', 'Powlesland', 5, 'A'),
('Mellie', 'Mc Gorley', 'McHarry', 6, 'B, C'),
('Ellette', 'Barnewelle', 'Vertigan', 7, 'A, B'),
('Karina', 'Byforth', 'Goroni', 8, 'A'),
('Willi', 'Grosvener', 'Sullly', 9, 'A, B, C'),
('Kelcie', 'Goodburn', 'Santostefano.', 10, 'B'),
('Tillie', 'Geertsen', 'McCard', 11, 'C'),
('Lloyd', 'Minguet', 'Buller', 12, 'A'),
('Gregoire', 'Peeke-Vout', 'Gerriets', 13, 'A, B, C'),
('Jonis', 'Hannabuss', 'Mayberry', 14, 'A'),
('Trefor', 'Fearnehough', 'Plesing', 15, 'A, B'),
('Lennie', 'Dewfall', 'McDougall', 16, 'A'),
('Percival', 'De Maine', 'Doore', 17, 'A, C'),
('Shanan', 'Sawday', 'Stammler', 18, 'C, B'),
('Eamon', 'Teale', 'McDell', 19, 'A, C'),
('Lissa', 'Kingzett', 'Klausewitz', 0, 'A'),
('Flem', 'Anan', 'Pryde', 1, 'B'),
('Margret', 'Camus', 'Sharpin', 2, 'A'),
('Berk', 'Rustidge', 'Waiting', 3, 'A'),
('Rosita', 'Dablin', 'Blaszczynski', 4, 'C'),
('Chet', 'Ragat', 'Grigsby', 5, 'A'),
('Siana', 'Nitti', 'Feeny', 6, 'A'),
('Chrystel', 'Ford', 'Treadger', 7, 'B'),
('Herc', 'Gabbotts', 'Adney', 8, 'A'),
('Randy', 'Briggs', 'Crandon', 9, 'A'),
('Roddy', 'McCaughen', 'Mattes', 10, 'A')
GO

INSERT INTO
Premium (AmountInUAH)
VALUES
(574),
(1753),
(1757),
(215),
(1254),
(1130),
(902),
(1402)
GO

INSERT INTO
Route (Name, PerfectDistance, FixedPriceInUAH)
VALUES
('Baiyang - Baiyang', 1863, 9813),
('Kalashnikovo - Kalashnikovo', 250, 8268),
('Borovany - Borovany', 3870, 2153),
('Yueyang - Yueyang', 581, 7344),
('Dębowiec - Dębowiec', 810, 6034),
('Крива Паланка - Крива Паланка', 1132, 4443),
('Metz - Metz', 2440, 3500),
('Shangdu - Shangdu', 845, 3730),
('Jönköping - Jönköping', 753, 2802),
('Sumberbening - Sumberbening', 3047, 9220),
('Ngangpo - Ngangpo', 1567, 2391),
('Louisville - Louisville', 1370, 3261),
('Sihe - Sihe', 1663, 9716),
('Montijo - Montijo', 3423, 9335),
('Mataya - Mataya', 1429, 9016),
('Tula - Tula', 3611, 1651),
('Suncun - Suncun', 3798, 1693),
('Cogon - Cogon', 621, 6170),
('Guangdu - Guangdu', 3976, 5262),
('Vamvakoú - Vamvakoú', 689, 3413),
('Fuyong - Fuyong', 983, 9848),
('Bradford - Bradford', 2384, 1449),
('Buzet - Buzet', 1632, 6351),
('Mâcon - Mâcon', 758, 5055),
('Sausa - Sausa', 879, 209),
('Washington - Washington', 73, 3359),
('Chalcos - Chalcos', 441, 1876),
('Ipoti - Ipoti', 2595, 7308),
('Valejas - Valejas', 2001, 9366),
('Demerval Lobão - Demerval Lobão', 3389, 4148)
GO

INSERT INTO
Transportation (DateOfDispatch, DateOfArrival, ActualDistance, FkRouteName, FkPremiumId)
VALUES
('2014-08-01', '2014-10-02', 536, 'Baiyang - Baiyang', 1),
('2018-10-05', '2014-10-08', 2043, 'Baiyang - Baiyang', NULL),
('2013-03-07', '2018-02-16', 2249, 'Baiyang - Baiyang', 2),
('2020-02-22', '2017-02-12', 459, 'Baiyang - Baiyang', 4),
('2019-04-11', '2015-10-14', 1131, 'Baiyang - Baiyang', NULL),
('2013-04-04', '2019-07-17', 2453, 'Baiyang - Baiyang', 6),
('2015-01-22', '2014-05-26', 20, 'Baiyang - Baiyang', 7),
('2014-06-03', '2013-01-01', 984, 'Baiyang - Baiyang', 8)
GO

INSERT INTO
TransportationsJournal (FkTransportationId, FkDriverId)
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(5, 6),
(7, 8)
GO