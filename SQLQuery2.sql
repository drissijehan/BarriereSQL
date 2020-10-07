select s.MasterID, Date_Debut, Date_Fin,
[Nom_Naissance],[Nom_Usage],[Prenom],[Prenom_Usage],
      [Ville_Naissance] ,[Nationalite] ,[Pays_De_Residence]
  FROM [BARRIERE].[dbo].[H_ResaDetailSejour] s
  inner join (select masterID,[Prenom],[Nom_Naissance],[Nom_Usage]
      ,[Prenom_Usage],[Ville_Naissance],[Pays_De_Residence]
      ,[Nationalite]   FROM [BARRIERE].[dbo].[Contacts]) c
  on s.MasterID=c.MasterID
  where Code_Etablissement = 'RIBRR'
  and Date_Debut between '20190601' and '20190731'
  and Type_de_Chambre <> 'PSEUDO'
  and Type_Sejour=1
  and Statut_Reservation in (3,4)
