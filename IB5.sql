/*IB_5% WEB*/

--CUMUL
drop table #IB_5
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #IB_5
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20200801' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #IB_5

--VS M-1
drop table #Octobre
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Octobre
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20191101' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Octobre

drop table #Novembre
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Novembre
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191101' and '20191201' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Novembre

drop table #Decembre
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Decembre
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191201' and '20200101' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Decembre

drop table #Janvier
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Janvier
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20200101' and '20200201' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Janvier

drop table #Fevrier
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Fevrier
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20200201' and '20200301' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Fevrier

drop table #Mars
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Mars
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20200301' and '20200401' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Mars

drop table #Avril
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Avril
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20200401' and '20200501' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Avril

drop table #Mai
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Mai
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20200501' and '20200601' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Mai

drop table #Juin
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Juin
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20200601' and '20200701' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Juin

drop table #Juillet
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
COUNT (distinct MasterID) as Client,
--Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation,
 sum (isnull([Paye_Total_TTC],0)) as CaTotal_TTC
,sum (isnull(Paye_Total_HT,0)) as CaTotal_HT
into #Juillet
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20200701' and '20200801' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 
select * from #Juillet

drop table #etabs
create table #etabs (hotel varchar (5))	
	
Insert into #etabs values ('DEAHG')	
Insert into #etabs values ('DEAHN')	
Insert into #etabs values ('DEARD')	
Insert into #etabs values ('DINGH')	
Insert into #etabs values ('ENGGE')	
Insert into #etabs values ('ENGLE')	
Insert into #etabs values ('LBAHH')	
Insert into #etabs values ('LBAHR')	
Insert into #etabs values ('LBAML')	
Insert into #etabs values ('LILHC')	
Insert into #etabs values ('LTQWE')	
Insert into #etabs values ('PARHF')	
Insert into #etabs values ('RIBRR')	
Insert into #etabs values ('CANGA')	
Insert into #etabs values ('CANHM')	
Insert into #etabs values ('COUNH')	


select * from #etabs 

