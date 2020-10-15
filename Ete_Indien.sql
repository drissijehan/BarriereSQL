/*Ete Indien*/

drop table #dat
select *
into #dat
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and type_sejour = 1 -- Indiv Loisir
and Rate_Code in ('PROMO2')
and Date_Debut <> Date_Fin -- Pas de day use
and Code_Etablissement in ('DEAHN','DEAHG','LBAHR','LBAML','ENGGE','LILHC','DINGH','RIBRR') -- Etablissements participants
and Date_Reservation between '20200825' and dateadd(day,1,'20200904') -- Date Reservation	
and Date_Debut between '20200830' and '20201031'  -- Date Sejour


drop table #dat2
select *
into #dat2
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and type_sejour = 1 -- Indiv Loisir
and Rate_Code in ('PROMO1')
and Date_Debut <> Date_Fin -- Pas de day use
and Code_Etablissement in ('CANGA','CANHM') -- Etablissements participants
and Date_Reservation between '20200825' and dateadd(day,1,'20200904') -- Date Reservation	
and Date_Debut between '20200830' and '20201031'  -- Date Sejour
select * from #dat2

drop table #dat3
select * into #dat3 from #dat union select * from #dat2
select * from #dat3

select count ( distinct MasterID) AS CLient 
,count (distinct id_sejour_ws) as sejour 
,sum(Nb_Nuits) as Nuit
from #dat3


select  Code_Etablissement ,[Classe_de_Chambre]
,count (distinct MasterID) as Client
,sum(Nb_Nuits) as Nuit
,sum(Paye_Chambre_HT) as CA_Hebgt_HT
 from #dat3
group by [Classe_de_Chambre],Code_Etablissement 

/*Chiffres clés*/

select --Code_Etablissement,
count (distinct MasterID) as Client
,count (distinct Id_Sejour_Ws) as Sejour
,sum (Nb_Nuits) as Nuitees
,sum (Nb_Nuits)/count (distinct Id_Sejour_Ws) as Nuitee_Moy_Sej
,AVG(datediff(day,Date_Reservation,Date_Debut)) as Anticipation
,sum(isnull(Paye_Chambre_HT,0)) as Panier_Chambre_HT
,sum(isnull(Paye_Total_HT,0)) as Panier_Total_HT -- sur checked out uniquement 
,sum(isnull(Paye_Total_TTC,0)) as Panier_Total_TTC -- sur checked out uniquement 
,Sum (Paye_chambre_HT) / sum(Nb_Nuits) as RMC
,sum(isnull(Paye_Total_TTC,0))/count (distinct MasterID) as Panier_Moy_TTC
FROM #dat3
group by Code_Etablissement



/*Profil*/


  drop table #prems
select MasterId,
min(date_Reservation) as Prem_Resa
into #prems
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR] r
where Code_Etablissement <> 'MARNA'
and Type_Sejour = 1
and Classe_de_Chambre <> 'PSEUDO'
and r.Delete_Date is null
and Date_Reservation between '20170825' and dateadd(day,1,'20200904') -- 3 ans
group by MasterId
select top 100 * from #prems


-----------------------------------------------

drop table #profil
select 
Sexe, Age, Client_IB, Pays_De_Residence
,case when  Prem_Resa  between '20200825' and '20200904' then 1 else 0 end as Primo
into #profil
 from  [SIDBDWH].[qts].[T_CONTACTS] c
 inner join #prems p
 on c.MasterID=p.MasterID
