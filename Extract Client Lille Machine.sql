


select distinct n.MasterId, n.Cd_Casino_Rattachement, 
case when Niv_Fid = 1 then 'Blanc' 
when Niv_Fid = 2 then 'Argent'
when Niv_Fid = 3 then 'Or' else 'Noire' end as Niveau,
Nom_Usage, Nom_Naissance, Prenom_Usage, Prenom,
convert(date,Date_Naissance) as Date_Naissance,
NoTelephone,
Email,
convert(date, Der_Partie_RAE) as Der_Partie_RAE,
Handle_RAE


from 
/*Selection clients noire et or de Nice*/
(select MasterId, Cd_Casino_Rattachement, Niv_Fid
FROM [BARRIERE].[dbo].[C_CompteClient] 
where DT_Deb_Niv_Actu is not null 
) n --in (1,2,3,4) ) n

/*Noms, prenoms, date de naissance*/
inner join [BARRIERE].[dbo].Contacts c
on n.MasterId = c.MasterID

/*Num téléphone*/
left join (select MasterId, NoTelephone
from [BARRIERE].[dbo].ConsentementTel 
where FlgConsentement = 1 
and FlgContactable = 1 
and ContenuID in (3,4) )  t
on n.MasterId = t.MasterID

/*email*/
left join (select MasterId, Email
from [BARRIERE].[dbo].ConsentementEmail 
where FlgConsentement = 1 
and FlgContactable = 1 
and ContenuID in (3,4) )  m
on n.MasterId = m.MasterID


/*transactions RAE 12 mois*/
inner join (select MasterId, sum(Handle) as Handle_RAE,
max(Date_Seance_Casino) as Der_Partie_RAE
from [BARRIERE].[dbo].[C_EarnCasino] 
where Date_Seance_Casino between dateadd(month, -12, getdate()) and getdate()
/* Zone ASIE*/
and Slot_ID in ('280',
'135',
'136',
'481',
'605',
'604',
'137',
'141')
and Code_Etablissement = 'LIL' 
group by MasterId) h
on n.MasterId = h.MasterID
and h.Handle_RAE >= 200 
