drop table #Royal
select  distinct ID_CLIENT 
into #Royal
 FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
 where DT_DEBUT_SEJOUR between '20161219' and '20201220'
 and CO_ETABLISSEMENT_QTS = 'LBAHR'
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)
 and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR

 select count (distinct ID_CLIENT) as Client
 ,count (distinct ID_SEJOUR) as Sejour
 ,sum(isnull(MT_CA_SEJ_HEBERGEMENT_TTC,0)) as CA_TTC_Hebergement
 ,sum(isnull(MT_CA_SEJOUR_TTC,0)) as CA_TTC_Sejour
  FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR] 
  where DT_DEBUT_SEJOUR between '20200207' and '20200223'
 and CO_ETABLISSEMENT_QTS in ( 'LBAML')
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)
 and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR
 and ID_CLIENT in (select * from #Royal)

 select  distinct ID_SEJOUR
 ,sum(isnull(MT_CA_SEJ_HEBERGEMENT_TTC,0)) as CA_TTC_Hebergement
 ,sum(isnull(MT_CA_SEJOUR_TTC,0)) as CA_TTC_Sejour
 , DATEDIFF(day,DT_DEBUT_SEJOUR,DT_FIN_SEJOUR) as Nuitées
 FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
 where DT_DEBUT_SEJOUR between '20200207' and '20200223'
 and CO_ETABLISSEMENT_QTS in ('LBAHH','LBAML')
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)
 and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR
 and ID_CLIENT in (select * from #Royal)
 group by ID_SEJOUR, DT_DEBUT_SEJOUR,DT_FIN_SEJOUR