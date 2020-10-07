---------------------------------------------
/* BURN */
---------------------------------------------
select [Code_Etablissement],	
case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE'	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT'	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end as Fam_Article,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end as Article,	
count(distinct Date_Transaction) as Nb_Actes_Burn,	
sum(Nb_Points_Prime) as Pts_Primes_Burnés	
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS	
where 
--Date_Seance_Casino between '20190301' and '20200130' and 
univers = 7	
group by [Code_Etablissement],	
case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE'	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT'	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end  ,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end	
order by [Code_Etablissement],	
case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE'	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT'	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end  ,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end	

---------------------------------------------
/* EARN */
---------------------------------------------
select Code_Etablissement,Univers,
month(Date_Seance_Casino) as mois, YEAR(Date_Seance_Casino) as annee,
--count(distinct MasterID) as Client
sum(isnull([Nb_Points_Prime],0)) as Pts_Prime
FROM [BARRIERE].[dbo].[C_EarnCasino]
where --Date_Seance_Casino between '20190301'  and '20200130' and 
univers in (1,2,3,4)
group by month(Date_Seance_Casino) , YEAR(Date_Seance_Casino),
Code_Etablissement ,Univers
order by Univers

---------------------------------------------
/* EVOLUTION BURN RESTO */
---------------------------------------------
select --month(Date_Seance_Casino) as Mois,
year(Date_Seance_Casino) as Annee,
case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
else '5) AUTRES'  end as Fam_Article,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo		
else '5) AUTRES'  end as Article,	
count(distinct Date_Transaction) as Nb_Actes_Burn,	
sum(Nb_Points_Prime) as Pts_Primes_Burnés	
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS	
where 
--Date_Seance_Casino between '20190301' and '20200130'	and 
univers = 7	
group by --month(Date_Seance_Casino),
year(Date_Seance_Casino) ,
case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
else '5) AUTRES'  end  ,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo	
else '5) AUTRES'  end	
order by year(Date_Seance_Casino)--,month(Date_Seance_Casino),
,case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
else '5) AUTRES'  end  ,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo	
else '5) AUTRES'  end


---------------------------------------------
/* EVOLUTION EARN DANS LE TEMPS */
---------------------------------------------
select Code_Etablissement,Univers, 
month(Date_Seance_Casino)as mois, year(Date_Seance_Casino) as annee,
sum(isnull([Nb_Points_Prime],0)) as Pts_Prime
FROM [BARRIERE].[dbo].[C_EarnCasino]
where Date_Seance_Casino between '20190301'  and '20200130'
group by Univers, Code_Etablissement,
month(Date_Seance_Casino), year(Date_Seance_Casino)
order by Univers

---------------------------------------------
/* NOMBRE DES CLIENTS ACTIFS (EARN OU BURN) */
---------------------------------------------
drop table #Clt_Earn
select distinct MasterID as Earn
into #Clt_Earn
FROM [BARRIERE].[dbo].[C_EarnCasino]
where Date_Seance_Casino between '20190301'  and '20200130'
and Nb_Points_Prime is not null
and Univers in (1,2,3,4)


drop table #Clt_Burn
select distinct MasterID as Clts_Burn
into #Clt_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
--and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
--or b2.[Famille_Article] = 'BAR/RESTAURATION'  
and ( b2.[Famille_Article] = 'MACHINES A SOUS'
or b2.[Famille_Article] = 'JEUX DE TABLE')

select  distinct (Earn) ,Clts_Burn
from #Clt_Earn e full join #Clt_Burn b on e.Earn=b.Clts_Burn

---------------------------------------------
/* CLIENT BURN */
---------------------------------------------
select COUNT (distinct MasterID) as Clts_Burn,
case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE'	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT'	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end as Fam_Article,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end as Article,	
count(distinct Date_Transaction) as Nb_Actes_Burn,	
sum(Nb_Points_Prime) as Pts_Primes_Burnés	
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS	
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
group by
case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE'	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT'	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end  ,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end	
order by 
case when  (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')	
or b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration'	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE'	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT'	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end  ,	
case when  b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'  then '3) Restauration - Burn Direct'	
when b2.[Famille_Article] = 'BAR/RESTAURATION' then '3) Restauration - ' + b2.LibellePromo	
when b2.[Famille_Article] = 'MACHINES A SOUS' then '1) MAS / JTE - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'JEUX DE TABLE' then '2) JDT - ' + b2.LibellePromo	
when  b2.[Famille_Article] = 'HOTELS' then '4) HOTELS'	
else '5) AUTRES'  end	



