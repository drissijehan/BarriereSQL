select *, DATEDIFF(day,DT_DEBUT_SEJOUR,DT_FIN_SEJOUR) as Nuitees	
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where LB_TYPE_OFFRE in ('Package Thalasso')	
and CO_ETABLISSEMENT_QTS in ('LBAHR')	
and DT_DEBUT_SEJOUR between '20180501' and '20190430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
order by DT_DEBUT_SEJOUR	
	
/*Total Nuitees*/	
select month(DT_DEBUT_SEJOUR) as month	
, year(DT_DEBUT_SEJOUR) as year	
,SUM (ISNULL(NB_NUITS,0)) as Nuitees	
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where	
CO_ETABLISSEMENT_QTS in ('LBAHR')	
and DT_DEBUT_SEJOUR between '20180501' and '20190430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
GROUP by MONTH(DT_DEBUT_SEJOUR), year(DT_DEBUT_SEJOUR)	
	
/*Anticipation*/	
select avg(DATEDIFF(day,DH_RESERVATION,DT_DEBUT_SEJOUR)) as anticipation	
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where LB_TYPE_OFFRE in ('Package Thalasso')	
and CO_ETABLISSEMENT_QTS in ('LBAHR')	
and DT_DEBUT_SEJOUR between '20180501' and '20190430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
	
/*pAYS DE rESIDENCE*/	
select count (distinct ID_CLIENT) ,LB_CLIENT_PAYS_RESIDENCE	
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where LB_TYPE_OFFRE in ('Package Thalasso')	
and CO_ETABLISSEMENT_QTS in ('LBAHR')	
and DT_DEBUT_SEJOUR between '20180501' and '20190430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by LB_CLIENT_PAYS_RESIDENCE	
	
/*Region Departement Client francais*/	
select	
distinct s.ID_CLIENT,	
LB_REGION ,LB_DEPARTEMENT	
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR] s	
inner join ( select MasterID , Insee FROM [SIDBDWH].[qts].[T_CONTACTS]) c	
on s.ID_CLIENT=c.MasterID	
left join (select distinct [CO_INSEE_SANS_LES_0],LB_REGION, LB_DEPARTEMENT FROM [SIDBDWH].[ref].[T_GEOGRAPHIE]) g	
on c.Insee=g.[CO_INSEE_SANS_LES_0]	
where ID_CLIENT in (select distinct ID_CLIENT	
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where LB_TYPE_OFFRE in ('Package Thalasso')	
and CO_ETABLISSEMENT_QTS in ('LBAHR')	
and DT_DEBUT_SEJOUR between '20180501' and '20190430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
and CO_CLIENT_PAYS_RESIDENCE = 'FRA')	
group by	
s.ID_CLIENT	
,LB_REGION ,LB_DEPARTEMENT	
	
	
/*Canal Reservation*/	
SELECT ID_SEJOUR,	
LB_CANAL_RESERVATION, LB_CANAL_DETAIL, LB_TYPE_CANAL_RESERVATION	
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]	
where ID_SEJOUR in (select distinct ID_SEJOUR	
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where LB_TYPE_OFFRE in ('Package Thalasso')	
and CO_ETABLISSEMENT_QTS in ('LBAHR')	
and DT_DEBUT_SEJOUR between '20180501' and '20190430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR)	

/*Profil Client*/
select * 
FROM [SIDBDWH].[qts].[T_CONTACTS]
where MasterID in (
select distinct ID_CLIENT	
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where LB_TYPE_OFFRE in ('Package Thalasso')	
and CO_ETABLISSEMENT_QTS in ('LBAHR')	
and DT_DEBUT_SEJOUR between '20180501' and '20190430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR)

/*sEJOUR*/

select *
 FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
 where  ID_SEJOUR in (
select distinct ID_SEJOUR	
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where LB_TYPE_OFFRE in ('Package Thalasso')	
and CO_ETABLISSEMENT_QTS in ('LBAHR')	
and DT_DEBUT_SEJOUR between '20180501' and '20190430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR)


/*Contactabilite*/
 --Voir fichier MKH .. Contactabilite

 /* Nouveaux Clients */
   drop table #prems
select ID_CLIENT,
min(dh_Reservation) as Prem_Resa,
min(case when [ID_STATUT_SEJOUR] = 4 then [DT_DEBUT_SEJOUR] else null end ) as Prem_Sej
into #prems
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION] r
where [CO_ETABLISSEMENT_QTS] <> 'MARNA'
and [ID_TYPE_SEJOUR] = 1
and [LB_CLASSE_CHAMBRE] <> 'PSEUDO'
and  [DT_DEBUT_SEJOUR] <> [DT_FIN_SEJOUR]
--and [ID_TYPE_OFFRE] = 42
and (dh_Reservation between '20160501' and dateadd(day,1,'20190430')
or [DT_DEBUT_SEJOUR] between '20160501' and '20190430' )
group by ID_CLIENT 
select top 100 * from #prems


drop table #client
select 
distinct s.ID_CLIENT
,case when  Prem_Resa  between '20180501' and '20190430' then 1 else 0 end as Primo
,sexe, Client_IB, Age, Pays_De_Residence
into #client
FROM [SIDBDMT].[mkh].[T_FAIT_RESERVATION] s
inner join (select * FROM [SIDBDWH].[qts].[T_CONTACTS]) c
on s.ID_CLIENT=c.MasterID
inner join #prems p
on s.ID_CLIENT= p.ID_CLIENT
where Dh_Reservation between '20180501' and '20190430'
and ID_Type_Sejour=1
and [ID_STATUT_SEJOUR]=4
and [CO_ETABLISSEMENT_QTS] in ('LBAHR') --not in ('COUNH', 'MARNA', 'DEARD', 'LTQWE')
and [LB_CLASSE_CHAMBRE] <> 'PSEUDO'
and [ID_TYPE_OFFRE] = 42

select * from #client where Primo=1
select * from #client

