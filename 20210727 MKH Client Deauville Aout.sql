drop table #Client
SELECT distinct ID_Sejour, ID_Client, LB_ETABLISSEMENT, Client_IB, DT_DEBUT_SEJOUR, DT_FIN_SEJOUR
into #Client
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION] r
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c 
on r.ID_CLIENT=c.MasterId
where CO_ETABLISSEMENT_QTS in ('DEAHG','DEAHN','DEAHR')
and DT_DEBUT_SEJOUR between '20210903' and '20210912'
--and (DT_DEBUT_SEJOUR <=  '20210903' and DT_FIN_SEJOUR >= '20210903') -- IBVIP 3 SEP
--and (DT_DEBUT_SEJOUR <=  '20210911' and DT_FIN_SEJOUR >= '20210911') -- IBVIP 11 SEP
and ID_type_sejour = 1
and ID_STATUT_SEJOUR != 1
ORDER BY LB_ETABLISSEMENT
select * from #Client

select count (distinct ID_SEJOUR) as client from #Client where Client_IB=1
select count (distinct ID_Client) from #Client where Client_IB=1
---------------------------------------
select distinct ID_CLient, Client_IB
,Niveau_IB, Type_Fid from #Client c
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_COMPTEFIDELITE] f
on c.ID_Client = f.MasterId
where Client_IB=1
and Type_Fid = 'IB'
---------------------------------------
---------NIVEAU IB---------

Drop Table  #IB_Hist
select c.MasterId, max(case when Niveau_IB = 7 then 0 else Niveau_IB end ) as Niv_IB
into #IB_Hist
from  [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_COMPTEFIDELITE] c
inner join (select MasterId, max(Update_Date) as max_update  
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_COMPTEFIDELITE]
  where type_fid = 'IB'
---and [Num_Adht_IB] like '[A-Z]%'
--and Niveau_IB between 1 and 7
group by MasterId )x
on c. masterid = x.MasterId
and c.Update_Date = x.max_update
group by c.MasterId
select * from #IB_Hist

drop table #IB
select * into #IB from #Client c
inner join #IB_Hist i
on c.ID_Client = i.MasterId
where Client_IB=1
select * from #IB

-----------------------------
---------OPTIN------------
--------Email
drop table #OptinEmail
select i.ID_Client,Niv_IB  ,
case when (FlgContactable = 1  and FlgConsentement = 1 and ContenuId=1) then 1 else 0 end Optin_Email
into #OptinEmail
from #IB i
inner join   [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONSENTEMENTEMAIL] e
on i.MasterId= e.MasterId
where ContenuId = 1 and AdressePrincipale =1 
select * from #OptinEmail

--------SMS
drop table #OptinTel
select i.ID_Client,Niv_IB  ,
case when (FlgContactable = 1  and FlgConsentement = 1 and ContenuId=1) then 1 else 0 end Optin_Tel
into #OptinTel
from #IB i
inner join   [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONSENTEMENTTEL] t
on i.MasterId= t.MasterId
where ContenuId = 1 and TelephonePrincipal =1 
select * from #OptinTel

--Client
select
 distinct i.Id_Client, LB_ETABLISSEMENT, i.Client_IB,  Nom_Usage, Prenom, i.Niv_IB,Optin_Email, Optin_Tel
from #IB i left join #OptinEmail e on i.ID_Client=e.ID_Client 
left join #OptinTel t on i.ID_CLient=t.ID_Client
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c
on i.ID_Client=c.MasterID

--Sejour
select distinct i.ID_SEJOUR, 
 i.Id_Client, LB_ETABLISSEMENT, i.Client_IB,  Nom_Usage, Prenom, i.Niv_IB,Optin_Email, Optin_Tel
, DT_DEBUT_SEJOUR, DT_FIN_SEJOUR
from #IB i left join #OptinEmail e on i.ID_Client=e.ID_Client 
left join #OptinTel t on i.ID_CLient=t.ID_Client
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c
on i.ID_Client=c.MasterID
--where i.Niv_IB=6 -- VIP
order by DT_DEBUT_SEJOUR
