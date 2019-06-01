library(devtools)
library(ggplot2)
library(ggthemes)
library(plotly)
library(shiny)
library(shinydashboard)
library(DT)
library(DBI)
library(RMySQL)

#uc<-dbConnect(MySQL(),user="root",
              #password="",dbname="bucky")
#dat<-dbGetQuery(uc,"SELECT * FROM `table 2`")
#View(dat)
setwd("C:/Users/anu/Documents/tydy intern")
dat<-read.csv("Watson_Analytics IBM Sample data.csv",header = TRUE,stringsAsFactors = TRUE)

ui<-dashboardPage(skin="red",
  dashboardHeader(title="Employee Analytics"),
  dashboardSidebar(title = "Attributes",
                   sidebarMenu(
                     menuItem("Raw Data", tabName = "raw", icon = icon("table")),
                     menuItem("Dashboard", tabName = "dash", icon = icon("bar-chart")),
                     menuItem("Attrition", tabName = "att", icon = icon("pie-chart")),
                     menuItem("Predictive Model", tabName = "distance", icon = icon("question-circle"))
                     #menuItem("Education", tabName = "education", icon = icon("mortar-board")),
                     #menuItem("Gender", tabName = "gender", icon = icon("intersex")),
                     #menuItem("Job-Satisfaction", tabName = "satisfaction", icon = icon("smile-o")),
                     #menuItem("year_company", tabName = "year", icon = icon("handshake-o"))
                     
                   )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "raw",
              
              fluidRow(
                box(width = 12,dataTableOutput("table"),title="Data")
              )
      ),
      tabItem(tabName = "dash",
              fluidRow(
                h2("HR Dashboard"),
                box(width=6,plotOutput("plot1",height = 300),collapsible = T),
                box(width=6,plotOutput("plot2",height = 300),collapsible = T)
              ),
              fluidRow(
                
                box(width=6,plotOutput("plot3",height = 300),collapsible = T),
                box(width=6,plotOutput("plot4",height = 300),collapsible = T)
              ),
              fluidRow(
                
                box(width=6,plotOutput("plot5",height = 500),collapsible = T),
                box(width=6,plotOutput("plot6",height = 500),collapsible = T)
              )
              
      ),
      tabItem(tabName = "att",
              fluidRow(
                h2("Attrition Dashboard"),
                box(width=6,plotOutput("plot7",height = 300),collapsible = T),
                box(width=6,plotOutput("plot8",height = 300),collapsible = T)
              ),
              fluidRow(
                
                box(width=6,plotOutput("plot9",height = 300),collapsible = T),
                box(width=6,plotOutput("plot10",height = 300),collapsible = T)
              ),
              fluidRow(
                
                box(width=6,plotOutput("plot11",height = 500),collapsible = T),
                box(width=6,plotOutput("plot12",height = 500),collapsible = T)
              )
              
      )
      
    )
    
  )
)
server<-function(input,output){
  output$plot1<-renderPlot({
  ggplot(data=dat,aes(Age,fill="red"))+geom_density()+
    labs(title="Age distribution for employees") +
    labs(x="Age", y="Count of employees")
  }
  )
  output$plot2<-renderPlot({
    ggplot(data=dat,aes(Department,fill = Department))+geom_bar()+
      labs(title="Department wise distribution")+
      labs(x="Department", y="Count of employees")
  }
    
  )
  output$plot3<-renderPlot({
    ggplot(dat, aes(x=factor(1), fill=Gender))+
      geom_bar(width = 1)+
      labs(title="Gender Ratio")+
      coord_polar("y")
      
  }
  )
  output$plot4<-renderPlot({
    dat$JobSatisfaction<-as.factor(dat$JobSatisfaction)
    ggplot(dat, aes(x="",fill=JobSatisfaction))+
      labs(title="Jobsatisafaction Ratio")+
      geom_bar(width = 1)+
      coord_polar("y")
    
  }
  )
  output$plot5<-renderPlot({
    ggplot(data=dat,aes(Attrition,fill=Attrition))+geom_bar()+
      labs(title="Attrition Staus") +
      labs(x="Attrition status", y="Count of employees")
  }
  )
  
  output$plot6<-renderPlot({
    ggplot(data=dat,aes(JobRole,fill=JobRole))+geom_bar()+
      labs(title="JobRole wise distribution")+
      labs(x="JobRole", y="Count of employees")+
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
  }
  
  )
  output$plot7<-renderPlot({
    ggplot(dat,aes(Age,fill=Attrition))+geom_density()+facet_grid(~Attrition)+
      labs(title="Age with Attrition")+
      labs(x="Age", y="density of employees")
      
  }
  
  )
  output$plot8<-renderPlot({
    ggplot(dat,aes(Department,fill = Attrition))+geom_bar()+
      labs(title="Department wise Attrition")+
      labs(x="JobRole", y="Count of employees")
      
  }
  
  )
  output$plot9<-renderPlot({
    ggplot(dat, aes(x=factor(1), fill=Gender))+
      geom_bar(width = 1)+
      facet_grid(~Attrition)+
      labs(title="Gender Ratio")+
      coord_polar("y")
    
    
  }
  
  )
  output$plot10<-renderPlot({
    dat$JobSatisfaction<-as.factor(dat$JobSatisfaction)
    ggplot(dat, aes(x="",fill=JobSatisfaction))+
      labs(title="Jobsatisafaction Ratio")+
      facet_grid(~Attrition)+
      geom_bar(width = 1)+
      coord_polar("y")
    
  }
  )
  
  output$plot11<-renderPlot({
    ggplot(data=dat,aes(OverTime,fill=Attrition))+geom_bar()+
      labs(title="OverTime and Attrition") +
      labs(x="OverTime", y="Count of employees")
  }
  )
  output$plot12<-renderPlot({
    ggplot(data=dat,aes(JobRole,fill=Attrition))+geom_bar()+
      labs(title="JobRole wise distribution")+
      labs(x="JobRole", y="Count of employees")+
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
  }
  
  )
  
  
  
  output$table<-DT::renderDataTable({
    DT::datatable(dat, 
                  options = list(scrollX = TRUE),filter='top')
  })
  
}
shinyApp(ui,server)
