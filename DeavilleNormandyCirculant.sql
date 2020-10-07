/*AVANT REONOVATION NORMANDY*/
drop table #Normandy_Clt
select distinct ID_CLIENT
into #Normandy_Clt
 FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
 where CO_ETABLISSEMENT_QTS = 'DEAHN' 
 and DT_DEBUT_SEJOUR between '20121101' and '20151031' --3 ans 
 and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)


 drop table #Royal_Clt
select distinct ID_CLIENT
into #Royal_Clt
 FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
 where CO_ETABLISSEMENT_QTS = 'DEARD' 
 and DT_DEBUT_SEJOUR between '20121101' and '20151031' --3 ans 
 and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)
 select * from #Royal_Clt

 /*EXCLUSIF NORMANDY*/
 select Id_Client
 from #Normandy_Clt where ID_CLIENT not in (select ID_CLIENT from #Royal_Clt)

 /*EXCLUSIF ROYAL*/
 select Id_Client
 from #Royal_Clt where ID_CLIENT not in (select ID_CLIENT from #Normandy_Clt)


 select n.ID_CLIENT from #Normandy_Clt n inner join #Royal_Clt r on n.ID_CLIENT=r.ID_CLIENT

 /*PROFIL CLIENT CIRCULANT*/

 select MasterID, Sexe, Age, Pays_De_Residence,Client_IB
  FROM [SIDBDWH].[qts].[T_CONTACTS]
  where MasterID in (select n.ID_CLIENT from #Normandy_Clt n inner join #Royal_Clt r on n.ID_CLIENT=r.ID_CLIENT)


   /*SEJOUR*/
   select distinct (ID_SEJOUR), CO_ETABLISSEMENT_QTS, ID_CLIENT
   ,DATEDIFF(day, DH_RESERVATION,DT_DEBUT_SEJOUR) as Anticipation
   ,DATEDIFF(day, DT_DEBUT_SEJOUR,DT_FIN_SEJOUR) Nuitée
   ,BO_CLIENT_FAMILLE,LB_TYPE_CANAL_RESERVATION, BO_CLIENT_CIRCULANT, ID_FREQUENCE_ACTIVITE
   ,MT_CA_SEJOUR_TTC
     FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
	  where ID_CLIENT in (select n.ID_CLIENT from #Normandy_Clt n inner join #Royal_Clt r on n.ID_CLIENT=r.ID_CLIENT)
	   and DT_DEBUT_SEJOUR between '20121101' and '20151031'  -- 3 ans
 and DT_DEBUT_SEJOUR <> DT_FIN_SEJOUR
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)
 and CO_ETABLISSEMENT_QTS in ('DEAHN','DEARD' )

 ------------------------------------------------------------
 ------------------------------------------------------------


 /*APRES REONOVATION NORMANDY*/
drop table #Normandy_Clt_2
select distinct ID_CLIENT
into #Normandy_Clt_2
 FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
 where CO_ETABLISSEMENT_QTS = 'DEAHN' 
 and DT_DEBUT_SEJOUR between '20170201' and '20200131' --3 ans 
 and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)


 drop table #Royal_Clt_2
