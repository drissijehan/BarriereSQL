 
 /* Toutes les réservations loisirs sur 12 mois avec identification des réservations 
 Showroom privé et vente privée  */
Drop table #Resas_12M
SELECT r1.[Id_Sejour_WS]
      ,r1.[Code_Etablissement]
      ,r1.[MasterID]
	  ,count(distinct r1.[Ach_Conf_No]) as NB_Resas
	  ,Max(r1.Rate_Code) as Rate_Code
      ,min(r1.[Date_Reservation]) as Dt_Resa 
      ,min(r1.[Date_Debut]) as Dt_Deb
      ,max(r1.[Date_Fin]) as Dt_Fin 
	, sum(r1.[Nb_Nuits]) as Nuitees
	, datediff(day,min(r1.Date_Reservation), max(r1.Date_Debut)) as Delai
	, datediff(day,min(r1.Date_Debut), max(r1.Date_Fin)) as Duree
	, sum( isnull(r1.[Paye_Total_TTC],0) + isnull(r2.[Paye_Total_TTC],0))  as Ca_Total_Ttc
     ,  Sum(isnull(r1.Share_Amount,0)
+ isnull(r1.Prd_Resv_Separate_Line_Amount,0)
+ isnull(r1.Prd_Resv_Combined_Line_Amount,0)
+ isnull(r1.Fixed_Charges_Amount,0)) as Tarif_ttc
, max(case when  (r1.Rate_Code like '%SRP%' or c1.Nom_Societe like '%showroom%'
  or r1.Rate_Code like '%VTP%' or c1.Nom_Societe like '%vente%priv%' ) and r1.rate_code not like 'BR%' then 1 else 0 end) as SRP_VTP, 
  max(case when  (r1.Rate_Code like '%SRP%'or c1.Nom_Societe like '%showroom%'  ) then 1 else 0 end) as SRP, 
   max(case when  (r1.Rate_Code like '%VTP%' or c1.Nom_Societe like '%vente%priv%') and r1.rate_code not like 'BR%' then 1 else 0 end) as VTP 
   , max(case when r1.Statut_Reservation = 4 then 1 else 0 end) as Checked_Out 
   , max(case when c1.Nom_Societe like '%box%' or c2.Nom_Societe like '%box%'  or r1.Rate_Code like 'MBF%' then 1 else 0 end) as Coffret
   into #Resas_12M
FROM [BARRIERE].[dbo].[H_ResaDetailSejour] r1 
  left join  [BARRIERE].[dbo].[H_ResaDetailSejour] r2
  on r1.Id_Sejour_WS = r2.Id_Sejour_Reel_WS
  left join  [BARRIERE].[dbo].Contacts c1
  on r1.[Interm_Commission] = c1.MasterID 
    left join  [BARRIERE].[dbo].Contacts c2
  on r1.Groupe_Commission = c2.MasterID 
  where r1.Type_Sejour = 1 and r1.[Code_Etablissement] <> 'MARNA'
  and r1.Date_Reservation between '20180801' and '20190731'
  and r1.Classe_de_Chambre <> 'PSEUDO'
  and datediff(day,r1.Date_Debut, r1.Date_Fin) > 0 
  group by r1.[Id_Sejour_WS]
      ,r1.[Code_Etablissement]
      ,r1.[MasterID]


/*Date de 1èere réservations et de 1er séjour pour chaque client*/
Drop table #primos 
select MasterID,
min(Date_Reservation) as Prem_resa, 
min(case when Statut_Reservation =4 then Date_Debut else null end) as Prem_Sej
into #primos 
FROM [BARRIERE].[dbo].[H_ResaDetailSejour] r1
  where r1.Type_Sejour = 1 and r1.[Code_Etablissement] <> 'MARNA'
  and r1.Date_Reservation between '20101101' and '20190731'
  and r1.Classe_de_Chambre <> 'PSEUDO'
    and datediff(day,r1.Date_Debut, r1.Date_Fin) > 0 
  group by MasterID

