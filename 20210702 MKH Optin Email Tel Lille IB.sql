Drop Table  #IB_Hist
select c.MasterId, max(case when Niveau_IB = 7 then 0 else Niveau_IB end ) as Niv_IB
into #IB_Hist
from  [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_COMPTEFIDELITE] c
inner join (select MasterId, max(Update_Date) as max_update  
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_COMPTEFIDELITE]
  where type_fid = 'IB'
---and [Num_Adht_IB] like '[A-Z]%'
and Niveau_IB between 1 and 7
group by MasterId )x
on c. masterid = x.MasterId
and c.Update_Date = x.max_update
group by c.MasterId

select * from #IB_Hist

select 
[CO_ETABLISSEMENT_QTS]
,year(dt_debut_sejour) as Annee_Sej,
case when ([BO_CLIENT_IB] =1 and Niv_IB is not null) then 'IB '+convert(varchar,Niv_IB) 
when([BO_CLIENT_IB] =1 and Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end as Type_Client
,count(distinct id_client) as Client
,count([ID_SEJOUR]) as Sejour
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
  left join #IB_Hist i
  on s.ID_Client=i.Masterid
where id_type_sejour=1
and id_statut_sejour in (3,4)
and ( dt_debut_sejour between '20190101' and '20191231' or dt_debut_sejour between '20200101' and '20201231' or dt_debut_sejour between '20210101' and '20211231' )
and CO_ETABLISSEMENT_QTS = 'LILHC'
group by  [CO_ETABLISSEMENT_QTS], year(dt_debut_sejour),
case when ([BO_CLIENT_IB] =1 and Niv_IB is not null) then 'IB '+convert(varchar,Niv_IB) 
when([BO_CLIENT_IB] =1 and Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end 
order by year(dt_debut_sejour),
case when ([BO_CLIENT_IB] =1 and Niv_IB is not null) then 'IB '+convert(varchar,Niv_IB) 
when([BO_CLIENT_IB] =1 and Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end 


----------------- OPTIN ----------


drop table #OptinEmail
select i.MasterId,Niv_IB  ,
case when (FlgContactable = 1  and FlgConsentement = 1 and ContenuId=1) then 1 else 0 end Optin_Email
into #OptinEmail
from #IB_Hist i
inner join   [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONSENTEMENTEMAIL] e
on i.MasterId= e.MasterId
where ContenuId = 1 and AdressePrincipale =1 
select * from #OptinEmail
-------sms-------
drop table #OptinTel
select i.MasterId,Niv_IB  ,
case when (FlgContactable = 1  and FlgConsentement = 1 and ContenuId=1) then 1 else 0 end Optin_Tel
into #OptinTel
from #IB_Hist i
inner join   [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONSENTEMENTTEL] t
on i.MasterId= t.MasterId
where ContenuId = 1 and TelephonePrincipal =1 


select 
[CO_ETABLISSEMENT_QTS]
,year(dt_debut_sejour) as Annee_Sej,
case when ([BO_CLIENT_IB] =1 and i.Niv_IB is not null) then 'IB '+convert(varchar,i.Niv_IB) 
when([BO_CLIENT_IB] =1 and i.Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end as Type_Client
,count(distinct id_client) as Client
,count([ID_SEJOUR]) as Sejour
,Optin_Email,Optin_Tel
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
  left join #IB_Hist i
  on s.ID_Client=i.Masterid
  left join #OptinEmail e
  on s.ID_Client=e.MasterId
  left join #OptinTel t
  on s.ID_Client=t.MasterId
where id_type_sejour=1
and id_statut_sejour in (3,4)
and ( dt_debut_sejour between '20190101' and '20191231' or dt_debut_sejour between '20200101' and '20201231' or dt_debut_sejour between '20210101' and '20211231' )
and CO_ETABLISSEMENT_QTS = 'LILHC'
group by  [CO_ETABLISSEMENT_QTS], year(dt_debut_sejour),
case when ([BO_CLIENT_IB] =1 and i.Niv_IB is not null) then 'IB '+convert(varchar,i.Niv_IB) 
when([BO_CLIENT_IB] =1 and i.Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end 
,Optin_Email,Optin_Tel
order by year(dt_debut_sejour),
case when ([BO_CLIENT_IB] =1 and i.Niv_IB is not null) then 'IB '+convert(varchar,i.Niv_IB) 
when([BO_CLIENT_IB] =1 and i.Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end 
