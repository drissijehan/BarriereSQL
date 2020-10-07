-- dernier hôtel du client 

drop table #last_hotel_tot
select distinct prf_id, act_place
into #last_hotel_tot
from
	(select distinct prf_id, max(act_date_end) as df

	from [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[DWH_PROFILE] P
	inner join [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[dwh_activity] A
	on A.act_prf_id=P.prf_id
	inner join [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[dwh_activity_hotel] AH
	on Ah.act_id=A.act_id

	where act_date_begin>='2018-08-01 00:00:00' and act_date_begin<'2018-09-01 00:00:00'
	and ach_status in ('CHECKED OUT','CC')
	and ach_rate_category in ('RACK', 'DISC', 'MOCO', 'TOOL', 'HACO', 'PROM', 'SPEC', 'TOPE', 'DISC1', 'DISC2', 'CAPA')
	and ach_room_type not in ('PM','SAL','CONH','PI','PF')
	and ach_rate_code<>'NORATE'
	and ach_total_revenue_wt <>0

	group by prf_id) as t1
	inner join [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[dwh_activity] A
	on A.act_prf_id=t1.prf_id and t1.df=A.act_date_end
	inner join [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[dwh_activity_hotel] AH
	on Ah.act_id=A.act_id
	where 
	ach_status in ('CHECKED OUT','CC')
	and ach_rate_category in ('RACK', 'DISC', 'MOCO', 'TOOL', 'HACO', 'PROM', 'SPEC', 'TOPE', 'DISC1', 'DISC2', 'CAPA')
	and ach_room_type not in ('PM','SAL','CONH','PI','PF')
	and ach_rate_code<>'NORATE'
	and ach_total_revenue_wt <>0


-- email booking 
select distinct P.act_place, case
when email is null then 0
else email
end as email
from #last_hotel_tot P
left join
(select act_place, count(distinct prf_id) as email
from
	#last_hotel_tot P
	inner join [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[DWH_PROFILE_communication] C
	on P.prf_id=C.prc_prf_id
where prc_value like '%@guest.booking.com'
and prc_primary_yn='y' and C.delete_date is null
and act_place<>'MARNA'
group by act_place)as t1
on t1.act_place=P.act_place
order by P.act_place asc

-- avec email 
select act_place, count(distinct prf_id)
from
	#last_hotel_tot P
	inner join [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[DWH_PROFILE_communication] C
	on P.prf_id=C.prc_prf_id
where prc_value like '%@%'
and prc_value not like '%@guest.booking.com'
and prc_value not like 'no@email.com'
and prc_primary_yn='y' and C.delete_date is null
and act_place<>'MARNA'
group by act_place
order by act_place asc

-- sans email 

select distinct act_place, count(distinct prf_id)
from #last_hotel_tot P
left join [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[DWH_PROFILE_communication] C
on P.prf_id=C.prc_prf_id
where P.prf_id not in
(select distinct prf_id
from [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[DWH_PROFILE] P
inner join [V-FRPRSA2-CSP01\DWHPRF ].[GLB_DWH-PRF].[dbo].[DWH_PROFILE_communication] C
on P.prf_id=C.prc_prf_id
where prc_value like '%@%' and prf_id is not null and C.delete_date is null)	
and act_place<>'MARNA'
group by act_place
order by act_place asc

-- total clients

select distinct act_place, count(distinct prf_id)
	from #last_hotel_tot
	where act_place<>'MARNA'
	group by act_place
	order by act_place asc


