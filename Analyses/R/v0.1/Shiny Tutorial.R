library(shiny)
library(shinydashboard)
library(DT)


#### 1. UI ####
ui = dashboardPage(
  dashboardHeader(title = 'PRU Web App'),
  
  ##### 1.1 Sidebar #####
  dashboardSidebar(
    sidebarMenu(
      ###### Poverty ######
      menuItem("On Poverty", tabName = "poverty", icon=icon('question-circle'),
               startExpanded = TRUE,
               menuItem('About', tabName = 'poverty_about'),
               menuItem('Profiles', tabName = 'poverty_profiles',
                        menuSubItem('Jane Doe', tabName = 'poverty_profiles_jane_doe'),
                        menuSubItem('John Doe', tabName = 'poverty_profiles_john_doe'))
               ),
      ###### Report ######
      menuItem("Report", tabName = "report", icon = icon("file-alt"),
               menuSubItem('About', tabName = 'report_about'),
               menuSubItem('Key Findings', tabName = 'report_key_findings'),
               menuSubItem('Policy and Path', tabName = 'report_policy_path'),
               menuSubItem('Measuring Poverty', tabName = 'report_measuring'),
               menuSubItem('Appendices', tabName = 'report_appendices')
               ),
      ###### Data ######
      menuItem("Data", tabName = "data", icon = icon("chart-bar"),
               menuSubItem('Highights', tabName = 'data_highlights'),
               menuSubItem('Detail', tabName = 'data_detail'),
               menuSubItem('Comparison', tabName = 'data_comparison'),
               menuSubItem('Policy', tabName = 'data_policy')
               )
    )
  ),
  
  ##### 1.2 Dashboard #####
  dashboardBody(
    tabItems(
      ###### Poverty - About ######
      tabItem("poverty_about",
              fluidPage(
                h1('What is Poverty?'),
                p('The World Bank describes poverty as:'),
                box(width = 8,
                  tags$q('Poverty is hunger. Poverty is lack of shelter. Poverty is being sick and not being able to see a doctor. Poverty is not having access to school and not knowing how to read. Poverty is not having a job, is fear for the future, living one day at a time. Poverty has many faces, changing from place to place and across time, and has been described in many ways.  Most often, poverty is a situation people want to escape. So poverty is a call to action -- for the poor and the wealthy alike -- a call to change the world so that many more may have enough to eat, adequate shelter, access to education and health, protection from violence, and a voice in what happens in their communities.')
                ),
                fluidRow(
                  box(status = 'warning', plotOutput("plot1", height = 250)),
                  
                  box(
                    title = "Controls",
                    sliderInput("slider", "Number of observations:", 1, 100, 50)
                  )
                )
              )),
      ###### Poverty - Profiles ######
      tabItem("poverty_profiles_jane_doe",
              fluidPage(
                h1("Jane Doe"),
                hr(style = "border-top: 1px solid #000000;"),
                img(src = "jane.jpg", height="65%", width="65%", align="center"),
                dataTableOutput("carstable")
                )
              ),
      tabItem("poverty_profiles_john_doe",
              fluidPage(
                h1("John Doe"),  
                hr(style = "border-top: 1px solid #000000;"),
                img(src = "john.jpg", height="65%", width="65%", align="center"),
                dataTableOutput("carstable")
              )
      ),
      ###### Report - About ######
      tabItem("report_about",
              'Report',
              fluidPage(
              h1('About'),
              p("The New York City poverty report is an annual research document meant to shed light on the current state of poverty in the city. It is mandated by the New York City Charter, which requires the Mayor’s Office for Economic Opportunity (NYC Opportunity) to release an update to the NYC Government poverty measure (NYCgov measure) every year, along with a survey of efforts to reduce poverty in the city. The report helps the City to monitor poverty and near poverty across the five boroughs, and to understand its impact on specific parts of the population. This edition of the report contains data through 2019, just before the onset of the COVID-19 pandemic."),
              p(actionButton(inputId = 'report_2018', label = "Download Current Report (2018)",
                             icon = icon("file-download"),
                             onclick = "window.open('https://www1.nyc.gov/assets/opportunity/pdf/20_poverty_measure_report'), _blank")
              ),
              p(actionButton(inputId = 'report_previous', label = "Download Previous Reports",
                             icon = icon("file-download"),
                             onclick = "window.open('https://www1.nyc.gov/site/opportunity/poverty-in-nyc/poverty-measure.page'), _blank")
              )
              )
      ),
      ###### Report - Key Findings ######
      tabItem("report_key_findings",
              "Report",
              fluidPage(
                h1("Key Findings"),
                p('The New York City Government (NYCgov) poverty measure is a measure of poverty adapted to the realities of the city’s economy. The poverty threshold accounts for housing costs that are higher than the national average. The measure of family resources includes public benefits and tax credits, but also acknowledges spending on medical costs and work-related expenses such as childcare and commuting.'),
                p('The NYCgov poverty rate, threshold, and income measure are higher than those same figures in the U.S. official measure.'),
                h3('Poverty in New York City, 2019'),
                h4('The NYCgov poverty rate for 2019 is 17.9 percent'),
                p('This is a statistically significant 1.4 percentage point change from 2018 when the rate was 19.3 percent.1 The 2019 rate is the lowest NYCgov poverty rate since the series began with 2005 data. The decline in the poverty rate primarily is due to increases in income and employment during the last year of the economic expansion that followed the Great Recession. The decline in poverty over the five-year period 2015 to 2019 also was statistically significant, resulting in a poverty rate that fell from 19.6 to 17.9 percent.'),
                p('The NYCgov poverty rate is historically higher than the U.S. official poverty rate. The official rate is derived only from pre-tax cash income and a poverty threshold that is three times the nationwide cost of a minimal food budget. The NYCgov rate responds to changes in multiple sources of income (including income supplements), medical and work-related expenses, and changes in average living standards over time, including local housing costs. Table 1.1 and Figure 1.1 illustrate these differences.'),
                h4('The NYCgov near poverty rate for 2019 is 40.8 percent.'),
                p('This is a statistically significant decline from the 41.9 percent near poverty rate in 2018. The term “near poverty,” as utilized in this report, includes the share of the population living under 150 percent of the NYCgov poverty threshold. It includes all people in poverty and those above the threshold but at risk of falling into poverty. The decline in near poverty, from 45.4 percent in 2015 to 40.8 percent in 2019, also is statistically significant (see Figure 1.2).'),
                fluidRow(
                  box(tabsetPanel(type = "tabs",
                                  tabPanel("Plot", plotOutput("plot")),
                                  tabPanel("Summary", verbatimTextOutput("summary")),
                                  tabPanel("Table", tableOutput("table"))
                  )),
                  
                  box(
                    title = "Controls",
                    # Input: Select the random distribution type
                    radioButtons("dist", "Distribution type:",
                                 c("Normal" = "norm",
                                   "Uniform" = "unif",
                                   "Log-normal" = "lnorm",
                                   "Exponential" = "exp")),
                    
                    # br() element to introduce extra vertical spacing
                    br(),
                    
                    # Input: Slider for the number of observations to generate
                    sliderInput("n",
                                "Number of observations:",
                                value = 500,
                                min = 1,
                                max = 1000)
                  ))
              )
      ),
      ###### Report - Policy & Path ######
      tabItem("report_policy_path",
              "Report",
              fluidPage(
                
                # App title
                titlePanel("Tabsets"),
                
                # Sidebar layout with input and output definitions
                sidebarLayout(
                  
                  # Sidebar panel for inputs
                  sidebarPanel(
                    
                    # Input: Select the random distribution type
                    radioButtons("dist", "Distribution type:",
                                 c("Normal" = "norm",
                                   "Uniform" = "unif",
                                   "Log-normal" = "lnorm",
                                   "Exponential" = "exp")),
                    
                    # br() element to introduce extra vertical spacing
                    br(),
                    
                    # Input: Slider for the number of observations to generate
                    sliderInput("n",
                                "Number of observations:",
                                value = 500,
                                min = 1,
                                max = 1000)
                    
                  ),
                  
                  # Main panel for displaying outputs
                  mainPanel(
                    
                    # Output: Tabset w/ plot, summary, and table
                    tabsetPanel(type = "tabs",
                                tabPanel("Plot", plotOutput("plot")),
                                tabPanel("Summary", verbatimTextOutput("summary")),
                                tabPanel("Table", tableOutput("table"))
                    )
                    
                  )
                )
              )
      ),
      ###### Report - Measuring ######
      tabItem("report_measuring",
              "Second tab",
              navbarPage(
                title = 'DataTable Options',
                tabPanel('Display length',     DT::dataTableOutput('ex1')),
                tabPanel('Length menu',        DT::dataTableOutput('ex2')),
                tabPanel('No pagination',      DT::dataTableOutput('ex3')),
                tabPanel('No filtering',       DT::dataTableOutput('ex4')),
                tabPanel('Function callback',  DT::dataTableOutput('ex5'))
              )
      ),
      ###### Report - Appendices ######
      tabItem("report_appendices",
              "Second tab",
              fluidPage(
                h1("Cars"),
                dataTableOutput("carstable")
              )
      ),
      ###### Data - Highlights ######
      tabItem("data_highlights",
              "Second tab",
              fluidPage(
                h1("Cars"),
                dataTableOutput("carstable")
              )
      ),
      ###### Data - Detail ######
      tabItem("data_detail",
              "Second tab",
              fluidPage(
                h1("Cars"),
                dataTableOutput("carstable")
              )
      ),
      ###### Data - Comparison ######
      tabItem("data_comparison",
              "Second tab",
              fluidPage(
                h1("Cars"),
                dataTableOutput("carstable")
              )
      ),
      ###### Data - Policy ######
      tabItem("data_policy",
              "Second tab",
              fluidPage(
                h1("Cars"),
                dataTableOutput("carstable")
              )
      )
      )
    )
)

