USE CompanieTelefonicaBD;
GO

-- verificare Angajati
GO
CREATE OR ALTER FUNCTION ufVerificareAngajati 
(
@id_angajat INT,
@numar_inregistrare_sediu INT,
@functie VARCHAR(20),
@nume VARCHAR(20),
@prenume VARCHAR(20),
@numar_telefon INT
)
RETURNS NVARCHAR(255) AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = '';

	IF (@id_angajat < 1)
		SET @ERRORS = @ERRORS + 'Id angajat nu poate fi nul sau negativ! ';

	IF (NOT EXISTS (SELECT @numar_inregistrare_sediu FROM Sedii WHERE @numar_inregistrare_sediu = @numar_inregistrare_sediu))
		SET @ERRORS = @ERRORS + 'Id sediu nu exista! ';
		
	IF (PATINDEX('%[^a-z]%', @functie) > 0)
		SET @ERRORS = @ERRORS + 'Functie invalida! '

	IF (PATINDEX('%[^a-z]%', @nume) > 0)
		SET @ERRORS = @ERRORS + 'Nume invalid! '

	IF (PATINDEX('%[^a-z]%', @prenume) > 0)
		SET @ERRORS = @ERRORS + 'Prenume invalid! '

	IF (@numar_telefon < 0)
		SET @ERRORS = @ERRORS + 'Numarul de telefon invalid!';

	RETURN @ERRORS;
END

-- verificare Clienti
GO 
CREATE OR ALTER FUNCTION ufVerifareClienti
(
@id_client INT,
@id_serviciu INT,
@tip_client VARCHAR(20),
@nume VARCHAR(20),
@prenume VARCHAR(20),
@numar_telefon int
)
RETURNS NVARCHAR(255) 
AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = '';

	IF (@id_client < 1)
		SET @ERRORS = @ERRORS + 'Id client nu poate fi nul sau negativ! ';

	IF (NOT EXISTS (SELECT id_serviciu FROM Servicii WHERE id_serviciu = @id_serviciu))
		SET @ERRORS = @ERRORS + 'Id serviciu nu exista! ';

	IF (PATINDEX('%[^ a-z ]%', @tip_client) > 0)
		SET @ERRORS = @ERRORS + 'Tip client invalid! ';
	
	IF (PATINDEX('%[^a-z]%', @nume) > 0)
		SET @ERRORS = @ERRORS + 'Nume invalid! '

	IF (PATINDEX('%[^a-z]%', @prenume) > 0)
		SET @ERRORS = @ERRORS + 'Prenume invalid! '

	IF (@numar_telefon < 0)
		SET @ERRORS = @ERRORS + 'Numarul de telefon invalid!';

	RETURN @ERRORS;
END

-- verificare Cereri
GO
CREATE OR ALTER FUNCTION ufVerificareCereri
(
@id_cerere INT, 
@id_client INT,
@id_angajat INT,
@data_cerere DATE
)
RETURNS NVARCHAR(255) AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = '';

	IF (@id_cerere < 1)
		SET @ERRORS = @ERRORS + 'Id cerere nu poate fi nul sau negativ! ';

	IF (NOT EXISTS (SELECT id_client FROM Clienti WHERE id_client = @id_client))
		SET @ERRORS= @ERRORS + 'Id client invalid! ';

	IF (NOT EXISTS (SELECT id_angajat FROM Angajati WHERE id_angajat = @id_angajat))
		SET @ERRORS = @ERRORS + 'Id angajat invalid! ';

	RETURN @ERRORS;
END


