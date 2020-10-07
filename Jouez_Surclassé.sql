	
/*	
-- Recherche Opération dans données CRM	
select *	
FROM [SIDBDWH].[qts].[T_OPERATION]	
where slabel  like '%jouez%' --- ici	
and tsStart >= '20190101' */	
	
/*Stockage id opeartion crm*/	
select 65091693 as IdOperation into #op_crm	
	
	
/* période op */	
Drop Table #Periode	
select '20200106' as Dt_Min,	
'20200202' as Dt_Max	
into #Periode	
	
/* établissements participants*/	
create table #etabs (casino varchar (3))	
	
Insert into #etabs values ('BDT')	
Insert into #etabs values ('BIA')	
Insert into #etabs values ('BLZ')	
Insert into #etabs values ('BDX')	
Insert into #etabs values ('CAN')	
Insert into #etabs values ('CRY')	
Insert into #etabs values ('CIS')	
Insert into #etabs values ('DEA')	
Insert into #etabs values ('DIN')	
Insert into #etabs values ('LBA')	
Insert into #etabs values ('LRO')	
Insert into #etabs values ('LIL')	
Insert into #etabs values ('MEN')	
Insert into #etabs values ('ENG')	
Insert into #etabs values ('NDR')	
Insert into #etabs values ('OUI')	
Insert into #etabs values ('RBV')	
Insert into #etabs values ('ROY')	
Insert into #etabs values ('SMX')	
Insert into #etabs values ('SMA')	
Insert into #etabs values ('SRP')	
Insert into #etabs values ('TLS')	
Insert into #etabs values ('TRO')	
Insert into #etabs values ('AGD')	
Insert into #etabs values ('CAP')	
Insert into #etabs values ('LTQ')	
Insert into #etabs values ('NCE')	
	
	
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
FROM  [SIDBDWH].[qts].[T_C_CompteClient] c	
inner join (select MasterId,  max([Id_Compte_Client_WS]) as Max_Cpte	
FROM [SIDBDWH].[qts].[T_C_CompteClient]	
where [DT_Deb_Niv] <= dateadd(day,1,(select Dt_Max from #Periode) )	
and isnull(Date_Inactive_Cc,'20990101') >  dateadd(day,1,(select Dt_Max from #Periode) )	
and Type_Fid in (1, 2)  group by MasterId ) m	
on c.MasterId = m. MasterId and c.Id_Compte_Client_WS = m.Max_Cpte	
	
drop table #cibles	
select MasterId,	
max(case when [iMessageType] = 0 then 1 else 0 end) as Email,	
max(case when [iMessageType] = 1 then 1 else 0 end) as SMS,	
min(case when slabel like '%prospect%' then 1 else 0 end) as Prospect	
into #cibles	
FROM [SIDBDWH].[qts].[T_DELIVERY] d	
inner join [SIDBDWH].[qts].[T_BROADLOG] b	
on d.iDeliveryId =b.iDeliveryId	
where iOperationId = (select * from #op_crm )	
group by masterid	
	
Drop table #perf_cib	
select c.MasterId, Email, SMS, Prospect,	
isnull(Entrees,0) as Entrees,	
case when e.MasterID is not null then 1 else 0 end as Ent,	
(case when a.MasterID is not null then 1 else 0 end) as Jeu,	
isnull(Mas_Jte,0) as Cli_Mas_Jte, isnull(Handle,0) as Handle,	
isnull(Jdt,0) as Jdt, isnull(Drop_Jdt,0) as Drop_Jdt	
into #perf_cib	
from #cibles c	
left join (select MasterID,	
count(distinct id_entree_ws) as Entrees	
from [SIDBDWH].[qts].[T_C_Entree]	
where Code_Etablissement in (select * from #etabs)	
and Date_Seance_Casino between (select Dt_Min from #Periode) and (select Dt_Max from #Periode)	
group by MasterID  ) e	
on c.MasterID = e.MasterID	
left join	
(select MasterId,	
max(case when Univers in (1,3) then 1 else 0 end) as Mas_Jte,	
sum(case when  Univers in (1,3) and Handle between 0.01 and 500000 then Handle else 0 end) as  Handle,	
max(case when Univers = 2 then 1 else 0 end) as Jdt,	
sum(case when Univers = 2 and [Valeur_Drop] between 0.01 and 50000 then [Valeur_Drop] else 0 end) as  Drop_Jdt	
from [SIDBDWH].[qts].[T_C_EarnCasino]	
where Code_Etablissement in (select * from #etabs)	
and Date_Seance_Casino between (select Dt_Min from #Periode) and (select Dt_Max from #Periode)	
and Univers between 1 and 3	
group by MasterID ) a	
on c.MasterID = a.MasterID	
	
	
-- select top 5000 * from #perf_cib where email +  sms < 1	
	
select case when email = 1 and sms = 0 then '1 - Email'	
when email = 0 and sms = 1 then '2 - SMS'	
when email = 1 and sms = 1 then '3 - Email & SMS'	
else '4 - Autres' end as Communication,	
-- select	
count(distinct masterid) as Cibles,	
sum(ent) as Cibles_Ent,	
sum(Entrees) as Entrees,	
sum(Jeu) as Cibles_Jeu,	
convert(int,sum(Handle)) as Handle,	
convert(int,case when sum(Cli_Mas_Jte) > 0 then sum(Handle) / sum(Cli_Mas_Jte) else 0 end) as Han_Cible,	
convert(int,sum(Drop_Jdt)) as Drop_Jdt,	
convert(int,case when  sum(Jdt) > 0 then sum(Drop_Jdt) / sum(Jdt) else 0 end ) as Drop_Cible	
from #perf_cib	
--where [Prospect]= 0	
group by  case when email = 1 and sms = 0 then '1 - Email'	
when email = 0 and sms = 1 then '2 - SMS'	
when email = 1 and sms = 1 then '3 - Email & SMS'	
else '4 - Autres' end	
order by case when email = 1 and sms = 0 then '1 - Email'	
when email = 0 and sms = 1 then '2 - SMS'	
when email = 1 and sms = 1 then '3 - Email & SMS'	
else '4 - Autres' end	
	
	
	
select case when Prospect =1 then 0 else [Niv_Fid] end as Niv,	--- 0 si  prospect
count(distinct p.MasterID) as Cibles,	
sum(ent) as Cibles_Ent,	
sum(Entrees) as Entrees,	
sum(Jeu) as Cibles_Jeu,	
convert(int,sum(Handle)) as Handle,	
convert(int,case when sum(Cli_Mas_Jte) > 0 then sum(Handle) / sum(Cli_Mas_Jte) else 0 end) as Han_Cible,	
convert(int,sum(Drop_Jdt)) as Drop_Jdt,	
convert(int,case when  sum(Jdt) > 0 then sum(Drop_Jdt) / sum(Jdt) else 0 end ) as Drop_Cible	
from #perf_cib	p
left join #niv n	
on p.MasterID = n.MasterId	
--where [Niv_Fid]>= 2	
group by  case when Prospect =1 then 0 else [Niv_Fid] end	
order by  case when Prospect =1 then 0 else [Niv_Fid] end	
