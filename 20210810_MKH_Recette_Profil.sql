
/*Périmètre loisir dans table temporaire */
drop table #loisirs
select  *,
/*Identification des réservations Web*/
 case when [ID_SOURCE_RESERVATION] in (18,27) -- OWS / HB 
or [ID_INTERM_COMMISSION] in (481318, 481327, 88188, 1103615, 774614, 
1710283, 1421287, 14744074)  -- Fastbooking 
or ([ID_SOURCE_RESERVATION] = 8 and [LB_UTILISATEUR_INS] = '*MYFIDELIO*') -- AS et Insert User MyFidelio 
then 1 else 0 end as hb_com 
into #loisirs  
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]							
where [ID_TYPE_SEJOUR] = 1							
and ID_JOUR_DEBUT_SEJOUR between  20200914 and 20210108 -- 20190920 and 20200106
and ID_JOUR_RESERVATION between  20200908 and 20200922 -- 20190910 and 20190923
and [CO_ETABLISSEMENT_QTS] in ('RIBRR','LTQWE', 'CANHM', 'CANGA') 

select * from #loisirs
/*Identification des réservations offres 
et des réservations offres cibles CRM */
drop table #perimetres
select  l.* , 
case when CO_RATE in ('SOLDES1', 'PKBBADV') then 1 else 0 end as Perimetre_Offre , 
case when crm.Id_Client is not null and CO_RATE in ('SOLDES1', 'PKBBADV') then 1 else 0 end as Cibles_CRM 
into #perimetres 
from #loisirs  l
left join 
/*Cibles campagnes CRM*/
( select distinct ID_CLIENT 
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CAMPAGNE_ENVOI_H] e
INNER JOIN [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CAMPAGNE_H] c
on e.ID_CAMPAGNE=c.ID_CAMPAGNE
INNER JOIN [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_CAMPAGNE_CONTACT_H] o
on e.ID_ENVOI = o.ID_ENVOI
where LB_campagne  = '20200908_Ventes exclusives Automne' -- in ( '20190910_Email_Lancement_Vente_Exclusive_Automne','20190917_Email_relance_Vente_Exclusive_Automne')
AND LB_ENVOI NOT LIKE '%BAT%' -- envois à exclure de toutes les campagnes
AND LB_ENVOI NOT LIKE '%TEST%'  -- envois à exclure de toutes les campagnes
AND DT_SUPPRESSION IS NULL  -- envois à exclure de toutes les campagnes 
) crm on l.id_client = crm.id_client 

select * from #perimetres

/* REQUETE NOUVEAU REPEAT */
----------------------------
--Attention ajouter 1 jour pour les resa si vs utilisez DH_Reservation

drop table #Nv_Rp
select *
into #Nv_Rp
 from	
	
