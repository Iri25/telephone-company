USE CompanieTelefonica;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspAllTests]
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @id_test INT, @name_test VARCHAR(20)
	DECLARE @table_name VARCHAR(20)

	-- Cursor pentru Tests
	DECLARE cursor_teste CURSOR FOR SELECT * FROM Tests 
	OPEN cursor_teste
	FETCH NEXT FROM cursor_teste INTO @id_test, @name_test

	DECLARE @testRunID_TRT INT, @testTableID_TRT INT, @startDate_TRT DATETIME
	DECLARE @testRunID_TR INT, @testID_description VARCHAR(20)
	DECLARE @sql_command NVARCHAR(50)

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SET @testID_description = @name_test
		INSERT INTO TestRuns(Description, StartAt) VALUES (@testID_description, GETDATE())
		SET @testRunID_TR = SCOPE_IDENTITY()
		DECLARE @no_rows INT

	    -- DELETE
		-- Cursor pentru TestTables
		DECLARE cursor_tables CURSOR FOR SELECT T.Name, TT.NoOfRows, TT.TableID FROM TestTables as TT INNER JOIN Tables T on TT.TableID = T.TableID WHERE TestID = @id_test ORDER BY Position
		OPEN cursor_tables
		FETCH NEXT FROM cursor_tables INTO @table_name, @no_rows, @testTableID_TRT

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @sql_command = N'delete from ' + @table_name
			EXECUTE sp_executesql @sql_command
			FETCH NEXT FROM cursor_tables INTO @table_name, @no_rows, @testTableID_TRT
		END

		CLOSE cursor_tables
		DEALLOCATE cursor_tables

		-- INSERT
        -- Cursor pentru TestTables 
		DECLARE cursor_tables_reverse CURSOR FOR SELECT T.Name, TT.NoOfRows, TT.TableID FROM TestTables AS TT INNER JOIN Tables T on TT.TableID = T.TableID WHERE TestID = @id_test ORDER BY Position desc
		OPEN cursor_tables_reverse
		FETCH NEXT FROM cursor_tables_reverse INTO @table_name, @no_rows, @testTableID_TRT

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @startDate_TRT = GETDATE() -- timp start
			EXECUTE uspInsertIntoTables @table_name, @no_rows
			INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt) VALUES (@testRunID_TR, @testTableID_TRT, @startDate_TRT, GETDATE())
			FETCH NEXT FROM cursor_tables_reverse INTO @table_name, @no_rows, @testTableID_TRT
		END

		CLOSE cursor_tables_reverse
		DEALLOCATE cursor_tables_reverse


		DECLARE @view_name varchar(20), @view_id INT
	    -- VIEW
		-- Cursor pentru TestViews 
		DECLARE cursor_views CURSOR FOR SELECT T.Name, TT.ViewID FROM TestViews AS TT INNER JOIN Views T on TT.ViewID = T.ViewID WHERE TestID = @id_test
		OPEN cursor_views
		FETCH NEXT FROM cursor_views INTO @view_name, @view_id

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @sql_command = N'select * from ' + @view_name
			SET @startDate_TRT = GETDATE()
			EXECUTE sp_executesql @sql_command
			INSERT INTO TestRunViews (TestRunID, ViewID, StartAt, EndAt) VALUES (@testRunID_TR, @view_id, @startDate_TRT, GETDATE())
			FETCH NEXT FROM cursor_views INTO @view_name, @view_id
		END

		CLOSE cursor_views
		DEALLOCATE cursor_views

		-- Update 
		UPDATE TestRuns
		SET EndAt = GETDATE()
		WHERE TestRunID = @testRunID_TR
		FETCH NEXT FROM cursor_teste INTO @id_test, @name_test

	END

	CLOSE cursor_teste
	DEALLOCATE cursor_teste

	SET NOCOUNT OFF

END