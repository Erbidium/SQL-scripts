USE [DocumentsManagementDB]
GO

--1
CREATE FUNCTION getDocumentFiles(@DocumentId int)
RETURNS TABLE
AS
RETURN (
select FileName, FileExtension
from DocumentInfo
where @DocumentId=DocumentId
)
RETURNS TABLE
AS
RETURN (
select DISTINCT OrganisationName[Organisation Sender], City, Street, Email, WorkerId, Name [Receiver name], Surname [Receiver surname], Patronymic [Receiver patronymic], Position, PhoneNumber, TypeName, DepartmentName, Text, RecevingDate
from IncomingDocumentInfo
where @IncomingDocumentId=IncomingDocumentId
)
RETURNS TABLE
AS
RETURN (
select DISTINCT OrganisationName[Organisation Receiver], City, Street, Email, WorkerId, Name [Sender name], Surname [Sender surname], Patronymic [Sender patronymic], Position, PhoneNumber, TypeName, DepartmentName, Text, DepartureDate
from OutgoingDocumentInfo
where @OutgoingDocumentId=OutgoingDocumentId
)
AS
BEGIN
UPDATE IncomingDocument SET RecevingDate = @date
WHERE IncomingDocumentId = @IncomingDocumentId
END
AS
BEGIN
UPDATE OutgoingDocument SET DepartureDate = @date
WHERE OutgoingDocumentId = @OutgoingDocumentId
END
SELECT WorkerId, Name, Surname, Patronymic, Position, PhoneNumber, FkChiefId
FROM DepartmentWorkersInfo
WHERE @DepartmentName=DepartmentName
)
AS
BEGIN
UPDATE Department SET DepartmentName = @NewDepartmentName
WHERE DepartmentName = @OldDepartmentName
END
BEGIN
INSERT INTO DepartmentPhoneNumber(PhoneNumber, FkDepartmentName) VALUES(@PhoneNumber, @DepartmentName)
END

SELECT * FROM DepartmentPhoneNumber WHERE FkDepartmentName='Services'

EXEC InsertDepartmentPhoneNumber '+5-454-444-444', 'Services';

--10
CREATE PROCEDURE InsertOrganisationPhoneNumber @PhoneNumber varchar(50), @OrganisationId int
BEGIN
INSERT INTO OrganisationPhoneNumber(PhoneNumber, FkOrganisationId) VALUES(@PhoneNumber, @OrganisationId)
END

SELECT * FROM OrganisationPhoneNumber WHERE FkOrganisationId=4

EXEC InsertOrganisationPhoneNumber '+5-494-784-444', '4';

--11
CREATE FUNCTION getOutgoingInfoLastMonth(@MonthNumber int)
SELECT *
FROM OutgoingDocumentInfo
WHERE ABS(DATEDIFF(MONTH, GETDATE(), DepartureDate))<=ABS(@MonthNumber)
)

SELECT * FROM getOutgoingInfoLastMonth(3)

--12
CREATE FUNCTION getIncomingInfoLastMonth(@MonthNumber int)
SELECT *
FROM IncomingDocumentInfo
WHERE ABS(DATEDIFF(MONTH, GETDATE(), RecevingDate))<=ABS(@MonthNumber)
)

SELECT * FROM getIncomingInfoLastMonth(15)

--13
CREATE PROCEDURE changeDepartmentPhoneNumber @NewPhoneNumber varchar(50), @OldPhoneNumber varchar(50), @DepartmentName nvarchar(50)
AS
BEGIN
UPDATE DepartmentPhoneNumber SET PhoneNumber = @NewPhoneNumber
WHERE FkDepartmentName = @DepartmentName AND PhoneNumber=@OldPhoneNumber
END
SELECT * FROM DepartmentPhoneNumber WHERE FkDepartmentName='Services'

EXEC changeDepartmentPhoneNumber '+1-303-606-9666', '+1-303-606-9236', 'Services';