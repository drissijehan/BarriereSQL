/*VeryChic*/

drop table #VeryChic
select *
into #VeryChic
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and type_sejour = 1 -- Indiv Loisir
and Rate_Code in ('PROMO2')
and Date_Debut <> Date_Fin -- Pas de day use
and Code_Etablissement in ('DEAHN','DEAHG','LBAHR','LBAML','ENGGE','LILHC','DINGH','RIBRR') -- Etablissements participants
and Date_Reservation between '20200825' and dateadd(day,1,'20200904') -- Date Reservation	
and Date_Debut between '20200830' and '20201031'  -- Date Sejour
