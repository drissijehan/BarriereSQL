
-------------- NIV ---------------
drop table #niv
select Cd_Casino_rattachement,c.MasterID
,(case when Niv_Fid in (5,6) then Niv_Fid - 4
when Niv_Fid = 7 then 4
when Niv_Fid = 8 then 5
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
from [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_C_COMPTECLIENT] c
inner join (select MasterId , max(Id_compte_client_ws) as Max_Cpte
from [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_C_COMPTECLIENT]
where Dt_Deb_Niv <= '20990101'
and isnull (date_Inactive_Cc,'20990101') > '20191001'
and Type_Fid in (1,2) group by MasterId ) m
on c.MasterId = m.MasterID and c.Id_Compte_Client_Ws = m.Max_Cpte
order by c.MasterID
select top 100 * from #niv

------- Points --------

select ID_Etablissement_SES, DT_SEANCE_Casino
,sum (NB_POINTS_STATUT) as Point_Statut,
sum (NB_POINTS_STATUT_N) as Points_Statut_N
,sum(NB_Points_Statut_P) as Points_Statut_P
,sum(NB_Points_Prime) as Points_Prime
,sum(NB_POINTS_Prime_N) as Points_Prime_N
,sum(NB_Points_Prime_P) as Points_Prime_P
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkc].[T_FAIT_POINTS_FIDELITE] 
where LB_EARN_BURN = 'EARN'
and (DT_SEANCE_CASINO between '20191028' and '20191103' or DT_SEANCE_CASINO between '20191104' and '20191110')
group by ID_Etablissement_SES, DT_SEANCE_Casino
order by ID_Etablissement_SES, DT_SEANCE_Casino


----Point par Niveau --------

select ID_Etablissement_SES, Niv_Fid
,sum (NB_POINTS_STATUT) as Point_Statut,
sum (NB_POINTS_STATUT_N) as Points_Statut_N
,sum(NB_Points_Statut_P) as Points_Statut_P
,sum(NB_Points_Prime) as Points_Prime
,sum(NB_POINTS_Prime_N) as Points_Prime_N
,sum(NB_Points_Prime_P) as Points_Prime_P
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkc].[T_FAIT_POINTS_FIDELITE] f
inner join #niv n
on f.ID_CLIENT=n.MasterId
where LB_EARN_BURN = 'EARN'
and (DT_SEANCE_CASINO between '20191028' and '20191103' )
group by ID_Etablissement_SES, Niv_Fid
order by ID_Etablissement_SES, Niv_Fid