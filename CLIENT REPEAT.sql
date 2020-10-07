/* sélection de tous les séjours loisirs en checked out sur la période */
/* partition par client, établissement et dates de début : 1 compteur par couple client - hôtel */
drop table #cli_sej
select ROW_NUMBER() OVER(PARTITION BY Id_client, CO_ETABLISSEMENT_QTS ORDER BY [DT_DEBUT_SEJOUR] ) AS index_sej, 
	id_client, ID_SEJOUR, [DT_DEBUT_SEJOUR],CO_ETABLISSEMENT_QTS, 
	MT_CA_SEJ_HEBERGEMENT_HT as CA_Heb_Ht, 
	MT_CA_SEJOUR_TTC as CA_Total_ttc, 
	LB_CANAL_RESERVATION, LB_CANAL_DETAIL 
	into #cli_sej
  from [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
  where ID_JOUR_DEBUT_SEJOUR between 20141101 and 20190930 
  and CO_ETABLISSEMENT_QTS in ('CANHM', 'CANGA', 'COUNH','DEAHN','DEAHG', 'DEARD', 'DINGH', 'ENGLE','ENGGE',
  'LBAHR', 'LBAHH', 'LBAML', 'LILHC', 'LTQWE', 'PARHF','RIBRR') 
  and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR = 4 
  order by id_client, CO_ETABLISSEMENT_QTS, [DT_DEBUT_SEJOUR]

--- select top 500 * from #cli_sej

/* sélection des clients avec plus d'un séjour sur l'établissement 
= clients avec un compteurs avec plus d'une valeur */
drop table #cli_rep 
select s.* into #cli_rep from #cli_sej s
inner join (select ID_CLIENT, CO_ETABLISSEMENT_QTS 
from #cli_sej group by ID_CLIENT, CO_ETABLISSEMENT_QTS 
having MAX(index_sej) > 1 )  m 
on s.ID_CLIENT = m.ID_CLIENT and s.CO_ETABLISSEMENT_QTS = m.CO_ETABLISSEMENT_QTS
order by ID_CLIENT, CO_ETABLISSEMENT_QTS, index_sej 

--- select top 500 * from #cli_rep order by id_client  

/*calcul de la durée en semaine entre deux séjours : freq_sem */
drop table #cli_sej_rep
select a.* ,
b.DT_DEBUT_SEJOUR as DEB_SEJ_PRECEDENT, 
DATEDIFF(WEEK, b.DT_DEBUT_SEJOUR,a.DT_DEBUT_SEJOUR) as Freq_sem  
into #cli_sej_rep
from #cli_rep a left join #cli_rep b
on a.ID_CLIENT = b.ID_CLIENT 
and a.CO_ETABLISSEMENT_QTS = b.CO_ETABLISSEMENT_QTS
and a.index_sej - 1 = b.index_sej  
order by a.ID_CLIENT, a.CO_ETABLISSEMENT_QTS, a.index_sej 

--- select * from #cli_sej_rep where id_client = 608 order by CO_ETABLISSEMENT_QTS, index_sej

/* Recherche du canal de recrutement au client sur l'hôtel concerné :
Canal de réservation sur le 1er séjour effectué au sein de l'établissement 
 */
drop table #canal_rec
select distinct ID_CLIENT, CO_ETABLISSEMENT_QTS,
LB_CANAL_RESERVATION  AS Canal_Recrute,
LB_CANAL_DETAIL As Canal_Det_Recrute 
into #canal_rec  
from #cli_rep a 
where index_sej = 1 

/*Rattachement du canal de recrutement au couple client - hôtel */
/* Un client aura toujours le même canal de recrutement quelque soit son canal de réservation à partir du 2nd séjour */
drop table #cli_canal
select distinct r.* , Canal_Recrute,  Canal_Det_Recrute
into #cli_canal
from #cli_sej_rep r inner join #canal_rec  c 
on r.ID_CLIENT = c.ID_CLIENT 
and r.CO_ETABLISSEMENT_QTS = c.CO_ETABLISSEMENT_QTS 

--- select * from #cli_canal /* where id_client = 844580 */ order by ID_CLIENT, CO_ETABLISSEMENT_QTS, index_sej 

/*agrégation des informations par client, hôtel et exercice */
/*le premier séjour du client dans un établissement n'est pas compté comme repeat */
drop table #repeats
 select CO_ETABLISSEMENT_QTS,
 case  when [DT_DEBUT_SEJOUR] >= '2018-11-01' then 2019
	when [DT_DEBUT_SEJOUR] between '2017-11-01' and '2018-10-31' then 2018
      when [DT_DEBUT_SEJOUR] between '2016-11-01' and '2017-11-01' then 2017
      when [DT_DEBUT_SEJOUR] between '2015-11-01' and '2016-11-01' then 2016
      when [DT_DEBUT_SEJOUR] between '2014-11-01' and '2015-11-01' then 2015
      else 2000 end as exercice,
	  a.id_client, Canal_Recrute,  Canal_Det_Recrute,
	  case when ID_NIVEAU_FID is not null then 1 else 0 end as IB,
	  count(distinct(cast(index_sej as varchar) + CAST(a.id_client as varchar) + CO_ETABLISSEMENT_QTS)) as nb_sej,
	  AVG(convert(float,Freq_sem)) as moy_freq ,
	  SUM(ca_heb_ht) as Ca_heb_ht,
	  SUM(ca_total_ttc) as Ca_Total_Ttc 
	 into #repeats
	  from #cli_canal a
	  left join [SIDBDMT].[mkh].[T_DIM_CLIENT_H] l 
	  on a.ID_CLIENT = l.ID_CLIENT
	  where index_sej > 1 --- non pris en compte du premier séjour du client 
	  group by CO_ETABLISSEMENT_QTS,
 case  when [DT_DEBUT_SEJOUR] >= '2018-11-01' then 2019
	when [DT_DEBUT_SEJOUR] between '2017-11-01' and '2018-10-31' then 2018
      when [DT_DEBUT_SEJOUR] between '2016-11-01' and '2017-11-01' then 2017
      when [DT_DEBUT_SEJOUR] between '2015-11-01' and '2016-11-01' then 2016
      when [DT_DEBUT_SEJOUR] between '2014-11-01' and '2015-11-01' then 2015
      else 2000 end,
	  a.id_client, Canal_Recrute,  Canal_Det_Recrute,  
	  case when ID_NIVEAU_FID is not null then 1 else 0 end 

---select top 5000 * from #test where exercice = 2019 and CO_ETABLISSEMENT_QTS = 'COUNH'
/*
/* Sorties data clients repeat*/
select CO_ETABLISSEMENT_QTS, IB, Exercice, 
Canal_Recrute,  Canal_Det_Recrute,
--select  
count(distinct(id_client)) as Nb_Clients,
SUM(nb_sej) as Nb_Sejours,
AVG(moy_freq) as Frequence,
SUM(ca_heb_ht) as Ca_heb_ht,
SUM(ca_total_ttc) as Ca_Total_Ttc 
from #test
where exercice <> '2000' --and IB = 1 
-- group by exercice  order by exercice 
group by CO_ETABLISSEMENT_QTS, IB ,exercice ,Canal_Recrute,  Canal_Det_Recrute
order by CO_ETABLISSEMENT_QTS, IB ,exercice ,Canal_Recrute,  Canal_Det_Recrute

select Canal_Recrute + ' / ' + 
Canal_Det_Recrute,
count(distinct id_client) as Nb_Clients
from #test
where exercice <> '2000'
group by Canal_Recrute + ' / ' +  
Canal_Det_Recrute
order by count(distinct id_client) desc 

select Années_Repeat,
COUNT(distinct id_client) from (
select id_client, 
COUNT(distinct exercice) as Années_Repeat 
from #test
where exercice <> '2000'
group by id_client) d 
group by Années_Repeat
order by Années_Repeat

*/

/* comptage nb de clients actifs loisirs global + détail par établissement / an */
drop table #loisirs 
select --CO_ETABLISSEMENT_QTS,
 case  when [DT_DEBUT_SEJOUR] >= '2018-11-01' then 2019
	when [DT_DEBUT_SEJOUR] between '2017-11-01' and '2018-10-31' then 2018
      when [DT_DEBUT_SEJOUR] between '2016-11-01' and '2017-11-01' then 2017
      when [DT_DEBUT_SEJOUR] between '2015-11-01' and '2016-11-01' then 2016
      when [DT_DEBUT_SEJOUR] between '2014-11-01' and '2015-11-01' then 2015
      else 2000 end as exercice, 
'-' as Canal_Recrute, 
'-' as Canal_Det_Recrute, 
--	  case when ID_NIVEAU_FID is not null then 0 else 1 end as IB,
count(distinct(a.id_client)) as Nb_Clients,
COUNT(distinct Id_Sejour) as Nb_Sejours, 
sum(MT_CA_SEJ_HEBERGEMENT_HT) as CA_Heb_Ht, 
sum(MT_CA_SEJOUR_TTC) as CA_Total_ttc 
---into #loisirs
  FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR] a
  	  left join [SIDBDMT].[mkh].[T_DIM_CLIENT_H] l 
	  on a.ID_CLIENT = l.ID_CLIENT
  where ID_JOUR_DEBUT_SEJOUR between 20131101 and 20180331 
 and CO_ETABLISSEMENT_QTS in ('CANHM', 'CANGA', 'COUNH','DEAHN','DEAHG', 'DEARD', 'DINGH', 'ENGLE','ENGGE',
  'LBAHR', 'LBAHH', 'LBAML', 'LILHC', 'LTQWE', 'PARHF','RIBRR') 
  and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR = 4 
  -- and ID_NIVEAU_FID is not null
  group by --CO_ETABLISSEMENT_QTS,
 case  when [DT_DEBUT_SEJOUR] >= '2018-11-01' then 2019
	when [DT_DEBUT_SEJOUR] between '2017-11-01' and '2018-10-31' then 2018
      when [DT_DEBUT_SEJOUR] between '2016-11-01' and '2017-11-01' then 2017
      when [DT_DEBUT_SEJOUR] between '2015-11-01' and '2016-11-01' then 2016
      when [DT_DEBUT_SEJOUR] between '2014-11-01' and '2015-11-01' then 2015
      else 2000 end
	  	 -- , case when ID_NIVEAU_FID is not null then 0 else 1 end 