-- rollback pe intreaga procedura stocata
GO
CREATE OR ALTER PROCEDURE uspAdaugaDate1 
(
@id_angajat INT,
@numar_inregistrare_sediu INT,
@functie VARCHAR(20),
@nume_angajat VARCHAR(20),
@prenume_angajat VARCHAR(20),
@numar_telefon_angajat INT,

@id_client INT,
@id_serviciu INT,
@tip_client VARCHAR(20),
@nume_client VARCHAR(20),
@prenume_client VARCHAR(20),
@numar_telefon_client INT,

@id_cerere INT, 
@data_cerere DATE
)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			-- validare Angajati
			DECLARE @ERRORS_ANGAJAT NVARCHAR(255) = dbo.ufVerificareAngajati(@id_angajat, @numar_inregistrare_sediu, @functie, @nume_angajat, @prenume_angajat, @numar_telefon_angajat);

			IF (EXISTS (SELECT id_angajat FROM Angajati WHERE @id_angajat = id_angajat))
				SET @ERRORS_ANGAJAT = @ERRORS_ANGAJAT + 'Id angajat exista! ';

			IF (@ERRORS_ANGAJAT != '')
			BEGIN
				PRINT @ERRORS_ANGAJAT;
			RAISERROR('Invalid Angajati Data', 14, 1)
			END
			ELSE
				INSERT INTO Angajati (id_angajat, numar_inregistrare_sediu, functie, nume, prenume, numar_telefon) VALUES (@id_angajat, @numar_inregistrare_sediu, @functie, @nume_angajat, @prenume_angajat, @numar_telefon_angajat)

			-- validare Clienti
			DECLARE @ERRORS_CLIENT NVARCHAR(255) = dbo.ufVerifareClienti(@id_client, @id_serviciu, @tip_client, @nume_client, @prenume_client, @numar_telefon_client);

			IF (EXISTS (SELECT id_client FROM Clienti WHERE id_client = @id_client))
				SET @ERRORS_CLIENT = @ERRORS_CLIENT + 'Id client exista! ';

			IF ( @ERRORS_CLIENT != '')
			BEGIN
				PRINT @ERRORS_CLIENT;
				RAISERROR('Invalid Clienti Data', 14, 1)
			END
			ELSE
				INSERT INTO Clienti(id_client, id_serviciu, tip_client, nume, prenume, numar_telefon) VALUES (@id_client, @id_serviciu, @tip_client, @nume_client, @prenume_client, @numar_telefon_client)

			-- validare Cereri
			DECLARE @ERRORS_CERERE NVARCHAR(255) = dbo.ufVerificareCereri(@id_cerere, @id_client, @id_angajat, @data_cerere);

			IF (EXISTS (SELECT id_cerere FROM Cereri WHERE id_cerere = @id_cerere))
				SET @ERRORS_CERERE = @ERRORS_CERERE + 'Id cerere exista! ';

			IF ( @ERRORS_CERERE != '')
			BEGIN
				PRINT @ERRORS_CERERE;
				RAISERROR('Invalid Cereri Data', 14, 1)
			END 
			ELSE
				INSERT INTO Cereri(id_cerere, id_client, id_angajat, data_cerere ) VALUES (@id_cerere, @id_client, @id_angajat, @data_cerere)

			COMMIT TRAN
			PRINT('Tranzactia s-a terminat cu succes!')
			SELECT 'Transaction commited'
		END TRY

		BEGIN CATCH
			ROLLBACK TRAN
			SELECT 'Transaction rolled back'
		END CATCH
END

GO
SELECT * FROM Angajati;
SELECT * FROM Clienti;
SELECT * FROM Cereri;

GO
EXEC uspAdaugaDate1 20, 124551, 'Consultant', 'Marin', 'Teodor', 751709807, 12, 111, 'Cu abonament', 'Ionescu', 'Ciprian', 768469290, 6, '2021-05-01';

GO
SELECT * FROM Angajati;
SELECT * FROM Clienti;
SELECT * FROM Cereri;

