Drop table #perimetre
Select 'STBCG' as Hotel , 
'20180701' as Dt_Min,
'20190630' as Dt_Max
into  #perimetre

Drop Table #sej_canaux 
select g.* ,
/*case when Canal_Vente = 'OTA' and (Rate_Code like 'BOO%' or Nom_Societe like '%Booking%')  then Canal_Vente + ' - Booking'
when Canal_Vente = 'OTA' and (Rate_Code like 'EX%' or Nom_Societe like '%Expedia%') then Canal_Vente + ' - Expedia'
when Canal_Vente in ('OTA','Vente Flash') and (Rate_Code like '%VTP%' or Nom_Societe like '%Vente%Priv%') then Canal_Vente + ' - Vente Privée'
when Canal_Vente = 'Direct' and [Source_Reservation] in (27,18) then Canal_Vente + ' - HB.com'
else Canal_Vente end as Canal_Det,*/
case when SourceAff = 1 then 'Affiliation'
when SourceAff = 0 and Canal_Vente = 'OTA' and (Rate_Code like 'BOO%' or Nom_Societe like '%Booking%')  then Canal_Vente + ' - Booking'
when SourceAff = 0 and Canal_Vente = 'OTA' and (Rate_Code like 'EX%' or Nom_Societe like '%Expedia%') then Canal_Vente + ' - Expedia'
when  SourceAff = 0 and Canal_Vente in ('OTA','Vente Flash') and (Rate_Code like '%VTP%' or Nom_Societe like '%Vente%Priv%') then Canal_Vente + ' - Vente Privée'
when  SourceAff = 0 and Canal_Vente = 'Direct' and [Source_Reservation] in (27,18) then Canal_Vente + ' - HB.com'
when  SourceAff = 0 and Canal_Vente = 'Direct' and [Source_Reservation] not in (27,18) 
and Flag_Agence = 1 and Nom_Societe not in ('WONDERBOX')  then 'TO'
else Canal_Vente end as Canal_Det,
case when Flag_Agence =1 then o.nom_Societe else null end as Agence_B,
case when Gpe = 1 then  Id_Agence else g.MasterID end as Id_Contact_Pays
into #sej_canaux
from
(
select Code_Etablissement, Id_Detail_Sejour_WS,
case when [Rate_Category] between 1 and 11 then '1 - Loisir Indiv'
when [Rate_Category] =13 then '2 - Pro Gpe'
when [Rate_Category] =14 then '3 - Loisir Gpe'
when [Rate_Category] = 15 then '4 - Pro Indiv'
when [Rate_Category] = 17 then '5 - Festival'
else '6 - Autres' end  as Type_Sejour,
case when (Rate_Code like '%OTA%' 
or Rate_Code like '%EX' 
or Rate_Code like 'BOO%' 
or Rate_Code like 'EX%'  
or Rate_Code like 'WD%'  
or Rate_Code like 'HT%'  
or Rate_Code like 'AGO%'  
or Rate_Code like 'SM%'  
or Rate_Code like 'WH%'  
or Rate_Code in ('OBZBARPDJ','VITAL', 'SE020718',
'SE041017','SE060618','SE070218','SE090818','SE131018',
'SE131117','SE140518','SE140718','SE140817','SE150917',
'SE190418','SE220118','SE240918','SE251017','SE280717',
'SE291217','SEBE020718','SEBE060618','SEBE090818','SEBE140518',
'SEBE140718','SEBE190418') )
then 'OTA'
when (Rate_Code like 'TO%' 
or Rate_Code like '%TO' 
or  Rate_Code in ('AGV','OCTGOLF') 
)then 'TO'
when (Rate_Code like 'FHR%'
or Rate_Code like 'L[0-9]%'
or Rate_Code like 'N[0-9]%'
or Rate_Code like 'X%'
or Rate_Code like 'WON%'
or Rate_Code like 'CONN%'
or  Rate_Code in ('ALTOUR','AMCENTU','AMPLAT',
'ECGPK','FROSCH','N1WQ','N4F','N4QZ','N750','NE3','LFE',
'NFM','NH7','NIC','NLCN','NOZE','NTRK','NXBV','NXT2',
'TRVLEAD', 'V2M', 'VIRTPROM', 'VIRTUOSO','LHS','LWS',
'VISA','VITA','VITANET', 'S1','S30') )
then 'Affiliation'
when (Rate_Code like '%VTP'
or Rate_Code like 'SR%'
or Rate_Code like 'VTP%'
or Rate_Code like 'VP%'
or Rate_Code like 'VF%'
or Rate_Code like 'VC%' )
then 'Vente Flash'
when (Rate_Code like 'MBF%'
or Rate_Code like 'PK%'
or Rate_Code like 'FLEX%'
or Rate_Code like 'TS%'
or Rate_Code like 'NFL%'
or Rate_Code like 'CREA%'
or Rate_Code like 'TH%'
or Rate_Code like 'PROMO%'
or Rate_Code like 'SOLDES%'
or Rate_Code like 'BAR%'
or Rate_Code like 'FETE%'
or Rate_Code like 'BR%'
or Rate_Code like 'CP%'
or Rate_Code like 'EVENT%'
or Rate_Code like 'IB%'
or Rate_Code like 'TLB%'
or Rate_Code like 'NEGO%'
or Rate_Code like 'PROT%'
or Rate_Code like 'DETOX%'
or Rate_Code like 'S0%' 
or Rate_Code like 'S1%' 
or Rate_Code like 'C[0-2]%' 
or Rate_Code like 'BAN%' 
or  Rate_Code in ('ACCIND','ALSAWWAF','ATLBB',
'BPT','CA','CO1BB','CREA23','DAY','DAYSPA',
'DSAPK','EARLY','EGERIES','ETOILE','FTBE','TLB',
'GDL','HOTEL13','OFSP','PAQUES','VLGA','WALKIN') )
and Rate_Code not like '%OTA%' 
and Rate_Code not like '%EX' 
and Rate_Code not like 'BOO%' 
and Rate_Code not like 'EX%'  
and Rate_Code not like 'WD%'  
and Rate_Code not like 'HT%'  
and Rate_Code not like 'AGO%'  
and Rate_Code not like 'SM%'
and Rate_Code not like '%VTP%'
and Rate_Code not like 'TO%' 
and Rate_Code not like '%TO' 
then 'Direct'
else 'Direct' end as Canal_Vente, 
Rate_Code, 
Ach_conf_no,
r.MasterId, 
[Source_Reservation],
[Rate_Category],
m.CodeValS as Source_Ref,
t.CodeValS as Rate_Cat,
case when m.CodeValS in ('ALB','CCS','CCSF','CCSM','ACS',
'CCSW','INT','RE','TOP','TOPM','TOPW','WI','A3C') then '1 - Direct non Web'
when m.CodeValS in ('FB','HB','OWS') then '2 - Direct Web'
when m.CodeValS in ('AM','AU','GA','SA','TOPAS','WO','AV',
'TOPE','GSOLH','GSOMLH','CROLH','CROWLH','CROAMLH') then '3 - Indirect non Web'
when m.CodeValS in ('ADS','AF','AS','SVF','SWLH','SWHLH',
'SWPLH','ASLH','CROAMLH','JJTLH','TRVZLH','WHTLH','AHC') then '4 - Indirect Web'
else '5 - Autres' end as Canal_Distrib,
[Date_Debut], [Date_Fin],
case when [Rate_Category] in (13,14) then 1 else 0 end as Gpe, 
case when [Interm_Commission] is null then 0 else 1 end as Flag_Agence, 
c1.Nom_Societe  as SourceOp, 
case when c1.Nom_Societe like 'Relai%Ch%teau%' 
or c1.Nom_Societe like '%Leading%' 
or c1.Nom_Societe like '%Virtuoso%'  
or c1.Nom_Societe like '%preferred%' 
then 1 else 0 end as SourceAff, 
c2.Nom_Societe  as Agence, 
case when [Interm_Commission] is null then [Groupe_Commission] else [Interm_Commission] end as Id_Agence, 
(case when (Nb_Adultes + Nb_Enfants) > 0 then Nb_Nuits else 0 end) as Nuitees,
(isnull(Share_Amount,0) + isnull(Prd_Resv_Separate_Line_Amount,0) 
+ isnull(Prd_Resv_Combined_Line_Amount,0) + isnull([Fixed_Charges_Amount],0))  as Tarif_Ttc  
  FROM [BARRIERE].[dbo].[H_ResaDetailSejour] r
  left join [BARRIERE].[ref].[Misc] m 
  on m.TypeRef = 'GB_ORI_CODE' 
  and [Source_Reservation] = m.[CodeValN]
    left join [BARRIERE].[ref].[Misc] t 
  on t.TypeRef = 'GB_RATE_CAT' 
  and [Rate_Category] = t.[CodeValN]
    left join [BARRIERE].[dbo].[Contacts] c1
  on r.[Groupe_Commission] = c1.MasterID 
    left join [BARRIERE].[dbo].[Contacts] c2
  on r.[Interm_Commission] = c2.MasterID 
  where r.Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO' 
  and Rate_Category not in (18, 12)
  and Code_Etablissement like (select hotel from #perimetre) 
 -- and Code_Etablissement not in ('MARNA')
  and Date_Debut between (select dt_min from #perimetre)  and (select dt_max from #perimetre) 
  and Statut_Reservation in (3,4) ) g
  left join [BARRIERE].[dbo].Contacts o
	on g.Id_Agence = o.MasterID 
   


--- select Canal_Vente, Rate_Code, count(distinct ach_conf_no)  from #sej_canaux group by Canal_Vente, Rate_Code order by Canal_Vente, Rate_Code 
-- select top 5010 * from #sej_canaux where canal_vente = 'TO' and rate_code = 'C16'

drop table #sej
  select distinct c.*,
  case when Date_Debut = Prem_Sej then 1 else 0 end as Nouveau
  into #sej
from  #sej_canaux c
left join (select MasterId, 
min(Date_Debut) as Prem_Sej
from [BARRIERE].[dbo].[H_ResaDetailSejour] r
where r. Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO' 
  and r.Rate_Category not in (18, 12)
  and ([Rate_Category] between 1 and 11 )
  and r.Code_Etablissement <> 'MARNA'
  and Date_Debut >= '20101101' 
  and Statut_Reservation in (3,4) 
  group by MasterId) r 
    on c.MasterID = r.MasterID


--- select  * from #sej

Drop table #cli 
select s.* into #cli from #sej s
inner join (select Masterid, max(Id_Detail_Sejour_WS) as Max_Id 
from #sej group by MasterId) m 
on s.MasterID = m.MasterID
and s.Id_Detail_Sejour_WS = m.Max_Id 



/* 1 - Tous séjours, tous clients*/ 
  /*Onglet Canaux*/
select Canal_Det,  
sum(Nuitees) as Nuitees 
 from #sej_canaux
 group by Canal_Det 
 order by  Canal_Det


 /* 2 - Séjours loisirs*/ 
   /*Onglet Canaux*/
select Canal_Det,  
sum(Nuitees) as Nuitees 
 from #sej_canaux
 where Type_Sejour like '%Loisir%'
 group by Canal_Det 
 order by  Canal_Det

 ------------------------
 select * from #sej_canaux
 where Type_Sejour like '%Loisir%'
-------------------------

 /* 3 - Séjours pros*/ 
  /*Onglet Canaux*/
select Canal_Det,  
sum(Nuitees) as Nuitees 
 from #sej_canaux
 where Type_Sejour like '%pro%'
 group by Canal_Det 
 order by  Canal_Det


 /* 4 - Séjours Loisirs, Nouveaux clients*/ 
 /*Onglet Nvx*/
select Canal_Det,  
sum(Nuitees) as Nuitees 
 from #sej
 where Type_Sejour like '%loisir%'
 and Nouveau = 1
 group by Canal_Det 
 order by  Canal_Det

/*
select Canal_Det,  
count(distinct MasterId) as clients
 from #cli 
 --where Nouveau = 1 
 group by Canal_Det 
 order by  Canal_Det

 */