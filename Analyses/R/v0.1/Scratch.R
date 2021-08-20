# nycounties <- geojsonio::geojson_read("json/nycounties.geojson", what = "sp")
library(tidyverse)
library(geojsonsf)
library(sf)
library(viridis)
library(RColorBrewer)
library(leaflet)

### NYC POVERTY DATA
label_info = 'Ethnicity'
years = c(2018)

pov_data1 = dataset %>%
  filter(year>=years & year<=years) %>%
  group_by(PUMA) %>%
  summarise(pov_rate = round(sum(PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)*100, 1),
            pop = sum(PWGTP)) 

pov_data2 = dataset %>%
  filter(year>=years & year<=years) %>%
  group_by(PUMA, !!sym(label_info)) %>%
  summarise(pov_rate = round(sum(PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)*100, 1),
            pop = sum(PWGTP)) %>%
  pivot_wider(names_from = Ethnicity, values_from = c('pov_rate', 'pop'))
#join dfs
pov_data = inner_join(pov_data1, pov_data2, by = 'PUMA')

pov_data %>%
  select(starts_with('pop_'))/pov_data$pop * 100
### PUMA GEOMETRY DATA
#downloaded from https://maps.princeton.edu/catalog/nyu-2451-34512
json_nyc = geojson_sf('/Users/djw/Downloads/Public Use Microdata Areas (PUMA).geojson')

### NEIGHBORHOOD INFO
#downloaded from  https://data.cityofnewyork.us/Housing-Development/Public-Use-Microdata-Areas-PUMA-/cwiz-gcty
neighborhoods = st_read('/Users/djw/Downloads/nyu-2451-34512-shapefile/nyu_2451_34512.shp') %>%
  mutate(boro = str_match(namelsad10, "-\\s*(.*?)\\s* ")[,2], #pull out names from column
         com_dist = str_extract(namelsad10, "[[:digit:]]+"),
         neighborhood = str_match(namelsad10, "--\\s*(.*?)\\s* PUMA")[,2],
         puma = as.character(as.numeric(pumace10)) #remove leading 0
         ) %>%
  data.table::setDT() #convert to datatable
  
#remove column
neighborhoods = neighborhoods[, !'geometry']

#join dfs
map_data = inner_join(json_nyc, pov_data, by = c("puma" = "PUMA"))
map_data = inner_join(map_data, neighborhoods, by = 'puma')

### MAKE INTERACTIVE MAP OF POVERTY RATE BY PUMA
labels = sprintf(
  "<h3>%s</h3><h2>%s in Poverty</h2><strong>Population by Ethnicity</strong><br/>White: %s<br/>Black: %s<br/>Asian: %s<br/>Hispanic: %s",
  map_data$neighborhood,
  paste0(as.character(map_data$pov_rate), '%'),
  paste0(round(map_data$`pop_White (non-hispanic)`/map_data$pop*100, 1), '%'),
  paste0(round(map_data$`pop_Black (non-hispanic)`/map_data$pop*100, 1), '%'),
  paste0(round(map_data$`pop_Asian (non-hispanic)`/map_data$pop*100, 1), '%'),
  paste0(round(map_data$`pop_Hispanic (any race)`/map_data$pop*100, 1), '%')
  ) %>%
  lapply(htmltools::HTML)

# SET COLORS
bins <- c(0, 10, 15, 20, 25, 30, 100)
pal <- colorBin("Blues", domain = map_data$pov_rate, bins = bins)

### INTERACTIVE MAP
leaflet(map_data) %>%
  #addProviderTiles("CartoDB.Positron") %>%
  addPolygons(label = labels,
              stroke = TRUE,
              weight = .4,
              color = "white",
              smoothFactor = 0.5,
              opacity = .5,
              fillOpacity = 0.7,
              fillColor = ~pal(pov_rate),
              highlightOptions = highlightOptions(weight = .8,
                                                  fillOpacity = 1,
                                                  color = 'white',
                                                  opacity = 1,
                                                  bringToFront = TRUE)
              ) %>%
  addLegend(position = "bottomright",
            pal = pal,
            values = ~ pov_rate,
            title = "Below NYCgov</br>Poverty Threshold",
            labFormat = labelFormat(suffix = "%"),
            opacity = 0.7)


#######

