select top 100 * from #niv
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
where [DT_Deb_Niv] <= dateadd(day,1,'20200612' )	
and isnull(Date_Inactive_Cc,'20990101') >  dateadd(day,1,'20200612' )	
and Type_Fid in (1, 2)  group by MasterId ) m	
on c.MasterId = m. MasterId and c.Id_Compte_Client_WS = m.Max_Cpte	
	
	/*Client*/
select distinct ID_CLIENT as ID_CLIENT, Niv_Fid, 
Cd_Casino_Rattachement
FROM [SIDBDMT].[mkc].[T_FAIT_ENTREES] e
inner join (select MasterId, Niv_Fid,
 Cd_Casino_Rattachement FROM #niv) c
on e.ID_CLIENT=c.MasterId
where ID_ETABLISSEMENT_SES = 'DEA'
and DT_SEANCE_CASINO between '20190602' and '20190612'

/*Entrées*/
select distinct ID_ENTREE as ID_ENTREE, ID_CLIENT, Niv_Fid, 
Cd_Casino_Rattachement
FROM [SIDBDMT].[mkc].[T_FAIT_ENTREES] e
inner join (select MasterId, Niv_Fid,
 Cd_Casino_Rattachement FROM #niv) c
on e.ID_CLIENT=c.MasterId
where ID_ETABLISSEMENT_SES = 'DEA'
and DT_SEANCE_CASINO between '20190602' and '20190612'




