USE [DocumentsManagementDB]
GO


CREATE TABLE Worker(
	WorkerId int IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(50) NOT NULL,
	Surname nvarchar(50) NOT NULL,
	Patronymic nvarchar(50),
	Position nvarchar(50) NOT NULL,
	PhoneNumber varchar(50) NOT NULL UNIQUE
)
GO

ALTER TABLE Worker
ADD CONSTRAINT CHK_WorkerName
CHECK (Name LIKE '%[A-Za-z]%' AND Name NOT LIKE '%[^A-Za-z-]%')
GO

ALTER TABLE Worker
ADD CONSTRAINT CHK_WorkerSurname
CHECK (Surname LIKE '%[A-Za-z]%' AND Surname NOT LIKE '%[^A-Za-z'' -]%')
GO

ALTER TABLE Worker
ADD CONSTRAINT CHK_WorkerPatronymic
CHECK (Patronymic LIKE '%[A-Za-z]%' AND Patronymic NOT LIKE '%[^A-Za-z'' -]%')
GO

ALTER TABLE Worker
ADD CONSTRAINT CHK_WorkerPhoneNumber CHECK (PhoneNumber LIKE '+%-%-%-%' AND PhoneNumber NOT LIKE '%[a-Z]%')
GO

CREATE TABLE Organisation(
	OrganisationId int IDENTITY(1,1) PRIMARY KEY,
	OrganisationName nvarchar(50),
	City nvarchar(50) NOT NULL,
	Street nvarchar(50) NOT NULL,
	StreetNumber int NOT NULL,
	Email nvarchar(50) NOT NULL
)
GO

ALTER TABLE Organisation
ADD CONSTRAINT CHK_EmailFormat CHECK (Email LIKE '%_@_%_.__%') 
GO

ALTER TABLE Organisation
ADD CONSTRAINT CHK_OrganisationName CHECK (OrganisationName NOT LIKE '%[0-9]%' AND LEN(OrganisationName)>=5)
GO

ALTER TABLE Organisation
ADD CONSTRAINT CHK_OrganisationCity CHECK (City NOT LIKE '%[0-9]%' AND LEN(City)>=3)
GO

ALTER TABLE Organisation
ADD CONSTRAINT CHK_OrganisationStreet CHECK (LEN(Street)>=1)
GO

ALTER TABLE Organisation
ADD CONSTRAINT CHK_OrganisationStreetNumber CHECK (StreetNumber>=0)
GO

CREATE TABLE OrganisationPhoneNumber(
	PhoneNumber varchar(50) NOT NULL PRIMARY KEY,
	FkOrganisationId int NOT NULL FOREIGN KEY REFERENCES Organisation(OrganisationId)
)
GO

ALTER TABLE OrganisationPhoneNumber
ADD CONSTRAINT CHK_OrganisationPhoneNumber CHECK (PhoneNumber LIKE '+%-%-%-%' AND PhoneNumber NOT LIKE '%[a-Z]%')
GO

CREATE TABLE Department(
	DepartmentName nvarchar(50) NOT NULL PRIMARY KEY,
	FkChiefId int NOT NULL FOREIGN KEY REFERENCES Worker(WorkerId)
)
GO

CREATE TABLE DepartmentPhoneNumber(
	PhoneNumber varchar(50) NOT NULL PRIMARY KEY,
	FkDepartmentName nvarchar(50) NOT NULL
)
GO

ALTER TABLE DepartmentPhoneNumber
WITH CHECK ADD CONSTRAINT FK_DepartmentName_DepartmentPhoneNumber FOREIGN KEY(FkDepartmentName)
REFERENCES Department(DepartmentName)
ON UPDATE CASCADE
GO

ALTER TABLE DepartmentPhoneNumber
ADD CONSTRAINT CHK_DepartmentPhoneNumber CHECK (PhoneNumber LIKE '+%-%-%-%' AND PhoneNumber NOT LIKE '%[a-Z]%')
GO

