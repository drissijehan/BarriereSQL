
--- Handle et temps par client
SELECT [MasterID]
      --[Date_Seance_Casino]
  --    ,[Temps_de_Jeu]
 , sum(Handle) as Hdl_client
 , sum(datepart(hour,[Temps_de_Jeu])*60 + datepart(MINUTE,[Temps_de_Jeu]) )as tps_minutes_client
 into #tps_hdl_cli
  FROM [BARRIERE].[dbo].[C_EarnCasino]
    where Univers in (1,3) --- 1 = MAS / 3 = JTE  
  and Date_Seance_Casino between '20190401' and '20190430'
  and Code_Etablissement = 'BDX' 
  group by  [MasterID]

  -- Moyenne Handle par Client
  select sum(Hdl_client)/count(distinct MasterID) as Hdl_cli
  from #tps_hdl_cli --5032.097580

  --- Handle et temps par seance
  SELECT [Date_Seance_Casino]
  --    ,[Temps_de_Jeu]
 , sum(Handle) as Hdl_visite
 , sum(datepart(hour,[Temps_de_Jeu])*60 + datepart(MINUTE,[Temps_de_Jeu]) )as tps_minutes_visite
 into #tps_hdl_vis
  FROM [BARRIERE].[dbo].[C_EarnCasino]
    where Univers in (1,3) --- 1 = MAS / 3 = JTE  
  and Date_Seance_Casino between '20190401' and '20190430'
  and Code_Etablissement = 'BDX' 
  group by  [Date_Seance_Casino]


  --Moyenne Handle par visite
  select sum(Hdl_visite)/count(distinct Date_Seance_Casino)
  from #tps_hdl_vis