where c.MasterId in (select MasterId from #dat3)
select * from #profil

select avg(Age)as age
from #profil

-----------------------------------
----------------------------------

/* Client IB */

/*Chiffres clés*/

select count (distinct MasterID) as Client
,count (distinct Id_Sejour_Ws) as Sejour
,sum (Nb_Nuits) as Nuitees
,sum (Nb_Nuits)/count (distinct Id_Sejour_Ws) as Nuitee_Moy_Sej
,AVG(datediff(day,Date_Reservation,Date_Debut)) as Anticipation
,sum(isnull(Paye_Chambre_HT,0)) as Panier_Chambre_HT
,sum(isnull(Paye_Total_HT,0)) as Panier_Total_HT -- sur checked out uniquement 
,sum(isnull(Paye_Total_TTC,0)) as Panier_Total_TTC
,Sum (Paye_chambre_HT) / sum(Nb_Nuits) as RMC
,sum(isnull(Paye_Total_TTC,0))/count (distinct MasterID) as Panier_Moy_TTC
FROM #dat3
where MasterID in (select MasterID from  [SIDBDWH].[qts].[T_CONTACTS]
where Client_IB=1)


select  Code_Etablissement ,[Classe_de_Chambre]
,count (distinct MasterID) as Client
,sum(Nb_Nuits) as Nuit
,sum(Paye_Chambre_HT) as CA_Hebgt_HT
 from #dat3
 where MasterID in (select MasterID from  [SIDBDWH].[qts].[T_CONTACTS]
where Client_IB=1)
group by [Classe_de_Chambre],Code_Etablissement 

/* Profil */
select 
Sexe, Age, Client_IB, Pays_De_Residence
,case when  Prem_Resa  between '20200825' and '20200904' then 1 else 0 end as Primo
 from  [SIDBDWH].[qts].[T_CONTACTS] c
 inner join #prems p
 on c.MasterID=p.MasterID
where c.MasterId in (select MasterId from #dat3)
and Client_IB=1


---------------------------
----------------------------
/* Canal de Vente */

select LB_CANAL_RESERVATION--, LB_CANAL_DETAIL 
,count (distinct Id_Sejour_WS) as Sejour
FROM #dat3 r
inner join [SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
on r.Id_Sejour_WS=s.ID_SEJOUR
group by LB_CANAL_RESERVATION
, LB_CANAL_DETAIL 


---------------------------
----------------------------
/* VERSUS N-1 */
---------------------------
----------------------------

drop table #dat19
select *
into #dat19
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and type_sejour = 1 -- Indiv Loisir
and Rate_Code in ('PROMO2')
and Date_Debut <> Date_Fin -- Pas de day use
and Code_Etablissement in ('DEAHN','DEAHG','LBAHH','LBAHR','LBAML','DINGH') -- Etablissements participants
and Date_Reservation between '20190827' and dateadd(day,1,'20190906') -- Date Reservation	
and Date_Debut between '20190830' and '20191031'  -- Date Sejour
and [Source_Reservation] in (18,27, 21,22,23,24) -- commandes web 18 = OWS |  27 = HB
select * from #dat19

drop table #dat19_2
select *
into #dat19_2
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and type_sejour = 1 -- Indiv Loisir
and Rate_Code in ('PROMO3')
and Date_Debut <> Date_Fin -- Pas de day use
and Code_Etablissement in ('LTQWE') -- Etablissements participants
and Date_Reservation between '20190827' and dateadd(day,1,'20190906') -- Date Reservation	
and Date_Debut between '20190830' and '20191031'  -- Date Sejour
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
select * from #dat19_2

drop table #dat19_3
select * into #dat19_3 from #dat19 union select * from #dat19_2
select * from #dat19_3

select count ( distinct MasterID) AS CLient 
,count (distinct id_sejour_ws) as sejour 
,sum(Nb_Nuits) as Nuit
from #dat19_3                               


/*Chiffres clés*/

select --Code_Etablissement,
count (distinct MasterID) as Client
,count (distinct Id_Sejour_Ws) as Sejour
,sum (Nb_Nuits) as Nuitees
,AVG(datediff(day,Date_Reservation,Date_Debut)) as Anticipation
,sum(isnull(Paye_Chambre_HT,0)) as Panier_Chambre_HT
,sum(isnull(Paye_Total_HT,0)) as Panier_Total_HT -- sur checked out uniquement 
,sum(isnull(Paye_Total_TTC,0)) as Panier_Total_TTC -- sur checked out uniquement 
,Sum (Paye_chambre_HT) / sum(Nb_Nuits) as RMC
FROM #dat19_3
group by Code_Etablissement

/* Client IB */

/*Chiffres clés*/

select count (distinct MasterID) as Client
,count (distinct Id_Sejour_Ws) as Sejour
,sum (Nb_Nuits) as Nuitees
,AVG(datediff(day,Date_Reservation,Date_Debut)) as Anticipation
,sum(isnull(Paye_Chambre_HT,0)) as Panier_Chambre_HT
,sum(isnull(Paye_Total_HT,0)) as Panier_Total_HT -- sur checked out uniquement 
,sum(isnull(Paye_Total_TTC,0)) as Panier_Total_TTC
,Sum (Paye_chambre_HT) / sum(Nb_Nuits) as RMC
FROM #dat19_3
where MasterID in (select MasterID from  [SIDBDWH].[qts].[T_CONTACTS]
where Client_IB=1)
