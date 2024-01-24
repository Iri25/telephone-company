USE CompanieTelefonica
GO

--Angajati
GO
CREATE OR ALTER FUNCTION uf_verificareAngajati 
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

GO
CREATE OR ALTER PROCEDURE usp_citesteAngajati
AS
BEGIN
	SELECT * FROM Angajati
END

GO
CREATE OR ALTER PROCEDURE usp_adaugaAngajati 
(
@id_angajat INT,
@numar_inregistrare_sediu INT,
@functie VARCHAR(20),
@nume VARCHAR(20),
@prenume VARCHAR(20),
@numar_telefon INT
)
AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = dbo.uf_verificareAngajati(@id_angajat, @numar_inregistrare_sediu, @functie, @nume, @prenume, @numar_telefon);

	IF (EXISTS (SELECT id_angajat FROM Angajati WHERE @id_angajat = id_angajat))
		SET @ERRORS= @ERRORS + 'Id angajat exista! ';

	IF (@ERRORS != '')
		PRINT @ERRORS;
	ELSE
		INSERT INTO Angajati (id_angajat, numar_inregistrare_sediu, functie, nume, prenume, numar_telefon) VALUES (@id_angajat, @numar_inregistrare_sediu, @functie, @nume, @prenume, @numar_telefon)
END

GO
CREATE OR ALTER PROCEDURE usp_updateAngajati
(
@id_angajat INT,
@numar_inregistrare_sediu INT,
@functie VARCHAR(20),
@nume VARCHAR(20),
@prenume VARCHAR(20),
@numar_telefon INT
)
AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = dbo.uf_verificareAngajati(@id_angajat, @numar_inregistrare_sediu, @functie, @nume, @prenume, @numar_telefon);

	IF (NOT EXISTS (SELECT id_angajat FROM  Angajati WHERE @id_angajat = id_angajat))
		SET @ERRORS= @ERRORS + 'Id angajat nu exista! ';

	IF ( @ERRORS != '')
		PRINT @ERRORS;
	ELSE
		UPDATE Angajati 
		SET numar_inregistrare_sediu = @numar_inregistrare_sediu, functie = @functie, nume = nume, prenume = @prenume, numar_telefon = @numar_telefon
		WHERE id_angajat = @id_angajat;
END

GO
CREATE OR ALTER PROCEDURE usp_stergeAngajati
(
@id_angajat INT
)
AS
BEGIN
	DELETE FROM Angajati WHERE id_angajat = @id_angajat
	if ( @@ROWCOUNT = 0 )
		PRINT 'Id angajat exista! ';
END

--Clienti
GO 
CREATE OR ALTER FUNCTION uf_verifareClienti
(
@id_client INT,
@id_serviciu INT,
@tip_client INT,
@nume VARCHAR(20),
@prenume VARCHAR(20),
@numar_telefon int
)
RETURNS NVARCHAR(255) AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = '';

	IF (@id_client < 1)
		SET @ERRORS = @ERRORS + 'Id client nu poate fi nul sau negativ! ';

	IF (NOT EXISTS (SELECT id_serviciu FROM Servicii WHERE id_serviciu = @id_serviciu))
		SET @ERRORS = @ERRORS + 'Id serviciu nu exista! ';

	if ( @tip_client = '')
		SET @ERRORS = @ERRORS + 'Tip client invalid! ';
	
	IF (PATINDEX('%[^a-z]%', @nume) > 0)
		SET @ERRORS = @ERRORS + 'Nume invalid! '

	IF (PATINDEX('%[^a-z]%', @prenume) > 0)
		SET @ERRORS = @ERRORS + 'Prenume invalid! '

	IF (@numar_telefon < 0)
		SET @ERRORS = @ERRORS + 'Numarul de telefon invalid!';

	RETURN @ERRORS;
END

GO
CREATE OR ALTER PROCEDURE usp_citesteClienti
AS
BEGIN
	SELECT * FROM Clienti
END

