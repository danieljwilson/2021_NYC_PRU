library(tidyverse)

df = read_csv("../../../Data/NYCgov_Poverty_Measure_Data__2016_.csv")
spec(df)

#### 1 SUBSELECT COLUMNS ####
# Based on tablemaker: https://www1.nyc.gov/site/opportunity/poverty-in-nyc/data-tool.page

##### 1.1 Specify Columns #####

# Population
AGEP
FamType_PU (1,3,4)

# Poverty By
SEX
Boro
AGEP
Ethnicity
HousingStatus
CIT
EducAttain
TotalWorkHrs_PU
FamType_PU
DIS #disability

# Poverty level
NYCgov_PovGap

##### 1.2 Create Sub-selected DF #####

df_c = df[c('PWGTP', 'AgeCateg', 'SEX', 'Boro', 'Ethnicity',
            'TEN', 'CitizenStatus', 'EducAttain', 'FTPTWork',
            'FamType_PU', 'DIS', 'NYCgov_Income', 'NYCgov_Threshold')]

##### 1.3 Specify data types #####

categorical_cols = c('AgeCateg', 'SEX', 'Boro', 'Ethnicity',
                     'TEN', 'CitizenStatus', 'EducAttain', 'FTPTWork',
                     'FamType_PU', 'DIS')

df_c = df_c %>%
  mutate_at(categorical_cols, factor)

str(df_c)

##### 1.4 Rename #####
# rename the columns to standardize formatting
# convert to snake case
df_c = df_c %>%
  janitor::clean_names(abbreviations = c("NYC"))

# rename the factor levels for legibility
sort(names(Filter(is.factor, df_c)))



df_c = df_c %>%
  mutate(age_categ = recode(age_categ,
         `1` = 'Under 18',
         `2` = '18-64',
         `3` = '65+')) %>%
  mutate(boro = recode(boro,
         `1` = 'Bronx',
         `2` = 'Brooklyn',
         `3` = 'Manhattan',
         `4` = 'Queens',
         `5` = 'Staten Island')) %>%
  mutate(citizen_status = recode(citizen_status,
         `1` = 'Citizen (Birth)',
         `2` = 'Citizen (Naturalized)',
         `3` = 'Not a Citizen')) %>%
  mutate(dis = recode(dis,
         `1` = 'With disability',
         `2` = 'No disability')) %>%
  mutate(educ_attain = recode(educ_attain,
         `1` = '< High School',
         `2` = 'High School Degree',
         `3` = 'Some College',
         `4` = 'Bachelor Degree+')) %>%
  mutate(ethnicity = recode(ethnicity,
         `1` = 'White (non-hispanic)',
         `2` = 'Black (non-hispanic)',
         `3` = 'Asian (non-hispanic)',
         `4` = 'Hispanic (any race)',
         `5` = 'Other Race/Ethnic Group')) %>%
  mutate(fam_type_pu = recode(fam_type_pu,
         `1` = 'Husband/Wife + child ',
         `2` = 'Husband/Wife no child ',
         `3` = 'Single Male + child ',
         `4` = 'Single Female + child ',
         `5` = 'Male unit head, no child ',
         `6` = 'Female unit head, no child ',
         `7` = 'Unrelated Indiv w/others 8 Unrelated Indiv Alone')) %>%
  mutate(ftpt_work = recode(ftpt_work,
         `1` = 'Full Time Year Round',
         `2` = 'Less than Full Time Year Round',
         `3` = 'No Work')) %>%
  mutate(sex = recode(sex,
         `1` = 'Male',
         `2` = 'Female')) %>%
  mutate(ten = recode(ten,
         `1` = 'Owned - mortgage',
         `2` = 'Owned - free and clear',
         `3` = 'Rented',
         `4` = 'Occupied without payment of rent'))

##### 1.5 Add computed columns #####

# add column threshold pct
df_c = df_c %>%
  mutate(threshold_pct = (nyc_gov_income/nyc_gov_threshold) * 100,
         year = "2016")
# create categorical version
df_c$nyc_gov_poverty_status <- cut(
  df_c$threshold_pct,
  breaks = c(0, 100, 150, Inf),
  labels = c("In Poverty", "Near Poverty", "Not in/near Poverty"),
  right  = TRUE
)

#### EXPORT DF ####
write_csv(df_c, "../../../Data/NYCgov_Poverty_Measure_Data_2016_cleaned.csv")


#### SHINY APP ####
sort(colnames(df_c))

##### UI #####
ui = fluidPage(
  # Application title
  titlePanel("NYC Gov Poverty Measure 2005-2019"),
  # Sidebar with inputs 
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "year",
        label = "Year:",
        choices = c("2016",
                    "2017",
                    "2018",
                    "All")
        ),
      
      selectizeInput(
        inputId = 'population',
        label = 'Sub-Population',
        choices = c(
          'Age' = 'age_categ',
          'Borough' = 'boro',
          'Disability' = 'dis',
          'Educational Attainment' = 'educ_attain',
          'Ethnicity' = 'ethnicity',
          'Housing Status' = 'ten',
          'Sex' = 'sex'
          ),
        multiple = TRUE
        ),
      ),
    
    # Show plot and table
    mainPanel(
      plotOutput("plot"),
      DT::dataTableOutput("table")
    )
  )
)
  
pop_characteristics = c('age_categ', 'boro', 'sex', 'ten')

