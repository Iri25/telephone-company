create database CompanieTelefonica;
use CompanieTelefonica;

create table Sedii
(
numar_inregistrare_sediu int primary key,
nume_sediu varchar(20),
id_manager int,
nume_manager varchar(20),
prenume_manager varchar(20),
numar_telefon int,
localitate_sediu varchar(20),
strada_sediu varchar(20),
numar_sediu int,
produse_la_sediu varchar(40),
);

create table Servicii
(
id_serviciu int primary key,
numar_inregistrare_sediu int foreign key references Sedii(numar_inregistrare_sediu),
denumire varchar(100),
descriere varchar(100),
pret money,
);

create table Produse
(
 numar_inregistrare_produse int primary key,
 numar_inregistrare_sediu int foreign key references Sedii(numar_inregistrare_sediu),
 denumire varchar(100),
 descriere varchar(100),
 pret money,
 perioada_de_garantie varchar(20),
);

create table Promotii
(
id_promotie int primary key,
numar_inregistrare_sediu int foreign key references Sedii(numar_inregistrare_sediu),
tip_promotie varchar(20),
durata varchar(20),
);

create table Angajati
(
id_angajat int primary key,
numar_inregistrare_sediu int foreign key references Sedii(numar_inregistrare_sediu),
functie varchar(20),
nume varchar(20),
prenume varchar(20),
numar_telefon int,
);

create table Clienti
(
id_client int primary key,
id_serviciu int foreign key references Servicii(id_serviciu),
tip_client varchar(20),
nume varchar(20),
prenume varchar(20),
numar_telefon int,
);

create table Cereri
(
id_cerere int primary key,
id_client int foreign key references Clienti(id_client),
id_angajat int foreign key references Angajati(id_angajat),
data_cerere date
);

create table Comenzi
(
numar_inregistrare_comanda int primary key,
lista_numar_inregistrare_produse varchar(100),
id_angajat int foreign key references Angajati(id_angajat),
id_client int foreign key references Clienti(id_client),
data_comanda date,
pret money
);

create table Livrari
(
numar_inregistrare_livrare int primary key,
numar_inregistrare_comanda int foreign key references Comenzi(numar_inregistrare_comanda),
id_client int foreign key references Clienti(id_client),
data_livrare date,
judet varchar(20),
localitate varchar(20),
strada varchar(20),
numar int
);

create table Oferte
(
id_oferta int primary key,
id_promotie int foreign key references Promotii(id_promotie),
id_client int foreign key references Clienti(id_client), 
tip_oferta varchar(20),
data_de_incepere date,
data_de_expirare date,
);