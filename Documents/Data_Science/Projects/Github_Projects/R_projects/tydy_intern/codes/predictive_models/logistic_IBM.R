setwd("C:/Users/anu/Documents/tydy intern")
dat<-read.csv("Watson_Analytics IBM Sample data.csv",header = TRUE,stringsAsFactors = TRUE)
library(caTools)
dat$EmployeeNumber<-NULL
dat$Over18<-NULL
dat$StandardHours<-NULL
dat$EmployeeCount<-NULL
set.seed(100)
split<-sample.split(dat$Attrition,SplitRatio = .75)
train<-subset(dat,split==T)
test<-subset(dat,split==F)
model<-glm(Attrition~.,train,family = "binomial")
pre<-predict(model,test,type="response")
table(pre>0.5,test$Attrition)
