Drop table #perimetre
Select 'COUNH' as Hotel , 
'20180501' as Dt_Min,
'20190430' as Dt_Max
into  #perimetre




/*Restauration*/
Drop table #restau 
select distinct MasterId
into #restau 
[BARRIERE].[dbo].[H_RESADETAILSEJOUR] 
  where date_debut between (select dt_min from #perimetre)  and (select dt_max from #perimetre) 
  and Statut_Reservation in (3, 4 )
and [Rate_Category] between 1 and 11 
  and Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO'
/*type offre ou rate segment = IPTH */ 
  and Type_Offre = 42  
  and Code_Etablissement like (select hotel from #perimetre) 
  and (Id_Detail_Sejour_WS in (Select Id_Detail_Sejour_WS
  FROM [BARRIERE].[dbo].[H_CONSOSEJOUR] c
  inner join [BARRIERE].[dbo].[H_RefProduitSejour] r
  on c.Id_Produit_Sejour_WS = r.Id_Produit_Sejour_WS  
  where [Trx_Code] in (2112,2111,2211,2212,2511, 2512,8010,8037,
  3113, 3213, 5001,5002,6211,6212,6221,6222,8010)
  or [Trx_Code] between 8008 and 8014 )
 or Rate_Code like '%PKGOU%'
 or Rate_Code like '%DP1R%'
 or Rate_Code like 'FETE%'
 or rate_Code like 'MBFDP%'
 or rate_Code in ('MBFCE', 'MBFDP', 'MBFDP1', 'MBFMDG', 'MBFMDG1', 'MBFSG07','MBFETOILE',
 'MBFDPSRP', 'VTPDP') 
 )


  /* Golf Tennis*/
  Drop Table #golf 
	select distinct MasterId
	into #golf 
    FROM  [BARRIERE].[dbo].[H_RESADETAILSEJOUR]
  where date_debut between (select dt_min from #perimetre)  and (select dt_max from #perimetre) 
  and Statut_Reservation in (3, 4 )
and [Rate_Category] between 1 and 11 
  and Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO' 
  /*type offre ou rate segment = IPTH */ 
  and Code_Etablissement like (select hotel from #perimetre) 
  and (Id_Detail_Sejour_WS in (Select Id_Detail_Sejour_WS
  FROM [BARRIERE].[dbo].[H_CONSOSEJOUR] c
  inner join [BARRIERE].[dbo].[H_REFPRODUITSEJOUR] r
  on c.Id_Produit_Sejour_WS = r.Id_Produit_Sejour_WS  
  where [Trx_Code] in (6535,7124,7125,8017,8062,7003,7004,4798, 4799, 7130, 8062) -- 4798 et 7130 = tennis
  or (Code_Etablissement like 'LBA%' and [Trx_Code] between 6810 and 6839 )
  or (Code_Etablissement like 'LBA%' and [Trx_Code] between 6310 and 6339 )      ) 
 or Rate_Code in ('CG','COTDEA','MBFEG','MBFEG1','COTDEA', 'ASSOG', 'CG', 'LSP', 'FGOGPK') 
  or Rate_Code like 'FUGO%'
 or Rate_Code like '%GOLF%' 
 or Rate_Code like '%GO' 
 or Rate_Code like 'TOGLO%'
 or  Rate_Code like 'COT%' 
 or Type_Offre = 41 ) --- 41 = IPG


  /*Casino*/
 Drop Table #casino
	select distinct MasterId
	into #casino  
   FROM  [BARRIERE].[dbo].[H_RESADETAILSEJOUR]
  where date_debut between (select dt_min from #perimetre)  and (select dt_max from #perimetre) 
  and Statut_Reservation in (3, 4 )
and [Rate_Category] between 1 and 11 
  and Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO' 
  /*type offre ou rate segment = IPTH */ 
  and Code_Etablissement like (select hotel from #perimetre) 
  and (Id_Detail_Sejour_WS in (Select Id_Detail_Sejour_WS
  FROM [BARRIERE].[dbo].[H_CONSOSEJOUR] c
  inner join [BARRIERE].[dbo].[H_REFPRODUITSEJOUR] r
  on c.Id_Produit_Sejour_WS = r.Id_Produit_Sejour_WS  
  where ( (Code_Etablissement like 'ENG%' and [Trx_Code] between 6310 and 6339) 
  or (Code_Etablissement like 'DEA%' and ([Trx_Code] between 6610 and 6654 or [Trx_Code] in (6062,6026) ) )
  or (Code_Etablissement like 'CAN%' and ([Trx_Code] between 6510 and 6543 or [Trx_Code]  between 6210 and 6243 ))
  or (Code_Etablissement like 'CAN%' and [Trx_Code] in (4685, 4686,7041,8064,8067,6024,6042,6045,6054) )
  or [Trx_Code] in (6012,6021,6015,6051,8008)   ) ) 
   or Rate_Code in ('MBFMDSC','MBFMDSC1')
 or Rate_Code like '%CPALACE%' 
 or Rate_Code like '%CPI%' 
 or Rate_Code like '%CAS%'
 or Type_Offre = 38 ) --- 38 / IPCA 
	

  /*Spectacle   */
  drop table #spect
  	select distinct MasterId
	into #spect  
  FROM  [BARRIERE].[dbo].[H_RESADETAILSEJOUR]
  where date_debut between (select dt_min from #perimetre)  and (select dt_max from #perimetre) 
  and Statut_Reservation in (3, 4 )
and [Rate_Category] between 1 and 11 
  and Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO' 
  /*type offre ou rate segment = IPTH */ 
  and Code_Etablissement like (select hotel from #perimetre) 
  and (Id_Detail_Sejour_WS in (Select Id_Detail_Sejour_WS
  FROM [BARRIERE].[dbo].[H_CONSOSEJOUR] c
  inner join [BARRIERE].[dbo].[H_REFPRODUITSEJOUR] r
  on c.Id_Produit_Sejour_WS = r.Id_Produit_Sejour_WS  
  where [Trx_Code] in (4683, 8004)
  or  [Trx_Code]  between 6651 and 6654
  or (Code_Etablissement like 'LIL%' and [Trx_Code] between 2511 and 2549) 
  or (Code_Etablissement like 'LIL%' and [Trx_Code]  = 7010) 
  )
 or Rate_Code in ('ARTCAS','MM','MMBB','FPBB', 'FPDP','GALA','PKBBTHEA') 
 or Rate_Code like '%SBEB%' 
 or Rate_Code like '%SPECT%' 
 or Rate_Code like '%REVUE%'
 )	


   /*Bien Etre*/
  drop table #be
  	select distinct MasterId
	into #be  
  FROM  [BARRIERE].[dbo].[H_RESADETAILSEJOUR]
  where date_debut between (select dt_min from #perimetre)  and (select dt_max from #perimetre) 
  and Statut_Reservation in (3, 4 )
and [Rate_Category] between 1 and 11 
  and Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO' 
  /*type offre ou rate segment = IPTH */ 
  and Code_Etablissement like (select hotel from #perimetre) 
  and (Id_Detail_Sejour_WS in (Select Id_Detail_Sejour_WS
  FROM [BARRIERE].[dbo].[H_CONSOSEJOUR] c
  inner join [BARRIERE].[dbo].[H_REFPRODUITSEJOUR] r
  on c.Id_Produit_Sejour_WS = r.Id_Produit_Sejour_WS  
  where Rate_Code in ('MBF2BB', 'MBFBB', 'PKBBDUO') 
or  [Trx_Code] in (4911,5010, 5110, 5210,8012)
or [Trx_Code] between 8016 and 8046
  or  [Trx_Code]  between  4701 and 4711
  or (Code_Etablissement like 'LBA%' and [Trx_Code] between 6913 and 6980) 
   or (Code_Etablissement like 'ENG%' and [Trx_Code] between 6410 and 6439)   
  or Rate_Code in ('MBF2BB')
 or (( Rate_Code like '%LIBERTE%' or Rate_Code like '%FORM%' 
  or Rate_Code like '%SPA%'  or Rate_Code like '%TH%' or Rate_Code like '%DETOX%')
  and Rate_Code not like '%BEB%' and Rate_Code not like '%LIBERTE%' )
  or Type_Offre = 42 --- IPTH
  )	 )
  
  drop table #parking
  	select distinct MasterId
	into #parking  
  FROM  [BARRIERE].[dbo].[H_RESADETAILSEJOUR]
  where date_debut between (select dt_min from #perimetre)  and (select dt_max from #perimetre) 
  and Statut_Reservation in (3, 4 )
and [Rate_Category] between 1 and 11 
  and Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO' 
  and Code_Etablissement like (select hotel from #perimetre) 
  and (Id_Detail_Sejour_WS in (Select Id_Detail_Sejour_WS
  FROM [BARRIERE].[dbo].[H_CONSOSEJOUR] c
  inner join [BARRIERE].[dbo].[H_REFPRODUITSEJOUR] r
  on c.Id_Produit_Sejour_WS = r.Id_Produit_Sejour_WS  
  where [Trx_Code] in (4603,4608,4411,7206,7201)
  )	 )

    /*
  /*Ski   */
  drop table #ski
  	select distinct MasterId
	into #ski  
  FROM  [BARRIERE].[dbo].[H_RESADETAILSEJOUR]
  where date_debut between (select dt_min from #perimetre)  and (select dt_max from #perimetre) 
  and Statut_Reservation in (3, 4 )
and [Rate_Category] between 1 and 11 
  and Delete_Date is null 
  and datediff(day,Date_Debut,Date_Fin) > 0 
  and Classe_de_Chambre <> 'PSEUDO' 
  and Code_Etablissement like (select hotel from #perimetre) 
  and (Id_Detail_Sejour_WS in (Select Id_Detail_Sejour_WS
  FROM [BARRIERE].[dbo].[H_CONSOSEJOUR] c
  inner join [BARRIERE].[dbo].[H_REFPRODUITSEJOUR] r
  on c.Id_Produit_Sejour_WS = r.Id_Produit_Sejour_WS  
  where Code_Etablissement like 'COUNH' and [Trx_Code] in (7017,7020, 7021,7022,7211) ) )
  */         

  -- total clients avec une activité annexe 
  select count(distinct MasterId) as Total_Cli_Resort
  from
(
select * from #restau 
union all
select * from #casino 
union all 
select * from #golf 
union all 
select * from #be
union all 
select * from #spect 

 ) g 

select count(distinct masterId) as Cli_restau from #restau 
select count(distinct masterId) as Cli_casino from #casino 
select count(distinct masterId) as Cli_be from #be 
select count(distinct masterId) as Cli_golf from #golf 
select count(distinct masterId) as Cli_spect from #spect 
 select count(distinct masterId) as Cli_park from #parking