------------------------------------------
/* EARN POINTS RESTAU DANS TS CASINOS */
------------------------------------------
select Code_Etablissement,
sum (Nb_Points_Prime) as Point_Earn
FROM [BARRIERE].[dbo].[C_EARNCASINO]
--where Code_Etablissement = 'ROY'
where Date_Seance_Casino between '20190301' and '20200130'
and Univers in (4)
group by Code_Etablissement
order by Point_Earn


---------------------------------------------
/* CLIENT BURN PAR NIVEAU*/
---------------------------------------------

 drop table #niv
select Cd_Casino_rattachement,c.MasterID
,(case when Niv_Fid in (5,6) then Niv_Fid - 4
when Niv_Fid = 7 then 4
else Niv_Fid end) as Niv_Fid
,Dt_deb_niv,
dt_fin_niv,
date_exp_niveau,
dt_deb_niv_Actu,
Status_Cc,
Type_cc,
Inactive_cause_text_cc,
inactive_cause_cc,
date_inactive_cc,
delete_date
into #niv
from [BARRIERE].[dbo].[C_CompteClient] c
inner join (select MasterId , max(Id_compte_client_ws) as Max_Cpte
from [BARRIERE].[dbo].[C_CompteClient]
where Dt_Deb_Niv <= '20990101'
and isnull (date_Inactive_Cc,'20990101') > '20190301'
and Type_Fid in (1,2) group by MasterId ) m
on c.MasterId = m.MasterID and c.Id_Compte_Client_Ws = m.Max_Cpte
order by c.MasterID




---------------------
drop table #Uni_cli_Burn
select  b.Clts_Burn
,Niv_Fid
, max(case when b.Famille_Article in ('MACHINES A SOUS','JEUX DE TABLE') then 1 else 0 end) as Flag_Jeux 
, max(case when b.Famille_Article in ('BAR/RESTAURATION') or b.Famille_Article is null then 1 else 0 end) as Flag_Restau 
into #Uni_cli_Burn
FROM (select distinct MasterID as Clts_Burn, b2.[Famille_Article]
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION'  
or b2.[Famille_Article] = 'MACHINES A SOUS'
or b2.[Famille_Article] = 'JEUX DE TABLE') b
inner join #niv n
on b.Clts_Burn=n.MasterId
group by b.Clts_Burn
,Niv_Fid
select * from #Uni_cli_Burn


select Niv_Fid,
case when Flag_Jeux = 1 and Flag_Restau = 0 then '3 - Exclu Jeux Burn'
 when Flag_Jeux = 0 and Flag_Restau = 1 then '2 - Exclu Restau Burn'
 when Flag_Jeux = 1 and Flag_Restau = 1 then '1 - Mixte Jeux Restau Burn'
 else '4 - Autres' end as Activité,
 count(distinct Clts_Burn) as Burners
 from #Uni_cli_Burn
 group by Niv_Fid, case when Flag_Jeux = 1 and Flag_Restau = 0 then '3 - Exclu Jeux Burn'
 when Flag_Jeux = 0 and Flag_Restau = 1 then '2 - Exclu Restau Burn'
 when Flag_Jeux = 1 and Flag_Restau = 1 then '1 - Mixte Jeux Restau Burn'
 else '4 - Autres' end

---------------------------------------------
/* CLIENT EARN PAR NIVEAU*/
---------------------------------------------
drop table #Uni_cli
select  e.MasterID
,Niv_Fid
, max(case when Univers in (1,2,3) then 1 else 0 end) as Flag_Jeux 
, max(case when Univers in (4) then 1 else 0 end) as Flag_Restau 
into #Uni_cli
FROM [BARRIERE].[dbo].[C_EarnCasino] e
inner join #niv n
on e.MasterID=n.MasterId
where Date_Seance_Casino between '20190301'  and '20200130'
and Nb_Points_Prime is not null
and Univers in (1,2,3,4)
group by e.MasterID
,Niv_Fid
select * from #Uni_cli


