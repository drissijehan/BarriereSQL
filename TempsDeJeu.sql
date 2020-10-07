drop table #T_Jeu
select concat(ID_CLIENT,DT_SEANCE_CASINO) as ID,
sum(datepart(Hour, HH_TEMPS_JEU)*60.0 +  datepart(MINUTE, HH_TEMPS_JEU)*1.0 + datepart(SECOND, HH_TEMPS_JEU)/60.0) as Temps_Jeu
into #T_Jeu
  FROM [SIDBDMT].[mkc].[T_FAIT_SESSIONS_JEU]
  where DT_SEANCE_CASINO between '20200601' and '20200831'
  and ID_UNIVERS_JEUX in (1,3)
  group by concat(ID_CLIENT,DT_SEANCE_CASINO)

  select avg(Temps_Jeu) Temps_Moy from #T_Jeu 
  

  drop table #Machine
  select ID_CLIENT,DT_SEANCE_CASINO,
  count (distinct NO_MACHINE) as Nb_Machine
  into #Machine
    FROM [SIDBDMT].[mkc].[T_FAIT_SESSIONS_JEU]
	where DT_SEANCE_CASINO between '20200601' and '20200831'
	group by ID_CLIENT,DT_SEANCE_CASINO

	select avg(Nb_Machine) as nb_mach from #Machine