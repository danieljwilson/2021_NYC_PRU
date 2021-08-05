############### BUTTON #####
header <- dashboardHeader(title = "MRO Dash")
sidebar <- dashboardSidebar(actionButton("downloadBT", "Downloads", icon = icon("download")))
body <- dashboardBody(
  tags$head(tags$style("#test .modal-body {width: auto; height: auto;}"))
)

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {
  
  myModal <- function() {
    div(id = "test",
        modalDialog(downloadButton("download1","Download .csv"),
                    br(),
                    br(),
                    downloadButton("download2","Download .tsv"),
                    easyClose = TRUE, title = "Download Data")
    )
  }
  
  # open modal on button click
  observeEvent(input$downloadBT,
               ignoreNULL = TRUE,   # Show modal on start up
               showModal(myModal())
  )
  
  output$download1 <- downloadHandler(
    filename = function(){paste("MTD of SBU Shipments ",Sys.time(), ".csv", sep = "")},
    content = function(file){write.csv(, file, row.names = FALSE)}
  )
  
  output$download2 <- downloadHandler(
    filename = function(){paste("MTD of SBU Shipments ",Sys.time(), ".csv", sep = "")},
    content = function(file){write.csv(, file, row.names = FALSE)}
  )
  
}

shinyApp(ui, server)

############### COLOR PALETTE #####

library(RColorBrewer)
display.brewer.pal(n = length(unique(df$year)), name = 'Blues')

############### POVERTY DIST #####

poverty = 35044
near_poverty = poverty * 1.5

incomes = df %>%
  filter(year == 2018) %>%
  filter(sex == 'Male') %>%
  filter(age_categ == '18-64') %>%
  filter(boro == 'Queens') %>%
  filter(educ_attain == 'Some College') %>%
  select('nyc_gov_income')

# turn into vector
incomes = incomes[[1]]
# get rid of negative income values
incomes[incomes<0] = 0

# calculate proportions
prop_p = as.character(round((length(incomes[incomes<=poverty])/length(incomes)) * 100, 1))
prop_np = as.character(round((length(incomes[incomes<=near_poverty])/length(incomes) - as.numeric(prop_p)/100) * 100, 1))
prop_xp = as.character(round((length(incomes[incomes>near_poverty])/length(incomes)) * 100, 1))

# a data frame with all the annotation info
annotation <- data.frame(
  x = c(poverty/2, poverty*1.25, (200000-near_poverty)/3 + near_poverty),
  y = c(1.5e-06, 1.5e-06, 1.5e-06),
  label = c(paste0(prop_p,'%'), paste0(prop_np, '%'), paste0(prop_xp, '%'))
)

# create kde
dens <- density(incomes, from = 0)
df_dens <- data.frame(x=dens$x, y=dens$y)
breaks <- c(0, poverty, near_poverty, Inf)
df_dens$quant <- factor(findInterval(df_dens$x,breaks))

ggplot(df_dens, aes(x,y)) + 
  geom_line() + 
  geom_ribbon(aes(ymin=0, ymax=y, fill=quant)) + 
  scale_x_continuous(labels = scales::comma) + 
  scale_fill_brewer(guide="none") +
  scale_x_continuous(label=scales::comma, limits=c(0, 200000)) + 
  xlab('Income') +
  ylab('Proportion') +
  geom_label(data=annotation, aes( x=x, y=y, label=label),
             #color="orange", 
             size=3 , angle=45, fontface="bold" ) +
  theme_classic() +
  theme(axis.text.y = element_blank(), text=element_text(size=14))

####### HOVER TEXT #########

library(ggplot2)

ui <- fluidPage(
  fluidRow(
    column(width = 12,
           plotOutput("plot1", height = 350,hover = hoverOpts(id ="plot_hover"))
    )
  ),
  fluidRow(
    column(width = 5,
           verbatimTextOutput("hover_info")
    )
  )
)

server <- function(input, output) {
  
  
  output$plot1 <- renderPlot({
    
    ggplot(mtcars, aes(x=mpg,y=disp,color=factor(cyl))) + geom_point()
    
  })
  
  output$hover_info <- renderPrint({
    if(!is.null(input$plot_hover)){
      hover=input$plot_hover
      dist=sqrt((hover$x-mtcars$mpg)^2+(hover$y-mtcars$disp)^2)
      cat("Weight (lb/1000)\n")
      if(min(dist) < 3)
        mtcars$wt[which.min(dist)]
    }
    
    
  })
}
shinyApp(ui, server)