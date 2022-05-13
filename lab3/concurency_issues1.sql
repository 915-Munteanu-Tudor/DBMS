USE ServiceAuto
GO

BEGIN TRAN
EXEC addLogConcurrencyIssue 'dirty read - before update'
UPDATE Mechanics SET name_mechanic = 'Alexandros' WHERE name_mechanic = 'DirtyMechanic' 
EXEC addLogConcurrencyIssue 'dirty read - before update'

WAITFOR DELAY '00:00:10:000'

ROLLBACK TRAN


exec ClearLogs


SELECT * FROM LogConcurrencyIssues

--non repeatable read
EXEC AddMechanic 'DirtyMechanic1', 69, 0

BEGIN TRAN
	EXEC addLogConcurrencyIssue 'non-repeatable read - before update'
	WAITFOR DELAY '00:00:10'

	UPDATE Mechanics 
	SET name_mechanic = 'Codrin'
	WHERE name_mechanic = 'DirtyMechanic1'
	
	EXEC addLogConcurrencyIssue 'non-repeatable read - after update'

COMMIT TRAN

DELETE FROM Mechanics WHERE name_mechanic='Codrin'

SELECT * FROM LogConcurrencyIssues

SELECT @@TRANCOUNT

--phantom reads

DELETE FROM Mechanics WHERE id_mechanic = 1111

BEGIN TRAN
	EXEC addLogConcurrencyIssue 'phantom read - before insert'
	WAITFOR DELAY '00:00:10'
	INSERT INTO dbo.Mechanics Values(1111, 'Teodor', 3, 1, 21);

	EXEC addLogConcurrencyIssue 'phantom read - after insert'

COMMIT TRAN

--deadlock
delete from Mechanics where name_mechanic = 'DeadlockMechanic'
delete from Cars where car_brand = 'DeadlockCar'

EXEC AddMechanic 'DeadlockMechanic', 1, 0
EXEC AddCar 'DeadlockCar', 23, 125

SET DEADLOCK_PRIORITY low
BEGIN TRAN

	EXEC addLogConcurrencyIssue 'deadlock1 - before update'

	UPDATE Cars
	SET car_repair_cost = 222
	WHERE car_brand = 'DeadlockCar'

	EXEC addLogConcurrencyIssue 'deadlock1 - between updates'

	WAITFOR DELAY '00:00:10:000'

	UPDATE Mechanics
	SET experience_mechanic = 222
	WHERE name_mechanic = 'DeadlockMechanic'

	EXEC addLogConcurrencyIssue 'deadlock1 - after updates'
COMMIT TRAN

SELECT * FROM Cars
SELECT * FROM Mechanics

--update conflict

ALTER DATABASE ServiceAuto
SET ALLOW_SNAPSHOT_ISOLATION ON

ALTER DATABASE ServiceAuto
SET ALLOW_SNAPSHOT_ISOLATION off

alter database ServiceAuto set READ_COMMITTED_SNAPSHOT on

SET TRANSACTION ISOLATION LEVEL SNAPSHOT

BEGIN TRAN
	EXEC addLogConcurrencyIssue 'update conflict1 - before select'

	SELECT * FROM Mechanics

	EXEC addLogConcurrencyIssue 'update conflict - between'

	WAITFOR DELAY '00:00:10:000'

	UPDATE Mechanics
	SET experience_mechanic = 666
	WHERE name_mechanic = 'DeadlockMechanic'

	EXEC addLogConcurrencyIssue 'update conflict - after update'
COMMIT TRAN