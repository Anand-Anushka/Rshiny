library(ggplot2)
library(lattice)
library(caret)
library(randomForest)
#plotting

library(rpart.plot)
library(RColorBrewer)

#loading data

setwd("C:/Users/anu/Documents/tydy intern")
dat<-read.csv("Watson_Analytics IBM Sample data.csv",header = TRUE,stringsAsFactors = TRUE)
View(dat)

#Training and Testing Sample

set.seed(12345)
inTrain <- createDataPartition(dat$Attrition,p=0.75,list = FALSE)
Training <- dat[inTrain,]
Testing <- dat[-inTrain,]

# Modeling

train_model<- randomForest(formula = as.factor(Attrition) ~ Age+BusinessTravel+Department+DistanceFromHome+EnvironmentSatisfaction+Gender+JobInvolvement+JobLevel+JobSatisfaction+MaritalStatus+MonthlyIncome+NumCompaniesWorked+OverTime+PercentSalaryHike+PerformanceRating+RelationshipSatisfaction+TotalWorkingYears+TrainingTimesLastYear+WorkLifeBalance+YearsAtCompany+YearsInCurrentRole+YearsSinceLastPromotion+YearsWithCurrManager,data=Training,ntree=1000)
True_attrition<-Testing$Attrition
Testing$Attrition<-NULL
predicted_result<-predict(train_model,newdata = Testing,type="class")
#predicted_result <- ifelse(predicted_result > 0.5,"Yes","No")
misClasificError <- mean(predicted_result!= True_attrition)
print(paste('Accuracy',1-misClasificError))
confusionMatrix(predicted_result,True_attrition)
varImpPlot(train_model)
