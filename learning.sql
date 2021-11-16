USE [FreightTransportationDB]
GO

TRUNCATE TABLE BlogUser
GO

INSERT INTO BlogUser(Name, Surname, Patronymic, Email, UserLogin, Password, RegistrationDate) VALUES
('Jane','ambursky', 'ratmirovna', 'spell@yanedex.ru', 'spell', '8937', '20150507')
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BlogUser](
	UserId int IDENTITY(1,1),
	[UserLogin] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Patronymic] [nvarchar](50) NULL,
	[Email] [varchar](50) NOT NULL,
	[RegistrationDate] [datetime] NOT NULL
)
GO

ALTER TABLE [dbo].[BlogUser]
ADD  CONSTRAINT [DF_BlogUser_RegistrationDate]  DEFAULT (getdate()) FOR [RegistrationDate]
GO

ALTER TABLE BlogUser
ADD CONSTRAINT DF_BlogUser_UserLogin_Unique UNIQUE (UserLogin)
GO

ALTER TABLE BlogUser
ADD CONSTRAINT DF_BlogUser_Email_Unique UNIQUE (Email)
GO

ALTER TABLE BlogUser
ADD UserId int IDENTITY(1,1)
GO

ALTER TABLE BlogUser
ADD CONSTRAINT PK_BlogUser_UserID PRIMARY KEY CLUSTERED (UserID)
GO


CREATE TABLE Blog (
	BlogId int IDENTITY(1,1),
	Name nvarchar(50) NOT NULL,
	[Description] nvarchar (250) NULL,
	CreatedDate datetime NOT NULL
)
GO

ALTER TABLE Blog
ADD CONSTRAINT PK_Blog_BlogId PRIMARY KEY CLUSTERED (BlogId)
GO

ALTER TABLE Blog
ADD CONSTRAINT DF_Blog_CreatedDate_Default DEFAULT (getdate()) FOR CreatedDate
GO

ALTER TABLE Blog
ADD UserId int NOT NULL
GO

ALTER TABLE Blog
ALTER COLUMN UserId int NOT NULL
GO

ALTER TABLE Blog
WITH CHECK ADD CONSTRAINT FK_BlogUser FOREIGN KEY(UserId)
REFERENCES BlogUser (UserId)
ON UPDATE CASCADE
ON DELETE CASCADE
GO