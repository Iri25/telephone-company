use CompanieTelefonica;

create table VersiuneBazaDeDate
(
versiune int primary key
)

insert into VersiuneBazaDeDate values(0);
select * from VersiuneBazaDeDate;

go
create procedure uspModificaTipulDeDateComenzi
as
begin 
	if (not exists(select * from sys.tables where name = 'Comenzi'))
	begin
		print('Nu exista tabela Comenzi!');
	end
	else
	begin
		if(not exists(select * from sys.columns where name = 'data_comanda'))
		begin
			print('Nu exista coloana data_comanda');
		end
		else
		begin
			alter table Comenzi
			alter column data_comanda datetime
			print 'Tip de data modificat!'
			update VersiuneBazaDeDate
			set versiune = 1
		end
	end
end;

go
create or alter procedure uspAdaugaConstragereLocalitateSediu
as
begin
	if (not exists(select * from sys.tables where name = 'Sedii'))
	begin
		print('Nu exista tabela Sedii!');
	end
	else
	begin
		if(not exists(select * from sys.columns where name = 'localitate_sediu'))
		begin
			print('Nu exista coloana localitate_sediu');
		end
		else
		begin
			if (exists(select * from sys.default_constraints where name = 'localitate_sediu'))
			begin
				print('Exista deja o constrangere implicita cu numele!');
			end
			else
			begin
				alter table Sedii
				add constraint localitate_sediu default 'Cluj-Napoca' for localitate_sediu;
				print 'Constangere creata!'
				update VersiuneBazaDeDate
				set versiune = 2
			end
		end
	end
end;

go
create or alter procedure uspCreazaTabelaAdresa
as
begin
	if (exists(select *  from sys.tables where name = 'Adresa'))
	begin
		print('Exista deja tabela Adresa!');
	end
	else
	begin
		create table Adresa
		(
		id int not null primary key,
		judet nvarchar(50),
		localitate nvarchar(50),
		strada nvarchar(50),
		numar int,
		)
		print 'Tabela creata!'
		update VersiuneBazaDeDate
		set versiune = 3
	end
end;

go 
create or alter procedure uspAdaugaCampRaiting
as
begin
	if (not exists(select *  from sys.tables where name = 'Produse'))
	begin
		print('Nu exista tabela Produse!');
	end
	else
	begin
		alter table Produse
		add raiting int;
		print 'Camp creat!'
		update VersiuneBazaDeDate
		set versiune = 4
	end
end;

go 
create or alter procedure uspStergeConstrangereNumarInregistrareSediu
as
begin
	if (not exists(select * from sys.tables where name = 'Produse'))
	begin
		print('Nu exista tabela Produse!');
	end
	else
	begin
		if(not exists(select * from sys.columns where name = 'numar_inregistrare_sediu'))
		begin
			print('Nu exista coloana numar_inregistrare_sediu');
		end
		else
		begin
			alter table Produse
			drop constraint numar_inregistrare_sediu;
			print ('Constangere stearsa!');
			update VersiuneBazaDeDate
			set versiune = 5
		end
	end
end;

go
create procedure uspNuModificaTipulDataComenzi
as
begin
	if (not exists(select * from sys.tables where name = 'Comenzi'))
	begin
		print('Nu exista tabela Comenzi!');
	end
	else
	begin
		if(not exists(select * from sys.columns where name = 'data_comanda'))
		begin
			print('Nu exista coloana data_comanda');
		end
		else
		begin
			alter table Comenzi
			alter column data_comanda date
			print 'Tip de data modificat!'
			update VersiuneBazaDeDate
			set versiune = 1
		end
	end
end;

go
create or alter procedure uspStergeConstragereLocalitateSediu
as
begin
	if (not exists(select * from sys.tables where name = 'Sedii'))
	begin
		print('Nu exista tabela Sedii!');
	end
	else
	begin
		if(not exists(select * from sys.columns where name = 'localitate_sediu'))
		begin
			print('Nu exista coloana localitate_sediu');
		end
		else
		begin
			if (not exists(select * from sys.default_constraints where name = 'localitate_sediu'))
			begin
				print('Nu exista o constrangere implicita cu numele!');
			end
			else
			begin
				alter table Sedii
				drop localitate_sediu;
				print 'Constangere stearsa!'
				update VersiuneBazaDeDate
				set versiune = 2
			end
		end
	end
