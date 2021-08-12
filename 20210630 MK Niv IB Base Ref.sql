SELECT [Nom]
      ,[CodeValN]
      ,[CodeValS]
      ,[Libelle]
      ,[SOURCE_FICHIER]
      ,[ID_LOAD]
      ,[DATE_INS]
      ,[DATE_MAJ]
      ,[DATE_SUP]


  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_REFERENTIELS]
  where Nom like '%IB%'
GO


