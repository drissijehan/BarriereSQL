select 
Code_Etablissement,
MasterID,
Date_Debut,
Delete_Date,
Date_Debut,
Date_Fin,
Classe_de_Chambre,
Paye_Total_TTC
FROM [BARRIERE].[dbo].[H_ResaDetailSejour] 
where Code_Etablissement <> 'MARNA' /* exclusion marrakech*/
and Date_Debut between '20180701' and '20190630' 
and Delete_Date is null  /* exclusion lignes supprimées*/
and datediff(day,Date_Debut,Date_Fin) > 0 /*exclusion day use*/ 
and Classe_de_Chambre <> 'PSEUDO' /*exclusion chambres pseudo*/
and Statut_Reservation = 4 /*les checked out */


select *   FROM [BARRIERE].[ref].[Misc]  where typeref= 'GB_STATUS' 