-- rollback partial pe procedura stocata
GO
CREATE OR ALTER PROCEDURE uspAdaugaDate2
(
@id_angajat INT,
@numar_inregistrare_sediu INT,
@functie VARCHAR(20),
@nume_angajat VARCHAR(20),
@prenume_angajat VARCHAR(20),
@numar_telefon_angajat INT,

@id_client INT,
@id_serviciu INT,
@tip_client VARCHAR(20),
@nume_client VARCHAR(20),
@prenume_client VARCHAR(20),
@numar_telefon_client INT,

@id_cerere INT, 
@data_cerere DATE
)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			-- validare Angajati
			DECLARE @ERRORS_ANGAJAT NVARCHAR(255) = dbo.ufVerificareAngajati(@id_angajat, @numar_inregistrare_sediu, @functie, @nume_angajat, @prenume_angajat, @numar_telefon_angajat);

			IF (EXISTS (SELECT id_angajat FROM Angajati WHERE @id_angajat = id_angajat))
				SET @ERRORS_ANGAJAT = @ERRORS_ANGAJAT + 'Id angajat exista! ';

			IF (@ERRORS_ANGAJAT != '')
			BEGIN
				PRINT @ERRORS_ANGAJAT;
			RAISERROR('Invalid Angajati Data', 14, 1)
			END
			ELSE
				INSERT INTO Angajati (id_angajat, numar_inregistrare_sediu, functie, nume, prenume, numar_telefon) VALUES (@id_angajat, @numar_inregistrare_sediu, @functie, @nume_angajat, @prenume_angajat, @numar_telefon_angajat)

			COMMIT TRAN
		END TRY

		BEGIN CATCH
			ROLLBACK TRAN
			SELECT 'Transaction rolled back at Angajati'
		END CATCH

	BEGIN TRAN
		BEGIN TRY
			-- validare Clienti
			DECLARE @ERRORS_CLIENT NVARCHAR(255) = dbo.ufVerifareClienti(@id_client, @id_serviciu, @tip_client, @nume_client, @prenume_client, @numar_telefon_client);

			IF (EXISTS (SELECT id_client FROM Clienti WHERE id_client = @id_client))
				SET @ERRORS_CLIENT = @ERRORS_CLIENT + 'Id client exista! ';

			IF ( @ERRORS_CLIENT != '')
			BEGIN
				PRINT @ERRORS_CLIENT;
				RAISERROR('Invalid Clienti Data', 14, 1)
			END
			ELSE
				INSERT INTO Clienti(id_client, id_serviciu, tip_client, nume, prenume, numar_telefon) VALUES (@id_client, @id_serviciu, @tip_client, @nume_client, @prenume_client, @numar_telefon_client)

			COMMIT TRAN
		END TRY

		BEGIN CATCH
			ROLLBACK TRAN
			SELECT 'Transaction rolled back at Clienti'
		END CATCH

	BEGIN TRAN
		BEGIN TRY
			-- validare Cereri
			DECLARE @ERRORS_CERERE NVARCHAR(255) = dbo.ufVerificareCereri(@id_cerere, @id_client, @id_angajat, @data_cerere);

			IF (EXISTS (SELECT id_cerere FROM Cereri WHERE id_cerere = @id_cerere))
				SET @ERRORS_CERERE = @ERRORS_CERERE + 'Id cerere exista! ';

			IF ( @ERRORS_CERERE != '')
			BEGIN
				PRINT @ERRORS_CERERE;
				RAISERROR('Invalid Cereri Data', 14, 1)
			END 
			ELSE
				INSERT INTO Cereri(id_cerere, id_client, id_angajat, data_cerere ) VALUES (@id_cerere, @id_client, @id_angajat, @data_cerere)
			
			COMMIT TRAN
		END TRY

		BEGIN CATCH
			ROLLBACK TRAN
			SELECT 'Transaction rolled back at Cereri'
		END CATCH
END

GO
SELECT * FROM Angajati;
SELECT * FROM Clienti;
SELECT * FROM Cereri;

GO
EXEC uspAdaugaDate2 23, 124551, 'Consultant', 'Pop', 'Teodor', 751712807, 8, 110, 'Cu abonament', 'Popescu', 'Vladimir', 768469990, 5, '2021-05-01';

GO
SELECT * FROM Angajati;
SELECT * FROM Clienti;
SELECT * FROM Cereri;