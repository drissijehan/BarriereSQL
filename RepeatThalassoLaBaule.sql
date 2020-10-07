   drop table #prems
select MasterId,
min(date_Reservation) as Prem_Resa,
min(case when Statut_Reservation = 4 then Date_Debut else null end ) as Prem_Sej
into #prems
FROM [BARRIERE].[dbo].[H_RESADETAILSEJOUR] r
where Code_Etablissement <> 'MARNA'
and Type_Sejour = 1
and Classe_de_Chambre <> 'PSEUDO'
and r.Delete_Date is null
--and Type_Offre= 42
and (Date_Reservation between '20160501' and dateadd(day,1,'20190430')
or Date_Debut between '20160501' and '20190430' )
group by MasterId
select  * from #prems

drop table #client
select 
distinct s.MasterID
,case when  Prem_Resa  between '20180501' and '20190430' then 1 else 0 end as Primo
,sexe, Client_IB, Age, Pays_De_Residence
into #client
FROM [BARRIERE].[dbo].[H_ResaDetailSejour] s
inner join (select * FROM [BARRIERE].[dbo].[Contacts]) c
on s.MasterID=c.MasterID
inner join #prems p
on s.MasterID= p.MasterID
where Date_Reservation between '20180501' and '20190430'
and Type_Sejour=1
and Code_Etablissement in ('LBAHR') --not in ('COUNH', 'MARNA', 'DEARD', 'LTQWE')
and Classe_de_Chambre <> 'PSEUDO'
and Type_Offre=42
select count (distinct MasterID) from #client where Primo=1


-------------------------------
/*SEJOURs*/
drop table #primo
select 
distinct s.MasterID, Id_Sejour_WS
,case when  Prem_Resa  between '20180501' and '20190501' then 1 else 0 end as Primo
,sexe, Client_IB, Age, Pays_De_Residence
, DATEDIFF(day,Date_Debut, Date_Fin) as Nuitées
, DATEDIFF(day, Date_Reservation,Date_Debut) as Anticipation
,sum(isnull(Share_Amount,0) + isnull(Prd_Resv_Separate_Line_Amount,0)
+ isnull(Prd_Resv_Combined_Line_Amount,0) + isnull([Fixed_Charges_Amount],0)) as Panier
into #primo
FROM [BARRIERE].[dbo].[H_ResaDetailSejour] s
inner join (select * FROM [BARRIERE].[dbo].[Contacts]) c
on s.MasterID=c.MasterID
inner join #prems p
on s.MasterID= p.MasterID
where Date_Reservation between '20180501' and '20190501'
and Type_Sejour=1
and Statut_Reservation=4
and Code_Etablissement in ('LBAHR')
and Classe_de_Chambre <> 'PSEUDO'
and Type_Offre=42
group by s.MasterID,Id_Sejour_WS,case when  Prem_Resa  between '20180501' and '20190501' then 1 else 0 end
,sexe, Client_IB, Age, Pays_De_Residence, Rate_Code
,DATEDIFF(day,Date_Debut, Date_Fin) 
,DATEDIFF(day, Date_Reservation,Date_Debut)
select * from #primo
select count(distinct Id_Sejour_WS) from #primo
select count(distinct MasterID) from #primo


select count (distinct MasterID) as client
,count (distinct Id_Sejour_WS) as sejour
,sum(Paye_Chambre_HT) as CA_Heb_Ht,
sum(paye_chambre_TTC) as CA_Heb_TTC,
sum(Paye_Total_HT) as CA_Tot_Ht,
sum (Paye_Total_TTC) as CA_Tot_TTC
,sum(Nb_Nuits) as Nuitees,
sum(Paye_Chambre_HT) / sum(Nb_Nuits) as RMC
,avg(datediff(day,Date_Reservation,Date_Debut)+1) as Anticipation
,sum(datediff(day,Date_Reservation,Date_Debut)+1) as Anticipation2
,sum(Nb_Adultes)as Adulte, sum(Nb_Enfants) as Enfant
from [BARRIERE].[dbo].[H_RESADETAILSEJOUR]
 where date_debut between '20180501' and '20190430'
   and Code_Etablissement = 'LBAHR'
 and Statut_Reservation in (3, 4 )
and Type_Sejour = 1
 and Delete_Date is null
 and datediff(day,Date_Debut,Date_Fin) > 0
 and Classe_de_Chambre <> 'PSEUDO'
/*type offre ou rate segment = IPTH */
 and Type_Offre = 42  