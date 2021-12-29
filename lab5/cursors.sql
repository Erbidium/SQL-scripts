USE [FreightTransportationDB]
GO

DECLARE CURS CURSOR
FOR SELECT Name, Surname, Patronymic, Experience, CategoriesOfLicences
FROM Driver
WHERE Experience > 5

OPEN CURS

DECLARE @Name nvarchar(50)
DECLARE @Surname nvarchar(50)
DECLARE @Patronymic nvarchar(50)
DECLARE @Experience int
DECLARE @CategoriesOfLicences nvarchar(50)

FETCH NEXT FROM CURS INTO @Name, @Surname, @Patronymic, @Experience, @CategoriesOfLicences

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Name ' + @Name + ' Surname ' + @Surname + ' Patronymic ' + @Patronymic + ' Exprerience ' + convert(nvarchar(4), @Experience) + ' Categories of licences ' + @CategoriesOfLicences
	FETCH NEXT FROM CURS INTO @Name, @Surname, @Patronymic, @Experience, @CategoriesOfLicences
END

CLOSE CURS

DEALLOCATE CURS