select Niv_Fid,
case when Flag_Jeux = 1 and Flag_Restau = 0 then '1 - Exclu Jeux'
 when Flag_Jeux = 0 and Flag_Restau = 1 then '2 - Exclu Restau'
 when Flag_Jeux = 1 and Flag_Restau = 1 then '3 - Mixte Jeux Restau'
 else '4 - Autres' end as Activité,
 count(distinct masterId) as earners
 from #Uni_cli
 group by Niv_Fid, case when Flag_Jeux = 1 and Flag_Restau = 0 then '1 - Exclu Jeux'
 when Flag_Jeux = 0 and Flag_Restau = 1 then '2 - Exclu Restau'
 when Flag_Jeux = 1 and Flag_Restau = 1 then '3 - Mixte Jeux Restau'
 else '4 - Autres' end


---------------------------------------------
/* PROFIL DE CLIENT BURNER RESATURATION */
---------------------------------------------
/*BURNER RESTAU*/
select distinct MasterID as Clts_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION' 

/*SEXE AGE BUERNER RESTAU*/
select Clts_Burn,Sexe, Age,
DATEDIFF(year,getdate(),Date_Creation)
FROM [BARRIERE].[dbo].[Contacts] c
inner join(select distinct MasterID as Clts_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION' ) b
on c.MasterID = b.Clts_Burn


/*ENTREES*/
drop table #entrees
  select e.MasterID,count ( distinct ID_ENTREE) as nbr_entree 
   into #entrees
  FROM [BARRIERE].[dbo].[C_Entree] e
  inner join(select distinct MasterID as Clts_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION' ) b
on e.MasterID = b.Clts_Burn
where Date_Seance_Casino between '20190301' and '20200130'
 group by e.MasterID

select top 100 * from #entrees
select avg(nbr_entree)
from #entrees

/*HANDLE*/
select Univers,
 count(distinct e.masterID) as MasterID,
 avg(Handle) as Handle
 ,avg (PBJ) as pbj , avg([Drop]) as Drop_jeu
  FROM [BARRIERE].[dbo].[C_EarnCasino] e
  inner join(select distinct MasterID as Clts_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION' ) b
on e.MasterID = b.Clts_Burn
 where Date_Seance_Casino between '20190301' and '20200130' and Univers in (1,2,3,4)
 group by Univers


 ------------------------------------------
/* CLIENT RECRUTE RESTAU JOUENT APRES */
------------------------------------------



----------------------------------------
/*DANILO*/
----------------------------------------


/*NVX CLIENT RECRUTE SUR LA PERIODE*/
drop table #carte_cli
select row_number() over (partition by masterid order by isnull(Dt_Inactivation,'20991231')) as Num_Carte_Cli, 
* into #carte_cli
  FROM [BARRIERE].[dbo].[C_CarteDeFidelite]
  where ( convert(date,Date_Emission_Carte) <> 
  convert(date,Dt_Inactivation)
  or Dt_Inactivation is null )
  and Type_Fid in (1, 2 )
  and [Code_Etablissement] in ('ENG', 'BDT', 'BIA', 'CAN', 'CRY', 'CIS',
'BLZ', 'BDX', 'DEA', 'DIN', 'LBA','LRO', 'LIL', 'MEN', 
'NDR', 'OUI', 'RBV', 'ROY','SMA','SRP','SMX','TLS',
'TRO','AGD','LTQ','CAP','NCE')  

--select top 1000 * from #nvx order by masterid --, Num_Carte_Cli

drop table #cptes
select MasterId,
Num_Carte_Cli,
Code_Etablissement,
Id_Fid, 
convert(date,Date_Emission_Carte) as Dt_Deb,
convert(date,isnull(Dt_Inactivation,'20991231')) as Dt_Fin
 into #cptes 
from #carte_cli
where Masterid in (select MasterId 
from #carte_cli
where Num_Carte_Cli = 1 and Id_Fid = 1
and Date_Emission_Carte between '20190301' and '20200130' ) 

drop table #nvx 
select c1.MasterID, c1.Code_Etablissement, 
c1.Dt_Deb as Dt_Entree_Prog, 
c2.Id_Fid as Niv_Fid_Fin_Periode
into #nvx
from #cptes c1 
left join #cptes c2
on c1.MasterID = c2.MasterID 
and c2.Dt_Deb <='20200130'
and c2.Dt_Fin > '20200130'
where c1.Num_Carte_Cli = 1 

select * from #nvx

/*ORIGINE DE RECRUTEMENT*/

SELECT  Univers,
count( distinct  f.MasterID ) as Clients_1ere_trx
from (
select row_number() over (partition by MasterID order by Date_Transaction) as num,
*
FROM [BARRIERE].[dbo].[C_EARNCASINO] 
where Date_seance_casino between '20190301' and '20200130'
and Univers between 1 and 4 and MasterID in (select MasterID from #nvx)
) f
where num = 1
group by Univers



/*EARNERS JEU*/
select distinct e.MasterID
  FROM [BARRIERE].[dbo].[C_EarnCasino] e
  inner join (SELECT  
distinct (case when Univers=4 then masterid else null end) as Clients_Restau
from (
select row_number() over (partition by MasterID order by Date_Transaction) as num,
*
FROM [BARRIERE].[dbo].[C_EARNCASINO]
where Date_seance_casino between '20190301' and '20200130'
and Univers between 1 and 4 
) f
where num = 1) m
on e.MasterID=m.Clients_Restau
  where Date_seance_casino between '20190301' and '20200130'
and Univers between 1 and 3 and Nb_Points_Prime is not null


select count (distinct e.MasterID), 
m.Univers
  FROM [BARRIERE].[dbo].[C_EarnCasino] e
  inner join (SELECT 
distinct  masterid  as Clients_1ere_trx,  Univers
from (
select row_number() over (partition by MasterID order by Date_Transaction) as num,
*
FROM [BARRIERE].[dbo].[C_EARNCASINO]
where Date_seance_casino between '20190301' and '20200130'
and Univers between 1 and 4 and MasterID in (select MasterID from #nvx)
) f
where num = 1
group by Univers,MasterID) m
on e.MasterID=m.Clients_1ere_trx
  where Date_seance_casino between '20190301' and '20200130'
and e.Univers between 1 and 3 and Nb_Points_Prime is not null
group by m.Univers

/*NIVEAU EARNERS JEU*/
select count (distinct e.MasterID), 
 n.Niv_Fid_Fin_Periode
  FROM [BARRIERE].[dbo].[C_EarnCasino] e
  inner join (SELECT 
distinct  masterid  as Clients_1ere_trx,  Univers
from (
select row_number() over (partition by MasterID order by Date_Transaction) as num,
*
FROM [BARRIERE].[dbo].[C_EARNCASINO]
where Date_seance_casino between '20190301' and '20200130'
and Univers between 1 and 4 and MasterID in (select MasterID from #nvx)
) f
where num = 1
group by Univers,MasterID) m
on e.MasterID=m.Clients_1ere_trx
inner join #nvx n
on e.MasterID=n.MasterId
  where Date_seance_casino between '20190301' and '20200130'
and e.Univers between 1 and 3 and Nb_Points_Prime is not null
and m.Univers=4
group by n.Niv_Fid_Fin_Periode


------------------------------------------
/* CLIENT RECRUTE RESTAU */
------------------------------------------
select * from #nvx
/*NOUVEAUx CLIENTS*/
SELECT Code_Etablissement,
 count (distinct  f.MasterID) as Clients_1ere_trx
from (
select row_number() over (partition by MasterID order by Date_Transaction) as num,
*
FROM [BARRIERE].[dbo].[C_EARNCASINO] 
where Date_seance_casino between '20190301' and '20200130'
and Univers between 1 and 4 and MasterID in (select MasterID from #nvx)
) f
where num = 1
group by Code_Etablissement


/*CLIENT RECRUTES RESTAU*/
SELECT Code_Etablissement ,
count( distinct  masterid ) as Clients_1ere_trx
from (
select row_number() over (partition by MasterID order by Date_Transaction) as num,
*
FROM [BARRIERE].[dbo].[C_EARNCASINO]
where Date_seance_casino between '20190301' and '20200130'
and Univers between 1 and 4 and MasterID in (select MasterID from #nvx)
) f
where num = 1 and Univers=4
group by Code_Etablissement




-------------------------------------
/*PROFIL CLIENT EARNER*/
--------------------------------
select --c.MasterID, Sexe, Age, Date_Creation,
  --count (distinct c.MasterID) as MasterID
--avg ( DATEDIFF(year,getdate(),Date_Creation))
avg (age)
   FROM [BARRIERE].[dbo].[Contacts] c
   inner join (select distinct MasterID
 FROM [BARRIERE].[dbo].[C_EarnCasino]
 where Univers in (1,2,3,4) 
 and Date_Seance_Casino between '20190301' and '20200130'
 and Nb_Points_Prime is not null) m
 on c.MasterID=m.MasterID
 --where sexe =1

  /*FREQUENCE*/
  drop table #entrees
  select e.MasterID,count ( distinct ID_ENTREE) as nbr_entree
   into #entrees
  FROM [BARRIERE].[dbo].[C_Entree] e
 inner join (select distinct MasterID
 FROM [BARRIERE].[dbo].[C_EarnCasino]
 where Univers in (1,2,3,4) 
 and Date_Seance_Casino between '20190301' and '20200130'
 and Nb_Points_Prime is not null) m
 on e.MasterID=m.MasterID
 where Date_Seance_Casino between '20190301' and '20200130'
 group by e.MasterID

  select avg ( nbr_entree)
 from #entrees

 /*HANDLE*/
 select Univers,
 count(distinct e.masterID) as MasterID,
 avg(Handle) as Handle
 ,avg (PBJ) as pbj , avg ([Drop]) as Drop_jeu
   FROM [BARRIERE].[dbo].[C_EarnCasino] e
   inner join (select distinct MasterID
 FROM [BARRIERE].[dbo].[C_EarnCasino] 
 where Univers in (1,2,3,4) 
 and Date_Seance_Casino between '20190301' and '20200130'
 and Nb_Points_Prime is not null) m
 on e.MasterID=m.MasterID
 where Date_Seance_Casino between '20190301' and '20200130' and Univers in (1,2,3,4)
 group by Univers



 --------------------------------
/*TOUs burners*/
-------------------------------

select --c.MasterID, Sexe, Age, Date_Creation,
  count (distinct c.MasterID) as MasterID
--avg ( DATEDIFF(year,getdate(),Date_Creation))
--avg (age)
   FROM [BARRIERE].[dbo].[Contacts] c
   inner join (
select distinct MasterID as Clts_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION'  
or b2.[Famille_Article] = 'MACHINES A SOUS'
or b2.[Famille_Article] = 'JEUX DE TABLE') m
 on c.MasterID=m.Clts_Burn
 where sexe =1


/*FREQUENCE*/
  drop table #entrees
  select e.MasterID,count ( distinct ID_ENTREE) as nbr_entree
   into #entrees
  FROM [BARRIERE].[dbo].[C_Entree] e
 inner join (select distinct MasterID as Clts_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION'  
or b2.[Famille_Article] = 'MACHINES A SOUS'
or b2.[Famille_Article] = 'JEUX DE TABLE') m
 on e.MasterID=m.Clts_Burn
 where Date_Seance_Casino between '20190301' and '20200130'
 group by e.MasterID

  select avg ( nbr_entree)
 from #entrees


 /*NIV FID*/
  select Niv_Fid,count (distinct e.MasterId) as Clt
    FROM [BARRIERE].[dbo].[C_CompteClient] e
  inner join (select distinct MasterID as Clts_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')
or b2.[Famille_Article] = 'BAR/RESTAURATION'  
or b2.[Famille_Article] = 'MACHINES A SOUS'
or b2.[Famille_Article] = 'JEUX DE TABLE') m
 on e.MasterID=m.Clts_Burn
 where Type_Fid=2
 group by Niv_Fid

 select n.Niv_Fid,count (distinct c.MasterId) as Clt
    FROM [BARRIERE].[dbo].[C_CompteClient] c
	inner join #niv n
	on c.MasterId=n.MasterId
	where c.MasterId in (select distinct MasterID 
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')
or b2.[Famille_Article] = 'BAR/RESTAURATION'  
or b2.[Famille_Article] = 'MACHINES A SOUS'
or b2.[Famille_Article] = 'JEUX DE TABLE')
group by n.Niv_Fid

/*HANDLE*/
select Univers,
 count(distinct e.masterID) as MasterID,
 avg(Handle) as Handle
 ,avg (PBJ) as pbj , avg([Drop]) as Drop_jeu
  FROM [BARRIERE].[dbo].[C_EarnCasino] e
  inner join(select distinct MasterID 
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and (b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION')
or b2.[Famille_Article] = 'BAR/RESTAURATION'  
--or b2.[Famille_Article] = 'MACHINES A SOUS'
--or b2.[Famille_Article] = 'JEUX DE TABLE' 
) b
on e.MasterID = b.MasterID
 where Date_Seance_Casino between '20190301' and '20200130' and Univers in (1,2,3,4)
 group by Univers

 ----------------------------------
 /*ACTIF BURN*/
 drop table #Uni_cli_Burn
select  b.Clts_Burn
, max(case when b.Famille_Article in ('MACHINES A SOUS','JEUX DE TABLE') then 1 else 0 end) as Flag_Jeux 
, max(case when b.Famille_Article in ('BAR/RESTAURATION') or b.Famille_Article is null then 1 else 0 end) as Flag_Restau 
into #Uni_cli_Burn
FROM (select distinct MasterID as Clts_Burn, b2.[Famille_Article], Code_Etablissement
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION'  
or b2.[Famille_Article] = 'MACHINES A SOUS'
or b2.[Famille_Article] = 'JEUX DE TABLE') b
--where b.Code_Etablissement = 'ROY'
group by b.Clts_Burn

select * from #Uni_cli_Burn

select 
case when Flag_Jeux = 1 and Flag_Restau = 0 then '3 - Exclu Jeux Burn'
 when Flag_Jeux = 0 and Flag_Restau = 1 then '2 - Exclu Restau Burn'
 when Flag_Jeux = 1 and Flag_Restau = 1 then '1 - Mixte Jeux Restau Burn'
 else '4 - Autres' end as Activité,
 count(distinct Clts_Burn) as Burners
 from #Uni_cli_Burn
 group by  case when Flag_Jeux = 1 and Flag_Restau = 0 then '3 - Exclu Jeux Burn'
 when Flag_Jeux = 0 and Flag_Restau = 1 then '2 - Exclu Restau Burn'
 when Flag_Jeux = 1 and Flag_Restau = 1 then '1 - Mixte Jeux Restau Burn'
 else '4 - Autres' end
------------------------------------
/*CLIENT BURNER EN RESTAURATION CA EN EARN*/
/*BURNER RESTAU*/
------------------------------------

select sum(isnull(Nb_Points_Prime,0)) as Nb_Points_Prime
FROM [BARRIERE].[dbo].[C_EarnCasino]
where MasterID in (
select distinct MasterID as Clts_Burn
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION' )
and Date_Seance_Casino between '20190301' and '20200130'
and Univers in (4)

select 
sum(isnull(Nb_Points_Prime,0)) as Nb_Points_Prime
FROM [BARRIERE].[dbo].[C_EarnCasino]
where Date_Seance_Casino between '20190301' and '20200130'
and Univers in (4)



 /*FREQUENCE RESTAURATION earner*/
  drop table #entrees
 select MasterID, convert(float, count (distinct Date_Seance_Casino)) as Entrees,
 convert(float, count (distinct [Transaction_Id])) as Tx
 ,sum(Nb_Points_Prime) as Prime
 into #entrees
   FROM [BARRIERE].[dbo].[C_EarnCasino]
    where Univers in (4) 
 and Date_Seance_Casino between '20190301' and '20200130'
 --and Nb_Points_Prime is not null
 group by MasterID

  select avg ( tx / Entrees)
 from #entrees


  /*FREQUENCE RESTAURATION burner*/

   drop table #entrees_burn
 select MasterID, convert(float, count (distinct Date_Seance_Casino)) as Entrees,
 convert(float, count (distinct [Transaction_Id])) as Tx
 ,sum(Nb_Points_Prime) as Prime
 into #entrees_burn
   FROM [BARRIERE].[dbo].[C_EarnCasino] 
    where Univers in (4) 
	and MasterID in (select distinct MasterID 
FROM [BARRIERE].[dbo].[C_BurnCasino] b1	
left join  [BARRIERE].[dbo].[C_Burn_user] b2	
on b1.Id_Burn_Casino_WS = b2.Id_Burn_Casino_WS
where Date_Seance_Casino between '20190301' and '20200130'	
and univers = 7	
and b2.[Famille_Article] is null and b2.LibellePromo = 'BURN_RESTAURATION'
or b2.[Famille_Article] = 'BAR/RESTAURATION')
 and Date_Seance_Casino between '20190301' and '20200130'
 --and Nb_Points_Prime is not null
 group by MasterID


   select avg ( Prime / Entrees)
 from #entrees

