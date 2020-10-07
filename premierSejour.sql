SELECT [MasterID]
,Date_Premier_Sejour
 FROM [BARRIERE].[dbo].[H_IndicateurIndiv]

 select MasterId, min(Date_Debut) as Date_Prem_Sejour  
 FROM [BARRIERE].[dbo].[H_ResaDetailSejour]
 where Date_Debut >= '20110101'
 and Type_Sejour = 1 and Statut_Reservation = 4 
 and Classe_de_Chambre = 'PSEUDO'
 and datediff(day, date_debut, date_fin)  > 0 
 group by MasterID