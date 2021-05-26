USE CompanieTelefonica;
GO

DELETE FROM Livrari
DELETE FROM Comenzi
DELETE FROM Cereri
DELETE FROM Oferte
DELETE FROM Clienti
DELETE FROM Servicii
DELETE FROM Promotii
DELETE FROM Sedii
DELETE FROM Angajati
DELETE FROM Produse

execute uspAllTests

SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews

DELETE FROM TestRuns
DELETE FROM TestRunTables
DELETE FROM TestRunViews