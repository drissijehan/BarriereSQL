/*	select Univers,
	sum(Handle)
FROM [BARRIERE].[dbo].[C_EarnCasino]	
where Univers  in (1,3)	
and [Date_Seance_Casino] between '20191017' and '20191122'	
and Handle between 0.01 and 1000000	
and Code_Etablissement = 'CAN'	
and MasterId in (select MasterId  from [BARRIERE].[dbo].[C_CompteClient]	
where Cd_Casino_Rattachement in ('CAP')	
and DT_Deb_Niv_Actu is not NULL)	
group by Univers	
*/	

/*Actifs Entrées*/	
select Niv_Fid, COUNT (DISTINCT e.MasterID) as Clients,	
count (distinct e.Id_Entree_WS) as Entrees	
FROM [BARRIERE].[dbo].[C_Entree] e	
inner join (select MasterId, Niv_Fid from [BARRIERE].[dbo].[C_CompteClient]	
where Cd_Casino_Rattachement in ('CAP')	
and DT_Deb_Niv_Actu is not NULL) c	
on e.MasterID = c.MasterId	
where Date_Seance_Casino >= '20191017' -- Date Fermeture Casino Les Princes	
and Code_Etablissement in ('CAN')	
group by Niv_Fid	
order by Niv_Fid	

/* Earn Standard Carré VIP : Mas, Jdt, Jte, Restauration*/	
select Niv_Fid, COUNT (DISTINCT e.MasterID) as Clients_Actifs_Earn_CVIP,	
count(distinct Code_Etablissement + cast(e.MasterId as varchar) + convert(varchar, Date_Seance_Casino) ) as Visites_Actives,	
sum(Nb_Points_Prime) as Pts_Earn_Std_Total	
FROM (select MasterId, Niv_Fid from [BARRIERE].[dbo].[C_CompteClient]	
where Cd_Casino_Rattachement in ('CAP')	
and DT_Deb_Niv_Actu is not NULL) c	
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
FROM (select MasterId, Niv_Fid from [BARRIERE].[dbo].[C_CompteClient]	
where Cd_Casino_Rattachement in ('CAP')	
and DT_Deb_Niv_Actu is not NULL) c	
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
FROM (select MasterId, Niv_Fid from [BARRIERE].[dbo].[C_CompteClient]	
where Cd_Casino_Rattachement in ('CAP')	
and DT_Deb_Niv_Actu is not NULL) c	
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
FROM (select MasterId, Niv_Fid from [BARRIERE].[dbo].[C_CompteClient]	
where Cd_Casino_Rattachement in ('CAP')	
and DT_Deb_Niv_Actu is not NULL) c	
inner join [BARRIERE].[dbo].[C_EarnCasino] e	
on c.MasterId = e.MasterId	
where Date_Seance_Casino >= '20191017' and Code_Etablissement in ('CAN')	
and Univers in (4) ---and Handle between 0.01 and 1000000	
group by Niv_Fid	
order by Niv_Fid	