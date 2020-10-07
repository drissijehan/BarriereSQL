
Drop Table #Periode	
select '20190806' as Dt_Min,	
'20200806' as Dt_Max	
into #Periode

Drop table #niv	
SELECT [Cd_Casino_Rattachement]	
,c.[MasterId]	
,(case when [Niv_Fid] in (5,6) then [Niv_Fid] - 4	
	when [Niv_Fid] = 7 then 4
	else [Niv_Fid] end) as [Niv_Fid]
,[DT_Deb_Niv]	
, [DT_Fin_Niv]	
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
where [DT_Deb_Niv] <= dateadd(day,1,(select Dt_Max from #Periode) )	
and isnull(Date_Inactive_Cc,'20990101') >  dateadd(day,1,(select Dt_Max from #Periode) )	
and Type_Fid in (1, 2)  group by MasterId ) m	
on c.MasterId = m. MasterId and c.Id_Compte_Client_WS = m.Max_Cpte	
--select top 100 * from #niv

select --Niv_Fid,
 Slot_ID
,count (distinct e.MasterId) as Client
, sum(Handle) as Handle_RAE
--,max(Date_Seance_Casino) as Der_Partie_RAE
from [BARRIERE].[dbo].[C_EarnCasino] e
inner join #niv n
on e.MasterID=n.MasterId
--where Date_Seance_Casino between dateadd(month, -12, getdate()) and getdate()
/* RAE uniquement*/
where Univers = 3  and Jeu like 'R%'
and Code_Etablissement = 'MEN' 
group by-- Niv_Fid,
Slot_ID
order by Niv_Fid--,Slot_ID

--------------------------
/*FAZI*/
select 
--Niv_Fid,
 Slot_ID
,count (distinct e.MasterId) as Client
, sum(Handle) as Handle_RAE
--,max(Date_Seance_Casino) as Der_Partie_RAE*/
from [BARRIERE].[dbo].[C_EarnCasino] e
inner join #niv n
on e.MasterID=n.MasterId
/* FAZI*/
where Slot_ID in ('1601','1602','1603','1604','1605',
'1606','1607','1608','1609','1610')
and Code_Etablissement = 'MEN' 
group by --Niv_Fid,
Slot_ID
order by Niv_Fid,Slot_ID

select count (distinct (c.MasterID)) as MasterID 
,niv_fid
, avg(Age) as Age_Moy
  FROM [BARRIERE].[dbo].[Contacts] c
  inner join #niv n
on c.MasterID=n.MasterId
  where c.MasterID in (select MasterID
from [BARRIERE].[dbo].[C_EarnCasino] 
/* FAZI*/
where Slot_ID in ('1601','1602','1603','1604','1605',
'1606','1607','1608','1609','1610')
and Code_Etablissement = 'MEN' )
group by Niv_Fid


--------------------------
/*NOVOMATIC*/
select 
Niv_Fid
-- Slot_ID
,count (distinct e.MasterId) as Client
, sum(Handle) as Handle_RAE
--,max(Date_Seance_Casino) as Der_Partie_RAE*/
from [BARRIERE].[dbo].[C_EarnCasino] e
inner join #niv n
on e.MasterID=n.MasterId
/* NOVOMATIC*/
where Slot_ID in ('1201','1202','1203','1204','1205','1206',
'1207','1215','1216','1217','1218','1219','1220','1221','1222','1223'
,'1224','1225','1226','1211')
and Code_Etablissement = 'MEN' 
group by Niv_Fid
--Slot_ID
order by Niv_Fid,Slot_ID

select count (distinct (c.MasterID)) as MasterID 
,niv_fid
, avg(Age) as Age_Moy
  FROM [BARRIERE].[dbo].[Contacts] c
  inner join #niv n
on c.MasterID=n.MasterId
  where c.MasterID in (select MasterID
from [BARRIERE].[dbo].[C_EarnCasino] 
/* FAZI*/
where Slot_ID in ('1201','1202','1203','1204','1205','1206',
'1207','1215','1216','1217','1218','1219','1220','1221','1222','1223'
,'1224','1225','1226','1211')
and Code_Etablissement = 'MEN' )
group by Niv_Fid
order by Niv_Fid