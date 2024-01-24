USE CompanieTelefonica
GO

CREATE VIEW viewAngajati
AS
SELECT nume, prenume, functie from Angajati A
INNER JOIN Cereri C on A.id_angajat = C.id_angajat
GO

SELECT * FROM viewAngajati
GO

CREATE VIEW viewClienti
AS
SELECT nume, prenume, tip_client from Clienti Cl
INNER JOIN Cereri Ce on Cl.id_client = Ce.id_client
GO

SELECT * FROM viewClienti
GO

CREATE NONCLUSTERED INDEX IX_Angajati ON Angajati(functie);
GO

CREATE NONCLUSTERED INDEX IX_Clienti ON Clienti(tip_client)
GO

SELECT * FROM Clienti
SELECT * FROM Servicii