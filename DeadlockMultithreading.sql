USE CompanieTelefonicaBD;

-- Deadlock multithreading

GO
CREATE OR ALTER PROCEDURE Deadlock1 AS
BEGIN
	BEGIN TRAN
	UPDATE Angajati SET numar_telefon = 749955109 where nume = 'Checherita' and prenume = 'Aurel'
	WAITFOR DELAY '00:00:10'
	UPDATE Cereri SET data_cerere ='2020-10-29' where id_angajat = 20
	COMMIT TRAN
END

GO
CREATE OR ALTER PROCEDURE Deadlock2 AS
BEGIN
	BEGIN TRAN
	SET DEADLOCK_PRIORITY HIGH
	BEGIN TRAN
	UPDATE Cereri SET data_cerere ='2020-10-29'
	WAITFOR DELAY '00:00:10'
	UPDATE Angajati SET numar_telefon = 749955109 where nume = 'Checherita' and prenume = 'Aurel'
	COMMIT TRAN
END

GO
SELECT * FROM Angajati;
SELECT * FROM Clienti;
SELECT * FROM Cereri;