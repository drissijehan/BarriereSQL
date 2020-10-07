/*IB_5% WEB*/
drop table #IB_5
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation
into #IB_5
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where Rate_code like 'IB[1-7]' -- critère des-5% IB
and [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20200625' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 

/*Commande Tous Canaux Tous Clients	*/
drop table #Ts_Canaus_Ts_clts
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation
into #Ts_Canaus_Ts_clts
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where  [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20200625' --- période réservation
group by Code_Etablissement 

/*Commande Tous Clients Web	*/
drop table #Ts_Clts_Web
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation
into #Ts_Clts_Web
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20200625' --- période réservation
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement 

/*Commande Client IB Tous Canaux	*/
drop table #IB_Ts_Canaux
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation
into #IB_Ts_Canaux
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20200625' --- période réservation
and MasterID in (select masterID FROM [SIDBDWH].[qts].[T_CONTACTS] where Client_IB=1)
group by Code_Etablissement 

/*Commande Client IB Web	*/
drop table #Clt_IB_Web
select code_etablissement,
count (distinct ach_conf_no) as Commandes_IB,
Sum(isnull(Share_Amount,0)+ isnull(Prd_Resv_Separate_Line_Amount,0)+ isnull(Prd_Resv_Combined_Line_Amount,0)) as CA_Reservation
into #Clt_IB_Web
FROM [SIDBDWH].[qts].[T_H_RESADETAILSEJOUR]
where [Classe_de_Chambre] <>  'PSEUDO' -- pas de chambres virtuelles
and [Delete_Date] is null -- pas de lignes supprimées
and [Date_Reservation] between '20191001' and '20200625' --- période réservation
and MasterID in (select masterID FROM [SIDBDWH].[qts].[T_CONTACTS] where Client_IB=1)
and [Source_Reservation] in (18,27) -- commandes web 18 = OWS |  27 = HB
group by Code_Etablissement

select * from #Clt_IB_Web

select  * from #Ts_Canaus_Ts_clts a
full outer join (select * from #Ts_Clts_Web) b on a.Code_Etablissement=b.Code_Etablissement
full outer join (select * from #IB_Ts_Canaux) c on b.Code_Etablissement=c.Code_Etablissement
full outer join (select * from #Clt_IB_Web) d on c.Code_Etablissement= d.Code_Etablissement
full outer join (select * from #IB_5) e on d.Code_Etablissement=e.Code_Etablissement