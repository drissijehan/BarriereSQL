--Drop Table #sej	
	select s.[Id_Sejour_WS]	
      ,s.[Code_Etablissement]	
      ,s.MasterID	
      ,s.[Date_Debut_du_Sejour]	
      ,s.[Date_Fin_du_Sejour]
	  , Pays_De_Residence
	  , case when max([Sexe]) = 1 then '1 - H'
	  when max(Sexe) = 2 then '2 - F' else '3 - NB' end as Sexe
      ,case when max(Age) between 18 and 35 then '1 - 35 ans ou moins'	
	  when max(Age) between 36 and 45 then '2 - de 36 à 45 ans'
	  when max(Age) between 46 and 55 then '3 - de 46 à 55 ans'
	  when max(Age) between 56 and 105 then '4 - 56 ans et plus'
	  else '5 - Inconnu' end as Tr_Age
	  , max(case when r.[Code_Etablissement] + r.Type_de_Chambre in 
	  ('CANHMP','CANHMDSP','CANHMPEN7','COUNHSUN','COUNHSD','COUNHPM','CANHMPEN4','COUNHSPR',
	'CANHMSMM','DEARDSR','DEAHNSP','CANHMPEN6','CANHMPEN3','COUNHJSPR','COUNHJ','COUNHPR',
	'PARHFSP','COUNHD','COUNHS','DEAHNSHF','PARHFSPR','DEARDSIS','LBAHHSP','CANHMSPTM',
	'PARHFSD','CANHMFC','LBAHRSR','PARHFSPPR','LBAHHSPMT','DEAHNSDM','PARHFSS','LBAHHJSPTM',
	'PARHFJSPR','DINGHSPM','LBAHHSPM','DEARDSPM','PARHFJSD','PARHFPR','DEAHNSD') 
		then 1 else 0 end
		)as Chambre_Plus
	 -- into #sej
  FROM [BARRIERE].[dbo].[H_Sejour] s	
  inner join  [BARRIERE].[dbo].[H_ResaDetailSejour] r 	
  on s.[Id_Sejour_WS] = r.[Id_Sejour_WS] 
  inner join [BARRIERE].[dbo].[Contacts] c 
  on s.MasterID = c.MasterID
   where s.[Date_Debut_du_Sejour] between '20180701' and '20190630' 	
  and s.Type_de_Sejour = 1 	
  and s.Statut_du_Sejour in (3,4) 	
  and s.[Code_Etablissement] not in ('MARNA','NIENB')
  and Type_de_Chambre <> 'PSEUDO'
  and Nb_Nuits > 0   
  group by s.[Id_Sejour_WS]	
      ,s.[Code_Etablissement]	
      ,s.MasterID	
      ,s.[Date_Debut_du_Sejour]	
      ,s.[Date_Fin_du_Sejour] 	
	  ,Pays_De_Residence


