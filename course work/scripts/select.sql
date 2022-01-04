USE [DocumentsManagementDB]
GO

--1
SELECT IncomingFile, OutgoingFile
FROM
DocumentsJournal
JOIN	(SELECT TRIM(FileName)+'.'+FileExtension IncomingFile, IncomingDocumentId
		FROM IncomingDocument
		JOIN Document ON FkDocumentId=DocumentId
		JOIN DocumentFile ON DocumentId=DocumentFile.FkDocumentId) tab1
ON tab1.IncomingDocumentId=FkIncomingDocumentId
JOIN	(SELECT TRIM(FileName)+'.'+FileExtension OutgoingFile, OutgoingDocumentId
		FROM OutgoingDocument
		JOIN Document ON FkDocumentId=DocumentId
		JOIN DocumentFile ON DocumentId=DocumentFile.FkDocumentId) tab2
ON tab2.OutgoingDocumentId=FkOutgoingDocumentId
GO

--2
SELECT DocumentId, TypeName, FileName as Name, FileExtension as Extension
FROM Document
JOIN DocumentFile ON DocumentId=FkDocumentId
JOIN DocumentType ON FkTypeId=TypeId
ORDER BY DocumentId
GO

--3
SELECT TypeName, Text, FkDepartmentName as DepartmentName
FROM Document
JOIN DocumentType ON FkTypeId=TypeId
ORDER BY DocumentId
GO

--4
SELECT Name +' '+Surname+' '+Patronymic as [Chief FIO], DepartmentName
FROM Document
JOIN Department ON FkDepartmentName=DepartmentName
JOIN Worker ON WorkerId=FkChiefId
GROUP BY DepartmentName, Name, Surname, Patronymic
GO

--5
SELECT OrganisationName, OrganisationPhoneNumber.PhoneNumber
FROM IncomingDocument
JOIN Organisation ON FkOrganisationId=OrganisationId
LEFT JOIN OrganisationPhoneNumber ON OrganisationPhoneNumber.FkOrganisationId=OrganisationId
GROUP BY OrganisationName, PhoneNumber
GO

--6
SELECT OrganisationName, OrganisationPhoneNumber.PhoneNumber
FROM OutgoingDocument
JOIN Organisation ON FkOrganisationId=OrganisationId
LEFT JOIN OrganisationPhoneNumber ON OrganisationPhoneNumber.FkOrganisationId=OrganisationId
GROUP BY OrganisationName, PhoneNumber
GO

--7
SELECT DocumentId, TypeName, Text, FileName as Name, FileExtension as Extension
FROM Document
JOIN DocumentFile ON DocumentId=FkDocumentId
JOIN DocumentType ON FkTypeId=TypeId
WHERE DocumentId NOT IN 
((SELECT DocumentId FROM Document JOIN IncomingDocument ON DocumentId=FkDocumentId)
UNION
(SELECT DocumentId FROM Document JOIN OutgoingDocument ON DocumentId=FkDocumentId))
ORDER BY DocumentId
GO

--8
SELECT DepartmentName, PhoneNumber
FROM Department
JOIN DepartmentPhoneNumber ON DepartmentName=FkDepartmentName
GROUP BY DepartmentName, PhoneNumber
GO

--9
SELECT workerDepartment.Name, workerDepartment.Surname, workerDepartment.Position, DepartmentName, chief.Name [Chief name], chief.Surname [Chief surname], chief.PhoneNumber [Chief phone number]
FROM DepartmentWorker
JOIN Worker workerDepartment ON WorkerId=FkWorkerId
JOIN Department ON FkDepartmentName=DepartmentName
JOIN Worker chief ON FkChiefId=chief.WorkerId
GO

--10
SELECT  Name, Surname, Patronymic, PhoneNumber, COUNT(inDoc.FkDocumentId) [Number of received docs], COUNT(outDoc.FkDocumentId) [Number of sent docs]
FROM Worker
LEFT JOIN IncomingDocument inDoc ON FkRecipientId=WorkerId
LEFT JOIN OutgoingDocument outDoc ON FkSenderId=WorkerId
GROUP BY WorkerId, Name, Surname, Patronymic, PhoneNumber
HAVING COUNT(inDoc.FkDocumentId)>0 OR COUNT(outDoc.FkDocumentId) >0
ORDER BY [Number of received docs] DESC, [Number of sent docs] DESC
GO

