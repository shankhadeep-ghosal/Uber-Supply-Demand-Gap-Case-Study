# #loading the data to uber_df
# uber_df<-read.csv("Uber Request Data.csv")
# 
# #Data Structure
# str(uber_df)
# 
# # Required libraries for primary data cleaning
# install.packages("dplyr")
# library("dplyr")
# install.packages("stringr")
# library("stringr")
# install.packages("lubridate")
# library("lubridate")
# install.packages("ggplot2")
# library("ggplot2")
# install.packages("sqldf")
# library("sqldf")
# 
# #checking the number of NA values in uber_df column-wise
# sapply(uber_df,function(x) sum(is.na(x)))
# 
# #Convert the d/m/y to d-m-y
# ?str_replace_all
# uber_df$Request.timestamp<-str_replace_all(uber_df$Request.timestamp,"[/]","-")
# uber_df$Drop.timestamp<-str_replace_all(uber_df$Drop.timestamp,"[/]","-")
# 
# #Convert the date formt to yyyy-mm-dd of Request.timestamp and Drop.timestamp
# 
# uber_df$request_stamp_format<-as.POSIXct(uber_df$Request.timestamp,format="%d-%m-%Y %H:%M")
# uber_df$drop_stamp_format<-as.POSIXct(uber_df$Drop.timestamp,format="%d-%m-%Y %H:%M")
# 
# #Seperating hour and date from request time
# uber_df$Req_time<-as.numeric(format(uber_df$request_stamp_format,"%H"))
# uber_df$Req_date<-as.numeric(format(uber_df$request_stamp_format,"%d"))
# 
# uber_df$weekdays<-weekdays(uber_df$request_stamp_format)
# 
# #Creation of derived column time_day based on req_time column
# 
# 
# 
# for(i in 1:nrow(uber_df))
# {
#   if ((uber_df$Req_time[i]>=00 & uber_df$Req_time[i]<=3)) {
#     uber_df$time_day[i]<-'Late Night'
#   } else if ((uber_df$Req_time[i]>=4 & uber_df$Req_time[i]<=7)) {
#     uber_df$time_day[i]<-'Early Morning'
#   } else if ((uber_df$Req_time[i]>=8 & uber_df$Req_time[i]<=11)) {
#     uber_df$time_day[i]<-'Morning'
#   } else if ((uber_df$Req_time[i]>=12 & uber_df$Req_time[i]<=15)) {
#     uber_df$time_day[i]<-'Afternoon'
#   } else if ((uber_df$Req_time[i]>=16 & uber_df$Req_time[i]<=19)) {
#     uber_df$time_day[i]<-'Evening'
#   } else  {
#     uber_df$time_day[i]<-'Night'
#   }
# }
# 
# # Travel Path
# for(k in 1:nrow(uber_df))
# {
#   if ((uber_df$Pickup.point[k]=="Airport")) {
#     uber_df$travel_path[k]<-'Airport to City'
#   } else {
#     uber_df$travel_path[k]<-'City to Airport'
#   }
# }
# 
# 
# 
# #Deletion of columns which are not required "Request.timestamp","Drop.timestamp"
# 
# drop <- c("Request.timestamp","Drop.timestamp")
# uber_df = uber_df[,!(names(uber_df) %in% drop)]
# 
# 
# 
# # Time Slot vs No. of request and Status
# ggplot(uber_df,aes(x=time_day,fill=Status))+geom_bar(position="dodge")+
#   labs(x="Time Slots",y="No.of Requests",fill="Status")+theme(axis.text.x = element_text(angle = 50, hjust = 1))
# 
# 
# 
# 
# # Status of availability of car in different times of the day
# G1<-ggplot(uber_df, aes(x = time_day,fill = Status))+geom_bar(position="dodge")
# G1<-G1+facet_wrap(~travel_path,nrow=2,ncol=1)+labs(x="Timings",y="No.of Requests",fill="Status")
# G1+theme(axis.text.x = element_text(angle = 50, hjust = 1))
# 
# 
# # Days vs No.of Request based on status and travel path
# G2<-ggplot(uber_df, aes(x = weekdays,fill = Status))+geom_bar(position="dodge")
# G2+facet_wrap(~travel_path,nrow=2,ncol=1)+labs(x="Days",y="No.of Requests",fill="Status")
# 
# 
# #Comparing Trip Status between Airport and City
# ggplot(uber_df,aes(x=travel_path,fill=Status))+geom_bar(position="dodge")
# 
# # Timings(Hour) vs no. of Request and Travel path based on Status
# G3<-ggplot(uber_df,aes(x=as.factor(Req_time),fill=travel_path))+geom_bar(position="dodge")
# G3+facet_wrap(~Status,nrow=3,ncol=1)+labs(x="Timings",y="No.of Requests",fill="travel_path")
# 
# G5<-ggplot(uber_df,aes(x=as.factor(Req_time),fill=Status))+geom_bar(position="dodge")
# G5+facet_wrap(~travel_path,nrow=3,ncol=1)+labs(x="Timings",y="No.of Requests",fill="Status")
# 
# # Time Slots vs no. of Request and Travel path based on Status
# G4<-ggplot(uber_df,aes(x=as.factor(time_day),fill=travel_path))+geom_bar(position="dodge")
# G4<-G4+facet_wrap(~Status,nrow=3,ncol=1)+labs(x="Timings",y="No.of Requests",fill="travel_path")
# G4+theme(axis.text.x = element_text(angle = 50, hjust = 1))
# 
# 
# # Time Slots vs no. of Request based on Status
# ggplot(uber_df,aes(x=as.factor(Req_time),fill=Status))+geom_bar(position="dodge")
# 
# 
# #Supply_vs_Demand(CITY to AIRPORT)
# 
# 
# df1<-uber_df[(uber_df$Pickup.point=="City"),]
# Total_Req_to_Airport<-nrow(df1)
# Total_Req_to_Airport_Completed<-nrow(df1[df1$Status=="Trip Completed",])
# 
# df0<-df1[df1$Status!="Trip Completed",]
# Total_Req_to_Airport_Not_Completed<-nrow(df0)
# 
# 
# counts<-c(Total_Req_to_Airport_Completed,Total_Req_to_Airport_Not_Completed)
# labels_1<-c("Trip Completed","Rejected")
# 
# pie_percent<- round(100*counts/sum(counts), 1)
# 
# pie(counts,pie_percent,
#     main = "Supply vs Demand ( City to Airport )",
#     col=c("green","red"),
#     border = "white",
#     clockwise = TRUE)
# legend("topright",
#        labels_1,
#        cex = 0.8,
#        fill = c("green","red"))
# 
# #Supply_vs_Demand(AIRPORT to CITY)
# 
# 
# df2<-uber_df[(uber_df$Pickup.point=="Airport"),]
# Total_Req_to_City<-nrow(df2)
# Total_Req_to_City_Completed<-nrow(df2[df2$Status=="Trip Completed",])
# 
# df3<-df2[df2$Status!="Trip Completed",]
# Total_Req_to_CIty_Not_Completed<-nrow(df0)
# 
# 
# counts1<-c(Total_Req_to_City_Completed,Total_Req_to_CIty_Not_Completed)
# labels_2<-c("Trip Completed","Rejected")
# 
# pie_percent_1<- round(100*counts1/sum(counts1), 1)
# 
# pie(counts1,pie_percent_1,
#     main = "Supply vs Demand ( Airport to City )",
#     col=c("green","red"),
#     border = "white",
#     clockwise = TRUE)
# legend("topright",
#        labels_2,
#        cex = 0.8,
#        fill = c("green","red"))
# 
# 
# # Supply-Demand Gap Analysis and finding out in which time slot it is high
# 
# #Pickup.point to Pickup_point name change, as Pickup.point is throwing error in sqldf
# 
# colnames(uber_df)[which(names(uber_df) == "Pickup.point")] <- "Pickup_point"
# 
# #Supply-Demand gap in City
# sqldf("select time_day,count(*) as 'Supply-Demand Gap',Travel_path from uber_df 
#       where status!='Trip Completed' and Pickup_point='City' 
#       group by time_day "  )
# #Supply-Demand gap in Airport
# sqldf("select time_day,count(*) as 'Supply-Demand Gap',travel_path from uber_df 
#       where status!='Trip Completed' and Pickup_point='Airport' 
#       group by time_day "  )
# 
# Gap_df<-uber_df[(uber_df$Status!="Trip Completed"),]
# 
# #Plot for Supply-Demand Gap
# G6<-ggplot(Gap_df, aes(x = time_day,fill = Status))+geom_bar(position="stack")
# G6<-G6+facet_wrap(~travel_path,nrow=2,ncol=1)+labs(x="Timings",y="No.of Requests",fill="Supply-Demand Gap")
# G6+theme(axis.text.x = element_text(angle = 50, hjust = 1))
# 
