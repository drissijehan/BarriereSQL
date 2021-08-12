Drop Table  #IB_Hist
select c.MasterId, max(case when Niveau_IB = 7 then 0 else Niveau_IB end ) as Niv_IB
into #IB_Hist
from  [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_COMPTEFIDELITE] c
inner join (select MasterId, max(Update_Date) as max_update  
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_COMPTEFIDELITE]
  where type_fid = 'IB'
---and [Num_Adht_IB] like '[A-Z]%'
and Niveau_IB between 1 and 7
group by MasterId )x
on c. masterid = x.MasterId
and c.Update_Date = x.max_update
group by c.MasterId

SELECT * FROM #IB_Hist
  ,[ID_CANAL_RESERVATION]
      ,[LB_CANAL_RESERVATION]
      ,[ID_CANAL_DETAIL]
    

SELECT TOP 900 [ID_SEJOUR]
      ,[ID_ETABLISSEMENT]
      ,[CO_ETABLISSEMENT_QTS]
      ,[LB_ETABLISSEMENT]
      ,[ID_CLIENT]
      ,[DH_RESERVATION]
      ,[DT_DEBUT_SEJOUR]
      ,[DT_FIN_SEJOUR]
      ,[DT_SEJOUR_PRECEDENT]
      ,[ID_JOUR_RESERVATION]
      ,[ID_JOUR_DEBUT_SEJOUR]
      ,[ID_JOUR_FIN_SEJOUR]
      ,[NB_DELAI_RESERVATION]
      ,[ID_DELAI_RESERVATION]
      ,[ID_STATUT_SEJOUR]
      ,[LB_STATUT_SEJOUR]
      ,[ID_RATE_CATEGORIE]
      ,[LB_RATE_CATEGORIE]
      ,[ID_TYPE_SEJOUR]
      ,[LB_TYPE_SEJOUR]
      ,[ID_DUREE_SEJOUR]
      ,[NB_DUREE_SEJOUR]
      ,[LB_DUREE_SEJOUR]
      ,[LB_CANAL_DETAIL]
      ,[ID_TYPE_CANAL_RESERVATION]
      ,[LB_TYPE_CANAL_RESERVATION]
      ,[CO_CODE_POSTAL_CLIENT]
      ,[ID_NATIONALITE_CLIENT]
      ,[CO_NATIONALITE_CLIENT]
      ,[ID_RESIDENCE_CLIENT]
      ,[CO_RESIDENCE_CLIENT]
      ,[ID_SEXE_CLIENT]
      ,[NB_AGE_CLIENT]
      ,[ID_TRANCHE_AGE_CLIENT]
      ,[BO_CLIENT_CIRCULANT]
      ,[BO_CLIENT_FAMILLE]
      ,[BO_CLIENT_IB]
      ,[ID_FREQUENCE_ACTIVITE]
      ,[NB_CHAMBRE]
      ,[NB_OCCUPANTS_ADULTES]
      ,[NB_OCCUPANTS_ENFANTS]
      ,[NB_ADULTES]
      ,[NB_ENFANTS]
      ,[ID_TRANCHE_CA_HEBERGEMENT_HT_1AN]
      ,[MT_CA_SEJ_HEBERGEMENT_TTC]
      ,[MT_CA_SEJ_RESTAURATION_TTC]
      ,[MT_CA_SEJ_DIVERS_TTC]
      ,[MT_CA_SEJOUR_TTC]
      ,[MT_CA_SEJ_HEBERGEMENT_HT]
      ,[MT_CA_SEJ_RESTAURATION_HT]
      ,[MT_CA_SEJ_DIVERS_HT]
      ,[MT_CA_SEJOUR_HT]
      ,[DT_PREMIERE_COMMANDE]
      ,[ID_CANAL_VENTE_DETAIL_PREM_COM]
      ,[LB_RATE_CODE_PREM_COM]
      ,[SOURCE_FICHIER]
      ,[ID_LOAD]
      ,[DATE_INS]
      ,[DATE_MAJ]
      ,[DATE_SUP]
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [BO_CLIENT_IB] = 1
and id_client not in  (select masterid
from #IB_Hist )



select 
[CO_ETABLISSEMENT_QTS],
[BO_CLIENT_FAMILLE] as Famille,
case when ([BO_CLIENT_IB] =1 and Niv_IB is not null) then 'IB '+convert(varchar,Niv_IB) 
when([BO_CLIENT_IB] =1 and Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end as Type_Client
,year(dt_debut_sejour) as Annee_Sej
,count([ID_SEJOUR]) as Sejour
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
  left join #IB_Hist i
  on s.ID_Client=i.Masterid
where id_type_sejour=1
and id_statut_sejour in (3,4)
and ( dt_debut_sejour between '20190521' and '20190620' or dt_debut_sejour between '20200521' and '20200620' )

group by  [CO_ETABLISSEMENT_QTS], year(dt_debut_sejour),
case when ([BO_CLIENT_IB] =1 and Niv_IB is not null) then 'IB '+convert(varchar,Niv_IB) 
when([BO_CLIENT_IB] =1 and Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end 
,[BO_CLIENT_FAMILLE]



-----------------------------


select 
[CO_ETABLISSEMENT_QTS]
,year(dt_debut_sejour) as Annee_Sej,
case when ([BO_CLIENT_IB] =1 and Niv_IB is not null) then 'IB '+convert(varchar,Niv_IB) 
when([BO_CLIENT_IB] =1 and Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end as Type_Client

,count(distinct id_client) as Client
,count([ID_SEJOUR]) as Sejour
  FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
  left join #IB_Hist i
  on s.ID_Client=i.Masterid
where id_type_sejour=1
and id_statut_sejour in (3,4)
and ( dt_debut_sejour between '20190101' and '20191231' or dt_debut_sejour between '20200101' and '20201231' 
or dt_debut_sejour between '20210101' and '20211231')

group by  [CO_ETABLISSEMENT_QTS], year(dt_debut_sejour),
case when ([BO_CLIENT_IB] =1 and Niv_IB is not null) then 'IB '+convert(varchar,Niv_IB) 
when([BO_CLIENT_IB] =1 and Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end 
order by  year(dt_debut_sejour), [CO_ETABLISSEMENT_QTS],
case when ([BO_CLIENT_IB] =1 and Niv_IB is not null) then 'IB '+convert(varchar,Niv_IB) 
when([BO_CLIENT_IB] =1 and Niv_IB is null) then 'IB Niv Inconnu' else 'Non IB' end
