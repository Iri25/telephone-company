USE CompanieTelefonica;
GO

CREATE VIEW ViewSedii
AS
SELECT dbo.Sedii.*
FROM     dbo.Sedii
GO

CREATE VIEW ViewServicii
AS
SELECT dbo.Servicii.id_serviciu, dbo.Servicii.numar_inregistrare_sediu, dbo.Servicii.denumire, dbo.Servicii.descriere, dbo.Servicii.pret, dbo.Clienti.id_client AS Expr1, dbo.Clienti.tip_client, dbo.Sedii.nume_sediu AS Expr2, 
                  dbo.Sedii.numar_inregistrare_sediu AS Expr3, dbo.Servicii.denumire AS Expr4, dbo.Servicii.descriere AS Expr5
FROM     dbo.Clienti INNER JOIN
                  dbo.Servicii ON dbo.Clienti.id_serviciu = dbo.Servicii.id_serviciu INNER JOIN
                  dbo.Sedii ON dbo.Servicii.numar_inregistrare_sediu = dbo.Sedii.numar_inregistrare_sediu
GO

create view ViewPromotii 
as 

SELECT count(Promotii.tip_promotie) AS [numar_tip_promotii], Promotii.id_promotie, Promotii.numar_inregistrare_sediu AS Expr3, Promotii.durata, Sedii.nume_sediu, Sedii.numar_inregistrare_sediu, Sedii.id_manager, 
                  Sedii.nume_manager
FROM     Promotii INNER JOIN
                  Sedii ON Promotii.numar_inregistrare_sediu = Sedii.numar_inregistrare_sediu
GROUP BY Promotii.id_promotie, Promotii.numar_inregistrare_sediu, Promotii.durata, Sedii.nume_sediu, Sedii.numar_inregistrare_sediu, Sedii.id_manager,Sedii.nume_manager
GO

CREATE VIEW ViewOferte
AS
SELECT dbo.Clienti.id_client, dbo.Clienti.tip_client, dbo.Clienti.id_serviciu, dbo.Oferte.id_client AS Expr1, dbo.Oferte.id_promotie, dbo.Oferte.id_oferta, dbo.Promotii.durata, dbo.Promotii.numar_inregistrare_sediu, dbo.Sedii.nume_manager, 
                  dbo.Sedii.nume_sediu, dbo.Servicii.numar_inregistrare_sediu AS Expr2, dbo.Servicii.denumire, dbo.Servicii.descriere
FROM     dbo.Clienti INNER JOIN
                  dbo.Oferte ON dbo.Clienti.id_client = dbo.Oferte.id_client INNER JOIN
                  dbo.Promotii ON dbo.Oferte.id_promotie = dbo.Promotii.id_promotie INNER JOIN
                  dbo.Sedii ON dbo.Promotii.numar_inregistrare_sediu = dbo.Sedii.numar_inregistrare_sediu INNER JOIN
                  dbo.Servicii ON dbo.Clienti.id_serviciu = dbo.Servicii.id_serviciu AND dbo.Sedii.numar_inregistrare_sediu = dbo.Servicii.numar_inregistrare_sediu
GO

