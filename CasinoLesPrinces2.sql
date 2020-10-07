-- Volume Entrees Clients Rattachés aux autres casinos hors Les Princes
drop table #Prince
select e.MasterID , Niv_Fid
,count (distinct id_entree_ws) as Entrees
,count (distinct (case when Code_Etablissement = 'CAP' then Id_Entree_WS else null end))  as Prince
into #Prince
FROM [BARRIERE].[dbo].[C_Entree] e
inner join (select MasterId, Niv_Fid from [BARRIERE].[dbo].[C_CompteClient] 
where Cd_Casino_Rattachement not in ('CAP')) c
on e.MasterID = c.MasterId
where Date_Seance_Casino between '20181001' and '20191017'
--and e.MasterID= 1862224 
group by e.MasterID, Niv_Fid
order by e.MasterID, Niv_Fid
--select * from #Prince

/* niveau des clients à la fin de la période N*/	
Drop table #niv	
SELECT [Cd_Casino_Rattachement]	
,c.[MasterId]	
,(case when [Niv_Fid] in (5,6) then [Niv_Fid] - 4	
	when [Niv_Fid] = 7 then 4
	else [Niv_Fid] end) as [Niv_Fid]
,[DT_Deb_Niv]	
,[DT_Fin_Niv]	
,[Date_Exp_Niveau]	
,[DT_Deb_Niv_Actu]	
,[Status_Cc]	
,[Type_Cc]	
,[Inactive_Cause_Text_Cc]	
,[Inactive_Cause_Cc]	
,[Date_Inactive_Cc]	
,[Delete_Date]	
	into #niv
FROM  [BARRIERE].[dbo].[C_CompteClient] c	
inner join (select MasterId,  max([Id_Compte_Client_WS]) as Max_Cpte	
FROM [BARRIERE].[dbo].[C_CompteClient]	
where [DT_Deb_Niv] <= '20191017' 	
and isnull(Date_Inactive_Cc,'20990101') >  '20191017' 
and Type_Fid in (1, 2)  group by MasterId ) m	
on c.MasterId = m. MasterId and c.Id_Compte_Client_WS = m.Max_Cpte	
order by c.MasterId
--select * from #niv


/* Selection Client avec moitié entrée les princes avant fermeture */
drop table #Rapport
select p.MasterID,n.Niv_Fid, Entrees, Prince , cast(Prince as float)/cast(Entrees as float)*100 as Rapport
into #Rapport
from #Prince p
inner join (select Niv_Fid, MasterId from #niv) n
on p.MasterID=n.MasterId
where cast(Prince as float)/cast(Entrees as float)*100 >= 50
--where MasterID=1862224
select * from #Rapport

/*Actifs Entrées*/	
select Niv_Fid, COUNT (DISTINCT e.MasterID) as Clients,	
count (distinct e.Id_Entree_WS) as Entrees	
FROM [BARRIERE].[dbo].[C_Entree] e	
inner join (select MasterId, Niv_Fid from #Rapport) c	
on e.MasterID = c.MasterId	
where Date_Seance_Casino >= '20191017' -- Date Fermeture Casino Les Princes	
and Code_Etablissement in ('CAN')	
group by Niv_Fid	
order by Niv_Fid

/* Earn Standard Carré VIP : Mas, Jdt, Jte, Restauration*/	
select Niv_Fid, COUNT (DISTINCT e.MasterID) as Clients_Actifs_Earn_CVIP,	
count(distinct Code_Etablissement + cast(e.MasterId as varchar) + convert(varchar, Date_Seance_Casino) ) as Visites_Actives,	
sum(Nb_Points_Prime) as Pts_Earn_Std_Total	
FROM (select MasterId, Niv_Fid from #Rapport) c	
inner join [BARRIERE].[dbo].[C_EarnCasino] e	
on c.MasterId = e.MasterId	
where Date_Seance_Casino >= '20191017' and Code_Etablissement in ('CAN')	
and Univers in (1,2,3,4)	
group by Niv_Fid	
order by Niv_Fid	

/* Earn Standard Carré VIP : Mas & Jte*/	
select Niv_Fid, COUNT (DISTINCT e.MasterID) as Clients_Actifs_Mas_Jte,	
--count (distinct e.Id_Entree_WS) as Entrees	
count(distinct Code_Etablissement + cast(e.MasterId as varchar) + convert(varchar, Date_Seance_Casino) ) as Visites_Actives,	
sum(Handle) as Handle_Mas_Jte,	
sum(Nb_Points_Prime) as Pts_Earn_Std_Mas_Jte	
FROM (select MasterId, Niv_Fid from #Rapport) c	
inner join [BARRIERE].[dbo].[C_EarnCasino] e	
on c.MasterId = e.MasterId	
where Date_Seance_Casino >= '20191017' and Code_Etablissement in ('CAN')	
and Univers in (1,3) and Handle between 0.01 and 1000000	
group by Niv_Fid	
order by Niv_Fid	


/* Earn Standard Carré VIP : JDT*/	
select Niv_Fid, COUNT (DISTINCT e.MasterID) as Clients_Actifs_Mas_Jte,	
--count (distinct e.Id_Entree_WS) as Entrees	
count(distinct Code_Etablissement + cast(e.MasterId as varchar) + convert(varchar, Date_Seance_Casino) ) as Visites_Actives,	
sum([Drop]) as Drop_JDT,	
sum(Nb_Points_Prime) as Pts_Earn_Std_Mas_Jte	
FROM (select MasterId, Niv_Fid from #Rapport) c	
inner join [BARRIERE].[dbo].[C_EarnCasino] e	
on c.MasterId = e.MasterId	
where Date_Seance_Casino >= '20191017' and Code_Etablissement in ('CAN')	
and Univers in (2) ---and Handle between 0.01 and 1000000	
group by Niv_Fid	
order by Niv_Fid

/* Actif Restauration Carré VIP */	
select Niv_Fid, COUNT (DISTINCT e.MasterID) as Clients_Actifs_Mas_Jte,	
--count (distinct e.Id_Entree_WS) as Entrees	
count(distinct Code_Etablissement + cast(e.MasterId as varchar) + convert(varchar, Date_Seance_Casino) ) as Visites_Actives,		
sum(Nb_Points_Prime) as Pts_Earn_Std_Mas_Jte	
FROM (select MasterId, Niv_Fid from #Rapport) c	
inner join [BARRIERE].[dbo].[C_EarnCasino] e	
on c.MasterId = e.MasterId	
where Date_Seance_Casino >= '20191017' and Code_Etablissement in ('CAN')	
and Univers in (4) ---and Handle between 0.01 and 1000000	
group by Niv_Fid	
order by Niv_Fid	