(select r.* ,	
nv.DH_RESERVATION as Prec_Resa_Gpe,	
case when  nv.id_client  is null or datediff(day, nv.DH_RESERVATION, r.DH_RESERVATION) > 365 then 1 else 0 end as Flg_Nouveau ,	--1826 jours pour 5 ans 
rp.DH_RESERVATION as Prec_Resa_Hotel,	
case when rp.id_client is not null and datediff(day, rp.DH_RESERVATION, r.DH_RESERVATION) <= 365 then 1 else 0 end as Flg_Repeat	--1826 jours pour 5 ans 
	
from	
	
(SELECT [ID_RESERVATION]	
,[ID_SEJOUR]	
,[ID_ETABLISSEMENT]	
,[CO_ETABLISSEMENT_QTS]	
,[ID_CLIENT]	
,[DH_RESERVATION]	
,[DT_DEBUT_SEJOUR]	
,[DT_FIN_SEJOUR]	
,[ID_JOUR_RESERVATION]	
,[ID_JOUR_DEBUT_SEJOUR]	
,[ID_JOUR_FIN_SEJOUR]	
,[NO_ACH_CONF]	
,[NB_ADULTES]	
,[NB_ENFANTS]	
,[NB_NUITS]	
, row_number() over (partition by Id_client order by DH_RESERVATION) as Num_Resa	
, row_number() over (partition by [ID_ETABLISSEMENT] , Id_client order by DH_RESERVATION) as Num_Resa_Hotel	
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD') ) r	
	
	
left join ( SELECT  [CO_ETABLISSEMENT_QTS], [ID_CLIENT], [DH_RESERVATION]	
	, row_number() over (partition by Id_client order by DH_RESERVATION) as Num_Resa
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD') ) nv	
on r.Id_Client = nv.id_client	
and r.Num_Resa = nv.Num_Resa + 1	
	
left join ( SELECT  [CO_ETABLISSEMENT_QTS], [ID_ETABLISSEMENT], [ID_CLIENT], [DH_RESERVATION]	
	, row_number() over (partition by [ID_ETABLISSEMENT] , Id_client order by DH_RESERVATION) as Num_Resa_Hotel
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD') ) rp	
on r.Id_Client = rp.id_client	
and r.[ID_ETABLISSEMENT] = rp.[ID_ETABLISSEMENT]	
and r.Num_Resa_Hotel = rp.Num_Resa_Hotel + 1	
) j	
	
where ID_JOUR_RESERVATION between 20200908 and 20200922 --20190910 and 20190923
--where [DH_RESERVATION] between '20200908' and '20200923' -- --'20190910' and '20190924'

--select * from #Nv_Rp --7493
/* -- Test --GOOD
select count (distinct ID_CLIENT) 
from #Nv_Rp
where ID_JOUR_DEBUT_SEJOUR between  20200914 and 20210108 -- 20190920 and 20200106
and ID_JOUR_RESERVATION between  20200908 and 20200922 -- 20190910 and 20190923
and [CO_ETABLISSEMENT_QTS] in ('RIBRR','LTQWE', 'CANHM', 'CANGA') 
*/
------------------------------
-----Total-------------------
------------------------------

--RESERTVANT
select count (distinct ID_Client) as Reservant
 from #perimetres


--FAMILLE
select count (distinct ID_Client) as Famille
 from #perimetres
 where NB_Enfants > 0 or CO_Rate like '%FAM%'


--IB
 drop table #IB 
 select ID_Client, min (DT_EFFET) as Min_Effet
 into #IB
from [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H] 
group by ID_Client

 select count(distinct p.ID_Client)  from #perimetres p
 inner join #IB f
 on p.ID_Client=f.ID_Client
 where Min_Effet <= DH_RESERVATION

 /*
 --Comparaison SAP mois de juin 2021
 select count (distinct s.ID_CLIENT) as Client from [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
 inner join #IB i
 on s.ID_CLIENT=i.ID_CLIENT
 where DT_DEBUT_SEJOUR between '20210601' and '20210630'
 and ID_TYPE_SEjour=1
 and ID_Statut_SEJOUr in (3,4)
 and DT_DEBUT_SEjour <> DT_FIN_SEJOUR 
 and Min_Effet <= DH_RESERVATION
 */

 --Genre
 select count (distinct p.ID_Client) as Genre
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where ID_SEXE =1

--Age
drop table #Age
select Distinct p.ID_Client, NB_Age
 into #Age
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 select avg (convert(float,NB_Age)) as Age_Moy from #Age

 --FRANCE
 select count(distinct p.ID_Client) as France
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_PAYS_Residence <>'FRA'

 --IDF
  select count(distinct p.ID_Client) as France
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_Region =11 and CO_PAYS_Residence= 'FRA'
 --where co_dep in (91,92,93,94,95,75,77,78) and  CO_PAYS_Residence= 'FRA'

 -----NOUVEAU REPEAT 
 
select count (distinct p.ID_Client ) 
from #perimetres p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
--where Flg_Nouveau =1
where Flg_Repeat=1


----Circulant
select count(distinct p.Id_CLIENT) as Circulant 
from #perimetres p
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
on p.ID_SEJOUR=s.ID_SEJOUR
where [BO_CLIENT_CIRCULANT] =1


------------------------------
-----Offre-------------------
------------------------------

--RESERTVANT
select count (distinct ID_Client) as Reservant
 from #perimetres
 where Perimetre_Offre=1

--FAMILLE
select count (distinct ID_Client) as Famille
 from #perimetres
 where( NB_Enfants > 0 or CO_Rate like '%FAM%')
 and Perimetre_Offre=1

--IB
 drop table #IB 
 select ID_Client, min (DT_EFFET) as Min_Effet
 into #IB
from [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H] 
group by ID_Client

 select count(distinct p.ID_Client)  from #perimetres p
 inner join #IB f
 on p.ID_Client=f.ID_Client
 where Min_Effet <= DH_RESERVATION
 and Perimetre_Offre=1

 --Genre
 select count (distinct p.ID_Client) as Genre
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where ID_SEXE =1
 and Perimetre_Offre=1

--Age
 drop table #Age
select Distinct p.ID_Client, NB_Age
 into #Age
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
  where Perimetre_Offre=1
 select avg (convert(float,NB_Age)) as Age_Moy from #Age

 --FRANCE
 select count(distinct p.ID_Client) as France
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_PAYS_Residence <>'FRA'
 and Perimetre_Offre=1

 --IDF
  select count(distinct p.ID_Client) as France
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_Region =11 and CO_PAYS_Residence= 'FRA'
 and Perimetre_Offre=1

 --Nouveau
 select count(distinct p.ID_client) from #perimetres p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where  Perimetre_Offre=1
and Flg_Nouveau=1

--Repeat
 select count(distinct p.ID_client) from #perimetres p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where  Perimetre_Offre=1
and Flg_Repeat=1

--Circulant
select count(distinct p.Id_CLIENT) as Circulant from #perimetres p
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
on p.ID_SEJOUR=s.ID_SEJOUR
where [BO_CLIENT_CIRCULANT] =1
and Perimetre_Offre=1

------------------------------
-----CRM-------------------
------------------------------

--RESERTVANT
select count (distinct ID_Client) as Reservant
 from #perimetres
 where Cibles_CRM=1

--FAMILLE
select count (distinct ID_Client) as Famille
 from #perimetres
 where (NB_Enfants > 0 or CO_Rate like '%FAM%')
 and Cibles_CRM=1

--IB
 drop table #IB 
 select ID_Client, min (DT_EFFET) as Min_Effet
 into #IB
from [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H] 
group by ID_Client

 select count(distinct p.ID_Client) as IB from #perimetres p
 inner join #IB f
 on p.ID_Client=f.ID_Client
 where Min_Effet <= DH_RESERVATION
 and Cibles_CRM=1

 --Genre
 select count (distinct p.ID_Client) as Genre
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where ID_SEXE =2
 and Cibles_CRM=1

--Age
 drop table #Age
select Distinct p.ID_Client, NB_Age
 into #Age
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
  where Cibles_CRM=1
 select avg (convert(float,NB_Age)) as Age_Moy from #Age

 --FRANCE
 select count(distinct p.ID_Client) as France
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_PAYS_Residence = 'FRA'
 and Cibles_CRM=1

 --IDF
  select count(distinct p.ID_Client) as France
 from #perimetres p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_Region =11 and CO_PAYS_Residence= 'FRA'
 and Cibles_CRM=1

 --Nouveau
 select count(distinct p.ID_client) from #perimetres p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where  Cibles_CRM=1
and Flg_Nouveau=1

--Repeat
 select count(distinct p.ID_client) from #perimetres p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where  Cibles_CRM=1
and Flg_Repeat=1

--Circulant
select count(distinct p.Id_CLIENT) as Circulant from #perimetres p
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
on p.ID_SEJOUR=s.ID_SEJOUR
where [BO_CLIENT_CIRCULANT] =1
and Cibles_CRM=1

------------------------------
-----------FAMILLE-------------
------------------------------

drop table #Famille
select *
into #Famille
 from #perimetres
 where (NB_Enfants > 0 or CO_Rate like '%FAM%')
 
--RESERTVANT
select count (distinct ID_Client) as Reservant
 from #Famille
 where --Perimetre_Offre=1
 Cibles_CRM=1

--FAMILLE
select count (distinct ID_Client) as Famille
 from #Famille
 where( NB_Enfants > 0 or CO_Rate like '%FAM%')
 and --Perimetre_Offre=1
 Cibles_CRM=1

--IB
 drop table #IB 
 select ID_Client, min (DT_EFFET) as Min_Effet
 into #IB
from [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H] 
group by ID_Client

 select count(distinct p.ID_Client)  from #Famille p
 inner join #IB f
 on p.ID_Client=f.ID_Client
 where Min_Effet <= DH_RESERVATION
 and --Perimetre_Offre=1
 Cibles_CRM=1

 --Genre
 select count (distinct p.ID_Client) as Genre
 from #Famille p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where ID_SEXE =1
 and --Perimetre_Offre=1
 Cibles_CRM=1

 --Age
 drop table #Age
select Distinct p.ID_Client, NB_Age
 into #Age
 from #Famille p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
  where --Perimetre_Offre=1
  Cibles_CRM=1
 select avg (convert(float,NB_Age)) as Age_Moy from #Age

 --FRANCE
 select count(distinct p.ID_Client) as France
 from #Famille p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_PAYS_Residence <>'FRA'
 and --Perimetre_Offre=1
 Cibles_CRM=1

 --IDF
  select count(distinct p.ID_Client) as France
 from #Famille p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_Region =11 and CO_PAYS_Residence= 'FRA'
 and Perimetre_Offre=1
 Cibles_CRM=1

 --Nouveau
 select count(distinct p.ID_client) from #Famille p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where Flg_Nouveau=1
and --Perimetre_Offre=1
Cibles_CRM=1

--Repeat
 select count(distinct p.ID_client) from #Famille p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where  Flg_Repeat=1
and --Perimetre_Offre=1
Cibles_CRM=1

--Circulant
select count(distinct p.Id_CLIENT) as Circulant from #Famille p
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
on p.ID_SEJOUR=s.ID_SEJOUR
where [BO_CLIENT_CIRCULANT] =1
and --Perimetre_Offre=1
Cibles_CRM=1


------------------------------
-----------IB-------------
------------------------------

 drop table #IB 
 select ID_Client, min (DT_EFFET) as Min_Effet
 into #IB
from [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H] 
group by ID_Client

drop table #I_B
 select p.*, Min_Effet into #I_B from #perimetres p
 inner join #IB f
 on p.ID_Client=f.ID_Client
 where Min_Effet <= DH_RESERVATION
 
--RESERTVANT
select count (distinct ID_Client) as Reservant
 from #I_B
 where-- Perimetre_Offre=1
 Cibles_CRM=1

--FAMILLE
select count (distinct ID_Client) as Famille
 from #I_B
 where( NB_Enfants > 0 or CO_Rate like '%FAM%')
 and --Perimetre_Offre=1
 Cibles_CRM=1

--IB
 select count(distinct p.ID_Client)  from #I_B p
 where --Perimetre_Offre=1
 Cibles_CRM=1

 --Genre
 select count (distinct p.ID_Client) as Genre
 from #I_B p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where ID_SEXE =1
 and--erimetre_Offre=1
 Cibles_CRM=1

--Age
 drop table #Age
select Distinct p.ID_Client, NB_Age
 into #Age
 from #I_B p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
  where --Perimetre_Offre=1
  Cibles_CRM=1
 select avg (convert(float,NB_Age)) as Age_Moy from #Age

 --FRANCE
 select count(distinct p.ID_Client) as France
 from #I_B p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_PAYS_Residence <>'FRA'
 and --Perimetre_Offre=1
 Cibles_CRM=1

 --IDF
  select count(distinct p.ID_Client) as France
 from #I_B p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_Region =11 and CO_PAYS_Residence= 'FRA'
 and --Perimetre_Offre=1
 Cibles_CRM=1

 --Nouveau
 select count(distinct p.ID_client) from #I_B p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where Flg_Nouveau=1
and Perimetre_Offre=1
Cibles_CRM=1

--Repeat
 select count(distinct p.ID_client) from #I_B p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where  Flg_Repeat=1
and Perimetre_Offre=1
Cibles_CRM=1

--Circulant
select count(distinct p.Id_CLIENT) as Circulant from #I_B p
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
on p.ID_SEJOUR=s.ID_SEJOUR
where [BO_CLIENT_CIRCULANT] =1
and Perimetre_Offre=1
Cibles_CRM=1



------------------------------
-----------NOUVEAU-------------
------------------------------
drop table #nv
 select p.*, Flg_Nouveau,Flg_Repeat 
 into #nv from #perimetres p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where Flg_Nouveau=1
 select * from #nv

--RESERTVANT
select count (distinct ID_Client) as Reservant
 from #nv
 where --Perimetre_Offre=1
 Cibles_CRM=1

--FAMILLE
select count (distinct ID_Client) as Famille
 from #nv
 where( NB_Enfants > 0 or CO_Rate like '%FAM%')
 and --Perimetre_Offre=1
 Cibles_CRM=1

--IB
 drop table #IB 
 select ID_Client, min (DT_EFFET) as Min_Effet
 into #IB
from [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H] 
group by ID_Client

 select count(distinct p.ID_Client)  from #nv p
 inner join #IB f
 on p.ID_Client=f.ID_Client
 where Min_Effet <= DH_RESERVATION
 and --Perimetre_Offre=1
 Cibles_CRM=1

 select * from #nv

 --Genre
 select  count (distinct p.ID_Client) as Genre
 from #nv p
 inner join  [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where ID_SEXE is null
 and-- Perimetre_Offre=1
 Cibles_CRM=1

--Age
 drop table #Age
select Distinct p.ID_Client, NB_Age
 into #Age
 from #nv p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
  where --Perimetre_Offre=1
  Cibles_CRM=1
 select avg (convert(float,NB_Age)) as Age_Moy from #Age

 --FRANCE
 select count(distinct p.ID_Client) as France
 from #nv p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_PAYS_Residence ='FRA'
 and --Perimetre_Offre=1
 Cibles_CRM=1

 --IDF
  select count(distinct p.ID_Client) as France
 from #nv p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_Region =11 and CO_PAYS_Residence= 'FRA'
 and --Perimetre_Offre=1
 Cibles_CRM=1


--Repeat
 select count(distinct p.ID_client) from #nv p
where  Flg_Repeat=1
and -- Perimetre_Offre=1
Cibles_CRM=1

--Circulant
select count(distinct p.Id_CLIENT) as Circulant from #nv p
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
on p.ID_SEJOUR=s.ID_SEJOUR
where [BO_CLIENT_CIRCULANT] =1
and --Perimetre_Offre=1
Cibles_CRM=1




------------------------------
-----------REPEAT-------------
------------------------------
drop table #rp
 select p.*, Flg_Nouveau,Flg_Repeat 
 into #rp from #perimetres p
inner join #Nv_Rp n
on p.ID_Client=n.ID_Client
where Flg_Repeat=1
 select * from #rp

--RESERTVANT
select count (distinct ID_Client) as Reservant
 from #rp
 where Perimetre_Offre=1
 Cibles_CRM=1

--FAMILLE
select count (distinct ID_Client) as Famille
 from #rp
 where( NB_Enfants > 0 or CO_Rate like '%FAM%')
 and --Perimetre_Offre=1
 Cibles_CRM=1

--IB
 drop table #IB 
 select ID_Client, min (DT_EFFET) as Min_Effet
 into #IB
from [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H] 
group by ID_Client

 select count(distinct p.ID_Client)  from #rp p
 inner join #IB f
 on p.ID_Client=f.ID_Client
 where Min_Effet <= DH_RESERVATION
 and --Perimetre_Offre=1
 Cibles_CRM=1

 select * from #nv

 --Genre
 select  count (distinct p.ID_Client) as Genre
 from #rp p
 inner join  [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where ID_SEXE =2
 and --Perimetre_Offre=1
 Cibles_CRM=1

--Age
 drop table #Age
select Distinct p.ID_Client, NB_Age
 into #Age
 from #rp p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
  where --Perimetre_Offre=1
  Cibles_CRM=1
 select avg (convert(float,NB_Age)) as Age_Moy from #Age

 --FRANCE
 select count(distinct p.ID_Client) as France
 from #rp p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_PAYS_Residence <>'FRA'
 and --Perimetre_Offre=1
 Cibles_CRM=1

 --IDF
  select count(distinct p.ID_Client) as France
 from #rp p
 inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_DIM_CLIENT_H] c
 on p.ID_CLIENT=c.ID_CLIENT 
 where CO_Region =11 and CO_PAYS_Residence= 'FRA'
 and --Perimetre_Offre=1
 Cibles_CRM=1


--Nouveau
 select count(distinct p.ID_client) from #rp p
where  Flg_Nouveau=1
and  --Perimetre_Offre=1
Cibles_CRM=1

--Circulant
select count(distinct p.Id_CLIENT) as Circulant from #rp p
inner join [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_SEJOUR] s
on p.ID_SEJOUR=s.ID_SEJOUR
where [BO_CLIENT_CIRCULANT] =1
and --Perimetre_Offre=1
Cibles_CRM=1