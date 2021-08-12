select count (distinct ID_CLIENT) as Client
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD')
and ID_JOUR_RESERVATION between 20200101 and 20200107 -- Les reservations sur 7 jours de Janvier 2020

select count (distinct ID_CLIENT) as Client
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD')
and DH_RESERVATION between '20200101' and '20200107' -- même date en utilisant DH_RESERVATION -- Il manquent des réservations

select count (distinct ID_CLIENT) as Client
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD')
and DH_RESERVATION between '20200101' and '20200108' -- +1 Jour -- On trouve les mêmes réservations

select count (distinct ID_CLIENT) as Client
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD')
and DH_RESERVATION between '20200101' and '20200107 23:59:59.999' --Pour trouver les mm résultats, il fo ajouter 23:59:59.999


--------------------------
drop table #ID_Sejour
select * into #ID_Sejour
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD')
and ID_JOUR_RESERVATION between 20200101 and 20200107

drop table #DH_Reservation
select *
into #DH_Reservation
FROM [V-FRPRSA2-SID01\SIDB].[SIDBDMT].[mkh].[T_FAIT_RESERVATION]	
where [ID_TYPE_SEJOUR] = 1	
and [CO_ETABLISSEMENT_QTS] not in ('NIENB', 'MARNA','DEACD')
and DH_RESERVATION between '20200101' and '20200107' 

select * from #ID_Sejour
select * from #DH_Reservation

select * from #ID_Sejour i  full join #DH_Reservation d on i.ID_RESERVATION =d.ID_RESERVATION