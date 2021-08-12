drop table #Client
SELECT --count (distinct ID_Sejour ) as sej , count (distinct Id_Client) as client
distinct ID_Sejour, ID_Client, LB_ETABLISSEMENT, Client_IB, DT_DEBUT_SEJOUR, DT_FIN_SEJOUR
into #Client
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION] r
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c 
on r.ID_CLIENT=c.MasterId
where CO_ETABLISSEMENT_QTS in ('LBAHH')
and (DT_DEBUT_SEJOUR <= '20210814' and DT_FIN_SEJOUR >= '20210814')
and DH_RESERVATION between '20201101' and '20210730'
and ID_type_sejour = 1
and ID_STATUT_SEJOUR != 1
select * from #Client where Client_IB=1

-----------------------------
---------OPTIN------------
--------Email
drop table #OptinEmail
select i.ID_Client,
case when (FlgContactable = 1  and FlgConsentement = 1 and ContenuId=1) then 1 else 0 end Optin_Email
into #OptinEmail
from #Client i
inner join   [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONSENTEMENTEMAIL] e
on i.ID_CLIENT= e.MasterId
where ContenuId = 1 and AdressePrincipale =1 
select * from #OptinEmail

--------SMS
drop table #OptinTel
select i.ID_Client,
case when (FlgContactable = 1  and FlgConsentement = 1 and ContenuId=1) then 1 else 0 end Optin_Tel
into #OptinTel
from #Client i
inner join   [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONSENTEMENTTEL] t
on i.ID_Client= t.MasterId
where ContenuId = 1 and TelephonePrincipal =1 
select * from #OptinTel


select distinct i.ID_SEJOUR, i.Id_Client, LB_ETABLISSEMENT, i.Client_IB,  Nom_Usage, Prenom, Optin_Email, Optin_Tel, DT_DEbUT_SEJOUR, DT_FIN_Sejour
from #Client i left join #OptinEmail e on i.ID_Client=e.ID_Client 
left join #OptinTel t on i.ID_CLient=t.ID_Client
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c
on i.ID_Client=c.MasterID
where i.Client_IB=1
order by DT_DEBUT_SEJOUR



---------------CDI----------
select distinct i.ID_SEJOUR, i.Id_Client, LB_ETABLISSEMENT, i.Client_IB,  Nom_Usage, Prenom, Optin_Email, Optin_Tel, DT_DEbUT_SEJOUR, DT_FIN_Sejour, Preference, detail
from #Client i left join #OptinEmail e on i.ID_Client=e.ID_Client 
left join #OptinTel t on i.ID_CLient=t.ID_Client
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c
on i.ID_Client=c.MasterID
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_PREFERENCE_EP] p
on i.ID_CLIENT=p.MasterID
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_EPV_REF_PREFERENCES] d
on p.[Preference]=d.Id
where i.Client_IB=1 and preference =201
order by DT_DEBUT_SEJOUR



select distinct i.ID_SEJOUR, i.Id_Client, LB_ETABLISSEMENT, i.Client_IB,  Nom_Usage, Prenom, Optin_Email, Optin_Tel, DT_DEbUT_SEJOUR, DT_FIN_Sejour,Common_ID
from #Client i left join #OptinEmail e on i.ID_Client=e.ID_Client 
left join #OptinTel t on i.ID_CLient=t.ID_Client
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c
on i.ID_Client=c.MasterID
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CDI] p
on i.ID_CLIENT=p.MasterID

where i.Client_IB=1 and common_ID=106--and preference =201
order by DT_DEBUT_SEJOUR