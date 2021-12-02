USE [master]
GO

USE [ATMMachines]
GO

insert into Account (FkOwnerId, AmountOfMoneyInUAH) 
values
('1', '100'),
('1', '300'),
('2', '0'),
('3', '10'),
('4', '500'),
('5', '200'),
('6', '550'),
('7', '100'),
('8', '100'),
('8', '10'),
('9', '0'),
('10', '100'),
('11', '0'),
('12', '300'),
('13', '900'),
('14', '700'),
('15', '600')
GO

insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (1, 10, '20210124 13:03:06', 'withdrawal', -55);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (2, 7, '20210404 08:01:07', 'moneyput', 374);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (3, 7, '20210109 20:16:47', 'withdrawal', -81);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (4, 6, '20210919 12:55:00', 'moneyput', 302);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (5, 8, '20210819 13:12:34', 'withdrawal', -82);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (6, 9, '20201202 02:52:39', 'moneyput', 440);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (7, 1, '20210226 04:18:46', 'withdrawal', -259);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (8, 2, '20210709 09:18:57', 'moneyput', 438);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (9, 3, '20210915 19:43:09', 'withdrawal', -116);
insert into Transactions (FkATMId, FkAccountId, TimeOfCompletion, TypeOfOperation, MoneyDiffInUAH) values (10, 4, '20201225 21:35:16', 'moneyput', 142);
GO