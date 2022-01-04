USE [DocumentsManagementDB]
GO

CREATE TRIGGER OnInsertDocumentsJournal
ON DocumentsJournal
INSTEAD OF INSERT
AS 
BEGIN
  DECLARE @IncomingId int
  DECLARE @OutgoingId int
  DECLARE @IncomingDate date
  DECLARE @OutgoingDate date
  DECLARE del_cursor CURSOR LOCAL FOR
    SELECT FkIncomingDocumentId, FkOutgoingDocumentId from inserted
  OPEN del_cursor
  FETCH NEXT FROM del_cursor INTO @IncomingId, @OutgoingId
  WHILE @@FETCH_STATUS = 0
  BEGIN 
	SET @IncomingDate=(SELECT RecevingDate FROM IncomingDocument WHERE IncomingDocumentId=@IncomingId)
	SET @OutgoingDate=(SELECT DepartureDate FROM OutgoingDocument WHERE OutgoingDocumentId=@OutgoingId)
    if @IncomingDate < @OutgoingDate
      insert DocumentsJournal(FkIncomingDocumentId, FkOutgoingDocumentId) values (@IncomingId, @OutgoingId)
	ELSE THROW 50005, N'Error! Incoming date is less than departure', 1;
    FETCH NEXT FROM del_cursor INTO @IncomingId, @OutgoingId
  END
  CLOSE del_cursor
  DEALLOCATE del_cursor
END
GO

DROP TRIGGER OnInsertDocumentsJournal
GO

INSERT INTO DocumentsJournal
VALUES ('151', '100')
GO

CREATE TRIGGER OnInsertOrganisationPhoneNumber
ON OrganisationPhoneNumber
INSTEAD OF INSERT
AS 
BEGIN
  DECLARE @PhoneNum varchar(50)
  DECLARE @OrganisationId int
  DECLARE del_cursor CURSOR LOCAL FOR
    SELECT PhoneNumber, FkOrganisationId from inserted
  OPEN del_cursor
  FETCH NEXT FROM del_cursor INTO @PhoneNum, @OrganisationId
  WHILE @@FETCH_STATUS = 0
  BEGIN 
    if @PhoneNum NOT IN (SELECT PhoneNumber FROM DepartmentPhoneNumber)
	BEGIN
      insert OrganisationPhoneNumber(PhoneNumber, FkOrganisationId) values (@PhoneNum, @OrganisationId)
	END
	ELSE THROW 50005, N'Error! This phone number is used in another table', 1;
    FETCH NEXT FROM del_cursor INTO @PhoneNum, @OrganisationId
  END
  CLOSE del_cursor
  DEALLOCATE del_cursor
END
GO

INSERT INTO OrganisationPhoneNumber 
VALUES ('+1-385-373-8710', '70')
GO

DROP TRIGGER OnInsertOrganisationPhoneNumber
GO

SELECT * FROM DepartmentPhoneNumber
GO

CREATE TRIGGER OnInsertDepartmentPhoneNumber
ON DepartmentPhoneNumber
INSTEAD OF INSERT
AS 
BEGIN
  DECLARE @PhoneNum varchar(50)
  DECLARE @DepartmentName nvarchar(50)
  DECLARE del_cursor CURSOR LOCAL FOR
    SELECT PhoneNumber, FkDepartmentName from inserted
  OPEN del_cursor
  FETCH NEXT FROM del_cursor INTO @PhoneNum, @DepartmentName
  WHILE @@FETCH_STATUS = 0
  BEGIN 
    if @PhoneNum NOT IN (SELECT PhoneNumber FROM OrganisationPhoneNumber)
	BEGIN
      insert DepartmentPhoneNumber(PhoneNumber, FkDepartmentName) values (@PhoneNum, @DepartmentName)
	END
	ELSE THROW 50005, N'Error! This phone number is used in another table', 1;
    FETCH NEXT FROM del_cursor INTO @PhoneNum, @DepartmentName
  END
  CLOSE del_cursor
  DEALLOCATE del_cursor
END
GO

INSERT INTO DepartmentPhoneNumber 
VALUES ('+1-727-274-6594', 'Services')

DROP TRIGGER OnInsertOrganisationPhoneNumber
GO