test = filter(df_c, year == '2016') %>%
  # this is making it take the list as var names (below)
  group_by(!!!syms(append(pop_characteristics, 'nyc_gov_poverty_status'))) %>% 
  summarise(percentage=sum(pwgtp)/8e6*100) %>%
  drop_na()

ggplot(data=test, aes(x=pop_characteristics[1], y=percentage,
                              fill=nyc_gov_poverty_status)) + 
  geom_bar(stat = 'identity') + 
  facet_grid(vars(pop_characteristics[2]), vars(pop_characteristics[3])) +
  labs(
    title = "Top 10 Leading Causes of Death"
  )

ggplot(data=test, aes(x=age_categ, y=percentage,
                      fill=nyc_gov_poverty_status)) + 
  geom_bar(stat = 'identity') + 
  facet_grid(dis ~ boro) +
  labs(
    title = "Poverty in New York City"
  ) + 
  theme(axis.text.x = element_text(angle = 90))

##### Server #####
server = function(input, output) {
  selections = reactive({
    req(input$year)
    req(input$population)
    filter(df_c, year == input$year) %>%
      # this is making it take the list as var names (below)
      group_by(!!!syms(append(pop_characteristics, 'nyc_gov_poverty_status'))) %>% 
      summarise(percentage=sum(pwgtp)/8e6*100)
  })
  output$plot = renderPlot({
    
    # ggplot(data=selections(), aes(x=!!!syms(input$population[1]), y=percentage,
    #                               fill=nyc_gov_poverty_status)) + 
    ggplot(data=selections(), aes(x={{input$population[1]}}, y=percentage,
                                  fill=nyc_gov_poverty_status)) + 
      geom_bar(stat = 'identity') + 
      facet_grid({{input$population[2]}} ~ {{input$population[3]}}) +
      labs(
        title = "Top 10 Leading Causes of Death"
      )
  })
  
  output$table = 
    DT::renderDataTable({
      DT::datatable(selections(),
                    rownames = FALSE,
      )
      
    })
}

shinyApp(ui = ui, server = server)


#### IDEAS ####
# Sankey by poverty, near poverty, median, top 10%

df1<-data.frame(Loc=c(rep("L1",5),rep("L2",3),rep("L3",4)),
                Type=c(rep("T1",3),rep("T2",2),"T1","T2","T2","T1","T1","T2","T2"),
                y2009=rep("A",12),y2010=c("A","B","A","A","A","A","B","B","A","A","B","B"),
                y2011=c("B","B","B","A","B",rep("B",4),"A","B","B"))
df1
library(reshape2)
df2 = melt(df1, id.vars=c("Loc", "Type"))
ggplot(data=df2, aes(x=value, fill=Type)) + 
  geom_bar() + facet_grid(Loc ~ variable)

groups = c('age_categ', 'boro', 'nyc_gov_poverty_status', 'sex')
test = df_c %>% 
  group_by(!!!syms(groups)) %>%
  summarise(n=sum(pwgtp)/8e6 * 100)

ggplot(data=df_c, aes(x=sex, fill=nyc_gov_poverty_status)) + 
  geom_bar() + facet_grid(age_categ ~ boro)


#### MULTI-DIMENSION PLOT EXAMPLE ###

ggplot(data=test, aes(x=sex, y=percentage, fill=nyc_gov_poverty_status)) + 
  geom_bar(stat = 'identity') + facet_grid(age_categ ~ boro)

########












output$table = 
  DT::renderDataTable({
    DT::datatable(selections()[,c("leading_cause", "deaths", "death_rate", "age_adjusted_death_rate")],
                  colnames = c("Leading Cause of Death", "Number of Deaths", "Death Rate", "Age-Adjusted Death Rate"),
                  options = list(order = list(2, 'des')),
                  rownames = FALSE,
    )
    
  })

## Only run examples in interactive R sessions
if (interactive()) {
  
  library("shiny")
  library("shinyWidgets")
  
  
  # simple use
  
  ui <- fluidPage(
    multiInput(
      inputId = "id", label = "Fruits :",
      choices = c("Banana", "Blueberry", "Cherry",
                  "Coconut", "Grapefruit", "Kiwi",
                  "Lemon", "Lime", "Mango", "Orange",
                  "Papaya"),
      selected = "Banana", width = "350px"
    ),
    selectizeInput(
      'e2', '2. Multi-select', choices = c('Test1', 'Test2'), multiple = TRUE
    ),
    verbatimTextOutput(outputId = "res")
  )
  
  server <- function(input, output, session) {
    output$res <- renderPrint({
      input$id
    })
  }
  
  shinyApp(ui = ui, server = server)
  
  
  # with options
  
  ui <- fluidPage(
    multiInput(
      inputId = "id", label = "Fruits :",
      choices = c("Banana", "Blueberry", "Cherry",
                  "Coconut", "Grapefruit", "Kiwi",
                  "Lemon", "Lime", "Mango", "Orange",
                  "Papaya"),
      selected = "Banana", width = "400px",
      options = list(
        enable_search = FALSE,
        non_selected_header = "Choose between:",
        selected_header = "You have selected:"
      )
    ),
    verbatimTextOutput(outputId = "res")
  )
  
  server <- function(input, output, session) {
    output$res <- renderPrint({
      input$id
    })
  }
  
  shinyApp(ui = ui, server = server)
  
}