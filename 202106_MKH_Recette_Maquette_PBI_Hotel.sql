/*Principaux indicateur sur périmètre Loisirs*/
select count(distinct no_ach_conf) as Nb_reservations , 
sum(NB_NUITS) as Nuitees ,
count(distinct Id_Client) as Nb_Reservants ,
sum( isnull([MT_OFFRE_ACT_ID],0) + isnull([MT_SUPPLEMENTS],0)			
+ isnull([MT_OPTIONS],0) + isnull([MT_SERVICES],0)) as Ca_Reservation_ttc  ,
avg( convert(float, 
datediff(day, DT_DEBUT_SEJOUR , DT_FIN_SEJOUR)
)) as Duree_Moy , 
avg(convert(float,
datediff(day, DH_RESERVATION, DT_DEBUT_SEJOUR ))) as Anticipation_Moy
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]							
where [ID_TYPE_SEJOUR] = 1							
and ID_JOUR_DEBUT_SEJOUR between 20190920 and 20200106
and ID_JOUR_RESERVATION between 20190910 and 20190923
and [CO_ETABLISSEMENT_QTS] in ('RIBRR','LTQWE', 'CANHM', 'CANGA') 


/*Périmètre loisir dans table temporaire */
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
and ID_JOUR_DEBUT_SEJOUR between 20190920 and 20200106
and ID_JOUR_RESERVATION between 20190910 and 20190923
and [CO_ETABLISSEMENT_QTS] in ('RIBRR','LTQWE', 'CANHM', 'CANGA') 

select * from #loisirs

/*Identification des réservations offres 
et des réservations offres cibles CRM */
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
where LB_campagne in ( '20190910_Email_Lancement_Vente_Exclusive_Automne','20190917_Email_relance_Vente_Exclusive_Automne')
AND LB_ENVOI NOT LIKE '%BAT%' -- envois à exclure de toutes les campagnes
AND LB_ENVOI NOT LIKE '%TEST%'  -- envois à exclure de toutes les campagnes
AND DT_SUPPRESSION IS NULL  -- envois à exclure de toutes les campagnes 
) crm on l.id_client = crm.id_client 


select count(distinct no_ach_conf) as Nb_reservations , 
sum(NB_NUITS) as Nuitees ,
count(distinct Id_Client) as Nb_Reservants ,
sum( isnull([MT_OFFRE_ACT_ID],0) + isnull([MT_SUPPLEMENTS],0)			
+ isnull([MT_OPTIONS],0) + isnull([MT_SERVICES],0)) as Ca_Reservation_ttc  ,
avg( convert(float, 
datediff(day, DT_DEBUT_SEJOUR , DT_FIN_SEJOUR)
)) as Duree_Moy , 
avg(convert(float,
datediff(day, DH_RESERVATION, DT_DEBUT_SEJOUR ))) as Anticipation_Moy ,
sum(case when hb_com = 1 then nb_nuits else 0 end ) as Nuitees_Hb_com 
from #perimetres 
where Perimetre_Offre = 1 


select count(distinct no_ach_conf) as Nb_reservations , 
sum(NB_NUITS) as Nuitees ,
count(distinct Id_Client) as Nb_Reservants ,
sum( isnull([MT_OFFRE_ACT_ID],0) + isnull([MT_SUPPLEMENTS],0)			
+ isnull([MT_OPTIONS],0) + isnull([MT_SERVICES],0)) as Ca_Reservation_ttc  ,
avg( convert(float, 
datediff(day, DT_DEBUT_SEJOUR , DT_FIN_SEJOUR)
)) as Duree_Moy , 
avg(convert(float,
datediff(day, DH_RESERVATION, DT_DEBUT_SEJOUR ))) as Anticipation_Moy ,
sum(case when hb_com = 1 then nb_nuits else 0 end ) as Nuitees_Hb_com 
from #perimetres 
where Cibles_CRM = 1