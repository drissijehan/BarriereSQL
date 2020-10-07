
select top 5000 r.* 
into #ClientRelai
FROM [BARRIERE].[dbo].[H_ResaDetailSejour] r  
inner join [BARRIERE].[dbo].[Contacts] c2
on r.[Groupe_Commission] = c2.MasterID 
where Code_Etablissement <> 'MARNA' /* exclusion marrakech*/
and Date_Debut between '20180801' and '20190731'
and r.Delete_Date is null  /* exclusion lignes supprimées*/
and datediff(day,Date_Debut,Date_Fin) > 0 /*exclusion day use*/ 
and Classe_de_Chambre <> 'PSEUDO' /*exclusion chambres pseudo*/
and c2.Nom_Societe like '%relais%chateau%' /*Source = Relais & Chateau*/
and Statut_Reservation = 4 /*checkeed out*/

select * 
from [BARRIERE].[dbo].[Contacts] c
inner join #ClientRelai r
on c.MasterID=r.MasterID