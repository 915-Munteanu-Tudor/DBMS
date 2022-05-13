use ServiceAuto
go

--grade 3
CREATE OR ALTER PROCEDURE AddMechanic(@name_mechanic VARCHAR(50), @experience_mechanic int , @has_superiour_studies bit)
AS
	DECLARE @maxId INT
	SET @maxId = (SELECT MAX(M.id_mechanic) FROM Mechanics M)
	SET @maxId = @maxId + 1
	IF (@name_mechanic is null)
	BEGIN
		THROW 51000, 'Mechanic name must be not null.', 1;  
	END
	IF (@experience_mechanic is null)
	BEGIN
		THROW 51000, 'Mechanic experience must be not null.', 1;  
	END
	IF (@has_superiour_studies is null or @has_superiour_studies not in (0,1))
	BEGIN
		THROW 51000, 'Mechanic studies must be not null, or different from 0 or 1.', 1;  
	END
	IF (@maxId is null)
	BEGIN
		SET @maxId = 0
	END
	INSERT INTO Mechanics(id_mechanic, name_mechanic, experience_mechanic, has_superiour_studies, coordinator_manager) VALUES (@maxId, @name_mechanic, @experience_mechanic, @has_superiour_studies, (select top 1 id_manager From Managers order by newid()))
GO


exec AddMechanic 'Alexandros', 2, 1


CREATE OR ALTER PROCEDURE AddCar(@brand varchar(50), @age int, @repair_cost int)
AS
	DECLARE @maxId INT
	SET @maxId = (SELECT MAX(C.id_car) FROM Cars C) 
	SET @maxId = @maxId + 1
	IF (@maxId is null)
	BEGIN
		SET @maxId = 0
	END
	IF (@age is null)
	BEGIN
		RAISERROR('Car age must not be null', 16, 1);
	END
	IF (@brand is null)
	BEGIN
		RAISERROR('Car brand must not be null', 16, 1);
	END
	IF (@repair_cost is null)
	BEGIN
		RAISERROR('Car repair cost must not be null', 16, 1);
	END
	INSERT INTO Cars(id_car, car_brand, car_age, car_repair_cost, accident_id) VALUES (@maxId, @brand, @age, @repair_cost, (select top 1 id_accident From Accidents order by newid()))
GO

exec AddCar 'Fiat', 23, 125

--!!!
select * from Cars
select * from Accidents

CREATE OR ALTER PROCEDURE AddMechanicsCars(@mechanicName varchar(50), @carBrand varchar(50))
AS

	DECLARE @mechanicID int
	SET @mechanicID = (SELECT M.id_mechanic FROM Mechanics M WHERE M.name_mechanic = @mechanicName)
	DECLARE @carID INT
	SET @carID = (SELECT C.id_car FROM Cars C WHERE C.car_brand = @carBrand)
	IF (@mechanicID is null)
	BEGIN
		RAISERROR('Mechanic does not exist', 16, 1);
	END
	IF (@carID is null)
	BEGIN
		RAISERROR('Car does not exist', 16, 1);
	END
	INSERT INTO MechanicsCars(mechanic_id, car_id) VALUES (@mechanicID, @carID)
GO

exec AddMechanicsCars 'Alexandros', 'Fiat'

--!!!
select * from MechanicsCars


--grade 5
DROP TABLE LogTable

CREATE TABLE LogTable (
	info varchar(100),
	error varchar(1000),
	logTime DATETIME
)
GO

truncate table LogTable

CREATE OR ALTER PROCEDURE addLog (@info VARCHAR(100), @error VARCHAR(100)) AS
	INSERT INTO LogTable VALUES (@info, @error,GETDATE())
GO

CREATE OR ALTER PROCEDURE addRollbackGrade5 (
	@mechName VARCHAR(50), 
	@mechExp INT,
	@mechStudies INT,
	@carBrand VARCHAR(50),
	@carAge INT,
	@carRepCost INT
)
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC AddMechanic @mechName, @mechExp, @mechStudies
		INSERT INTO LogTable VALUES ('Mechanic added', '', GETDATE())
		EXEC AddCar @carBrand, @carAge, @carRepCost
		INSERT INTO LogTable VALUES ('Car Added', '', GETDATE())
		EXEC AddMechanicsCars @mechName, @carBrand
		INSERT INTO LogTable VALUES ('MechanicsCars added', '', GETDATE())
	END TRY
	BEGIN CATCH
		SELECT * FROM LogTable
		WAITFOR DELAY '00:00:10:000'
		ROLLBACK TRAN
		RETURN
	END CATCH
	COMMIT TRAN
GO

EXEC addRollbackGrade5 'Maranica', 1, 0, 'Dodge', 4, 5432
EXEC addRollbackGrade5 'Maranica', 1, 0, 'Dodge', null, 5432
select * from LogTable


--!!!!!
select * from Mechanics
select * from Cars
select * from MechanicsCars

--!!!
delete from Mechanics where name_mechanic = 'Maranica'
delete from Cars where id_car = 2122
delete from Cars where car_brand = 'Dodge'
delete from MechanicsCars where mechanic_id = 1113


CREATE OR ALTER PROCEDURE addRecoverPossible (
	@mechName VARCHAR(50), 
	@mechExp INT,
	@mechStudies INT,
	@carBrand VARCHAR(50),
	@carAge INT,
	@carRepCost INT
)
AS
	BEGIN TRAN
	DECLARE @error VARCHAR(100)
	BEGIN TRY
		EXEC AddMechanic @mechName, @mechExp, @mechStudies
		EXEC addLog 'Mechanic Added', ''
	END TRY
	BEGIN CATCH
		SELECT @error = ERROR_MESSAGE()
		EXEC addLog 'Mechanic not added', @error
		COMMIT TRAN
		RETURN
	END CATCH
	BEGIN TRY
		EXEC AddCar @carBrand, @carAge, @carRepCost
		EXEC addLog 'Car Added', ''
	END TRY
	BEGIN CATCH
		SELECT @error = ERROR_MESSAGE()
		EXEC addLog 'Car not added', @error
		COMMIT TRAN
		RETURN
	END CATCH
	BEGIN TRY
		exec AddMechanicsCars @mechName, @carBrand
		EXEC addLog 'MechanicsCars Added', ''
	END TRY
	BEGIN CATCH
		SELECT @error = ERROR_MESSAGE()
		EXEC addLog 'MechanicsCars not added', @error
		COMMIT TRAN
		RETURN
	END CATCH
	EXEC addLog 'Everything was added', ''
	COMMIT TRAN
GO


SELECT * FROM LogTable