USE ServiceAuto

--exec ClearLogs
--dirty read
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- SOLUTION
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
SELECT * FROM Mechanics
EXEC addLogConcurrencyIssue 'dirty read - before select'
WAITFOR DELAY '00:00:10:000'
SELECT * FROM Mechanics

EXEC addLogConcurrencyIssue 'dirty read - after select'

COMMIT TRAN

--non repeatable reads
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- SOLUTION
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
	
	EXEC addLogConcurrencyIssue 'non-repeatable read - before select'

	SELECT * FROM Mechanics

	EXEC addLogConcurrencyIssue 'non-repeatable read - between select'

	WAITFOR DELAY '00:00:10:000'

	SELECT * FROM Mechanics

	EXEC addLogConcurrencyIssue 'non-repeatable read - after select'

COMMIT TRAN

SELECT @@TRANCOUNT

--phantom reads
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN

	EXEC addLogConcurrencyIssue 'phantom read - before select'

	SELECT * FROM Mechanics

	EXEC addLogConcurrencyIssue ' phantom read - between select'

	WAITFOR DELAY '00:00:10:000'

	SELECT * FROM Mechanics

	EXEC addLogConcurrencyIssue 'phantom read - after select'

COMMIT TRAN

--deadlock
SET DEADLOCK_PRIORITY high
BEGIN TRAN

	EXEC addLogConcurrencyIssue 'deadlock1 - before update'

	UPDATE Mechanics
	SET experience_mechanic = 333
	WHERE name_mechanic = 'DeadlockMechanic'

	EXEC addLogConcurrencyIssue 'deadlock1 - between updates'

	WAITFOR DELAY '00:00:10:000'

	UPDATE Cars
	SET car_repair_cost = 333
	WHERE car_brand = 'DeadlockCar'

	EXEC addLogConcurrencyIssue 'deadlock1 - after updates'
COMMIT TRAN

--update conflict
BEGIN TRAN
	EXEC addLogConcurrencyIssue 'update conflict2 - before update'

	UPDATE Mechanics
	SET experience_mechanic = 777
	WHERE name_mechanic = 'DeadlockMechanic'

	WAITFOR DELAY '00:00:10:000'

	EXEC addLogConcurrencyIssue 'update conflict2 - after update'

COMMIT TRAN
select * from Mechanics