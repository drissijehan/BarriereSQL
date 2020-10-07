/* VENTES EXCLUSIVES AUTOMNE */

   drop table #prems
select MasterId,
min(date_Reservation) as Prem_Resa,
min(case when Statut_Reservation = 4 then Date_Debut else null end ) as Prem_Sej
into #prems
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR] r
where Code_Etablissement <> 'MARNA'
and Type_Sejour = 1
and Classe_de_Chambre <> 'PSEUDO'
and r.Delete_Date is null
and (Date_Reservation between '20110101' and dateadd(day,1,'20190922')
or Date_Debut between '20110101' and '20210108' )
group by MasterId
select top 100 * from #prems

drop table #client_VEA
select 
distinct s.MasterID
,case when  Prem_Resa  between '20200908' and '20200922' then 1 else 0 end as Primo
,sexe, Client_IB, Age, Pays_De_Residence
,Rate_Code
into #client_VEA
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR] s
inner join (select * FROM [SIDBDWH].[qts].[T_CONTACTS]) c
on s.MasterID=c.MasterID
inner join #prems p
on s.MasterID= p.MasterID
where Date_Reservation between '20200908' and '20200923'
and Date_Debut between '20200914' and '20210108'
and Type_Sejour=1
and Code_Etablissement not in ('COUNH', 'MARNA', 'ENGLE', 'PARHF', 'LBAHH', 'STBCG')
and Classe_de_Chambre <> 'PSEUDO'
and [Rate_Code] in ('SOLDES1','PKBBADV','EXPROM1','BOOPROM1')

SELECT count (distinct MasterID) from #client_VEA
select count (distinct MasterID) as Client,
Rate_Code from #client_VEA where Primo = 1
group by Rate_Code order by Client desc

-------------------------------
/*SEJOURs*/
drop table #primo
select 
distinct s.MasterID, Id_Sejour_WS
,case when  Prem_Resa  between '20200908' and '20200922' then 1 else 0 end as Primo
,sexe, Client_IB, Age, Pays_De_Residence, Rate_Code
, DATEDIFF(day,Date_Debut, Date_Fin) as Nuitées
, DATEDIFF(day, Date_Reservation,Date_Debut) as Anticipation
,sum(isnull(Share_Amount,0) + isnull(Prd_Resv_Separate_Line_Amount,0)
+ isnull(Prd_Resv_Combined_Line_Amount,0) + isnull([Fixed_Charges_Amount],0)) as Panier
into #primo
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR] s
inner join (select * FROM [SIDBDWH].[qts].[T_CONTACTS]) c
on s.MasterID=c.MasterID
inner join #prems p
on s.MasterID= p.MasterID
where Date_Reservation between '20200908' and '20200923'
and Date_Debut between '20200914' and '20210108'
and Type_Sejour=1
and Code_Etablissement not in ('COUNH', 'MARNA', 'ENGLE', 'PARHF', 'LBAHH', 'STBCG')
and Classe_de_Chambre <> 'PSEUDO'
and [Rate_Code] in ('SOLDES1','PKBBADV','EXPROM1','BOOPROM1')
group by s.MasterID,Id_Sejour_WS,case when  Prem_Resa  between '20200908' and '20200922' then 1 else 0 end
,sexe, Client_IB, Age, Pays_De_Residence, Rate_Code
,DATEDIFF(day,Date_Debut, Date_Fin) 
,DATEDIFF(day, Date_Reservation,Date_Debut)
select * from #primo

select sum (panier) as panier, count (distinct MasterID), avg(Anticipation) as Client from #primo WHERE primo =1
-------------------------
/* CANAL DE RESERVATION */
drop table #canaux
select 
distinct Id_Sejour
,case when  Prem_Resa  between '20200908' and '20200922' then 1 else 0 end as Primo
,LB_CANAL_RESERVATION,LB_CANAL_DETAIL,LB_TYPE_CANAL_RESERVATION
,sum([NB_DUREE_SEJOUR]) as [NB_DUREE_SEJOUR]
into #canaux
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
inner join (select * FROM [SIDBDWH].[qts].[T_CONTACTS]) c
on s.ID_CLIENT=c.MasterID
inner join #prems p
on s.ID_CLIENT= p.MasterID
where DH_RESERVATION between '20200908' and '20200923'
and ID_TYPE_SEJOUR=1
and CO_ETABLISSEMENT_QTS not in ('COUNH', 'MARNA', 'ENGLE', 'PARHF', 'LBAHH', 'STBCG')
and [LB_RATE_CODE_PREM_COM] in ('SOLDES1','PKBBADV','EXPROM1','BOOPROM1')
group by s.ID_CLIENT,Id_Sejour,case when  Prem_Resa  between '20200908' and '20200922' then 1 else 0 end
,LB_CANAL_RESERVATION,LB_CANAL_DETAIL,LB_TYPE_CANAL_RESERVATION
select * from #canaux

