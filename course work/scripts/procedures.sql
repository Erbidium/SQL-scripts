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
)SELECT * FROM getDocumentFiles(7)DROP FUNCTION getDocumentFiles--2CREATE FUNCTION getIncomingDocumentInfo(@IncomingDocumentId int)
RETURNS TABLE
AS
RETURN (
select DISTINCT OrganisationName[Organisation Sender], City, Street, Email, WorkerId, Name [Receiver name], Surname [Receiver surname], Patronymic [Receiver patronymic], Position, PhoneNumber, TypeName, DepartmentName, Text, RecevingDate
from IncomingDocumentInfo
where @IncomingDocumentId=IncomingDocumentId
)SELECT * FROM getIncomingDocumentInfo(5)DROP FUNCTION  getIncomingDocumentInfo--3CREATE FUNCTION getOutgoingDocumentInfo(@OutgoingDocumentId int)
RETURNS TABLE
AS
RETURN (
select DISTINCT OrganisationName[Organisation Receiver], City, Street, Email, WorkerId, Name [Sender name], Surname [Sender surname], Patronymic [Sender patronymic], Position, PhoneNumber, TypeName, DepartmentName, Text, DepartureDate
from OutgoingDocumentInfo
where @OutgoingDocumentId=OutgoingDocumentId
)SELECT * FROM getOutgoingDocumentInfo(5)DROP FUNCTION  getOutgoingDocumentInfo--4CREATE FUNCTION getAverageFilesPerDocumentStatistic()RETURNS intASBEGIN	DECLARE @tempTable table(DocumentsNumber int)	DECLARE @Result int	INSERT INTO @tempTable  SELECT COUNT(*) FROM DocumentInfo DocumentsNumber GROUP BY DocumentId	SET @Result = (SELECT AVG(DocumentsNumber) FROM @tempTable)	RETURN @ResultENDSELECT dbo.getAverageFilesPerDocumentStatistic() as averageFilesDROP FUNCTION  getAverageFilesPerDocumentStatistic--5CREATE PROCEDURE setIncomingDate @IncomingDocumentId int, @date date
AS
BEGIN
UPDATE IncomingDocument SET RecevingDate = @date
WHERE IncomingDocumentId = @IncomingDocumentId
ENDEXEC setIncomingDate 1, '2020-04-22';DROP PROCEDURE setIncomingDate--6CREATE PROCEDURE setOutgoingDate @OutgoingDocumentId int, @date date
AS
BEGIN
UPDATE OutgoingDocument SET DepartureDate = @date
WHERE OutgoingDocumentId = @OutgoingDocumentId
ENDEXEC setOutgoingDate 1, '2021-05-27';SELECT * FROM OutgoingDocumentDROP PROCEDURE setOutgoingDate--7CREATE FUNCTION getWorkersOfDepartment(@DepartmentName nvarchar(50))RETURNS TABLEASRETURN (
SELECT WorkerId, Name, Surname, Patronymic, Position, PhoneNumber, FkChiefId
FROM DepartmentWorkersInfo
WHERE @DepartmentName=DepartmentName
)SELECT * FROM getWorkersOfDepartment('Services')SELECT * FROM DepartmentWorkersInfoDROP FUNCTION  getWorkersOfDepartment--8CREATE PROCEDURE renameDepartment @OldDepartmentName nvarchar(50), @NewDepartmentName nvarchar(50)
AS
BEGIN
UPDATE Department SET DepartmentName = @NewDepartmentName
WHERE DepartmentName = @OldDepartmentName
ENDSELECT * FROM DepartmentEXEC renameDepartment 'Legals', 'Legal';--9CREATE PROCEDURE InsertDepartmentPhoneNumber @PhoneNumber varchar(50), @DepartmentName nvarchar(50)AS
BEGIN
INSERT INTO DepartmentPhoneNumber(PhoneNumber, FkDepartmentName) VALUES(@PhoneNumber, @DepartmentName)
END

SELECT * FROM DepartmentPhoneNumber WHERE FkDepartmentName='Services'

EXEC InsertDepartmentPhoneNumber '+5-454-444-444', 'Services';

--10
CREATE PROCEDURE InsertOrganisationPhoneNumber @PhoneNumber varchar(50), @OrganisationId intAS
BEGIN
INSERT INTO OrganisationPhoneNumber(PhoneNumber, FkOrganisationId) VALUES(@PhoneNumber, @OrganisationId)
END

SELECT * FROM OrganisationPhoneNumber WHERE FkOrganisationId=4

EXEC InsertOrganisationPhoneNumber '+5-494-784-444', '4';

--11
CREATE FUNCTION getOutgoingInfoLastMonth(@MonthNumber int)RETURNS TABLEASRETURN (
SELECT *
FROM OutgoingDocumentInfo
WHERE ABS(DATEDIFF(MONTH, GETDATE(), DepartureDate))<=ABS(@MonthNumber)
)

SELECT * FROM getOutgoingInfoLastMonth(3)

--12
CREATE FUNCTION getIncomingInfoLastMonth(@MonthNumber int)RETURNS TABLEASRETURN (
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