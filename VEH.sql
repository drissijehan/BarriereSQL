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
and (Date_Reservation between '20110101' and dateadd(day,1,'20200405')
or Date_Debut between '20110101' and '20200405' )
group by MasterId
select top 100 * from #prems

drop table #client_VEH
select 
distinct s.MasterID
,case when  Prem_Resa  between '20200107' and '20200121' then 1 else 0 end as Primo
,sexe, Client_IB, Age, Pays_De_Residence
into #client_VEH
FROM [BARRIERE].[dbo].[H_ResaDetailSejour] s
inner join (select * FROM [BARRIERE].[dbo].[Contacts]) c
on s.MasterID=c.MasterID
inner join #prems p
on s.MasterID= p.MasterID
where Date_Reservation between '20200107' and '20200121'
and Type_Sejour=1
and Code_Etablissement not in ('COUNH', 'MARNA', 'DEARD', 'LTQWE')
and Classe_de_Chambre <> 'PSEUDO'
and [Rate_Code] in ('SOLDES2', 'SOLDES1','PROMOOTA1','EXPROM1','BOOPROM1')

-------------------------------
/*SEJOURs*/
drop table #primo
select 
distinct s.MasterID, Id_Sejour_WS
,case when  Prem_Resa  between '20200107' and '20200121' then 1 else 0 end as Primo
,sexe, Client_IB, Age, Pays_De_Residence, Rate_Code
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
where Date_Reservation between '20200107' and '20200121'
and Type_Sejour=1
and Code_Etablissement not in ('COUNH', 'MARNA', 'DEARD', 'LTQWE')
and Classe_de_Chambre <> 'PSEUDO'
and [Rate_Code] in ('SOLDES2', 'SOLDES1','PROMOOTA1','EXPROM1','BOOPROM1')
group by s.MasterID,Id_Sejour_WS,case when  Prem_Resa  between '20200107' and '20200121' then 1 else 0 end
,sexe, Client_IB, Age, Pays_De_Residence, Rate_Code
,DATEDIFF(day,Date_Debut, Date_Fin) 
,DATEDIFF(day, Date_Reservation,Date_Debut)


select * from #primo where Primo=1


/*CRM*/
/* 07012020_Ventes exclusives - OP1090 */
Drop table #cibles
select b.MasterID,count(distinct iOperationId) as nb_op,
count(distinct b.iDeliveryId) as nb_envois,
convert(datetime, convert(date,max(tsstart))) as dt_der_contact ,
convert(datetime, convert(date,min(tsstart))) as dt_prem_contact
into #cibles
FROM [BARRIERE].[dbo].[Delivery] d
inner join [BARRIERE].[tracking].[BroadLog] b
on d.iDeliveryId = b.iDeliveryId
where iOperationId in (67254888)
and iDeleteStatus = 0 and slabel not like '%BAT%'
and slabel not like '%test%' and tsstart is not null
group by b.MasterID  

select * from #cibles 

select count (distinct  masterid ) from #cibles -- cibles
select count (distinct  masterid ) from #cibles
where MasterID in (select MasterID from #client_VEH ) --Client reservant
select * from #primo  where MasterID in (select MasterID from #cibles)  -- Sejour Reservant 
select sum (Panier) from #primo  where MasterID in (select MasterID from #cibles)

 --NON ciblé
 select * from #client_VEH where masterid not in (select MasterID from #cibles)
select sum (Panier), sum (Nuitées), COUNT(distinct Id_Sejour_WS) 
from #primo  where MasterID not in (select MasterID from #cibles)  -- Sejour  NON CIBLé