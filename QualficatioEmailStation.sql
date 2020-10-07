drop table #contact
select s.[Code_Etablissement], 
s.masterId,
case when m.MasterId is not null then 1 else 0 end as Qualifie_Email,
case when m.FlgContactable = 1  and m.FlgConsentement = 1 then 1 else 0 end as Contactable_Email,
case when t.MasterId is not null then 1 else 0 end as Qualifie_Tel,
case when t.FlgContactable = 1  and t.FlgConsentement = 1 then 1 else 0 end as Contactable_Tel,
case when p.MasterId is not null then 1 else 0 end as Qualifie_Poste,
case when p.Npai = 0  and t.FlgConsentement = 1 then 1 else 0 end as Contactable_Poste
into #contact
from
  (select MasterId, [Code_Etablissement], min([Date_Debut_du_Sejour]) as Dt_Sej 
  FROM [BARRIERE].[dbo].[H_Sejour] 
   where --[Code_Etablissement] in('ENGGE','ENGLE') --- like (select hotel from #perimetre) 
  [Date_Debut_du_Sejour] between '20190301' and '20200229'   
  and Statut_du_Sejour in (3,4) and Type_de_Sejour = 1 
  group by MasterId, [Code_Etablissement] ) s
 /*adresse email*/
 left join 
  ( Select e.*
  FROM [BARRIERE].[dbo].[CONSENTEMENTEMAIL] e
  inner join ( Select MasterID , max([IDConsentementEmail]) as max_consent  
  FROM [BARRIERE].[dbo].[CONSENTEMENTEMAIL]
  where AdressePrincipale = 1 and ContenuID = 1 and FlgConsentement=1 group by  MasterID) x
   on e.MasterID = x.MasterID and [IDConsentementEmail] = max_consent)  m
   on s.MasterID =m.MasterID 
/*telephone*/
left join
	( Select e.*
  FROM [BARRIERE].[dbo].[ConsentementTel] e
  inner join ( Select MasterID , max([IDConsentementTel]) as max_consent  
  FROM [BARRIERE].[dbo].[ConsentementTel]
  where [TelephonePrincipal] = 1 and ContenuID = 1 and FlgConsentement=1 group by  MasterID) x
   on e.MasterID = x.MasterID  and [IDConsentementTel] = max_consent)  t
   on s.MasterID=t.MasterID 
/*poste*/
left join
	( Select e.*
  FROM [BARRIERE].[dbo].[ConsentementPostal] e
  inner join ( Select MasterID , max([IDConsentementPostal]) as max_consent  
  FROM [BARRIERE].[dbo].[ConsentementPostal]
  where ContenuID = 1 and (AdrLigne1 is not null or AdrLigne4 is not null) and FlgConsentement=1 group by  MasterID) x
   on e.MasterID = x.MasterID  and [IDConsentementPostal] = max_consent)  p
   on s.MasterID=p.MasterID     

 select left (s.[Code_Etablissement], 3), 
   sum(Qualifie_Email) / convert(float,count(distinct s.masterId)) as Tx_Qualif_Email, 
   sum(Contactable_Email) / convert(float,count(distinct s.masterId)) as Tx_Contact_Email, 
   sum(Qualifie_Tel) / convert(float,count(distinct s.masterId)) as Tx_Qualif_Tel, 
   sum(Contactable_Tel) / convert(float,count(distinct s.masterId)) as Tx_Contact_Tel, 
   sum(Qualifie_Poste) / convert(float,count(distinct s.masterId)) as Tx_Qualif_Poste, 
   sum(Contactable_Poste) / convert(float,count(distinct s.masterId)) as Tx_Contact_Poste,
   count(distinct( case when Nationalite is not null then s.MasterId else null end )) /
   convert(float,count(distinct s.MasterId)) as Qualif_Nationalite ,
   count(distinct( case when [Date_Naissance] is not null then s.MasterId else null end )) /
   convert(float,count(distinct s.MasterId)) as Qualif_Dt_Naissance 
   from #contact s
  inner join [BARRIERE].[dbo].Contacts c 
   on s.MasterID = c.MasterID 
 group by  left (s.[Code_Etablissement], 3) 