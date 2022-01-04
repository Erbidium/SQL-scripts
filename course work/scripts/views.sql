USE [DocumentsManagementDB]
GO

CREATE VIEW DocumentInfo AS
SELECT DocumentId,	TypeName, FkDepartmentName as DepartmentName, Text, DocumentFile.FileName, FileExtension
FROM Document JOIN DocumentFile ON DocumentId=FkDocumentId
JOIN DocumentType ON TypeId = FkTypeId
GO

CREATE VIEW IncomingDocumentInfo AS
SELECT IncomingDocumentId, OrganisationId, OrganisationName, City, Street, Email, WorkerId, Name, Surname, Patronymic, Position, PhoneNumber, TypeName, DepartmentName, Text, RecevingDate, FileName, FileExtension
FROM IncomingDocument
JOIN Organisation On FkOrganisationId=OrganisationId
JOIN Worker ON WorkerId=FkRecipientId
JOIN DocumentInfo ON FkDocumentId=DocumentId
GO

CREATE VIEW OutgoingDocumentInfo AS
SELECT OutgoingDocumentId, OrganisationId, OrganisationName, City, Street, Email, WorkerId, Name, Surname, Patronymic, Position, PhoneNumber, TypeName, DepartmentName, Text,  DepartureDate, FileName, FileExtension
FROM OutgoingDocument
JOIN Organisation On FkOrganisationId=OrganisationId
JOIN Worker ON WorkerId=FkSenderId
JOIN DocumentInfo ON FkDocumentId=DocumentId
GO

CREATE VIEW DepartmentWorkersInfo AS
SELECT DepartmentName, FkChiefId, WorkerId, Name, Surname, Patronymic, Position, PhoneNumber
FROM DepartmentWorker
JOIN Department ON DepartmentName=FkDepartmentName
JOIN Worker ON WorkerId=FkWorkerId
GO



--1((with view usage)
SELECT IncomingFile, OutgoingFile
FROM
DocumentsJournal
JOIN	(SELECT TRIM(FileName)+'.'+FileExtension IncomingFile, IncomingDocumentId
		FROM IncomingDocument
		JOIN DocumentInfo ON FkDocumentId=DocumentId) tab1
ON tab1.IncomingDocumentId=FkIncomingDocumentId
JOIN	(SELECT TRIM(FileName)+'.'+FileExtension OutgoingFile, OutgoingDocumentId
		FROM OutgoingDocument
		JOIN DocumentInfo ON FkDocumentId=DocumentId) tab2
ON tab2.OutgoingDocumentId=FkOutgoingDocumentId
GO

--2(with view usage)
SELECT DocumentId, TypeName, FileName as Name, FileExtension as Extension
FROM DocumentInfo
ORDER BY DocumentId
GO

--7(with view usage)
SELECT DocumentId, TypeName, Text, FileName as Name, FileExtension as Extension
FROM DocumentInfo
WHERE DocumentId NOT IN 
((SELECT DocumentId FROM Document JOIN IncomingDocument ON DocumentId=FkDocumentId)
UNION
(SELECT DocumentId FROM Document JOIN OutgoingDocument ON DocumentId=FkDocumentId))
ORDER BY DocumentId
GO

--9(with view usage)
SELECT DepartmentWorkersInfo.Name, DepartmentWorkersInfo.Surname, DepartmentWorkersInfo.Position, DepartmentName, chief.Name [Chief name], chief.Surname [Chief surname], chief.PhoneNumber [Chief phone number]
FROM DepartmentWorkerSInfo
JOIN Worker chief ON FkChiefId=chief.WorkerId
GO

--11(with view usage)
SELECT TypeName [Incoming document type], Text, FileName as Name, FileExtension as Extension
FROM DocumentInfo
JOIN IncomingDocument ON IncomingDocument.FkDocumentId=DocumentId
GO