select  * from #etabs aa
full outer join (select * from #Octobre) a on aa.hotel=a.Code_Etablissement
full outer join (select * from #Novembre) b on aa.hotel=b.Code_Etablissement
full outer join (select * from #Decembre) c on aa.hotel=c.Code_Etablissement
full outer join (select * from #Janvier) d on aa.hotel= d.Code_Etablissement
full outer join (select * from #Fevrier) e on aa.hotel=e.Code_Etablissement
full outer join (select * from #Mars) f on aa.hotel=f.Code_Etablissement
full outer join (select * from #Avril) g on aa.hotel= g.Code_Etablissement
full outer join (select * from #Mai) h on aa.hotel=h.Code_Etablissement
full outer join (select * from #Juin) i on aa.hotel= i.Code_Etablissement
full outer join (select * from #Juillet) j on aa.hotel=j.Code_Etablissement


---------------------------------------------------------------------
---------------------------------------------------------------------
/*Panier Moyen*/

/*Commande Client IB Tous Canaux	*/
drop table #IB_Ts_Canaux
select code_etablissement,
count (distinct MasterID) as Client_IB,
COUNT (DISTINCT Id_Sejour_WS) as Sejour,
sum(isnull(Paye_Total_TTC,0)) as PanierIB_TTC
into #IB_Ts_Canaux
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20200801' --- période réservation
and MasterID in (select masterID FROM [SIDBDWH].[qts].[T_CONTACTS] where Client_IB=1)
group by Code_Etablissement 
select * from #IB_Ts_Canaux

/*Commande Client NON IB Tous Canaux	*/
drop table #NON_IB_Ts_Canaux
select code_etablissement,
count (distinct MasterID) as Client_NonIB,
COUNT (DISTINCT Id_Sejour_WS) as Sejour,
sum(isnull(Paye_Total_TTC,0)) as PanierNonIB_TTC
into #NON_IB_Ts_Canaux
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20200801' --- période réservation
and MasterID in (select masterID FROM [SIDBDWH].[qts].[T_CONTACTS] where Client_IB=0)
group by Code_Etablissement 

select * from #IB_Ts_Canaux i full outer join #NON_IB_Ts_Canaux n on i.Code_Etablissement=n.Code_Etablissement

------------------------------------------------------------
--------------------------------------------------------------

/*Part clt inf / Actif*/
select count (distinct ID_CLIENT) as Client_Actif
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
and [DT_DEBUT_SEJOUR] between '20170801' and '20200731'

select count (distinct ID_CLIENT) as Client_Infiniment
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20170801' and  '20200731'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

-------------------------------------------------------
-----------------------------------------------------

/*TYPFID IB*/

/*OCTOBRE*/
drop table #Inf_oct
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_oct
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20191001' and  '20191031'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_oct
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_oct
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20191001' and '20191031'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #oct
SELECT hotel, Client_Actif, Client_Infiniment 
into #oct
from #etabs aa
full outer join #Actif_oct a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_oct i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]


/*Novembre*/
drop table #Inf_nov
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_nov
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20191101' and  '20191130'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_nov
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_nov
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20191101' and '20191130'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #nov
SELECT hotel, Client_Actif, Client_Infiniment 
into #nov
from #etabs aa
full outer join #Actif_nov a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_nov i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]



/*Decembre*/
drop table #Inf_dec
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_dec
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20191201' and  '20191231'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_dec
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_dec
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20191201' and '20191231'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #dec
SELECT hotel, Client_Actif, Client_Infiniment 
into #dec
from #etabs aa
full outer join #Actif_dec a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_dec i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]


/*Janvier*/
drop table #Inf_jan
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_jan
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20200101' and  '20200131'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_jan
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_jan
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20200101' and '20200131'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #jan
SELECT hotel, Client_Actif, Client_Infiniment 
into #jan
from #etabs aa
full outer join #Actif_jan a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_jan i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]

/*Fevrier*/
drop table #Inf_fev
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_fev
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20200201' and  '20200229'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_fev
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_fev
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20200201' and '20200229'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #fev
SELECT hotel, Client_Actif, Client_Infiniment 
into #fev
from #etabs aa
full outer join #Actif_fev a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_fev i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]

/*Mars*/
drop table #Inf_mars
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_mars
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20200301' and  '20200331'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_mars
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_mars
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20200301' and '20200331'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #mars
SELECT hotel, Client_Actif, Client_Infiniment 
into #mars
from #etabs aa
full outer join #Actif_mars a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_mars i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]


/*Avril*/
drop table #Inf_avr
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_avr
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20200401' and  '20200430'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_avr
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_avr
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20200401' and '20200430'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #avr
SELECT hotel, Client_Actif, Client_Infiniment 
into #avr
from #etabs aa
full outer join #Actif_avr a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_avr i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]


/*Mai*/
drop table #Inf_mai
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_mai
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20200501' and  '20200531'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_mai
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_mai
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20200501' and '20200531'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #mai
SELECT hotel, Client_Actif, Client_Infiniment 
into #mai
from #etabs aa
full outer join #Actif_mai a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_mai i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]

/*Juin*/
drop table #Inf_juin
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_juin
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20200601' and  '20200630'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_juin
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_juin
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20200601' and '20200630'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #juin
SELECT hotel, Client_Actif, Client_Infiniment 
into #juin
from #etabs aa
full outer join #Actif_juin a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_juin i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]


/*Juillet*/
drop table #Inf_juil
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Infiniment
into #Inf_juil
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where ID_CLIENT in (select ID_CLIENT
FROM [SIDBDMT].[mkh].[T_DIM_COMPTE_FIDELITE_H]
where ID_TYPE_CARTE_FIDELITE not in (8))
and [DT_DEBUT_SEJOUR] between '20200701' and  '20200731'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour
group by [CO_ETABLISSEMENT_QTS]

drop table #Actif_juil
select [CO_ETABLISSEMENT_QTS]
,count (distinct ID_CLIENT) as Client_Actif
into #Actif_juil
FROM [SIDBDMT].[mkh].[T_FAIT_SEJOUR]
where [DT_DEBUT_SEJOUR] between '20200701' and '20200730'
and ID_TYPE_SEJOUR = 1 and ID_STATUT_SEJOUR in (3,4) 
and dt_debut_sejour<> dt_fin_sejour

group by [CO_ETABLISSEMENT_QTS]

drop table #juil
SELECT hotel, Client_Actif, Client_Infiniment 
into #juil
from #etabs aa
full outer join #Actif_juil a on aa.hotel=a.[CO_ETABLISSEMENT_QTS]
full outer join #Inf_juil i on aa.hotel =i.[CO_ETABLISSEMENT_QTS]


select  * from #etabs aa
full outer join (select * from #oct) a on aa.hotel=a.hotel
full outer join (select * from #nov) b on aa.hotel=b.hotel
full outer join (select * from #dec) c on aa.hotel=c.hotel
full outer join (select * from #jan) d on aa.hotel= d.hotel
full outer join (select * from #fev) e on aa.hotel=e.hotel
full outer join (select * from #mars) f on aa.hotel=f.hotel
full outer join (select * from #avr) g on aa.hotel= g.hotel
full outer join (select * from #mai) h on aa.hotel=h.hotel
full outer join (select * from #juin) i on aa.hotel= i.hotel
full outer join (select * from #juil) j on aa.hotel=j.hotel