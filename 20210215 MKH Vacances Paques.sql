Drop table #V_Fev_2018
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_F
,sum(isnull(NB_ADULTES,0)) as Adultes_F
,sum(isnull(NB_ENFANTS,0)) as Enfants_F
into #V_Fev_2018
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS NOT in ('MARNA','ENGLE')	
and DT_DEBUT_SEJOUR between '20180217' and '20180305'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Fev_2018

Drop table #V_Paques_2018
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_P
,sum(isnull(NB_ADULTES,0)) as Adultes_P
,sum(isnull(NB_ENFANTS,0)) as Enfants_P
into #V_Paques_2018
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS NOT in ('MARNA','ENGLE')	
and DT_DEBUT_SEJOUR between '20180414' and '20180430'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Paques_2018

Drop table #V_Noel_2017
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_N
,sum(isnull(NB_ADULTES,0)) as Adultes_N
,sum(isnull(NB_ENFANTS,0)) as Enfants_N
into #V_Noel_2017
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS NOT in ('MARNA','ENGLE')	
and DT_DEBUT_SEJOUR between '20171223' and '20180108'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Noel_2017


select * from #V_Fev_2018 as f full outer join #V_Paques_2018 as p
on f.CO_ETABLISSEMENT_QTS=p.CO_ETABLISSEMENT_QTS
full outer join #V_Noel_2017 as n on p.CO_ETABLISSEMENT_QTS=n.CO_ETABLISSEMENT_QTS

Drop table #V_Noel_2020
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_N
,sum(isnull(NB_ADULTES,0)) as Adultes_N
,sum(isnull(NB_ENFANTS,0)) as Enfants_N
into #V_Noel_2020
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS NOT in ('MARNA','ENGLE')	
and DT_DEBUT_SEJOUR between '20201219' and '20210104'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Noel_2020

-------------------
--------NOEL-------
Drop table #V_Noel_2018
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_18
,sum(isnull(NB_ADULTES,0)) as Adultes_18
,sum(isnull(NB_ENFANTS,0)) as Enfants_18
into #V_Noel_2018
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS in ('DEAHG','DEAHN')	
and DT_DEBUT_SEJOUR between '20181222' and '20190107'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Noel_2018

Drop table #V_Noel_2019
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_19
,sum(isnull(NB_ADULTES,0)) as Adultes_19
,sum(isnull(NB_ENFANTS,0)) as Enfants_19
into #V_Noel_2019
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS in ('DEAHG','DEAHN')	
and DT_DEBUT_SEJOUR between '20191221' and '20200106'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Noel_2019

Drop table #V_Noel_2017_DEA
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_17
,sum(isnull(NB_ADULTES,0)) as Adultes_17
,sum(isnull(NB_ENFANTS,0)) as Enfants_17
into #V_Noel_2017_DEA
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS in ('DEAHG','DEAHN')	
and DT_DEBUT_SEJOUR between  '20171223' and '20180108'		
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Noel_2017_DEA

Drop table #V_Noel_2020_DEA
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_20
,sum(isnull(NB_ADULTES,0)) as Adultes_20
,sum(isnull(NB_ENFANTS,0)) as Enfants_20
into #V_Noel_2020_DEA
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS in ('DEAHG','DEAHN')		
and DT_DEBUT_SEJOUR between '20201219' and '20210104'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Noel_2020_DEA

select * from #V_Noel_2017_DEA as a full outer join #V_Noel_2018 as b
on a.CO_ETABLISSEMENT_QTS=b.CO_ETABLISSEMENT_QTS
full outer join #V_Noel_2019 as c on b.CO_ETABLISSEMENT_QTS=c.CO_ETABLISSEMENT_QTS
full outer join #V_Noel_2020_DEA as d on c.CO_ETABLISSEMENT_QTS=d.CO_ETABLISSEMENT_QTS

-----------------------
-----Pâques----------
Drop table #V_Paques_2019
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_19
,sum(isnull(NB_ADULTES,0)) as Adultes_19
,sum(isnull(NB_ENFANTS,0)) as Enfants_19
into #V_Paques_2019
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS NOT in ('MARNA','ENGLE')	
and DT_DEBUT_SEJOUR between '20190420' and '20190506'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Paques_2019

Drop table #V_Paques_2017
Select CO_ETABLISSEMENT_QTS,
count (distinct ID_CLIENT) As Client_17
,sum(isnull(NB_ADULTES,0)) as Adultes_17
,sum(isnull(NB_ENFANTS,0)) as Enfants_17
into #V_Paques_2017
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS NOT in ('MARNA','ENGLE')	
and DT_DEBUT_SEJOUR between '20170401' and '20170418'
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS
select * from #V_Paques_2017

select * from #V_Paques_2017 as a full outer join #V_Paques_2018 as b
on a.CO_ETABLISSEMENT_QTS=b.CO_ETABLISSEMENT_QTS
full outer join #V_Paques_2019 as c on b.CO_ETABLISSEMENT_QTS=c.CO_ETABLISSEMENT_QTS

----------------
------ WEEKEND PAques ---------
Select CO_ETABLISSEMENT_QTS
,count (distinct ID_CLIENT) As Client_19
,sum(isnull(NB_ADULTES,0)) as Adultes_19
,sum(isnull(NB_ENFANTS,0)) as Enfants_19
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where CO_ETABLISSEMENT_QTS NOT in ('MARNA','ENGLE')	
and DT_DEBUT_SEJOUR between '20180330' and '20180402'	
and ID_TYPE_SEJOUR = 1	
and ID_STATUT_SEJOUR in (3,4)	
and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR	
group by CO_ETABLISSEMENT_QTS