## Analysis of IBM data for Attrition 
#loading data
setwd("C:/Users/anu/Documents/tydy intern")
dat<-read.csv("Watson_Analytics IBM Sample data.csv",header = TRUE,stringsAsFactors = TRUE)
View(dat)

#Business_Travel

y<-subset(dat,BusinessTravel=="Non-Travel")
prop.table(table(y$BusinessTravel,y$Attrition))
y<-subset(dat,BusinessTravel=="Travel_Frequently")
prop.table(table(y$BusinessTravel,y$Attrition))
y<-subset(dat,BusinessTravel=="Travel_Rarely")
prop.table(table(y$BusinessTravel,y$Attrition))
agePlot <- ggplot(dat,aes(Age,fill=Attrition))+geom_density()+facet_grid(~Attrition)

# Plot analysis

library(ggplot2)
library(grid)
library(gridExtra)

# age - department

agePlot <- ggplot(dat,aes(Age,fill=Attrition))+geom_density()+facet_grid(~Attrition)
travelPlot <- ggplot(dat,aes(BusinessTravel,fill=Attrition))+geom_bar()
ratePlot <- ggplot(dat,aes(DailyRate,Attrition))+geom_point(size=4,alpha = 0.05)
depPlot <- ggplot(dat,aes(Department,fill = Attrition))+geom_bar()
grid.arrange(agePlot,travelPlot,ratePlot,depPlot,ncol=2,top = "Fig 1")

# distance-gender

distPlot <- ggplot(dat,aes(DistanceFromHome,fill=Attrition))+geom_bar()
eduPlot <- ggplot(dat,aes(Education,fill=Attrition))+geom_bar()
edufieldPlot <- ggplot(dat,aes(EducationField,fill=Attrition))+geom_bar()
envPlot <- ggplot(dat,aes(EnvironmentSatisfaction,fill=Attrition))+geom_bar()
genPlot <- ggplot(dat,aes(Gender,fill=Attrition))+geom_bar()
grid.arrange(distPlot,eduPlot,edufieldPlot,envPlot,genPlot,ncol=2,top = "Fig 2")

# hourly - job-satisfaction

hourlyPlot <- ggplot(dat,aes(HourlyRate,fill=Attrition))+geom_bar()
jobInvPlot <- ggplot(dat,aes(JobInvolvement,fill=Attrition))+geom_bar()
jobLevelPlot <- ggplot(dat,aes(JobLevel,fill=Attrition))+geom_bar()
jobSatPlot <- ggplot(dat,aes(JobSatisfaction,fill=Attrition))+geom_bar()
grid.arrange(hourlyPlot,jobInvPlot,jobLevelPlot,jobSatPlot,ncol=2,top = "Fig 3")

# marital_status - number of comapies worked

marPlot <- ggplot(dat,aes(MaritalStatus,fill=Attrition))+geom_bar()
monthlyIncPlot <- ggplot(dat,aes(MonthlyIncome,fill=Attrition))+geom_density()
monthlyRatePlot <- ggplot(dat,aes(MonthlyRate,fill=Attrition))+geom_density()
numCompPlot <- ggplot(dat,aes(NumCompaniesWorked,fill=Attrition))+geom_bar()
grid.arrange(marPlot,monthlyIncPlot,monthlyRatePlot,numCompPlot,ncol=2,top = "Fig 4")

#overtime-prformance

overTimePlot <- ggplot(dat,aes(OverTime,fill=Attrition))+geom_bar()
hikePlot <- ggplot(dat,aes(PercentSalaryHike,Attrition))+geom_point(size=4,alpha = 0.01)
perfPlot <- ggplot(dat,aes(PerformanceRating,fill = Attrition))+geom_bar()
RelSatPlot <- ggplot(dat,aes(RelationshipSatisfaction,fill = Attrition))+geom_bar()
grid.arrange(overTimePlot,hikePlot,perfPlot,RelSatPlot,ncol=2,top = "Fig 5")

#stock option - Work_life_balanca

StockPlot <- ggplot(dat,aes(StockOptionLevel,fill = Attrition))+geom_bar()
workingYearsPlot <- ggplot(dat,aes(TotalWorkingYears,fill = Attrition))+geom_bar()
TrainTimesPlot <- ggplot(dat,aes(TrainingTimesLastYear,fill = Attrition))+geom_bar()
WLBPlot <- ggplot(dat,aes(WorkLifeBalance,fill = Attrition))+geom_bar()
grid.arrange(StockPlot,workingYearsPlot,TrainTimesPlot,WLBPlot,ncol=2,top = "Fig 6")

#year_at_company - years-current_manager

YearAtComPlot <- ggplot(dat,aes(YearsAtCompany,fill = Attrition))+geom_bar()
YearInCurrPlot <- ggplot(dat,aes(YearsInCurrentRole,fill = Attrition))+geom_bar()
YearsSinceProm <- ggplot(dat,aes(YearsSinceLastPromotion,fill = Attrition))+geom_bar()
YearsCurrManPlot <- ggplot(dat,aes(YearsWithCurrManager,fill = Attrition))+geom_bar()
grid.arrange(YearAtComPlot,YearInCurrPlot,YearsSinceProm,YearsCurrManPlot,ncol=2,top = "Fig 7")