end;

go
create or alter procedure uspStergeTabelaAdresa
as
begin
	if (not exists(select *  from sys.tables where name = 'Adresa'))
	begin
		print('Nu exista tabela Adresa!');
	end
	else
	begin
		drop table Adresa;
		print 'Tabela stearsa!'
		update VersiuneBazaDeDate
		set versiune = 3
	end
end;

go 
create or alter procedure uspStergeCampRaiting
as
begin
	if (not exists(select *  from sys.tables where name = 'Produse'))
	begin
		print('Nu exista tabela Produse!');
	end
	else
	begin
		if(not exists(select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where table_name = 'Produse' and column_name = 'raiting'))
		begin
			print('Nu exista campul raiting!');
		end
		else
		begin
			alter table Produse
			drop column raiting
			print 'Camp sters!'
			update VersiuneBazaDeDate
			set versiune = 4;
		end
	end
end;

go 
create or alter procedure uspCreazaConstrangereNumarInregistrareSediu
as
begin
	if (not exists(select * from sys.tables where name = 'Produse'))
	begin
		print('Nu exista tabela Produse!');
	end
	else
	begin

		alter table Produse
		add constraint fk foreign key(numar_inregistrare_sediu)
		references Sedii(numar_inregistrare_sediu)
		on update cascade
		on delete cascade;
		print ('Constangere creata!');
		update VersiuneBazaDeDate
		set versiune = 5
	end
end;

go
create or alter procedure uspVersiuneBazaDeDate
@numar_versiune int
as
begin
	if @numar_versiune < 0
		begin 
			raiserror ('Numarul de versiune trebuie sa fie mai mare sau egal cu 0!', 11, 1);
			return 0;
		end
	if @numar_versiune > 5
		begin
			raiserror ('Numarul de versiune trebuie sa fie mai mare decat 5!', 11, 1);
			return 0;
		end

	declare @numar as int;
	select @numar = versiune from VersiuneBazaDeDate;

	while(@numar_versiune > @numar)
	begin
		if(@numar = 0)
		begin
			execute uspModificaTipulDeDateComenzi
			select @numar = versiune from VersiuneBazaDeDate;
		end
		if(@numar = 1)
		begin
			execute uspAdaugaConstragereLocalitateSediu
			select @numar = versiune from VersiuneBazaDeDate;
		end
		if(@numar = 2)
		begin
			execute uspCreazaTabelaAdresa
			select @numar = versiune from VersiuneBazaDeDate;
		end
		if(@numar = 3)
		begin
		execute uspAdaugaCampRaiting
			select @numar = versiune from VersiuneBazaDeDate;
		end
		if(@numar = 4)
		begin
			execute uspStergeConstrangereNumarInregistrareSediu
			select @numar = versiune from VersiuneBazaDeDate;
		end
		set @numar = @numar + 1;
	end
	
	update VersiuneBazaDeDate
	set versiune = @numar;

	while(@numar_versiune < @numar)
	begin
		if(@numar = 5)
		begin
			execute uspCreazaConstrangereNumarInregistrareSediu
			select @numar = versiune from VersiuneBazaDeDate;
		end
		if(@numar = 4)
		begin
		execute uspStergeCampRaiting
			select @numar = versiune from VersiuneBazaDeDate;
		end
		if(@numar = 3)
		begin
			execute uspStergeTabelaAdresa
			select @numar = versiune from VersiuneBazaDeDate;
		end
		if(@numar = 2)
		begin
			execute uspStergeConstragereLocalitateSediu
			select @numar = versiune from VersiuneBazaDeDate;
		end
		if(@numar = 1)
		begin
			execute uspNuModificaTipulDataComenzi
			select @numar = versiune from VersiuneBazaDeDate;
		end
		set @numar = @numar - 1;
	end

	update VersiuneBazaDeDate
	set versiune = @numar;

end;

set @numar = 5;
execute uspVersiuneBazaDeDate @numar_versiune = @numar;