drop table #resas_pr  
select r.*, --p.*,
case when p.Prem_resa = r.Dt_Resa then 1 else 0 end as Prem_Resa,
case when r.Dt_Deb = p.Prem_Sej and r.Checked_Out = 1 then 1 else 0 end as Prem_Sej 
into #resas_pr
from #Resas_12M r left join #primos p 
on r.MasterID = p.MasterID

--- select * from #resas_pr where srp_vtp = 1 

Drop table #cli_res
select r.MasterId,
count(distinct r.[Code_Etablissement]) as nb_etabs_resas,
sum(NB_Resas) as Resas,
sum(Nuitees) as Nuit_Resa,
sum(Tarif_ttc) as CA_Resa, 
avg(convert(float,Delai)) as Moy_Delai,
min (case when Pays_De_Residence = 'FRA' then '01 - France' 
when Pays_De_Residence = 'GBR' then '02 - Royaume Uni' 
when Pays_De_Residence = 'BEL' then '03 - Belgique' 
when Pays_De_Residence = 'USA' then '04 - Etats Unis' 
when Pays_De_Residence = 'RUS' then '05 - Russie' 
when  Pays_De_Residence = 'CHE' then '06 - Suisse' 
when Pays_De_Residence = 'DEU' then '07 - Allemagne' 
when Pays_De_Residence = 'ITA' then '08 - Italie' 
when Pays_De_Residence  is null then  '10 - Inconnu' 
else '09 - Autres Pays' end) as Pays, 
min(case when [Date_Naissance] between '19090101' and '20020101' 
then datediff(day, [Date_Naissance], Dt_Resa) / 365.00 
else 0 end) as Age,
max(case when sexe = 1 then 'H' when sexe = 2 then 'F' else '?' end) as Sexe,
max(case when fh.MasterID  is not null then 1 else 0 end) as IB, 
max(case when fc.MasterID  is not null then 1 else 0 end) as CVIP,
max(case when  i.MasterID is not null then r.SRP_VTP else null end) as  SRP_VTP, 
max(case when  i.MasterID is not null then r.SRP else null end) as  SRP, 
max(case when  i.MasterID is not null then r.VTP else null end) as  VTP,
max(Prem_Resa) as Prem_Resa ,
max(Coffret) as Coffret 
into #cli_res 
from #resas_pr r
left join [BARRIERE].[dbo].[Contacts] c
on r.MasterID=c.MasterID 
left join (select distinct MasterId
from [BARRIERE].[dbo].[H_CompteFidelite] 
where Delete_Date is null and Type_Fid = 'IB')fh 
on r.MasterID=fh.MasterID 
left join (select distinct MasterID 
from [BARRIERE].[dbo].C_CompteClient fc
where Type_Fid in (1,2)) fc 
on r.MasterID=fc.MasterID 
left join (select MasterId, min(Dt_Resa) as Min_Resa 
from #resas_pr group by MasterId) i 
on r.MasterID = i.MasterID and Dt_Resa = Min_Resa
group by r.MasterId

/*
drop table #cli_sej 
select r.MasterId,
count(distinct r.[Code_Etablissement] ) as nb_etabs_sej,
count(distinct Id_Sejour_WS) as Nb_Sej, 
sum(Nuitees)  as Nuit_Sej,
sum(Ca_Total_ttc)  as Ca_Sej,
avg(convert(float,Duree)) as Moy_Duree,
min (case when Pays_De_Residence = 'FRA' then '01 - France' 
when Pays_De_Residence = 'GBR' then '02 - Royaume Uni' 
when Pays_De_Residence = 'BEL' then '03 - Belgique' 
when Pays_De_Residence = 'USA' then '04 - Etats Unis' 
when Pays_De_Residence = 'RUS' then '05 - Russie' 
when  Pays_De_Residence = 'CHE' then '06 - Suisse' 
when Pays_De_Residence = 'DEU' then '07 - Allemagne' 
when Pays_De_Residence = 'ITA' then '08 - Italie' 
when Pays_De_Residence  is null then  '10 - Inconnu' 
else '09 - Autres Pays' end) as Pays, 
min(case when [Date_Naissance] between '19090101' and '20020101' 
then datediff(day, [Date_Naissance], Dt_Resa) / 365.00 
else 0 end) as Age,
max(case when sexe = 1 then 'H' when sexe = 2 then 'F' else '?' end) as Sexe,
max(case when fh.MasterID  is not null then 1 else 0 end) as IB, 
max(case when fc.MasterID  is not null then 1 else 0 end) as CVIP,
max(case when  i.MasterID is not null then r.SRP_VTP else 0 end) as  SRP_VTP, 
max(case when  i.MasterID is not null then r.SRP else 0 end) as  SRP, 
max(case when  i.MasterID is not null then r.VTP else 0 end) as  VTP,
max(Prem_Sej) as Prem_Sej ,
max(Coffret) as Coffret 
into #cli_sej 
from #resas_pr r
left join [BARRIERE].[dbo].[Contacts] c
on r.MasterID=c.MasterID 
left join (select distinct MasterId
from [BARRIERE].[dbo].[H_CompteFidelite] 
where Delete_Date is null and Type_Fid = 'IB') fh 
on r.MasterID=fh.MasterID 
left join (select distinct MasterID 
from [BARRIERE].[dbo].C_CompteClient fc
where Type_Fid in (1,2)) fc 
on r.MasterID=fc.MasterID 
left join (select MasterId, min(Dt_Resa) as Min_Resa 
from #resas_pr where checked_out = 1 group by MasterId) i 
on r.MasterID = i.MasterID and Dt_Resa = Min_Resa
where r.checked_out = 1
group by r.MasterId


--- select top 100 * from #cli_sej where masterid = 7082 
*/

select SRP_VTP,
sum(Resas) as Resas,
count(distinct masterid) as Reservants,  
sum(Nuit_Resa) as Nuitées_Res,
sum(Ca_Resa) as Ca_Resa,
avg(Moy_Delai) as Moy_Delai
from #cli_res 
--where srp_vtp = 1 
group by SRP_VTP
order by SRP_VTP desc 

/*
select Coffret,
sum(Resas) as Resas,
count(distinct masterid) as Reservants,  
sum(Nuit_Resa) as Nuitées_Res,
sum(Ca_Resa) as Ca_Resa,
avg(Moy_Delai) as Moy_Delai
from #cli_res 
where SRP_VTP = 1 and SRP =0 
group by Coffret 
order by Coffret desc 
*/

select * from #resas_pr
where masterid= 1295506 


select SRP_VTP,
sum(Nb_Sej) as Sejours,
count(distinct masterid) as Clients,  
sum(Nuit_Sej) as Nuitées_Sej,
sum(Ca_Sej) as Ca_Sej,
avg(Moy_Duree) as Moy_Duree
from #cli_sej 
group by SRP_VTP
order by SRP_VTP desc 

/*
select SRP,
sum(Nb_Sej) as Sejours,
count(distinct masterid) as Clients,  
sum(Nuit_Sej) as Nuitées_Sej,
sum(Ca_Sej) as Ca_Sej,
avg(Moy_Duree) as Moy_Duree
from #cli_sej 
where SRP_VTP = 1
group by SRP 
order by SRP

select Coffret,
sum(Nb_Sej) as Sejours,
count(distinct masterid) as Clients,  
sum(Nuit_Sej) as Nuitées_Sej,
sum(Ca_Sej) as Ca_Sej,
avg(Moy_Duree) as Moy_Duree
from #cli_res
where SRP_VTP = 1 and SRP =0 
group by Coffret 
order by Coffret desc 

*/

select SRP_VTP, 
case when Ca_resa < 250 then '1 - Entre 0 et 250€' 
when Ca_resa >= 250 and Ca_Resa < 500 then '2 - Entre 250 et 500€' 
when Ca_resa >= 500 and Ca_Resa < 1000 then '3 - Entre 500 et 1000€' 
when Ca_resa >= 1000 and Ca_Resa < 2000 then '4 - Entre 1000 et 2000€' 
when Ca_resa >= 2000 then '5 - Plus de 2000€'
else '6 - NB' end as Tr_CA ,
case when Age >= 18 and Age < 30 then '1 - Entre 18 et 30 ans' 
when Age >= 30 and Age < 45 then '2 - Entre 30 et 45 ans' 
when Age >= 45 and Age < 65 then '3 - Entre 45 et 65 ans'
when Age >= 65 and Age < 105 then '4 - Plus de 65 ans'
else '6 - inconnu' end as tr_Age, 
case when nb_etabs_resas > 1 then 1 else 0 end as Circulant, 
CVIP, IB, Prem_resa,
count( distinct MasterId) as Nb_Reservants 
from #cli_res 
group by SRP_VTP, 
case when Ca_resa < 250 then '1 - Entre 0 et 250€' 
when Ca_resa >= 250 and Ca_Resa < 500 then '2 - Entre 250 et 500€' 
when Ca_resa >= 500 and Ca_Resa < 1000 then '3 - Entre 500 et 1000€' 
when Ca_resa >= 1000 and Ca_Resa < 2000 then '4 - Entre 1000 et 2000€' 
when Ca_resa >= 2000 then '5 - Plus de 2000€'
else '6 - NB' end  ,
case when Age >= 18 and Age < 30 then '1 - Entre 18 et 30 ans' 
when Age >= 30 and Age < 45 then '2 - Entre 30 et 45 ans' 
when Age >= 45 and Age < 65 then '3 - Entre 45 et 65 ans'
when Age >= 65 and Age < 105 then '4 - Plus de 65 ans'
else '6 - inconnu' end  , 
case when nb_etabs_resas > 1 then 1 else 0 end  , 
CVIP, IB, Prem_Resa

select SRP, 
case when Ca_resa < 250 then '1 - Entre 0 et 250€' 
when Ca_resa >= 250 and Ca_Resa < 500 then '2 - Entre 250 et 500€' 
when Ca_resa >= 500 and Ca_Resa < 1000 then '3 - Entre 500 et 1000€' 
when Ca_resa >= 1000 and Ca_Resa < 2000 then '4 - Entre 1000 et 2000€' 
when Ca_resa >= 2000 then '5 - Plus de 2000€'
else '6 - NB' end as Tr_CA ,
case when Age >= 18 and Age < 30 then '1 - Entre 18 et 30 ans' 
when Age >= 30 and Age < 45 then '2 - Entre 30 et 45 ans' 
when Age >= 45 and Age < 65 then '3 - Entre 45 et 65 ans'
when Age >= 65 and Age < 105 then '4 - Plus de 65 ans'
else '6 - inconnu' end as tr_Age, 
case when nb_etabs_resas > 1 then 1 else 0 end as Circulant, 
CVIP, IB, Prem_Resa,
count( distinct MasterId) as Nb_Reservants 
from #cli_res where SRP_VTP = 1 
group by SRP, 
case when Ca_resa < 250 then '1 - Entre 0 et 250€' 
when Ca_resa >= 250 and Ca_Resa < 500 then '2 - Entre 250 et 500€' 
when Ca_resa >= 500 and Ca_Resa < 1000 then '3 - Entre 500 et 1000€' 
when Ca_resa >= 1000 and Ca_Resa < 2000 then '4 - Entre 1000 et 2000€' 
when Ca_resa >= 2000 then '5 - Plus de 2000€'
else '6 - NB' end  ,
case when Age >= 18 and Age < 30 then '1 - Entre 18 et 30 ans' 
when Age >= 30 and Age < 45 then '2 - Entre 30 et 45 ans' 
when Age >= 45 and Age < 65 then '3 - Entre 45 et 65 ans'
when Age >= 65 and Age < 105 then '4 - Plus de 65 ans'
else '6 - inconnu' end  , 
case when nb_etabs_resas > 1 then 1 else 0 end  , 
CVIP, IB, Prem_Resa


select Prem_Resa  ,
count(distinct masterid) 
from #cli_res where SRP_VTP = 1 and srp = 0  
group by Prem_Resa order by Prem_Resa 


select SRP_VTP, 
case when Ca_resa < 250 then '1 - Entre 0 et 250€' 
when Ca_resa >= 250 and Ca_Resa < 500 then '2 - Entre 250 et 500€' 
when Ca_resa >= 500 and Ca_Resa < 1000 then '3 - Entre 500 et 1000€' 
when Ca_resa >= 1000 and Ca_Resa < 2000 then '4 - Entre 1000 et 2000€' 
when Ca_resa >= 2000 then '5 - Plus de 2000€'
else '6 - NB' end as Tr_CA ,
case when Age >= 18 and Age < 30 then '1 - Entre 18 et 30 ans' 
when Age >= 30 and Age < 45 then '2 - Entre 30 et 45 ans' 
when Age >= 45 and Age < 65 then '3 - Entre 45 et 65 ans'
when Age >= 65 and Age < 105 then '4 - Plus de 65 ans'
else '6 - inconnu' end as tr_Age, 
case when nb_etabs_resas > 1 then 1 else 0 end as Circulant, 
CVIP, IB, Prem_resa,
count( distinct MasterId) as Nb_Reservants 
from #cli_res 
group by SRP_VTP, 
case when Ca_resa < 250 then '1 - Entre 0 et 250€' 
when Ca_resa >= 250 and Ca_Resa < 500 then '2 - Entre 250 et 500€' 
when Ca_resa >= 500 and Ca_Resa < 1000 then '3 - Entre 500 et 1000€' 
when Ca_resa >= 1000 and Ca_Resa < 2000 then '4 - Entre 1000 et 2000€' 
when Ca_resa >= 2000 then '5 - Plus de 2000€'
else '6 - NB' end  ,
case when Age >= 18 and Age < 30 then '1 - Entre 18 et 30 ans' 
when Age >= 30 and Age < 45 then '2 - Entre 30 et 45 ans' 
when Age >= 45 and Age < 65 then '3 - Entre 45 et 65 ans'
when Age >= 65 and Age < 105 then '4 - Plus de 65 ans'
else '6 - inconnu' end  , 
case when nb_etabs_resas > 1 then 1 else 0 end  , 
CVIP, IB, Prem_Resa

select Coffret, 
case when Ca_resa < 250 then '1 - Entre 0 et 250€' 
when Ca_resa >= 250 and Ca_Resa < 500 then '2 - Entre 250 et 500€' 
when Ca_resa >= 500 and Ca_Resa < 1000 then '3 - Entre 500 et 1000€' 
when Ca_resa >= 1000 and Ca_Resa < 2000 then '4 - Entre 1000 et 2000€' 
when Ca_resa >= 2000 then '5 - Plus de 2000€'
else '6 - NB' end as Tr_CA ,
case when Age >= 18 and Age < 30 then '1 - Entre 18 et 30 ans' 
when Age >= 30 and Age < 45 then '2 - Entre 30 et 45 ans' 
when Age >= 45 and Age < 65 then '3 - Entre 45 et 65 ans'
when Age >= 65 and Age < 105 then '4 - Plus de 65 ans'
else '6 - inconnu' end as tr_Age, 
case when nb_etabs_resas > 1 then 1 else 0 end as Circulant, 
CVIP, IB, Prem_Resa,
count( distinct MasterId) as Nb_Reservants 
from #cli_res where VTP = 1 
group by Coffret, 
case when Ca_resa < 250 then '1 - Entre 0 et 250€' 
when Ca_resa >= 250 and Ca_Resa < 500 then '2 - Entre 250 et 500€' 
when Ca_resa >= 500 and Ca_Resa < 1000 then '3 - Entre 500 et 1000€' 
when Ca_resa >= 1000 and Ca_Resa < 2000 then '4 - Entre 1000 et 2000€' 
when Ca_resa >= 2000 then '5 - Plus de 2000€'
else '6 - NB' end  ,
case when Age >= 18 and Age < 30 then '1 - Entre 18 et 30 ans' 
when Age >= 30 and Age < 45 then '2 - Entre 30 et 45 ans' 
when Age >= 45 and Age < 65 then '3 - Entre 45 et 65 ans'
when Age >= 65 and Age < 105 then '4 - Plus de 65 ans'
else '6 - inconnu' end  , 
case when nb_etabs_resas > 1 then 1 else 0 end  , 
CVIP, IB, Prem_Resa



select coffret,
count( distinct MasterId) as Nb_Reservants, 
avg(case when age between 17 and 105 then age else null end) as moy_age,
avg(Ca_resa) as Moy_CA_Resas
from #cli_res where VTP = 1 
group by coffret
order by coffret desc 

select coffret,
convert(float,count(distinct(case when pays like '01%' then  r.MasterId else null end))) / 
count( distinct (case when pays not like '10%' then r.MasterId else null end)) as Tx_Fr,
convert(float,count(distinct(case when sexe ='H'  then  r.MasterId else null end))) / 
count( distinct (case when sexe in ('H','F') then r.MasterId else null end)) as Tx_H
from #cli_res r
 where VTP = 1 
group by coffret
order by coffret desc 



--- select * from #cli_res where srp_vtp =  1 and cvip  = 1  


select case when SRP  = 1 then '1 - SRP'
when VTP = 1 and Coffret = 0 then '2 - VTP Hors Coffret' 
when VTP = 1 and Coffret = 1 then '3 - VTP Coffret' 
else '4 - NB' end as Canal, 
/*case when len(convert(varchar,month(Dt_Deb))) = 1 then 
convert(varchar,year(Dt_Deb)) + '0' + convert(varchar,month(Dt_Deb)) 
else convert(varchar,year(Dt_Deb)) + convert(varchar,month(Dt_Deb)) end as id_mois, */
[Code_Etablissement],
sum(nuitees) as nuitées 
from #resas_pr 
where srp_VTP = 1 
group by case when SRP  = 1 then '1 - SRP'
when VTP = 1 and Coffret = 0 then '2 - VTP Hors Coffret' 
when VTP = 1 and Coffret = 1 then '3 - VTP Coffret' 
else '4 - NB' end , /*case when len(convert(varchar,month(Dt_Deb))) = 1 then 
convert(varchar,year(Dt_Deb)) + '0' + convert(varchar,month(Dt_Deb)) 
else convert(varchar,year(Dt_Deb)) + convert(varchar,month(Dt_Deb)) end*/
 [Code_Etablissement]
order by case when SRP  = 1 then '1 - SRP'
when VTP = 1 and Coffret = 0 then '2 - VTP Hors Coffret' 
when VTP = 1 and Coffret = 1 then '3 - VTP Coffret' 
else '4 - NB' end , /*case when len(convert(varchar,month(Dt_Deb))) = 1 then 
convert(varchar,year(Dt_Deb)) + '0' + convert(varchar,month(Dt_Deb)) 
else convert(varchar,year(Dt_Deb)) + convert(varchar,month(Dt_Deb)) end*/
[Code_Etablissement]

/*ceci est juste un test*/

/*Branch test*/