#### 2. SERVER ####
# Define server logic for random distribution app
server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  # display 10 rows initially
  output$ex1 <- DT::renderDataTable(
    DT::datatable(iris, options = list(pageLength = 25))
  )
  
  # -1 means no pagination; the 2nd element contains menu labels
  output$ex2 <- DT::renderDataTable(
    DT::datatable(
      iris, options = list(
        lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
        pageLength = 15
      )
    )
  )
  
  # you can also use paging = FALSE to disable pagination
  output$ex3 <- DT::renderDataTable(
    DT::datatable(iris, options = list(paging = FALSE))
  )
  
  # turn off filtering (no searching boxes)
  output$ex4 <- DT::renderDataTable(
    DT::datatable(iris, options = list(searching = FALSE))
  )
  
  # write literal JS code in JS()
  output$ex5 <- DT::renderDataTable(DT::datatable(
    iris,
    options = list(rowCallback = DT::JS(
      'function(row, data) {
        // Bold cells for those >= 5 in the first column
        if (parseFloat(data[1]) >= 5.0)
          $("td:eq(1)", row).css("font-weight", "bold");
      }'
    ))
  ))
  
  # Reactive expression to generate the requested distribution
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  d <- reactive({
    dist <- switch(input$dist,
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   rnorm)
    
    dist(input$n)
  })
  
  # Generate a plot of the data
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$plot <- renderPlot({
    dist <- input$dist
    n <- input$n
    
    hist(d(),
         main = paste("r", dist, "(", n, ")", sep = ""),
         col = "#75AADB", border = "white")
  })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    summary(d())
  })
  
  # Generate an HTML table view of the data
  output$table <- renderTable({
    d()
  })
  
}

#### 3. APP ####
shinyApp(ui, server)