library(vroom) #fast importing/loading of csv data
library(sf) #spatial data
library(tigris) #geojoin
library(leaflet) #interactive maps
library(htmlwidgets) #interactive map labels

shp_nyc = st_read('data/NYC_Public Use Microdata Areas (PUMA)/geo_export_96260c7b-c3ad-4bdf-ad89-a8c8e362361c.shp')
shp_nyc$puma = as.numeric(shp_nyc$puma)
shp_nyc2 = st_read('/Users/djw/Downloads/nyu-2451-34512-shapefile/nyu_2451_34512.shp')
shp_nyc2$puma = as.numeric(shp_nyc2$pumace10)
shp_nyc3 = st_read('/Users/djw/Downloads/nyu_2451_34512/nyu_2451_34512.shp')



#need to extract the multipolygon
shp_nyc$test = NULL
for (i in length(shp_nyc$geometry)){
  shp_nyc$test[i] =  shp_nyc$geometry[[i]]
}

puma_data = dataset %>%
  filter(year>=2018) %>%
  # mutate(PUMA = as.numeric(as.character(PUMA))) %>%
  group_by(year, PUMA) %>%
  summarise(pov_rate = sum(PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP),
            pop = sum(PWGTP))

# load NYC PUMA shape file 
df_map = geo_join(shp_nyc, puma_data,
                'puma', 'PUMA',
                how = 'inner')
#convert to date
df_map$year = as.Date(as.character(df_map$year), format = "%Y")

### DATA INSPECT
df_map %>%
  ggplot(aes(x=pov_rate)) +
  geom_histogram(bins = 10)

### MAKE INTERACTIVE MAP OF POVERTY RATE BY PUMA
labels = sprintf(
  "<strong>%s</strong><br/>%g below NYCgov poverty threshold",
  df_map$neighborhoods, df_map$pov_rate) %>%
  lapply(htmltools::HTML)

#create color palette 
#to test what the palette looks like put 'display.' in front of 'brewer.pal'
pal = brewer.pal(n = 9, name = 'Blues')

map_interactive = df_map %>%
  st_transform(crs = "+init=epsg:4326") %>%
  #st_transform(crs = SRS_string='EPSG:4326') %>%
  #spTransform(CRS("+proj=longlat +datum=WGS84")) %>%
  leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(label = labels,
              stroke = FALSE,
              smoothFactor = 0.5,
              opacity = 1,
              fillOpacity = 0.7,
              fillColor = ~pal(pov_rate),
              highlightOptions = highlightOptions(weight = 5,
                                                  fillOpacity = 1,
                                                  color = 'black',
                                                  opacity = 1,
                                                  bringToFront = TRUE)
              ) %>%
  addLegend(position = "bottomright",
            pal = pal,
            values = ~ pov_rate,
            title = "% below NYCgov Poverty Threshold",
            opacity = 0.7)






 
######### 

colorRampPalette(brewer.pal(n = 9, name = 'Blues'))(length(unique(na.omit(dataset$year))))
colorRampPalette(c('#F7FBFF', '#4594C7'))(length(unique(na.omit(dataset$year))))

library(viridis)
viridis(12, alpha = 0.5)

nb.cols <- 18
mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(nb.cols)

####################
ui <- shinyUI({
  sidebarPanel(
    
    htmlOutput("brand_selector"),
    htmlOutput("candy_selector"))
  
})
##
server <- shinyServer(function(input, output) {
  candyData <- read.table(
    text = "Brand       Candy
    Nestle      100Grand
    Netle       Butterfinger
    Nestle      Crunch
    Hershey's   KitKat
    Hershey's   Reeses
    Hershey's   Mounds
    Mars        Snickers
    Mars        Twix
    Mars        M&Ms",
    header = TRUE,
    stringsAsFactors = FALSE)
  
  output$brand_selector <- renderUI({
    
    selectInput(
      inputId = "brand", 
      label = "Brand:",
      choices = as.character(unique(candyData$Brand)),
      selected = "Nestle")
    
  })
  
  output$candy_selector <- renderUI({
    
    available <- candyData[candyData$Brand == input$brand, "Candy"]
    
    selectInput(
      inputId = "candy", 
      label = "Candy:",
      choices = unique(available),
      selected = unique(available)[1])
    
  })
  
})
##
shinyApp(ui = ui, server = server)

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
display.brewer.pal(n = 9, name = 'Blues')

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