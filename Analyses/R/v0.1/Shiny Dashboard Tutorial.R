library(shiny)
library(shinydashboard)


ui = dashboardPage(
  dashboardHeader(title = 'PRU Web App'),
  dashboardSidebar(),
  dashboardBody()
)




server = function(input, output){
  
}

shinyApp(ui, server)