CREATE TABLE DepartmentWorker(
	FkDepartmentName nvarchar(50) NOT NULL,
	FkWorkerId int NOT NULL FOREIGN KEY REFERENCES Worker(WorkerId)
	CONSTRAINT PkDepartmentWorker PRIMARY KEY(FkDepartmentName, FkWorkerId)
)
GO

ALTER TABLE DepartmentWorker
WITH CHECK ADD CONSTRAINT FK_DepartmentName FOREIGN KEY(FkDepartmentName)
REFERENCES Department(DepartmentName)
ON UPDATE CASCADEGo
CREATE TABLE DocumentType(
	TypeId int IDENTITY(1,1) PRIMARY KEY,
	TypeName nvarchar(50) NOT NULL UNIQUE
)
GO

ALTER TABLE DocumentType
ADD CONSTRAINT CHK_DocumentTypeMinLength
CHECK (LEN(DocumentType.TypeName)>=1)
GO

CREATE TABLE Document(
	DocumentId int IDENTITY(1,1) PRIMARY KEY,
	FkTypeId int NOT NULL FOREIGN KEY REFERENCES DocumentType(TypeId),
	FkDepartmentName nvarchar(50) NOT NULL,
	Text nvarchar(2000) NOT NULL
)
GO

ALTER TABLE Document
WITH CHECK ADD CONSTRAINT FK_DepartmentName_DocumentTable FOREIGN KEY(FkDepartmentName)
REFERENCES Department(DepartmentName)
ON UPDATE CASCADE

ALTER TABLE Document
ADD CONSTRAINT CHK_DocumentTextMinLength
CHECK (LEN(Document.Text)>=50)
GO

CREATE TABLE DocumentFile(
	FileName nvarchar(50) NOT NULL,
    FileExtension nvarchar(50)  NOT NULL,
    FkDocumentId int NOT NULL FOREIGN KEY REFERENCES Document(DocumentId),
	CONSTRAINT PkDocumentFile PRIMARY KEY(FileName, FileExtension),
)
GO

ALTER TABLE DocumentFile
ADD CONSTRAINT CHK_DocumentFileMinLength
CHECK ((FileName LIKE ('%_%')) AND (FileExtension LIKE ('%_%')))
GO

CREATE TABLE IncomingDocument(
	IncomingDocumentId int IDENTITY(1,1) PRIMARY KEY,
	FkDocumentId int NOT NULL UNIQUE FOREIGN KEY REFERENCES Document(DocumentId),
	FkOrganisationId int NOT NULL FOREIGN KEY REFERENCES Organisation(OrganisationId),
	FkRecipientId int NOT NULL FOREIGN KEY REFERENCES Worker(WorkerId),
	RecevingDate date NOT NULL DEFAULT(GETDATE())
)
GO

ALTER TABLE IncomingDocument ADD CONSTRAINT CHK_ReceivingDate CHECK (RecevingDate <= CONVERT(date, GETDATE()))
GO

CREATE TABLE OutgoingDocument(
	OutgoingDocumentId int IDENTITY(1,1) PRIMARY KEY,
	FkDocumentId int NOT NULL UNIQUE FOREIGN KEY REFERENCES Document(DocumentId),
	FkOrganisationId int NOT NULL FOREIGN KEY REFERENCES Organisation(OrganisationId),
	FkSenderId int NOT NULL FOREIGN KEY REFERENCES Worker(WorkerId),
	DepartureDate date NOT NULL DEFAULT(GETDATE())
)
GO

ALTER TABLE OutgoingDocument ADD CONSTRAINT CHK_DepartureDate CHECK (DepartureDate <= CONVERT(date, GETDATE()))
GO

CREATE TABLE DocumentsJournal(
	FkIncomingDocumentId int NOT NULL FOREIGN KEY REFERENCES IncomingDocument(IncomingDocumentId),
	FkOutgoingDocumentId int NOT NULL FOREIGN KEY REFERENCES OutgoingDocument(OutgoingDocumentId),
	CONSTRAINT PkDocumentsJournal PRIMARY KEY(FkIncomingDocumentId, FkOutgoingDocumentId)
)
GO