library(DBI)
library(RMySQL)

uc<-dbConnect(MySQL(),user="testuser1",
              password="pass123",host="23.21.136.55",dbname="bucky")
ibm_dat<-dbGetQuery(uc,"SELECT * FROM `table 2`")
View(ibm_dat)
dbDisconnect(uc)
# 
# setwd("C:/Users/anu/Documents/tydy intern")
# dat<-read.csv("Watson_Analytics IBM Sample data.csv",header = TRUE,stringsAsFactors = TRUE)
# #View(dat)