drop table #canal
select 
distinct s.MasterID, Id_Sejour_WS
,case when  Prem_Resa  between '20200908' and '20200922' then 1 else 0 end as Primo
,sexe, Client_IB, Age, Pays_De_Residence, Rate_Code
, DATEDIFF(day,Date_Debut, Date_Fin) as Nuitées
, DATEDIFF(day, Date_Reservation,Date_Debut) as Anticipation
,sum(isnull(Share_Amount,0) + isnull(Prd_Resv_Separate_Line_Amount,0)
+ isnull(Prd_Resv_Combined_Line_Amount,0) + isnull([Fixed_Charges_Amount],0)) as Panier
, Source_Reservation
into #canal
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR] s
inner join (select * FROM [SIDBDWH].[qts].[T_CONTACTS]) c
on s.MasterID=c.MasterID
inner join #prems p
on s.MasterID= p.MasterID

where Date_Reservation between '20200908' and '20200923'
and Type_Sejour=1
and Code_Etablissement not in ('COUNH', 'MARNA', 'ENGLE', 'PARHF', 'LBAHH', 'STBCG')
and Classe_de_Chambre <> 'PSEUDO'
and [Rate_Code] in ('SOLDES1','PKBBADV','EXPROM1','BOOPROM1')
group by s.MasterID,Id_Sejour_WS,case when  Prem_Resa  between '20200908' and '20200922' then 1 else 0 end
,sexe, Client_IB, Age, Pays_De_Residence, Rate_Code
,DATEDIFF(day,Date_Debut, Date_Fin) 
,DATEDIFF(day, Date_Reservation,Date_Debut)
,Source_Reservation
select * from #canal

select count (distinct MasterID) as Client,sum (nuitées) as Nuitées, Source_Reservation,LB_SOURCE_RESERVATION
,sum(Panier) as panier
from #canal c
left  join  [SIDBDWH].[ref].[T_SOURCE_RESERVATION] sr
on c.Source_Reservation=sr.ID_SOURCE_RESERVATION
group by Source_Reservation,LB_SOURCE_RESERVATION


/*CRM*/
/*	
-- Recherche Opération dans données CRM	
select *	
FROM [SIDBDWH].[qts].[T_OPERATION]	
where slabel  like '%automne%' --- ici	
and tsStart >= '20190101' */	
	
/*Stockage id opeartion crm*/	
select 83097103 as IdOperation into #op_crm	
	

/* 83097103_Ventes exclusives - OP1090 */
Drop table #cibles
select b.MasterID,count(distinct iOperationId) as nb_op,
count(distinct b.iDeliveryId) as nb_envois,
convert(datetime, convert(date,max(tsstart))) as dt_der_contact ,
convert(datetime, convert(date,min(tsstart))) as dt_prem_contact
into #cibles
FROM [SIDBDWH].[qts].[T_DELIVERY] d
inner join [SIDBDWH].[qts].[T_TRACKINGLOG] b
on d.iDeliveryId = b.iDeliveryId
where iOperationId in (83097103)
and iDeleteStatus = 0 and slabel not like '%BAT%'
and slabel not like '%test%' and tsstart is not null
group by b.MasterID  

select top 1000 * from #cibles 

select count (distinct  masterid ) from #cibles -- cibles
select count (distinct  masterid ) from #cibles
where MasterID in (select MasterID from #client_VEA ) --Client reservant
select * from #primo  where MasterID in (select MasterID from #cibles)  -- Sejour Reservant 
select count (distinct MasterID) as Client, count (distinct id_Sejour_WS) as Sejour, sum(Nuitées) as Nuitées
,sum (Panier) as Panier
 from #primo  where MasterID in (select MasterID from #cibles)  -- Sejour Reservant 
select count (distinct MasterID) as Client, count (distinct id_Sejour_WS) as Sejour, sum(Nuitées) as Nuitées
, sum(Panier) as panier
 from #primo

select sum (Panier) from #primo  where MasterID in (select MasterID from #cibles)

 --NON ciblé
 select * from #client_VEA where masterid not in (select MasterID from #cibles)
select sum (Panier), sum (Nuitées), COUNT(distinct Id_Sejour_WS) 
from #primo  where MasterID not in (select MasterID from #cibles)  -- Sejour  NON CIBLé