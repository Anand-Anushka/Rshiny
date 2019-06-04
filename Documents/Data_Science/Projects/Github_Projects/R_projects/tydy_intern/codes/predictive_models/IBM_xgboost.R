library(ggplot2)
library(lattice)
library(caret)
library(rpart)
library(xgboost)
library(plyr)
#plotting
#library(rattle)
library(rpart.plot)
library(RColorBrewer)

#loading data

library(DBI)
library(RMySQL)

uc<-dbConnect(MySQL(),user="root",
              password="",dbname="bucky")
dat<-dbGetQuery(uc,"SELECT * FROM `table 2`")

#Feature Selection and engineering

dat$wc<-dat$YearsInCurrentRole-dat$YearsSinceLastPromotion
dat$EmployeeNumber<-NULL
dat$HourlyRate<-NULL
dat$Over18<-NULL
dat$MonthlyIncome<-NULL
dat$new<-dat$TotalWorkingYears-dat$YearsAtCompany
View(dat)
#Training and Testing Sample

set.seed(12345)
inTrain <- createDataPartition(dat$Attrition,p=0.75,list = FALSE)
Training <- dat[inTrain,]
Testing <- dat[-inTrain,]

#Modeling

xgbGrid <- expand.grid(nrounds = 300,
                       max_depth = 1,
                       eta = 0.3,
                       gamma = 0.01,
                       colsample_bytree = .7,
                       min_child_weight = 1,
                       subsample = 0.9)

set.seed(12)
train_model <- train(Attrition ~.,Training,method = 'xgbTree',tuneGrid = xgbGrid,trControl = trainControl(method = 'repeatedcv',number = 3,classProbs = TRUE)) 

True_attrition<-Testing$Attrition
Testing$Attrition<-NULL
predicted_result<-predict(train_model,newdata = Testing)

#predicted_result <- ifelse(predicted_result > 0.5,"Yes","No")

misClasificError <- mean(predicted_result!= True_attrition)
print(paste('Accuracy',1-misClasificError))
confusionMatrix(predicted_result,True_attrition)
gbmImp <- varImp(train_model, scale = FALSE)
plot(gbmImp)
