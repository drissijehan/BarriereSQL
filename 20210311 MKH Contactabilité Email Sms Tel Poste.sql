
select [Code_Etablissement],
count(distinct s.masterid) as Clients,
count(distinct m.masterid) as Contactables_Email ,
count(distinct t.masterid) as Contactables_Tel,
count(distinct p.masterid) as Contactables_Poste  
 FROM [V-FRPRSA2-SID01\SIDB].[SIDBDWH].[qts].[T_H_SEJOUR] s
 left join (select masterid
 FROM [Imports.Ext].[dbo].[V_Mkh_Contact_Emails]
 where [FlgContactable] = 1 and FlgConsentement = 1 ) m
 on s.masterId = m.masterid
 left join (select masterid
 FROM [Imports.Ext].[dbo].[V_Mkh_Contact_Tel]
 where [FlgContactable] = 1 and FlgConsentement = 1 ) t
 on s.masterid = t.masterid
left join (select masterid
 FROM [Imports.Ext].[dbo].[V_Mkh_Contact_Poste]
 where [Npai] = 0 and FlgConsentement = 1  ) p
 on s.masterid = p.masterid
  where [Code_Etablissement] not in ('MARNA', 'NIENB')
and [Type_de_Sejour] = 1 and [Statut_du_Sejour] in (3,4)
and [Date_Debut_du_Sejour] between '20210212' and '20210228'
group by [Code_Etablissement]
order by [Code_Etablissement]