library(readxl)
Danilo <- read_excel("Danilo.xlsx")
tps_visite<- aggregate(tps_minutes~MasterID+Date_Seance_Casino,
                       data = Danilo, sum)
tps_visite_univers<- aggregate(tps_minutes~MasterID+Date_Seance_Casino
                               +Univers, data= Danilo, sum)
Danilo$Handle<-as.numeric(Danilo$Handle)
hdl_visite<- aggregate(Handle~MasterID+Date_Seance_Casino, 
                       data= Danilo, sum)
hdl_visite_univers<-aggregate(Handle~MasterID+Date_Seance_Casino
                              +Univers, data= Danilo, sum)
hdl_client <-aggregate(Handle~MasterID, data= Danilo, sum)
