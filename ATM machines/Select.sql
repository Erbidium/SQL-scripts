USE [master]
GO

USE [ATMMachines]
GO

--a
SELECT Name, Surname, Patronymic
FROM Owner
JOIN Account ON OwnerId=FkOwnerId
JOIN Transactions ON AccountId=FkAccountId
JOIN ATM ON ATMId=FkATMId
WHERE DATEDIFF(y, GETDATE(), TimeOfCompletion)=1 AND PlacementRegion='Podol' AND TypeOfOperation = 'withdrawal'
ORDER BY MoneyDiffInUAH
--b
SELECT TOP 1 PlacementRegion
FROM(SELECT PlacementRegion, SUM(MoneyDiffInUAH) as TransactionsSum
FROM Owner
JOIN Account ON OwnerId=FkOwnerId
JOIN Transactions ON AccountId=FkAccountId
JOIN ATM ON ATMId=FkATMId
GROUP BY PlacementRegion) tab
WHERE TransactionsSum>(SELECT AVG(MoneyDiffInUAH) FROM Owner
JOIN Account ON OwnerId=FkOwnerId
JOIN Transactions ON AccountId=FkAccountId
JOIN ATM ON ATMId=FkATMId)
--c
SELECT OwnerId, Name, Surname, Patronymic, PhoneNumber
FROM Owner
JOIN Account ON OwnerId=FkOwnerId
JOIN Transactions ON AccountId=FkAccountId
JOIN ATM ON ATMId=FkATMId
WHERE AmountOfMoneyInUAH<10

--d
SELECT PlacementRegion
FROM ATM
WHERE ATMId=(
SELECT TOP 1 ATMId
FROM Owner
JOIN Account ON OwnerId=FkOwnerId
JOIN Transactions ON AccountId=FkAccountId
JOIN ATM ON ATMId=FkATMId
GROUP BY ATMId
ORDER BY COUNT(ATMId) DESC)
--e
SELECT *
FROM OWNER
WHERE EXISTS(SELECT * FROM Owner, Account, Transactions
WHERE OwnerId=FkOwnerId AND AccountId=FkAccountId AND DATEDIFF(mm, GETDATE(), TimeOfCompletion)>1)