select distinct ID_CLIENT
into #Royal_Clt_2
 FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
 where CO_ETABLISSEMENT_QTS = 'DEARD' 
 and DT_DEBUT_SEJOUR between '20170201' and '20200131' --3 ans 
 and DT_DEBUT_SEJOUR<>DT_FIN_SEJOUR
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)


 
 /*EXCLUSIF NORMANDY*/
 select Id_Client
 from #Normandy_Clt_2 where ID_CLIENT not in (select ID_CLIENT from #Royal_Clt_2)

 /*EXCLUSIF ROYAL*/
 select Id_Client
 from #Royal_Clt_2 where ID_CLIENT not in (select ID_CLIENT from #Normandy_Clt_2)


 select n.ID_CLIENT from #Normandy_Clt_2 n inner join #Royal_Clt_2 r on n.ID_CLIENT=r.ID_CLIENT

 /*PROFIL CLIENT CIRCULANT*/

 select MasterID, Sexe, Age, Pays_De_Residence,Client_IB
  FROM [SIDBDWH].[qts].[T_CONTACTS]
  where MasterID in (select n.ID_CLIENT from #Normandy_Clt n inner join #Royal_Clt r on n.ID_CLIENT=r.ID_CLIENT)


   /*SEJOUR*/
   select distinct (ID_SEJOUR), CO_ETABLISSEMENT_QTS, ID_CLIENT
   ,DATEDIFF(day, DH_RESERVATION,DT_DEBUT_SEJOUR) as Anticipation
   ,DATEDIFF(day, DT_DEBUT_SEJOUR,DT_FIN_SEJOUR) Nuitée
   ,BO_CLIENT_FAMILLE,LB_TYPE_CANAL_RESERVATION, BO_CLIENT_CIRCULANT, ID_FREQUENCE_ACTIVITE
   ,MT_CA_SEJOUR_TTC
     FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
	  where ID_CLIENT in (select n.ID_CLIENT from #Normandy_Clt n inner join #Royal_Clt r on n.ID_CLIENT=r.ID_CLIENT)
	   and DT_DEBUT_SEJOUR between '20170201' and '20200131'  -- 3 ans
 and DT_DEBUT_SEJOUR <> DT_FIN_SEJOUR
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)
 and CO_ETABLISSEMENT_QTS in ('DEAHN','DEARD' )


 -----------------------------------------------------
 -----------------------------------------------------

 /*CLIENT TRANSFERE ROYAL VERS NORMANDY*/
  select ID_CLIENT
 from #Normandy_Clt_2
 where ID_CLIENT in ( select Id_Client from #Royal_Clt ) 
 and ID_CLIENT not in ( select Id_Client from #Royal_Clt_2)


 /*CLIENT TRANSFERE EXCLUSIF ROYAL VERS NORMANDY*/
 select ID_CLIENT
 from #Normandy_Clt_2
 where ID_CLIENT in ( select Id_Client
 from #Royal_Clt where ID_CLIENT not in (select ID_CLIENT from #Normandy_Clt)) 
 and ID_CLIENT not in ( select Id_Client from #Royal_Clt_2)


 /*CLIENT CIRCULANT TRANSFERE ROYAL VERS NORMANDY*/
  select ID_CLIENT
 from #Normandy_Clt_2
 where ID_CLIENT in ( select n.ID_CLIENT from #Normandy_Clt n inner join #Royal_Clt r on n.ID_CLIENT=r.ID_CLIENT) 
 and ID_CLIENT not in ( select Id_Client from #Royal_Clt_2)


 /*PROFIL*/

 select MasterID, Sexe, Age, Pays_De_Residence,Client_IB
  FROM [SIDBDWH].[qts].[T_CONTACTS]
  where MasterID in (select ID_CLIENT
 from #Normandy_Clt_2
 where ID_CLIENT in (select ID_CLIENT from #Royal_Clt) 
 and ID_CLIENT not in (select ID_CLIENT from #Royal_Clt_2))


  /*SEJOUR*/
   select distinct (ID_SEJOUR), CO_ETABLISSEMENT_QTS, ID_CLIENT
   ,ID_SEXE_CLIENT, BO_CLIENT_IB, NB_AGE_CLIENT
   ,DATEDIFF(day, DH_RESERVATION,DT_DEBUT_SEJOUR) as Anticipation
   ,DATEDIFF(day, DT_DEBUT_SEJOUR,DT_FIN_SEJOUR) Nuitée
   ,BO_CLIENT_FAMILLE,LB_TYPE_CANAL_RESERVATION, BO_CLIENT_CIRCULANT, ID_FREQUENCE_ACTIVITE
   ,MT_CA_SEJOUR_TTC
     FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
	  where ID_CLIENT in (select ID_CLIENT
 from #Normandy_Clt_2
 where ID_CLIENT in (select ID_CLIENT from #Royal_Clt) 
 and ID_CLIENT not in (select ID_CLIENT from #Royal_Clt_2))
	   and DT_DEBUT_SEJOUR between '20170201' and '20200131'  -- 3 ans
 and DT_DEBUT_SEJOUR <> DT_FIN_SEJOUR
 and ID_TYPE_SEJOUR=1
 and ID_STATUT_SEJOUR in (3,4)
 and CO_ETABLISSEMENT_QTS in ('DEAHN','DEARD' )


 -----------------------------------------
 /*PROFIL EXCLUSIF ROYAL*/
  select MasterID, Sexe, Age, Pays_De_Residence,Client_IB
  FROM [SIDBDWH].[qts].[T_CONTACTS]
  where MasterID in (select Id_Client
 from #Royal_Clt where ID_CLIENT not in (select ID_CLIENT from #Normandy_Clt))