--11
SELECT TypeName [Incoming document type], Text, FileName as Name, FileExtension as Extension
FROM Document
JOIN DocumentFile ON DocumentId=FkDocumentId
JOIN IncomingDocument ON IncomingDocument.FkDocumentId=DocumentId
JOIN DocumentType ON FkTypeId=TypeId
GO

--12
SELECT TypeName [Outgoing document type], Text, FileName as Name, FileExtension as Extension
FROM Document
JOIN DocumentFile ON DocumentId=FkDocumentId
JOIN OutgoingDocument ON OutgoingDocument.FkDocumentId=DocumentId
JOIN DocumentType ON FkTypeId=TypeId
GO

--13
SELECT TypeName, COUNT(DocumentId) [Number of documents]
FROM Document
JOIN DocumentType ON TypeId=FkTypeId
GROUP BY TypeName
ORDER BY [Number of documents] DESC
GO

--14
SELECT DocumentId, TypeName, FileName as Name, FileExtension as Extension
FROM Document
JOIN DocumentFile ON DocumentId=FkDocumentId
JOIN DocumentType ON FkTypeId=TypeId
WHERE DocumentId IN ((SELECT FkDocumentId FROM IncomingDocument WHERE ABS(DATEDIFF(month, GETDATE(), RecevingDate))<3 AND YEAR(RecevingDate)=YEAR(GETDATE()))
				UNION (SELECT FkDocumentId FROM OutgoingDocument WHERE ABS(DATEDIFF(month, GETDATE(), DepartureDate))<3 AND YEAR(DepartureDate)=YEAR(GETDATE())))
GO

--15
SELECT TypeName, Text, FkDepartmentName Department
FROM Document
JOIN DocumentType ON TypeId=FkTypeId
WHERE DocumentId NOT IN (SELECT FkDocumentId FROM DocumentFile)
GO

--16
SELECT [Incoming document text], [Outgoing document text]
FROM DocumentsJournal
JOIN (SELECT IncomingDocumentId, Text [Incoming document text] FROM IncomingDocument JOIN Document ON FkDocumentId=DocumentId) tab1
ON tab1.IncomingDocumentId=FkIncomingDocumentId
JOIN (SELECT OutgoingDocumentId,  Text [Outgoing document text] FROM OutgoingDocument JOIN Document ON FkDocumentId=DocumentId) tab2
ON tab2.OutgoingDocumentId=FkOutgoingDocumentId
GO

--17
SELECT DepartmentName, TypeName as [Document type]
FROM Document
JOIN Department ON FkDepartmentName=DepartmentName
JOIN DocumentType On TypeId=FkTypeId
GROUP BY DepartmentName, TypeName
GO

--18
SELECT  Name, Surname, Patronymic, PhoneNumber
FROM Worker
LEFT JOIN IncomingDocument inDoc ON FkRecipientId=WorkerId
GROUP BY Name, Surname, Patronymic, PhoneNumber
HAVING COUNT(inDoc.FkDocumentId)=0
GO

--19
SELECT  Name, Surname, Patronymic, PhoneNumber
FROM Worker
LEFT JOIN OutgoingDocument outDoc ON FkSenderId=WorkerId
GROUP BY Name, Surname, Patronymic, PhoneNumber
HAVING COUNT(outDoc.FkDocumentId)=0
GO

--20
SELECT TOP 5 DepartmentName, COUNT(*) ProcessedDocuments
FROM Department
JOIN Document ON FkDepartmentName=DepartmentName
GROUP BY DepartmentName
ORDER BY ProcessedDocuments DESC
GO

SELECT WorkerId, Position FROM Worker
WHERE Position='Construction Expeditor'

CREATE INDEX WorkerIndex ON Worker(Position)

DROP INDEX WorkerIndex ON Worker
