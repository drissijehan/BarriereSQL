drop table #cli_34 
SELECT c.Cd_Casino_Rattachement
      ,c.[Lib_Casino_Rattachement]
      ,c.[MasterId]
      ,c.[Type_Fid]
      ,c.[DT_Deb_Niv]
      ,c.[Niv_Fid]
    , case when o.MasterId_Conj is not null then 1 else 0 end as CVIP_Noir_Conjoint 
	, case when entrees_av_op.MasterID is not null  then 0  else 1 end as Inactif_Av_Op
	, case when entrees_op.MasterID is not null  then 1  else 0 end as Actif_Op
	into #cli_34
  FROM [SIDBDWH].[qts].[T_C_COMPTECLIENT] c
  left join [SIDBDWH].[qts].[T_C_COMPTECLIENT] o
  on c.MasterId = o.MasterId_Conj 
  and o.DT_Deb_Niv_Actu is not null 
  and c.Niv_Fid = 4 
   left join (select distinct MasterId 
   from [SIDBDWH].[qts].[T_C_ENTREE] 
   where Date_Seance_Casino between '20200602' and '20200924'
   and Flag_Entree_Cartee = 1) entrees_av_op
   on  c.MasterId = entrees_av_op.MasterID 
      left join (select distinct MasterId 
   from [SIDBDWH].[qts].[T_C_ENTREE] 
   where Date_Seance_Casino between '20200925' and '20201010'
   and Flag_Entree_Cartee = 1) entrees_op
   on  c.MasterId = entrees_op.MasterID 
  where c.DT_Deb_Niv_Actu is not null 
  and c.Type_Fid = 2
  and c.Niv_Fid in (3,4) 




   select Lib_Casino_Rattachement, Niv_Fid
   --, Inactif_Av_Op,Actif_Op
   ,count (distinct MasterId) as Client
   from #cli_34 
   where 
   group by Lib_Casino_Rattachement, Niv_Fid--, Inactif_Av_Op,Actif_Op
	order by Lib_Casino_Rattachement, Niv_Fid