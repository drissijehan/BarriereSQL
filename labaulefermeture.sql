select count (distinct MasterID) as Client
,count (distinct Id_Sejour_WS) as sejour
,sum (isnull([CA_Sejour_Hebergement_TTC],0)) as CA_Sejour_Hebergement_TTC
,sum (isnull([CA_Sejour_TTC],0)) as CA_Sejour_TTC
FROM [BARRIERE].[dbo].[H_Sejour]
where Code_Etablissement = 'LBAHR'
and Date_Debut_du_Sejour between '20161219' and '20191220'
and Type_de_Sejour = 1 	
and Statut_du_Sejour in (3,4)


/*CLIENT ROYAL A HERMITAGE CASTEL PENDANT LA FERMETURE*/
select -- distinct MasterID 
distinct Id_Sejour_WS
,sum (isnull([CA_Sejour_Hebergement_TTC],0)) as CA_Sejour_Hebergement_TTC
,sum (isnull([CA_Sejour_TTC],0)) as CA_Sejour_TTC
,DATEDIFF(day,[Date_Debut_du_Sejour],[Date_Fin_du_Sejour]) as Nuitée
FROM [BARRIERE].[dbo].[H_Sejour]
where Code_Etablissement in ('LBAHH', 'LBAML')
and Date_Debut_du_Sejour between '20191220' and '20200105'
and Type_de_Sejour = 1 	
and Statut_du_Sejour in (3,4)
and MasterID in (select distinct MasterID
FROM [BARRIERE].[dbo].[H_Sejour]
where Code_Etablissement = 'LBAHR'
and Date_Debut_du_Sejour between '20161219' and '20191220'
and Type_de_Sejour = 1 	
and Statut_du_Sejour in (3,4) )
group by Id_Sejour_WS,[Date_Fin_du_Sejour],[Date_Debut_du_Sejour]


/*CLIENT LE ROYAL PENDATNT LA FERMETURE*/
select count (distinct MasterID) as Clients 
,count (distinct Id_Sejour_WS) as Sejours
,sum (isnull([CA_Sejour_Hebergement_TTC],0)) as CA_Sejour_Hebergement_TTC
,sum (isnull([CA_Sejour_TTC],0)) as CA_Sejour_TTC
FROM [BARRIERE].[dbo].[H_Sejour]
where Code_Etablissement in ( 'LBAML','LBAHH')
and Date_Debut_du_Sejour between '20191220' and '20200105'
and Type_de_Sejour = 1 	
and Statut_du_Sejour in (3,4)
and MasterID in (select distinct MasterID
FROM [BARRIERE].[dbo].[H_Sejour]
where Code_Etablissement = 'LBAHR'
and Date_Debut_du_Sejour between '20161219' and '20191220'
and Type_de_Sejour = 1 	
and Statut_du_Sejour in (3,4) )