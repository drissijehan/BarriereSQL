    drop table #prems
select MasterId,
min(date_Reservation) as Prem_Resa,
min(case when Statut_Reservation = 4 then Date_Debut else null end ) as Prem_Sej
into #prems
FROM  [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_RESADETAILSEJOUR] r
where Code_Etablissement <> 'MARNA'
and Type_Sejour = 1
and Classe_de_Chambre <> 'PSEUDO'
and r.Delete_Date is null
and (Date_Reservation between '20160212' and dateadd(day,1,'20210228')
or Date_Debut between '20160212' and '20210228' )
group by MasterId
select top 100 * from #prems
 
 drop table #Data
 select [CO_ETABLISSEMENT_QTS] as Etablissement,
 Id_client as Client, Id_sejour as Sejour
 , id_sexe_client as Sexe, nb_age_client as Age,
 bo_client_circulant as Circulant, bo_client_famille as Famille, bo_client_ib as IB,
 id_frequence_activite as Frequence_Activite,
 case when  Prem_Sej  between '20210212' and '20210228' then 1 else 0 end as Primo,
 co_residence_client as Provenance, co_code_postal_client as Code_Postal,
 nb_delai_reservation as Delai_Resa, nb_Duree_sejour as Duree_Sejour,
 lb_type_canal_reservation as Type_Canal_Resa, lb_canal_detail as Detail_Canal,
 [MT_CA_SEJ_HEBERGEMENT_HT] as CA_Hebg_HT, [MT_CA_SEJ_HEBERGEMENT_TTC] as CA_Hebg_TTC
 ,[MT_CA_SEJOUR_HT] as CA_Sejour_HT, [MT_CA_SEJOUR_TTC] as CA_Sejour_TTC
 into #Data
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
  inner join #prems p
  on s.id_client=p.MasterId
  where DT_DEBUT_SEJOUR between '20210212' and '20210228'
  and id_statut_sejour in (3,4)
  and id_type_sejour = 1
  and dt_debut_sejour <> dt_fin_sejour 
  and [CO_ETABLISSEMENT_QTS] = 'LBAHR'--not in ('MARNA', 'STBCG', 'LTQWE')

select * from #Data

 drop table #West
 select [CO_ETABLISSEMENT_QTS] as Etablissement,
 Id_client as Client, Id_sejour as Sejour
 , id_sexe_client as Sexe, nb_age_client as Age,
 bo_client_circulant as Circulant, bo_client_famille as Famille, bo_client_ib as IB,
 id_frequence_activite as Frequence_Activite,
 case when  Prem_Sej  between '20210212' and '20210305' then 1 else 0 end as Primo,
 co_residence_client as Provenance, co_code_postal_client as Code_Postal,
 nb_delai_reservation as Delai_Resa, nb_Duree_sejour as Duree_Sejour,
 lb_type_canal_reservation as Type_Canal_Resa, lb_canal_detail as Detail_Canal,
 [MT_CA_SEJ_HEBERGEMENT_HT] as CA_Hebg_HT, [MT_CA_SEJ_HEBERGEMENT_TTC] as CA_Hebg_TTC
 ,[MT_CA_SEJOUR_HT] as CA_Sejour_HT, [MT_CA_SEJOUR_TTC] as CA_Sejour_TTC
 into #West
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
  inner join #prems p
  on s.id_client=p.MasterId
  where DT_DEBUT_SEJOUR between '20210212' and '20210305'
  and id_statut_sejour in (3,4)
  and id_type_sejour = 1
  and dt_debut_sejour <> dt_fin_sejour 
  and [CO_ETABLISSEMENT_QTS] = 'LTQWE'

  select * from #West
  
  drop table #Data2
  select * into #Data2 from #Data union select * from #West
  select * from #Data2


  select distinct Client, Sexe,Age--, Famille
  ,IB, Primo, Provenance, Code_Postal
   from #Data2

select count (distinct sejour) as client
from #West
where Sexe=1


drop table #region
select distinct co_region, lb_region into #region from [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[ref].[T_GEOGRAPHIE]



select MasterId, Pays_de_residence, Region, lb_region
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c
full outer join #region r
on c.Region= r.co_region
where Masterid in (select Client from #Data2) and Region is not NULL 

----------------------
select distinct Client, Sexe--, Famille
  ,IB, Primo, Provenance, Code_Postal
   from #West

select MasterId, Pays_de_residence, Region, lb_region
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_CONTACTS] c
full outer join #region r
on c.Region= r.co_region
where Masterid in (select Client from #West)