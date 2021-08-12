
	select ID_CLIENT, ID_ETABLISSEMENT_SES, ID_UNIVERS_JEUX
	,sum (MT_HANDLE) as Handle,
	sum(MT_PBJ) as PBJ
	,sum(NB_POINTS_STATUT) as Point_Statut
	,sum(NB_POINTS_STATUT_P) as Point_Statut_P
	,sum(NB_POINTS_STATUT_N) as Point_Statut_N
	,sum(NB_POINTS_PRIME) as Point_Prime
	,sum(NB_POINTS_PRIME_P) as Point_Prime_P
	,sum(NB_POINTS_PRIME_N) as Point_Prime_N
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkc].[T_FAIT_SESSIONS_JEU]
  where [ID_TYPE_CARTE_FID] = 12
  and DT_SEANCE_CASINO between '20210519' and '20210713'
  group by ID_CLIENT, ID_ETABLISSEMENT_SES, ID_UNIVERS_JEUX
 
GO


