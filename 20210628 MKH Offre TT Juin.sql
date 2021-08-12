---------Resa-------------

select *
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]
where ID_JOUR_RESERVATION between 20210601 and 20210629
and CO_ETABLISSEMENT_QTS in ('LBAHH','LBAHR','LBAML','DEAHG','DEAHN','DEARD','LTQWE','DINGH')
and [ID_TYPE_SEJOUR] =1
--and [ID_STATUT_SEJOUR] =1 --Séjour Annulés
and CO_RATE in ('PKTT','PKTTA')

--------KPI----------

select count(distinct no_ach_conf) as Nb_reservations , 
sum(NB_NUITS) as Nuitees ,
count(distinct Id_Client) as Nb_Reservants ,
sum( isnull([MT_OFFRE_ACT_ID],0) + isnull([MT_SUPPLEMENTS],0)			
+ isnull([MT_OPTIONS],0) + isnull([MT_SERVICES],0)) as Ca_Reservation_ttc  ,
avg( convert(float, 
datediff(day, DT_DEBUT_SEJOUR , DT_FIN_SEJOUR)
)) as Duree_Moy , 
avg(convert(float,
datediff(day, DH_RESERVATION, DT_DEBUT_SEJOUR ))) as Anticipation_Moy
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]
where ID_JOUR_RESERVATION between 20210601 and 20210629
and CO_ETABLISSEMENT_QTS in ('LBAHH','LBAHR','LBAML','DEAHG','DEAHN','DEARD','LTQWE','DINGH')
and [ID_TYPE_SEJOUR] =1
--and [ID_STATUT_SEJOUR] =1 --Séjour Annulés
and CO_RATE in ('PKTT','PKTTA')


----------Nouveau---------
   drop table #prems
select MasterId,
min(date_Reservation) as Prem_Resa,
min(case when Statut_Reservation = 4 then Date_Debut else null end ) as Prem_Sej
into #prems
FROM  [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_RESADETAILSEJOUR] r
where Code_Etablissement <> 'MARNA'
and Type_Sejour = 1
and Classe_de_Chambre <> 'PSEUDO'
and r.Delete_Date is null
and (Date_Reservation between '20160628' and dateadd(day,1,'20210628')
or Date_Debut between '20160628' and '20210628' )
group by MasterId
select top 100 * from #prems

-----------Profil---------

select sexe,Age,client_IB,Pays_de_Residence,
case when (co_rate = '%FAM%' or NB_ENFANTS>0) then '1' else '0' end as Famille,
case when  Prem_Sej  between '20210601' and '20210629' then 1 else 0 end as Primo
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION] r
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c
on r.ID_CLIENT=c.MasterId
inner join #prems p
on c.MasterId=p.MasterId
where ID_JOUR_RESERVATION between 20210601 and 20210629
and CO_ETABLISSEMENT_QTS in ('LBAHH','LBAHR','LBAML','DEAHG','DEAHN','DEARD','LTQWE','DINGH')
and [ID_TYPE_SEJOUR] =1
and CO_RATE in ('PKTT','PKTTA')