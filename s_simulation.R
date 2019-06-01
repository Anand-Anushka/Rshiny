library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = 'Master TU QA Dashboard'),
  dashboardSidebar(fileInput("mobile", "Choose CSV File",
                             accept = c(
                               "text/csv",
                               "text/comma-separated-values,text/plain",
                               ".csv")
  ),
  tags$hr(),
  checkboxInput("header", "Header", TRUE)
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
      
      dataTableOutput("bottle")
  )
)

server <- function(input, output) {
  output$bottle <- renderDataTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$mobile
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header = input$header)
  })
}


shinyApp(ui, server)
