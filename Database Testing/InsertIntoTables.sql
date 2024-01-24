USE CompanieTelefonica;
GO

CREATE PROCEDURE [dbo].[uspInsertIntoTables]
(@table_name VARCHAR (20), @count INT)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @i INT = 1

	-- Sedii
	IF @table_name = 'Sedii'

	BEGIN

		DECLARE @numar_inregistrare_sediu INT, @nume_sediu VARCHAR(20), @id_manager INT, @nume_manager VARCHAR(20), @prenume_manager VARCHAR(20),
				@numar_telefon INT, @localitate_sediu VARCHAR(20), @strada_sediu VARCHAR(20), @numar_sediu INT, @produse_la_sediu VARCHAR(40)
		
		WHILE @i < @count
		BEGIN

			SET @numar_inregistrare_sediu = CAST((SELECT MAX (numar_inregistrare_sediu) + 1 FROM Sedii) AS INT)
			
			IF @numar_inregistrare_sediu IS NULL
			BEGIN
				SET @numar_inregistrare_sediu = 1
			END

			SET @nume_sediu = CAST(CHAR (39) + 'nume_sediu' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @id_manager = CAST((SELECT RAND() * (100 - 10) + 10) AS INT)
			SET @nume_manager = CAST(CHAR (39) + 'nume_menager' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @prenume_manager = CAST(CHAR (39) + 'prenume_menager' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @numar_telefon = CAST((SELECT RAND() * (100 - 10) + 10) AS INT)
			SET @localitate_sediu = CAST(CHAR (39) + 'localitate_sediu' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @strada_sediu = CAST(CHAR (39) + 'strada_sediu' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @numar_sediu = CAST((SELECT RAND() * (100 - 10) + 10) AS INT)
			SET @produse_la_sediu = CAST(CHAR (39) + 'produse_la_sediu ' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			INSERT INTO Sedii(numar_inregistrare_sediu, nume_sediu, id_manager, nume_manager, prenume_manager, numar_telefon, localitate_sediu, strada_sediu, numar_sediu, produse_la_sediu) 
			VALUES(@numar_inregistrare_sediu, @nume_sediu, @id_manager, @nume_manager, @prenume_manager, @numar_telefon, @localitate_sediu, @strada_sediu, @numar_sediu, @produse_la_sediu)
			SET @i = @i + 1
		END
	END

	-- Servicii
	ELSE IF @table_name = 'Servicii'
	BEGIN
		DECLARE @id_serviciu INT, @numar_inregistrare_sediu1 INT, @denumire VARCHAR(100), @descriere VARCHAR(100), @pret MONEY
		
		WHILE @i < @count
		BEGIN

			SET @id_serviciu = CAST((SELECT MAX (id_serviciu) + 1 FROM Servicii) AS INT)
			
			IF @id_serviciu IS NULL
			BEGIN
				SET @id_serviciu = 1
			END

			SET @numar_inregistrare_sediu1 = (SELECT TOP 1 numar_inregistrare_sediu FROM Sedii ORDER BY newid())
			SET @denumire = CAST(CHAR (39) + 'denumire' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @descriere = CAST(CHAR (39) + 'desriere' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @pret = 30.00
			INSERT INTO Servicii(id_serviciu, numar_inregistrare_sediu, denumire, descriere, pret) 
			VALUES(@id_serviciu, @numar_inregistrare_sediu1, @denumire, @descriere, @pret)
			SET @i = @i + 1
	    END
	END

	-- Clienti
	ELSE IF @table_name = 'Clienti'
	BEGIN
		DECLARE @id_client INT, @id_serviciu1 INT, @tip_client VARCHAR(20), @nume VARCHAR(20), @prenume VARCHAR(20), @telefon INT
		
		WHILE @i < @count
		BEGIN

			SET @id_client = CAST((SELECT MAX (id_client) + 1 FROM Clienti) AS INT)
			
			IF @id_client IS NULL
			BEGIN
				SET @id_client = 1
			END

			SET @id_serviciu1 = CAST((SELECT TOP 1 id_serviciu FROM Servicii ORDER BY newid()) AS INT)
			SET @tip_client = CAST(CHAR (39) + 'tip_client' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @nume = CAST(CHAR (39) + 'nume' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @prenume = CAST(CHAR (39) + 'prenume' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @telefon = CAST((SELECT RAND() * (100 - 10) + 10) AS INT)
			INSERT INTO Clienti(id_client, id_serviciu, tip_client, nume, prenume, numar_telefon) 
			VALUES(@id_client, @id_serviciu1, @tip_client, @nume, @prenume, @telefon)
			SET @i = @i + 1
	    END
	END

	-- Promotii
	ELSE IF @table_name = 'Promotii'
	BEGIN
		DECLARE @id_promotie INT, @numar_inregistrare_sediu2 INT, @tip_promotie VARCHAR(20), @durata VARCHAR(20)
		
		WHILE @i < @count
		BEGIN
			SET @id_promotie = CAST((SELECT MAX (id_promotie) + 1 FROM Promotii) AS INT)
			
			IF @id_promotie IS NULL
			BEGIN
				SET @id_promotie = 1
			END

			SET @numar_inregistrare_sediu2 = CAST((SELECT TOP 1 @numar_inregistrare_sediu2 FROM Servicii ORDER BY newid()) AS INT)
			SET @tip_promotie = CAST(CHAR (39) + 'tip_promotie' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @durata = CAST(CHAR (39) + 'durata' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			INSERT INTO Promotii(id_promotie, numar_inregistrare_sediu, tip_promotie, durata) 
			VALUES(@id_promotie, @numar_inregistrare_sediu2, @tip_promotie, @durata)
			SET @i = @i + 1
	    END
	END

	-- Oferte
	ELSE IF @table_name = 'Oferte'
	BEGIN
		DECLARE @id_oferta INT, @id_promotie1 INT, @id_client1 VARCHAR(20), @tip_oferta VARCHAR(20), @data_de_incepere DATE, @data_de_expirare DATE
		
		WHILE @i < @count
		BEGIN
			SET @id_oferta = CAST((SELECT MAX (id_oferta) + 1 FROM Oferte) AS INT)
			
			IF @id_oferta IS NULL
			BEGIN
				SET @id_oferta = 1
			END

			SET @id_promotie1 = CAST((SELECT TOP 1 @id_promotie1 FROM Servicii ORDER BY newid()) AS INT)
			SET @id_client1 = CAST((SELECT TOP 1 @id_client1 FROM Servicii ORDER BY newid()) AS INT)
			SET @tip_oferta = CAST(CHAR (39) + 'tip_oferta' + CAST(@i AS VARCHAR) + CHAR(39) AS VARCHAR)
			SET @data_de_incepere = getdate()
			SET @data_de_expirare = getdate()
			INSERT INTO Oferte(id_oferta, id_promotie, id_client, tip_oferta, data_de_incepere, data_de_expirare) 
			VALUES(@id_oferta, @id_promotie1, @id_client1, @tip_oferta, @data_de_incepere, @data_de_expirare)
			SET @i = @i + 1
	    END
	END

END;