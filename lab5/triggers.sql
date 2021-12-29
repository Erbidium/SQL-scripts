USE [FreightTransportationDB]
GO

CREATE TRIGGER OnInsertTransportation
ON Transportation
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @DateOfDispatch date
	DECLARE @DateOfArrival date
	DECLARE @ActualDistance int
	DECLARE @FkRouteName nvarchar(50)
	DECLARE @FkPremiumId int

	DECLARE curs CURSOR LOCAL FOR
		SELECT DateOfDispatch, DateOfArrival, ActualDistance, FkRouteName, FkPremiumId FROM inserted
	OPEN curs
	FETCH NEXT FROM curs INTO @DateOfDispatch, @DateOfArrival, @ActualDistance, @FkRouteName, @FkPremiumId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DateOfDispatch <= @DateOfArrival
			INSERT INTO Transportation(DateOfDispatch, DateOfArrival, ActualDistance, FkRouteName, FkPremiumId) VALUES(@DateOfDispatch, @DateOfArrival, @ActualDistance, @FkRouteName, @FkPremiumId)
		ELSE THROW 50005, N'Error! Date of dispatch is more than date of arrival', 1
		FETCH NEXT FROM curs INTO @DateOfDispatch, @DateOfArrival, @ActualDistance, @FkRouteName, @FkPremiumId
	END
	CLOSE curs
	DEALLOCATE curs
END
GO

SELECT * FROM Transportation
GO

INSERT INTO Transportation (DateOfDispatch, DateOfArrival, ActualDistance, FkRouteName) VALUES ('2014-10-02', '2014-08-01', 536, 'Baiyang - Baiyang')
GO

CREATE TRIGGER OnUpdateTransportation
ON Transportation
FOR UPDATE
AS
BEGIN
	IF UPDATE(DateOfDispatch) OR UPDATE(DateOfArrival)
	BEGIN
		DECLARE @DateOfDispatch date
		DECLARE @DateOfArrival date

		DECLARE curs CURSOR LOCAL FOR
			SELECT DateOfDispatch, DateOfArrival FROM inserted WHERE inserted.TransportationId IN (SELECT TransportationId FROM deleted)

		OPEN curs
		FETCH NEXT FROM curs INTO @DateOfDispatch, @DateOfArrival
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @DateOfDispatch > @DateOfArrival
			BEGIN
				ROLLBACK TRANSACTION;
				THROW 50005, N'Error! Date of dispatch is more than date of arrival', 1
			END
			FETCH NEXT FROM curs INTO @DateOfDispatch, @DateOfArrival
		END
		CLOSE curs
		DEALLOCATE curs
	END
END
GO

SELECT * FROM Transportation
GO

UPDATE Transportation SET DateOfArrival='2010-10-01' WHERE TransportationId=3
GO

CREATE TRIGGER OnDeleteTransportation
ON Transportation
FOR DELETE
AS
BEGIN
	DECLARE @DateOfArrival date
	SET @DateOfArrival = (SELECT MAX(DateOfArrival) FROM deleted)

	IF @DateOfArrival > CONVERT(date, GETDATE())
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50005, N'Error! You cannot delete transportation which is not completed', 1
	END
	ELSE
		PRINT 'Successfully deleted transportations'
END
GO

SELECT * FROM Transportation
GO

DELETE FROM Transportation WHERE TransportationId = 9
GO