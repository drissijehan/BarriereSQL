/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
FROM [SIDBDMT].[mkc].[T_FAIT_SESSIONS_JEU]
  WHERE LB_MODELE_QTS in ('Multi Poker' , 'Joker Poker') or LB_MODELE_QTS like 'Joker%'
  and NO_MACHINE in ('54','55','124','125','126','127','130','131','132','133','134','135',
'136','137','139','140','141','142','145','280','432','433','434','435','481','482','483',
'484','604','605')
  and ID_ETABLISSEMENT_SES = 'LIL'
  order by DT_SEANCE_CASINO desc