GO
CREATE OR ALTER PROCEDURE usp_adaugaClienti
(
@id_client INT,
@id_serviciu INT,
@tip_client INT,
@nume VARCHAR(20),
@prenume VARCHAR(20),
@numar_telefon INT
)
AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = dbo.uf_verifareClienti(@id_client, @id_serviciu, @tip_client, @nume, @prenume, @numar_telefon);

	IF (EXISTS (SELECT id_client FROM Clienti WHERE id_client = @id_client))
		SET @ERRORS= @ERRORS + 'Id client exista! ';

	IF ( @ERRORS != '')
		PRINT @ERRORS;
	ELSE
		INSERT INTO Clienti(id_client, id_serviciu, tip_client, nume, prenume, numar_telefon) VALUES (@id_client, @id_serviciu, @tip_client, @nume, @prenume, @numar_telefon)
END

GO
CREATE OR ALTER PROCEDURE usp_updateClienti
(
@id_client INT,
@id_serviciu INT,
@tip_client INT,
@nume VARCHAR(20),
@prenume VARCHAR(20),
@numar_telefon INT
)
AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = dbo.uf_verifareClienti(@id_client, @id_serviciu, @tip_client, @nume, @prenume, @numar_telefon);

	IF (NOT EXISTS (SELECT id_client FROM Clienti WHERE id_client = @id_client))
		SET @ERRORS= @ERRORS + 'Id client nu exista! ';

	IF ( @ERRORS != '')
		PRINT @ERRORS;
	ELSE
		UPDATE Clienti 
		SET id_serviciu = @id_serviciu, tip_client = @tip_client, nume = @nume, prenume = @prenume, numar_telefon = @numar_telefon
		WHERE id_client = @id_client;
END
GO

CREATE OR ALTER PROCEDURE usp_stergeClienti
(
@id_client INT
)
AS
BEGIN
	DELETE FROM Clienti WHERE id_client = @id_client
	IF ( @@ROWCOUNT = 0 )
		PRINT 'Id client  nu exista! ';
END
GO 

--Cereri
CREATE OR ALTER FUNCTION uf_verificareCereri
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
		SET @ERRORS= @ERRORS + 'Id cerere nu poate fi nul sau negativ! ';

	IF (NOT EXISTS (SELECT id_client FROM Clienti WHERE id_client = @id_client))
		SET @ERRORS= @ERRORS + 'Id client invalid! ';

	IF (NOT EXISTS (SELECT id_angajat FROM Angajati WHERE id_angajat = @id_angajat))
		SET @ERRORS= @ERRORS + 'Id angajat invalid! ';

	RETURN @ERRORS;
END

GO
CREATE OR ALTER PROCEDURE usp_citesteCereri
AS
BEGIN
	SELECT * FROM Cereri
END

GO
CREATE OR ALTER PROCEDURE usp_adaugaCereri 
(
@id_cerere INT, 
@id_client INT,
@id_angajat INT,
@data_cerere DATE
)
AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = dbo.uf_verificareCereri(@id_cerere, @id_client, @id_angajat, @data_cerere);

	IF (EXISTS (SELECT id_cerere FROM Cereri WHERE id_cerere = @id_cerere))
		SET @ERRORS= @ERRORS + 'Id cerere exista! ';

	IF ( @ERRORS != '')
		PRINT @ERRORS;
	ELSE
		INSERT INTO Cereri(id_cerere, id_client, id_angajat, data_cerere ) VALUES (@id_cerere, @id_client, @id_angajat, @data_cerere)
END

GO
CREATE OR ALTER PROCEDURE usp_updateCereri
(
@id_cerere INT, 
@id_client INT,
@id_angajat INT,
@data_cerere DATE
)
AS
BEGIN
	DECLARE @ERRORS NVARCHAR(255) = dbo.uf_verificareCereri(@id_cerere, @id_client, @id_angajat, @data_cerere);

	IF (NOT EXISTS (SELECT data_cerere FROM Cereri WHERE id_cerere = @id_cerere))
		SET @ERRORS = @ERRORS + 'Inregistrare inexistenta! ';

	IF ( @ERRORS != '')
		PRINT @ERRORS;
	ELSE
		UPDATE Cereri
		SET data_cerere = @data_cerere
		WHERE id_cerere = @id_cerere
END

GO
CREATE OR ALTER PROCEDURE usp_stergeCereri
(
@id_cerere INT, 
@id_comanda INT
)
AS
BEGIN
	DELETE FROM Cereri WHERE id_cerere = @id_cerere
	IF ( @@ROWCOUNT = 0 )
		PRINT 'Inregistrare Cereri inexistenta!'
END
