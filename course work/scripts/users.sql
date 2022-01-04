USE [DocumentsManagementDB]
GO

DELETE FROM Worker
WHERE Name='Dima' AND Surname = 'Maxymovich'

INSERT INTO Worker
VALUES('Dima', 'Maxymovich', 'Petrenko', 'Analyst', '+4-444-444-444-4')
GO

USE master

-- worker

ALTER LOGIN Worker WITH DEFAULT_DATABASE=master
GRANT CONNECT SQL TO Worker
ALTER LOGIN Worker ENABLE

CREATE LOGIN Worker WITH PASSWORD='Worker'
CREATE USER WorkerUser FOR LOGIN Worker

GRANT SELECT ON DocumentsJournal TO WorkerUser
GRANT SELECT ON IncomingDocument TO WorkerUser
GRANT SELECT ON OutgoingDocument TO WorkerUser
GRANT SELECT ON DepartmentWorker TO WorkerUser
GRANT SELECT ON DepartmentPhoneNumber TO WorkerUser
GRANT SELECT ON DocumentFile TO WorkerUser
GRANT SELECT ON Document TO WorkerUser
GRANT SELECT ON DocumentType TO WorkerUser
GRANT SELECT ON Department TO WorkerUser
GRANT SELECT ON Worker TO WorkerUser 
GRANT SELECT ON OrganisationPhoneNumber TO WorkerUser
GRANT SELECT ON Organisation TO WorkerUser

GRANT SELECT ON getDocumentFiles TO WorkerUser
GRANT SELECT ON getIncomingDocumentInfo TO WorkerUser
GRANT SELECT ON getOutgoingDocumentInfo TO WorkerUser
GRANT EXECUTE ON getAverageFilesPerDocumentStatistic TO WorkerUser
GRANT SELECT ON getOutgoingInfoLastMonth TO WorkerUser
GRANT SELECT ON getIncomingInfoLastMonth TO WorkerUser

	
-- department chief
CREATE LOGIN DepartmentChief WITH PASSWORD='DepartmentChief'
CREATE USER DepartmentChiefUser FOR LOGIN DepartmentChief

GRANT SELECT ON DocumentsJournal TO DepartmentChiefUser
GRANT SELECT ON IncomingDocument TO DepartmentChiefUser
GRANT SELECT ON OutgoingDocument TO DepartmentChiefUser
GRANT SELECT, INSERT, UPDATE, DELETE ON DepartmentWorker TO DepartmentChiefUser
GRANT SELECT, INSERT, UPDATE, DELETE ON DepartmentPhoneNumber TO DepartmentChiefUser
GRANT SELECT ON DocumentFile TO DepartmentChiefUser
GRANT SELECT ON Document TO DepartmentChiefUser
GRANT SELECT ON DocumentType TO DepartmentChiefUser
GRANT SELECT, INSERT, UPDATE, DELETE ON Department TO DepartmentChiefUser
GRANT SELECT, INSERT, UPDATE, DELETE ON Worker TO DepartmentChiefUser
GRANT SELECT ON OrganisationPhoneNumber TO DepartmentChiefUser
GRANT SELECT ON Organisation TO DepartmentChiefUser

GRANT SELECT ON getDocumentFiles TO DepartmentChiefUser
GRANT SELECT ON getIncomingDocumentInfo TO DepartmentChiefUser
GRANT SELECT ON getOutgoingDocumentInfo TO DepartmentChiefUser
GRANT EXECUTE ON getAverageFilesPerDocumentStatistic TO DepartmentChiefUser
GRANT SELECT ON getOutgoingInfoLastMonth TO DepartmentChiefUser
GRANT SELECT ON getIncomingInfoLastMonth TO DepartmentChiefUser
 
GRANT EXECUTE ON InsertOrganisationPhoneNumber TO DepartmentChiefUser
GRANT EXECUTE ON InsertDepartmentPhoneNumber TO DepartmentChiefUser
GRANT EXECUTE ON renameDepartment TO DepartmentChiefUser

-- secretary
CREATE LOGIN Secretary WITH PASSWORD='Secretary'
CREATE USER SecretaryUser FOR LOGIN Secretary

GRANT SELECT, INSERT, UPDATE, DELETE ON DocumentsJournal TO SecretaryUser
GRANT SELECT, INSERT, UPDATE, DELETE ON IncomingDocument TO SecretaryUser
GRANT SELECT, INSERT, UPDATE, DELETE ON OutgoingDocument TO SecretaryUser
GRANT SELECT ON DepartmentWorker TO SecretaryUser
GRANT SELECT ON DepartmentPhoneNumber TO SecretaryUser
GRANT SELECT, INSERT, UPDATE, DELETE ON DocumentFile TO SecretaryUser
GRANT SELECT, INSERT, UPDATE, DELETE ON Document TO SecretaryUser
GRANT SELECT, INSERT, UPDATE, DELETE ON DocumentType TO SecretaryUser
GRANT SELECT ON Department TO SecretaryUser
GRANT SELECT ON Worker TO SecretaryUser 
GRANT SELECT, INSERT, UPDATE, DELETE ON OrganisationPhoneNumber TO SecretaryUser
GRANT SELECT, INSERT, UPDATE, DELETE ON Organisation TO SecretaryUser

GRANT SELECT ON getDocumentFiles TO SecretaryUser
GRANT SELECT ON getIncomingDocumentInfo TO SecretaryUser
GRANT SELECT ON getOutgoingDocumentInfo TO SecretaryUser
GRANT EXECUTE ON getAverageFilesPerDocumentStatistic TO SecretaryUser
GRANT SELECT ON getOutgoingInfoLastMonth TO SecretaryUser
GRANT SELECT ON getIncomingInfoLastMonth TO SecretaryUser

GRANT EXECUTE ON InsertOrganisationPhoneNumber TO SecretaryUser
GRANT EXECUTE ON setOutgoingDate TO SecretaryUser
GRANT EXECUTE ON setIncomingDate TO SecretaryUser

-- company owner
CREATE LOGIN OrganisationOwner WITH PASSWORD='OrganisationOwner'
CREATE USER OrganisationOwnerUser FOR LOGIN OrganisationOwner
EXEC sp_addrolemember N'db_owner', N'OrganisationOwnerUser'