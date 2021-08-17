library(tidyverse)
library(shinydashboard)
library(plotly)
library(shiny)
library(DT)
library(data.table)
library(markdown)
library(RColorBrewer)
library(openxlsx)

# DASHBOARD ----
ui <- dashboardPage(
  dashboardHeader(title = "Poverty Research Unit"),
  
  # SIDEBAR----
  dashboardSidebar(
    sidebarMenu(
      # Poverty ----
      menuItem("On Poverty", tabName = "poverty", icon = icon("question-circle"),
               startExpanded = TRUE,
               menuItem('About', tabName = 'poverty_about'),
               menuItem('Profiles', tabName = 'poverty_profiles',
                        menuSubItem('Jane Doe', tabName = 'poverty_profiles_jane_doe'),
                        menuSubItem('John Doe', tabName = 'poverty_profiles_john_doe'))),
      # Report -----
      menuItem("Report", tabName = "report", icon = icon("file-alt"),
               menuSubItem('About', tabName = 'report_about'),
               menuSubItem('1 | Key Findings', tabName = 'report_key_findings'),
               menuSubItem('2 | Policy and Path', tabName = 'report_policy_path'),
               menuSubItem('3 | Measuring Poverty', tabName = 'report_measuring'),
               menuSubItem('Appendices', tabName = 'report_appendices')
      ),
      # Data -----
      menuItem("Data", tabName = "data", icon = icon("chart-bar"),
               menuSubItem('Spotlight', tabName = 'data_spotlight'),
               menuSubItem('Detail', tabName = 'data_detail'),
               menuSubItem('Comparison', tabName = 'data_comparison'),
               menuSubItem('Policy', tabName = 'data_policy')
      )
    )
  ),
  
  # BODY ----
  dashboardBody(
    tags$head(tags$style("#test .modal-body {width: auto; height: auto;}")),
    tabItems(
      # Poverty ----
      ## Poverty About -----
      tabItem(tabName = "poverty_about",
              h1('On Poverty'),
              fluidPage(
                box(
                  width = 12,
                  status = 'primary',
                  column(
                    width = 7,
                    img(src = "1024px-Bowery_men_waiting_for_bread_in_bread_line,_New_York_City,_Bain_Collection_(cropped).jpg",
                        width="100%"),
                    h6('Bowery men waiting for bread in bread line, 1910. (', a('Source', href = 'https://www.worldbank.org/en/home', target = '_blank'), ')'),
                  ),
                  column(
                    width = 5,
                    h4(tags$em('“By necessaries I understand not only the commodities which are indispensably necessary for the support of life, but whatever the customs of the country renders it indecent for credible people, even of the lowest order to be without.”')),
                    p('-Adam Smith, 1776')
                  ),
                ),
                hr(),
                box(
                  title = "What is Poverty?",
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('Echoes of Adam Smith\'s definition of poverty from almost 250 years ago can be found in a more recent defintion provided by ', a('The World Bank', href = 'https://www.worldbank.org/en/home', target = '_blank'), ':'),
                  p(em('Poverty is hunger. Poverty is lack of shelter. Poverty is being sick and not being able to see a doctor. Poverty is not having access to school and not knowing how to read. Poverty is not having a job, is fear for the future, living one day at a time. Poverty has many faces, changing from place to place and across time, and has been described in many ways.  Most often, poverty is a situation people want to escape. So poverty is a call to action -- for the poor and the wealthy alike -- a call to change the world so that many more may have enough to eat, adequate shelter, access to education and health, protection from violence, and a voice in what happens in their communities.', style = "font-family: 'times'; font-size: 16px")),
                  hr(),
                  p('If we agree that poverty ', tags$strong('is '), tags$em('a call to action '), ', then a natural question is what should that action be?'),
                  p('We believe that a first step is to establish a meaningful financial threshold defining poverty, and then measuring which people fall above and below  that threshold.')
                ),
                box(
                  title = "Why Measure Poverty?",
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('If we have the goal of reducing poverty it is important that we have some way to measure it.'),
                  tags$ul(
                    tags$li('A poverty measure serves as a ', tags$strong('social indicator'), ' that gauges the degree of material deprivation in our society.'), 
                    tags$li('An effective measure can track how poverty is affected by economic and demographic shifts over time, which in turn can help guide a policy response.'), 
                    tags$li('A measure is critical for evaluating the effect of policy and resources spent fighting poverty')
                  )
                ),
                box(
                  title = "How to Measure Poverty?",
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('Setting this threshold for poverty is not a straightfoward task.'),
                  p('As an illustration of this point we can compare the ', tags$strong('official federal poverty measure'), ' versus the ', tags$strong('NYCgov poverty measure'), '.'),
                  fluidRow(
                    column(
                      width = 5,
                      h3('Official')
                    ),
                    column(
                      width = 7,
                      h3('NYCgov')
                    )
                  ),
                  fluidRow(
                    box(
                      width = 5,
                      title = 'Threshold',
                      status = 'info',
                      tags$ul(
                        tags$li('Established in early 1960s at three times the cost of “Economy Food Plan”'), 
                        tags$li('Updated by change in Consumer Price Index'), 
                        tags$li('No geographic adjustment')
                      )
                    ),
                    box(
                      width = 7,
                      title = 'Threshold',
                      status = 'warning',
                      tags$ul(
                        tags$li('Equal to the 33rd percentile of family expenditures on food, clothing, shelter, and utilities, plus 20 percent more for miscellaneous needs'), 
                        tags$li('Updated by the change in expenditures for items in the threshold'), 
                        tags$li('Geographic adjustment based on differences in housing costs')
                      )
                    )
                  ),
                  fluidRow(
                    box(
                      width = 5,
                      title = 'Resources',
                      status = 'info',
                      tags$ul(
                        tags$li('Total family pre-tax cash income.  Includes earnings and transfer payments (if they take the form of cash)')
                      )
                    ),
                    box(
                      width = 7,
                      title = 'Resources',
                      status = 'warning',
                      tags$ul(
                        tags$li('Total family after-tax income'), 
                        tags$li('Include value of near-cash, in-kind benefits such as Food Stamps'), 
                        tags$li('Housing status adjustment'),
                        tags$li('Subtract work-related expenses such as childcare and transportation costs'), 
                        tags$li('Subtract medical out-of-pocket expenditures')
                      )
                    )
                  )
                )
              ),
      ),
      
      ## Poverty Profiles -----

      tabItem(tabName = "poverty_profiles_jane_doe",
              h1("Profiles"),
              h3('Note that these to be replaced by \"Archetypes\" if the section is to be kept...'),
              p("In a city where almost 1 in 5 people are living below the poverty threshold it is inevitable that you cross paths with people living in poverty on a daily basis. But do you know how these pepole are? Or what that experience is like?"),
              p("Five New Yorkers living under the city's poverty threshold, one from each borough, have generously allowed us to share their stories with you."),
              hr(style = "border-top: '1px solid black'"),
              h2("Jane Doe"),
              h4("34, Park Slope"),
              img(src = "jane.jpg", width="65%"),
              hr(),
              fluidRow(
                box(width = 5,
                    h3('The Numbers'),
                    dataTableOutput('table_jane_doe')
                    ),
                box(width = 7,
                    p('Description of life for Jane Doe...Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dapibus varius pellentesque. Sed gravida tortor et augue tincidunt pellentesque. Aliquam commodo dignissim purus, at scelerisque diam convallis a. Ut mi ipsum, sollicitudin et feugiat a, suscipit nec nulla. Suspendisse gravida laoreet libero pharetra maximus. Aenean facilisis, diam ut convallis ornare, sapien metus ornare lectus, et malesuada elit metus a nibh. Vivamus cursus elit sed velit aliquam porttitor et quis magna. Quisque pellentesque lorem a augue commodo gravida. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus sapien sapien, semper sit amet ex a, congue tristique nulla. Vestibulum imperdiet metus ut odio eleifend eleifend. Nullam vel pharetra mauris, non malesuada ex. Vivamus orci nisl, hendrerit vitae velit nec, feugiat finibus neque. Phasellus condimentum, ipsum a malesuada pellentesque, urna ante porttitor nunc, sed rutrum nulla nisi sed nulla. Suspendisse potenti. Vivamus eget metus sollicitudin, pharetra nulla eget, lobortis nulla.'),
                    p('Cras maximus dolor vitae lacus commodo mattis. Praesent ac augue at diam sollicitudin pharetra vitae et dolor. Praesent blandit eros gravida ante commodo, quis pharetra lacus tempus. Nulla euismod viverra justo vitae ultrices. Donec vitae lorem at nisi sollicitudin congue. Nullam enim neque, efficitur mattis venenatis eu, efficitur ut nulla. In eleifend justo ut sem sagittis egestas. Donec malesuada, ante at pretium aliquam, quam mi pretium neque, sed fringilla dui sapien pulvinar diam. Praesent sapien urna, auctor nec enim a, viverra scelerisque leo. Sed nulla erat, sagittis sit amet mi non, faucibus imperdiet orci. Phasellus id mauris tellus. Praesent a odio augue. Donec ornare sem nulla, vel mattis risus venenatis at. Ut eleifend dictum augue eget malesuada.'),
                    p('Sed a lacinia lorem. Aenean luctus dui ante, vel molestie nunc bibendum non. Aenean eros quam, consequat gravida condimentum non, blandit nec leo. Donec massa ex, pellentesque sit amet suscipit vel, aliquam non nibh. Phasellus ut orci vestibulum, elementum tortor et, congue lorem. Nam convallis nisi a nisi finibus aliquam. Nullam faucibus massa a est porta, quis mattis erat posuere. Nulla urna lectus, vestibulum id posuere eget, faucibus vel orci. Etiam id molestie lorem, ac imperdiet dolor. Vestibulum sit amet diam vehicula, tincidunt orci a, bibendum ex. Pellentesque fermentum sit amet orci at blandit. Integer facilisis erat eu turpis mattis consectetur. Integer non imperdiet neque, sit amet scelerisque risus. Curabitur et nibh efficitur, fermentum arcu ut, lacinia augue. Proin felis arcu, vestibulum a turpis non, ornare mattis odio. Maecenas nibh velit, commodo eu quam eget, condimentum imperdiet nulla.'),
                    p('Morbi et libero rutrum, tincidunt elit quis, tempus odio. In maximus ultricies mi, eu elementum augue ornare nec. Integer congue placerat sapien, a efficitur risus rutrum sit amet. In venenatis porttitor urna, sed malesuada purus interdum id. In lacinia venenatis est. Maecenas vulputate malesuada urna sit amet euismod. Mauris a porttitor ipsum, ornare mattis orci. In egestas magna a justo commodo, id auctor odio rutrum. Nullam ultricies odio ac mauris aliquet, quis viverra mi ultrices. Nam eget mollis urna, non ullamcorper nisl. Quisque hendrerit, tellus id scelerisque rutrum, lectus quam viverra tortor, vitae maximus augue augue non ante. Aenean sed pharetra magna. Morbi rhoncus, felis a auctor consectetur, turpis risus ornare mi, vel congue ligula massa et risus. Aliquam euismod massa malesuada nunc interdum, sed tempus enim tincidunt. Sed laoreet sem augue, vitae dignissim sapien malesuada blandit. Aenean sed arcu nec neque pharetra pulvinar.'))
              )),
      tabItem(tabName = "poverty_profiles_john_doe",
              h1("Profiles"),
              h3('Note that these to be replaced by \"Archetypes\" if the section is to be kept...'),
              p("In a city where almost 1 in 5 people are living below the poverty threshold it is inevitable that you cross paths with people living in poverty on a daily basis. But do you know how these pepole are? Or what that experience is like?"),
              p("Five New Yorkers living under the city's poverty threshold, one from each borough, have generously allowed us to share their stories with you."),
              hr(),
              h2("John Doe"),
              h4("48, Sunset Park"),
              img(src = "john.jpg", width="65%"),
              hr(),
              fluidRow(
                box(width = 5,
                    h3('The Numbers'),
                    dataTableOutput('table_john_doe')
                ),
                box(width = 7,
                    p('Description of life for John Doe...Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dapibus varius pellentesque. Sed gravida tortor et augue tincidunt pellentesque. Aliquam commodo dignissim purus, at scelerisque diam convallis a. Ut mi ipsum, sollicitudin et feugiat a, suscipit nec nulla. Suspendisse gravida laoreet libero pharetra maximus. Aenean facilisis, diam ut convallis ornare, sapien metus ornare lectus, et malesuada elit metus a nibh. Vivamus cursus elit sed velit aliquam porttitor et quis magna. Quisque pellentesque lorem a augue commodo gravida. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus sapien sapien, semper sit amet ex a, congue tristique nulla. Vestibulum imperdiet metus ut odio eleifend eleifend. Nullam vel pharetra mauris, non malesuada ex. Vivamus orci nisl, hendrerit vitae velit nec, feugiat finibus neque. Phasellus condimentum, ipsum a malesuada pellentesque, urna ante porttitor nunc, sed rutrum nulla nisi sed nulla. Suspendisse potenti. Vivamus eget metus sollicitudin, pharetra nulla eget, lobortis nulla.'),
                    p('Cras maximus dolor vitae lacus commodo mattis. Praesent ac augue at diam sollicitudin pharetra vitae et dolor. Praesent blandit eros gravida ante commodo, quis pharetra lacus tempus. Nulla euismod viverra justo vitae ultrices. Donec vitae lorem at nisi sollicitudin congue. Nullam enim neque, efficitur mattis venenatis eu, efficitur ut nulla. In eleifend justo ut sem sagittis egestas. Donec malesuada, ante at pretium aliquam, quam mi pretium neque, sed fringilla dui sapien pulvinar diam. Praesent sapien urna, auctor nec enim a, viverra scelerisque leo. Sed nulla erat, sagittis sit amet mi non, faucibus imperdiet orci. Phasellus id mauris tellus. Praesent a odio augue. Donec ornare sem nulla, vel mattis risus venenatis at. Ut eleifend dictum augue eget malesuada.'),
                    p('Sed a lacinia lorem. Aenean luctus dui ante, vel molestie nunc bibendum non. Aenean eros quam, consequat gravida condimentum non, blandit nec leo. Donec massa ex, pellentesque sit amet suscipit vel, aliquam non nibh. Phasellus ut orci vestibulum, elementum tortor et, congue lorem. Nam convallis nisi a nisi finibus aliquam. Nullam faucibus massa a est porta, quis mattis erat posuere. Nulla urna lectus, vestibulum id posuere eget, faucibus vel orci. Etiam id molestie lorem, ac imperdiet dolor. Vestibulum sit amet diam vehicula, tincidunt orci a, bibendum ex. Pellentesque fermentum sit amet orci at blandit. Integer facilisis erat eu turpis mattis consectetur. Integer non imperdiet neque, sit amet scelerisque risus. Curabitur et nibh efficitur, fermentum arcu ut, lacinia augue. Proin felis arcu, vestibulum a turpis non, ornare mattis odio. Maecenas nibh velit, commodo eu quam eget, condimentum imperdiet nulla.'),
                    p('Morbi et libero rutrum, tincidunt elit quis, tempus odio. In maximus ultricies mi, eu elementum augue ornare nec. Integer congue placerat sapien, a efficitur risus rutrum sit amet. In venenatis porttitor urna, sed malesuada purus interdum id. In lacinia venenatis est. Maecenas vulputate malesuada urna sit amet euismod. Mauris a porttitor ipsum, ornare mattis orci. In egestas magna a justo commodo, id auctor odio rutrum. Nullam ultricies odio ac mauris aliquet, quis viverra mi ultrices. Nam eget mollis urna, non ullamcorper nisl. Quisque hendrerit, tellus id scelerisque rutrum, lectus quam viverra tortor, vitae maximus augue augue non ante. Aenean sed pharetra magna. Morbi rhoncus, felis a auctor consectetur, turpis risus ornare mi, vel congue ligula massa et risus. Aliquam euismod massa malesuada nunc interdum, sed tempus enim tincidunt. Sed laoreet sem augue, vitae dignissim sapien malesuada blandit. Aenean sed arcu nec neque pharetra pulvinar.'))
              )),
      # Report ----
      ## Report - About -----
      tabItem("report_about",
              fluidPage(
                h1('New York City Government Poverty Measure 2019'),
                h3('An Annual Report from the Office of the Mayor'),
                p("The New York City poverty report is an annual research document meant to shed light on the current state of poverty in the city. It is mandated by the New York City Charter, which requires the Mayor’s Office for Economic Opportunity (NYC Opportunity) to release an update to the NYC Government poverty measure (NYCgov measure) every year, along with a survey of efforts to reduce poverty in the city. The report helps the City to monitor poverty and near poverty across the five boroughs, and to understand its impact on specific parts of the population. This edition of the report contains data through 2019, just before the onset of the COVID-19 pandemic."),
                p("The report shows poverty at a historic low: the NYCgov poverty rate of 17.9 percent for 2019 and near poverty rate of 40.8 percent are the lowest on record going back to 2005, the first year measured by our office. These rates reflect meaningful progress over recent years, and serve as an important pre-Covid baseline as New York City turns toward recovery."),
                hr(),
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
      ## Report - Key Findings ----
      tabItem("report_key_findings",
              fluidPage(
                h1("1 | Key Findings"),
                p('The New York City Government (NYCgov) poverty measure is a measure of poverty adapted to the realities of the city’s economy. The poverty threshold accounts for housing costs that are higher than the national average. The measure of family resources includes public benefits and tax credits, but also acknowledges spending on medical costs and work-related expenses such as childcare and commuting.'),
                p('The NYCgov poverty rate, threshold, and income measure are higher than those same figures in the U.S. official measure.'),
                hr(),
                fluidRow(
                  box(
                    title = '1.1 Poverty in New York City, 2019',
                    collapsible = TRUE,
                    collapsed = FALSE,
                    width = 12,
                    status = 'primary',
                    solidHeader = TRUE,
                    tags$strong('The NYCgov poverty rate for 2019 is 17.9 percent.'),
                    p('This is a statistically significant 1.4 percentage point change from 2018 when the rate was 19.3 percent.1 The 2019 rate is the lowest NYCgov poverty rate since the series began with 2005 data. The decline in the poverty rate primarily is due to increases in income and employment during the last year of the economic expansion that followed the Great Recession. The decline in poverty over the five-year period 2015 to 2019 also was statistically significant, resulting in a poverty rate that fell from 19.6 to 17.9 percent.'),
                    p('The NYCgov poverty rate is historically higher than the U.S. official poverty rate. The official rate is derived only from pre-tax cash income and a poverty threshold that is three times the nationwide cost of a minimal food budget. The NYCgov rate responds to changes in multiple sources of income (including income supplements), medical and work-related expenses, and changes in average living standards over time, including local housing costs. Table 1.1 and Figure 1.1 illustrate these differences.'),
                    tags$strong('The NYCgov near poverty rate for 2019 is 40.8 percent.'),
                    p('This is a statistically significant decline from the 41.9 percent near poverty rate in 2018. The term “near poverty,” as utilized in this report, includes the share of the population living under 150 percent of the NYCgov poverty threshold. It includes all people in poverty and those above the threshold but at risk of falling into poverty. The decline in near poverty, from 45.4 percent in 2015 to 40.8 percent in 2019, also is statistically significant (see Figure 1.2).'),
                    tags$strong('The NYCgov poverty threshold for 2019 is $36,262.'),
                    p('This represents an increase of 3.5 percent from 2018 when the poverty threshold was $35,044. The near poverty threshold (150 percent of the NYCgov threshold) increased to $52,566 (not shown). Thresholds stated are for two-adult, two-child families.'),
                    p('Threshold increases are driven by growth in national expenditures on food, clothing, shelter, and utilities, and by additional housing costs in New York City. In 2019, threshold components grew at slightly lower rates than in 2018. The NYC adjustment to the shelter and utilities component was an additional 56 percent compared to 54 percent in 2018.'),
                    hr(),
                    fluidRow(
                      box(
                        title = 'NYCgov and U.S. Official Poverty Rates 2005–2019',
                        width = 9,
                        status = 'primary',
                        tabsetPanel(type = "tabs",
                                    tabPanel("Plot", plotOutput("plot_1_1_rate")),
                                    tabPanel("Data", dataTableOutput('table_1_1_rate')),
                                    tabPanel("Source/Notes",
                                             tags$strong('Source:'),
                                             'American Community Survey Public Use Micro Sample as augmented by NYC Opportunity. U.S. official threshold from U.S. Census Bureau.',
                                             br(),
                                             br(),
                                             tags$strong('Notes:'),
                                             'Numbers in bold indicate a statistically significant change from prior year. U.S. official poverty rates are based on the NYCgov poverty universe and unit of analysis. See Appendix A for details.')
                        )
                    ),
                      box(
                        title = "Select Years",
                        width = 3,
                        status = 'primary',
                        sliderInput("slider_1_1", label = NULL, min = 2005, 
                                    max = 2019, value = c(2005, 2019), sep='', ticks = FALSE)
                      )
                    ),
                    fluidRow(
                      box(
                        title = 'Official and NYCgov Poverty Thresholds, 2005–2019',
                        width = 9,
                        tabsetPanel(type = "tabs",
                                    tabPanel("Plot", plotlyOutput("plot_1_2_threshold")),
                                    tabPanel("Data", dataTableOutput('table_1_2_threshold')),
                                    tabPanel("Source/Notes",
                                             tags$strong('Source:'),
                                             'American Community Survey Public Use Micro Sample as augmented by NYC Opportunity. U.S. official threshold from U.S. Census Bureau.',
                                             br(),
                                             br(),
                                             tags$strong('Notes:'),
                                             'Numbers in bold indicate a statistically significant change from prior year. U.S. official poverty rates are based on the NYCgov poverty universe and unit of analysis. See Appendix A for details.')
                        )
                      ),
                      box(
                        title = "Select Years",
                        width = 3,
                        sliderInput("slider_1_2", label = NULL, min = 2005, 
                                    max = 2019, value = c(2005, 2019), sep='', ticks = FALSE),
                        hr(),
                        radioButtons("radio_1_2", label = NULL,
                                     choices = list("Family of four" = "family",
                                                    "Single person" = "single"), selected = "family")
                      )
                    )
                  )
                ),
                fluidRow(
                  box(
                    title = '1.2 Differences in New York City Rates by Demographics and Geography',
                    collapsible = TRUE,
                    collapsed = TRUE,
                    width = 12,
                    status = 'primary',
                    solidHeader = TRUE,
                    p('The data in Section 1.1 showed citywide rates of poverty. When the city population is decomposed into demographic or geographic subgroups, different patterns of poverty can emerge. This section shows poverty rates for New Yorkers in various groupings: family type; work experience; educational attainment: race, gender, and ethnicity; borough; and community district. Poverty rates are shown for the years 2015 to 2019 to illustrate trends in the data. In the case of community districts, where sample sizes typically are small, we average five years of data and present one poverty rate for the years 2015 to 2019. Year-over-year changes in poverty rates are often significant but somewhat volatile. The more meaningful five-year trend shows that many groups have experienced significant declines in poverty rates over the 2015 to 2019 period, including:'),
                    tags$ul(
                      tags$li('Males and females'),
                      tags$li('Working age adults'),
                      tags$li('Working age adults at all levels of educational attainment'),
                      tags$li('One- and two-parent families'),
                      tags$li('Full time, year-round workers and less than full-time, year-round workers'),
                      tags$li('Hispanics, Non-Hispanic Blacks, and Non-Hispanic Whites (no significant change for Non-Hispanic Asians)'),
                      tags$li('Citizens by birth, naturalized citizens, and non-citizens'),
                      tags$li('All families with children under 18'),
                      tags$li('Married or unmarried partners with and without children'),
                      tags$li('Childless single heads of households'),
                      tags$li('Among residents of all boroughs')
                    ),
                    p('There were no statistically significant ', tags$strong('increases'), ' in poverty or near poverty for any group from 2018 to 2019, or from 2015 to 2019. Detailed data tables for poverty rates are provided in Chapter 4.'),
                    fluidRow(
                      box(
                        #title = 'NYCgov Poverty Rates, 2015–2019',
                        width = 12,
                        status = 'primary',
                        h3('NYCgov Poverty Rates, 2015-2019'),
                        column(3,
                               selectInput("select_1_2_options", h4("Options"), 
                                           choices = list("Age" = 'AgeCateg', "Sex" = 'SEX',
                                                          "Race/Ethnicity" = 'Ethnicity',
                                                          "Race/Ethnicity and Gender" = 'ethnicity_sex',
                                                          "Citizenship Status" = 'CitizenStatus',
                                                          "Educational Attainment" = 'EducAttain',
                                                          "Work Experience" = 'FTPTWork',
                                                          "Borough" = 'Boro'
                                                          ), selected = 'AgeCateg')
                               ),
                        column(9,
                               tabsetPanel(type = "tabs",
                                           tabPanel("Plot", plotOutput("plot_1_2_fig_3to10")),
                                           tabPanel("Data", dataTableOutput('table_1_2_fig_3to10')),
                                           tabPanel("Source/Notes",
                                                    tags$strong('Source:'),
                                                    'American Community Survey Public Use Micro Sample as augmented by NYC Opportunity. U.S. official threshold from U.S. Census Bureau.'
                                                    )
                                           )
                               )
                      )
                    ),
                    h4('Figure 1.11: Percentage of Population Below Poverty Threshold, by Neighborhood, 2015–2019'),
                    h4('Table 1.2: Racial and Ethnic Composition of Community Districts (CDs) with Highest and Lowest Poverty Rates, 2015–2019')
                  )
                ),
                fluidRow(
                  box(
                    title = '1.3 What Drives the Poverty Rate: The New York City Labor Market, Wages, and Income Supports',
                    collapsible = TRUE,
                    collapsed = TRUE,
                    width = 12,
                    status = 'primary',
                    solidHeader = TRUE,
                    p('Poverty rates are influenced by the economic environment. The number of people working and the income they earn are key factors in building household resources. The 2019 data mark the post-recession peak in employment and income, both of which continued to improve from the prior year. The employment/population ratio steadily has increased since the end of the Great Recession, reaching pre-recession levels by 2016. By 2019, nearly three-quarters of working age adults engaged in at least some hours of employment. The share of workers employed full time also surpassed pre-recession levels, with corresponding declines in both part-time workers and those who worked no weeks in 2019 (see Figures 1.12 and 1.13).'),
                    box(
                      title = 'Employment/Population Ratios, 2015–2019',
                      width = 12,
                      status = 'primary',
                      tabsetPanel(type = "tabs",
                                  tabPanel("Plot", plotOutput("")),
                                  tabPanel("Data", dataTableOutput('')),
                                  tabPanel("Source/Notes",
                                           tags$strong('Source:'),
                                           'American Community Survey Public Use Micro Sample as augmented by NYC Opportunity. U.S. official threshold from U.S. Census Bureau.'
                                  )
                      )
                    ),
                    h4('Figure 1.13: Weeks Worked in Prior 12 Months, 2015–2019'),
                    p('Strong earnings growth among the lowest income workers coincided with an expanding economy and increases in the minimum wage. In 2014, the hourly minimum wage in New York City was $8, a 75-cents-an-hour increase from the previous year. The minimum wage increased each year after that until it reached $15 in calendar year 2019. Panel A of Table 1.3 shows the distribution of wage increases among the lowest 50 percent of wage earners. The greatest wage growth occurred in the bottom deciles of the wage distribution where less than full- time workers and minimum wage earners make up most of the population. But wages are only one component of NYCgov Income – a measure that includes a wider range of resources. Additional income supports such as tax credits and food assistance are included in income while work-related expenditures are deducted. (See Section 1.4 for more on NYCgov Income components.)'),
                    p('Panel B of Table 1.3 shows growth over time of the fuller resource measure, NYCgov Income. NYCgov Income increases at a slower pace than wages. The interactions of its components are complicated. For many non- elderly families, including those in poverty, wages are the largest component of NYCgov Income. The other income components interact with wage income; for example, childcare costs may increase with work hours. For low-income families, rising earnings can involve tradeoffs or benefit cliffs. Eligibility for some income supports, such as the Supplemental Nutrition Assistance Program (SNAP), tapers off as earnings rise. The Earned Income Tax Credit (EITC) increases with earnings and then phases out. The mix of a family’s income components is not constant over time, but shifts with wages and benefit eligibility standards.'),
                    p('Panel A of Table 1.3 shows how the economic well-being of low-income New Yorkers improved with economic expansion and rising wages. But safety net benefits still play an important role in keeping families above the poverty threshold. Figure 1.14 shows the effect of programs in reducing the poverty rate. Conversely, the inclusion of nondiscretionary expenditures in NYC Income (medical spending and work-related costs) allows for measuring the effect of these expenditures in increasing the poverty rate.'),
                    p('In Figure 1.14, elements that lower the poverty rate are found to the left of zero and those that raise it are found to the right. Each bar shows the effect of the absence of a specific income component on the poverty rate. For example, in the absence of an income adjustment to account for housing supports, the 2019 poverty rate would be 5.6 percentage points higher, or 23.5 percent. In the absence of medical expenditures, the poverty rate would be 3 percentage points lower, or 14.9 percent.'),
                    h4('Table 1.3: Nominal Wages and Incomes at Select Percentiles of Distribution, 2015–2019'),
                    h4('Figure 1.14: Marginal Effects of Selected Sources of Income on the NYCgov Poverty Rate, 2019')
                    )
                ),
                fluidRow(
                  box(
                    title = '1.4 The Distribution of Poverty and the Safety Net',
                    collapsible = TRUE,
                    collapsed = TRUE,
                    width = 12,
                    status = 'primary',
                    solidHeader = TRUE,
                    p('Poverty rates, while useful, simply mark the difference between those with resources above or below the poverty threshold. The data discussed above show that the potential for being in poverty differs across groups and by location. But not all poverty is alike. Some families are living quite close to their poverty threshold, with a small gap in the resources necessary to cross that line. Other families are living far below their poverty threshold, with less than half the resources they need to move out of poverty. All of these families are classified as “poor” because the poverty rate is simply a headcount of those living below the threshold. However, the further from the threshold the more intense the experience of poverty. Resources for basic needs are scarcer, stress levels can be higher, and it is more difficult to acquire the resources needed to escape poverty.'),
                    p('Table 1.4 shows shares of the population at selected distances above and below the poverty threshold for the years 2015 to 2019. The light blue band denotes shares of the population in poverty. The dark blue band denotes those families with resources from 100 to 200 percent above their threshold – not in poverty, but uncomfortably close to the threshold.'),
                    h4('Table 1.4: Distribution of the Population by Degrees of Poverty, 2015–2019'),
                    p('For those in poverty, the distance below the threshold is known as the poverty gap. It is the amount of resources2 they need to cross the threshold and move out of poverty. The amount can differ for each family. The poverty gap for New York City in 2019 was $6.5 billion. This figure is the sum of the poverty gap for all families in poverty and represents the total amount needed to lift all New Yorkers above their poverty threshold. Figure 1.15 shows that the poverty gap is not equally distributed across the population but varies by family status: the size and composition of the family. Breaking out the data by family status illustrates the impact of income supports that often are tied to the presence of children in the family.'),
                    h4('Figure 1.15: NYC Poverty Gap in Billions: 2019'),
                    p('Those living above their threshold (the dark blue band in Table 1.4) have a “poverty surplus” – the amount of resources available beyond what is needed to meet the family’s poverty threshold. Figure 1.16 shows the poverty surplus for this population, and breaks out the surplus for families with children and for single adults.3 The surplus is indicative of the risk of falling into poverty. It is the cushion available to keep families from falling into poverty in the event of an unexpected shock.'),
                    p('In Figure 1.14, elements that lower the poverty rate are found to the left of zero and those that raise it are found to the right. Each bar shows the effect of the absence of a specific income component on the poverty rate. For example, in the absence of an income adjustment to account for housing supports, the 2019 poverty rate would be 5.6 percentage points higher, or 23.5 percent. In the absence of medical expenditures, the poverty rate would be 3 percentage points lower, or 14.9 percent.'),
                    h4('Figure 1.16: Average Resource Surplus Among Low-Income Families, 2015–2019'),
                    p('The likelihood of falling into poverty and the intensity of that poverty is not equally distributed across the population. One potential remedy is the safety net of public benefits. Figure 1.14 shows the importance of these benefits in lowering the poverty rate among the population. The safety net is effective at lowering poverty but its resources are not equally distributed – a key source of differences in the poverty gap. Figure 1.17 shows how the combined impact of government assistance programs differs by family type. In particular, families with children receive the largest offset to their poverty rate. This is intentional, as many programs are specifically designed to give the greater share of benefits to families with children. The programs succeed in this goal. The NYCgov and other alternative poverty measures have repeatedly shown the importance of public programs in lowering the poverty rate, especially the child poverty rate.4 Similar but less generous benefits exist for the elderly. Childless working-age adults receive minimal relief from benefit programs as their incomes mostly consist of earned income, scant tax credits, and minimal other benefits.'),
                    h4('Figure 1.17: Impact of Combined Government Assistance and Tax Credits by Selected Family Type, 2019 (Percent Decline in Poverty Rate)')
                  )
                ),
                fluidRow(
                  box(
                    title = '1.5 | The NYCgov Poverty Measure',
                    collapsible = TRUE,
                    collapsed = TRUE,
                    width = 12,
                    status = 'primary',
                    solidHeader = TRUE,
                    p('This section provides a brief overview of the NYCgov poverty measure and how it differs from the U.S. official poverty measure. All measures of income poverty include two components: a definition of income that represents resources available to a family5 and a definition of a poverty threshold – the minimal socially acceptable measure of resources necessary for a family of a particular size. If a family’s resource measure is less than their assigned threshold, they are in poverty. The share of people living below their assigned poverty threshold constitutes the poverty rate. The NYCgov poverty measure and the U.S. official poverty measure differ in their definitions of both income and threshold.'),
                    p(tags$strong('Comparing the U.S. Official and NYCgov Poverty Measures')),
                    tags$ul(
                      tags$li('The U.S. official threshold is based on the cost of a minimal nutritional standard that is adjusted for family size. It has remained unchanged for over 50 years, save for inflation adjustments. It does not reflect changes in the standard of living that have occurred in the last half century or geographic differences in the cost of living, housing costs in particular.'),
                      tags$li('The income measure is limited to pre-tax cash. Current anti-poverty policies consist of a limited amount of cash assistance, plus tax credits and in-kind benefits such as SNAP. Because these programs are excluded from the official resource measure their impact on the official poverty rate cannot be estimated.'),
                      tags$li('There is no accounting for nondiscretionary spending on items such as health care, or the transportation and childcare costs required of many working adults. Omitting these costs overstates the amount of pre-tax cash income that is available to meet the threshold.')
                    ),
                    p('The NYCgov poverty measure surmounts these shortcomings by redefining resources and thresholds:'),
                    tags$ul(
                      tags$li('The NYCgov threshold is based on national data on family spending for necessities (food, clothing, shelter, and utilities). The measure is adjusted for family size and the higher cost of housing in New York City.'),
                      tags$li('The NYCgov Income measure includes multiple resources that reflect current anti-poverty efforts:'),
                      tags$ul(
                        tags$li('After-tax cash income'),
                        tags$li('Nutrition assistance: SNAP; free school meals; and the Special Supplemental Nutrition Program for Women, Infants, and Children (WIC)'),
                        tags$li('Housing assistance, including the differential from market rents when residing in public, subsidized, or rent-regulated apartments'),
                        tags$li('Home heating assistance')
                      ),
                      tags$li('Nondiscretionary spending is estimated and subtracted from income:'),
                      tags$ul(
                        tags$li('Childcare and transit costs for workers'),
                        tags$li('Out-of-pocket medical spending, including premiums')
                      )
                    ),
                    p('Table 1.5 compares the components of the U.S. official poverty measure and the NYCgov measure. Since 2011, the U.S. Census Bureau has released another measure of poverty, the Supplemental Poverty Measure (SPM), that is similar to the NYCgov measure but not available at the city level. For 2019, the SPM rate for the United States was 11.7 percent, the lowest rate since the estimates began and a full percentage point lower than the 2018 SPM rate.'),
                    h4('Table 1.5: Comparison of U.S. Official and NYCgov Poverty Measures')
                  )
                )
                )
             ),
      ## Report: Policy & Path ----
      tabItem("report_policy_path",
              fluidPage(
                h1("2 | Policy & Path"),
                p('This is the final poverty report issued by the de Blasio administration. As such, it provides an opportunity to look back on the poverty policy of two mayoral terms and its impact. This year’s report shows a decline in poverty and near poverty. The New York City Government (NYCgov) poverty rate fell from 20.2 percent to 17.9 percent from 2014 to 2019, a statistically significant change. The rate for 2019 is the lowest since the start of the de Blasio administration and, in fact, the lowest rate going back to 2005 – the first year captured by the poverty measure. As of 2019, there were 521,000 fewer people in poverty or near poverty than if rates had remained at their 2013 levels. The decline reflects how increases in the minimum wage, rising labor market participation, and the many policies implemented during the de Blasio administration improved the economic well-being of low-income New Yorkers.'),
                p('This year’s report represents a snapshot of poverty and near poverty in New York City before the COVID-19 pandemic arrived in early 2020, so it must be viewed within that context. It nevertheless contains important lessons about the current state of poverty. The report also considers how, as conditions improve and the City reopens (with an infusion of federal help from the American Rescue Plan Act of 2021 that includes significant aid to city governments), it can recover from the negative economic impact of COVID-19.'),
                p('Poverty rates have declined significantly for most demographic groups during this administration’s two terms, as Table 2.1 shows by comparing 2014 and 2019 rates.'),
                h2('Table 2.1: NYCgov Poverty Rates for Persons, by Demographic Characteristic, 2014 and 2019'),
                p('This report includes information on the poverty gap – the amount of money needed to lift all families over the poverty threshold if the funds were perfectly targeted. The overall gap, $6.5 billion in 2019, did not change compared to 2014. But the gap for families with children and for single, nonelderly adults living alone or with unrelated individuals showed statistically significant declines from 2014 to 2019. See Table 2.2.'),
                h2('Table 2.2: NYCgov Poverty Gap, 2014–2019'),
                box(
                  title = '2.1 | Jobs and Increased Wages',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('One of the main lessons from the poverty data going back to 2014 is, not surprisingly, that well-paying jobs play a critical role in lifting people out of poverty and keeping them out. In particular, NYCgov data in this report and reports issued during the de Blasio administration show that the minimum wage has been one of the most powerful forces in moving people above the poverty line and keeping them there.'),
                  p('New York State sets the minimum wage in New York City, but the City aggressively worked with the State legislature to raise it through a multi-year phase-in. An increase in the minimum wage to $15 was a centerpiece of the City’s goal of moving 800,000 New Yorkers out of poverty or near poverty between 2013 and 2025. The minimum wage in the city, which was just $7.25 in 2013, rose to $15 for employers with 11 or more workers on the last day of 2018. It rose to $15 for smaller employers on the last day of 2019. That means the data in this year’s report are the first in which all but the smallest employers in the city were paying a minimum wage of $15. Between 2013 and 2019 the poverty threshold rose 16 percent, so New Yorkers benefiting from higher wages and a strong job market also contended with greater expenses. Even so, the actual number of people moved out of poverty or near poverty through the first year of the $15 minimum wage is about 521,000 – a population that would constitute the 35th largest city in the United States and more than the total number of residents of Miami or Atlanta, for instance.'),
                  p('The minimum wage reached $15 in a peak year for the job market. By 2019 employment had regained and surpassed jobs lost throughout the Great Recession, and it was a year before the COVID-19-related shutdown occurred. The $15 minimum wage appeared to have no notable impact on employment demand. Labor force participation rose over 5 percent from 2014 to 2019, with more workers engaged in full-time, year-round employment. Wages defining the bottom decile of the labor force grew by over $3,000. These two factors – wage growth and employment opportunity – were core drivers of the declining poverty rate.'),
                  p('The City also promoted increased wages in other ways. It has raised wages for its own workforce, nonprofit contracted vendors, and childcare workers. Although many of the workers who benefited from these wage increases were already above poverty or near poverty, in other cases the increases helped to lift families out of poverty or near poverty and into more stable, self-sufficient economic circumstances.'),
                  p('In April 2014 the City’s Earned Sick Time Act took effect, requiring many employers in New York City to provide employees with paid sick leave. By requiring employers to pay New Yorkers for days they take off to care for themselves or a family member, the law has increased take-home pay for many. The City has also established a program of free, high-quality universal pre-K and greatly expanded free 3-K. In addition to providing vitally important early childhood education, these programs increase wages in working families by freeing up parents to work more hours without having to pay for childcare.'),
                  p('The City has also promoted increased earnings through increased job creation. It has engaged in a wide range of efforts to foster economic development and the expansion of good jobs. In August 2020, the City announced a pledge by 27 of New York City’s largest employers, made in coordination with the Mayor’s Office, to create 100,000 jobs for low-income members of the Black, Latinx, and Asian communities by 2030. As part of this commitment, the New York Jobs CEO Council, a newly created nonprofit group, said it would partner with the City University of New York (CUNY) and the New York City Department of Education (DOE), with the aim of hiring at least 25,000 students by directing them to entry-level jobs, apprenticeships, and work-based learning opportunities.'),
                  p('The City looks to job training as an important tool for lifting New Yorkers out of poverty. The City has invested heavily in Jobs-Plus, a proven, place-based employment program for residents of New York City Housing Authority (NYCHA) developments that focuses on providing employment-related services, creating financial incentives that “make work pay,” and promoting community support for work. The City offers other job training programs, including Advance & Earn, a training and employment program for youth between the ages of 16 and 24. The City additionally has significantly expanded the number of slots in the decades-old Summer Youth Employment Program (SYEP) and launched the NYC Center for Youth Employment, a first-of-its-kind office designed to bring focus, rigor, and coordination to helping young people prepare for career success.'),
                  p('The City has an array of other initiatives designed to help New Yorkers find well-paying employment. In February 2019, it launched the Disconnected Youth Task Force to examine the obstacles faced by young people between the ages of 16 and 24 who are out of work and not in school. The City also recently launched WorkingNYC, a one-stop online portal that directs New Yorkers to jobs, job training, and educational opportunities.')
                  ),
                box(
                  title = '2.2 | Affordable Housing',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('The availability of affordable housing is another important factor in determining whether New Yorkers live above the poverty line. It is especially important in the city because of the high cost of housing compared to other parts of the country, and the large percentage of income New York City households spend on housing. Housing supports that range from public housing to rent regulated units consistently lower the poverty rate by freeing up family resources to meet other needs. The effect has been to lower the poverty rate in the range of approximately 5.5 to 6.6 percentage points in a given year.'),
                  p('The City has made a strong commitment to increasing the availability of affordable housing. When Mayor de Blasio took office in 2014, he launched Housing New York with the ambitious goal of creating or preserving 200,000 affordable homes and apartments in ten years. In November 2017, the administration announced it would meet that goal two years early, and launched Housing New York 2.0, a roadmap to a new goal of creating or preserving 300,000 houses or apartments by 2026. Housing New York 2.0 included new initiatives to help New Yorkers buy a first home, afford their rent, and stay in their neighborhoods. In January 2020, the City launched a third phase of Housing New York, YOUR Home NYC, with new initiatives to build and preserve affordable housing, protect renters, and create neighborhood wealth.'),
                  p('The City has also focused on helping New Yorkers who have housing to remain in it, since the loss of a home often contributes to a family or individual moving into poverty. In August 2017, the mayor signed a law creating a right to counsel in eviction cases, which has given New Yorkers an important new weapon to ward off eviction and possible homelessness. In January 2019, the mayor established the Mayor’s Office to Protect Tenants by executive order, which coordinates an array of tenant-protection efforts. The City’s Department of Social Services (DSS) operates a program that extends emergency rental assistance to families and individuals at risk of being evicted. In addition, the City launched its first-ever NYC Tenant Resource Portal, an online resource to help New Yorkers who rent their homes to access free City resources to prevent evictions.'),
                  p('The City also ramped up efforts to address homelessness, which remains a stubborn problem. It launched the HOME-STAT program, which sends canvassing teams out to identify homeless New Yorkers and connect them with homeless outreach staff who can address their housing and social service needs. Another program, One Shot Deal, extends one-time emergency grants to help New Yorkers facing unexpected circumstances to remain in their housing or assist them in moving into new housing. The City also operates CityFHEPS, a voucher program that helps New Yorkers experiencing homelessness to obtain permanent housing.')
                ),
                box(
                  title = '2.3 | Benefits',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('For many New Yorkers, government benefits of all kinds make the difference between living above the poverty line or below it. For example, combined tax credits such as the Earned Income Tax Credit (EITC) or the Child Tax Credit lower poverty an average of 3 percentage points. Supplemental Nutrition Assistance Program (SNAP) benefits have a similar effect.'),
                  p('The City has launched an array of initiatives designed to make it easier for New Yorkers to learn which benefits they qualify for and apply for them. NYC Opportunity updated ACCESS NYC, a digital tool that allows people to easily check their potential eligibility for over 30 federal, New York State, and New York City benefits. Available in over ten languages, the site provides information on how programs work, what documentation is required, how to apply online, and how to receive help. HRA also launched ACCESS HRA, available as a website and as a mobile app, which allows New Yorkers to apply for SNAP and Cash Assistance and regularly check the status of their benefits.'),
                  p('The City also introduced an array of reforms that removed obstacles to obtaining benefits. Clients previously were required to “work off” their benefits through the Work Experience Program (WEP) at City and nonprofit agencies. The City eliminated WEP and instead offers new opportunities for subsidized jobs, internships, and education and trainings oriented toward building career pathways.'),
                  p('The City has transformed Cash Assistance procedures to reduce unnecessary office visits. This allows clients to submit recertification questionnaires online and submit documents from a smartphone. The City has also put in place new protocols to prevent unnecessary case closings, which required clients to request a State fair hearing to reopen their case. With the new protocols, State fair hearing challenges declined by more than 47 percent.'),
                  p('On the policy level, the City has been a strong advocate for increased benefits. In June 2020, the mayor and the City’s Corporation Counsel joined a coalition of state attorneys general in urging Congress to block Trump administration efforts to cut SNAP benefits. In January 2021, President Biden signed an executive order that increased the amount of SNAP benefits people are eligible for, which applied to very low-income households in particular.'),
                  p('The City also successfully advocated for a change in State law that permits clients to obtain a college degree while receiving benefits. Participation in a four-year college program was not a permissible employment activity for clients before the change – a limitation that cut many off from degrees that would greatly improve their ability to earn a living wage.')
                ),
                box(
                  title = '2.4 | Education',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('Education is one of the most powerful tools for moving people out of poverty. Extensive data show a strong correlation between education levels and living above the poverty line. It is consistently found that an individual with less than a high school degree is four times more likely to be poor than an individual with a bachelor’s degree or higher. Gaining a high school degree lowers that risk to three times more likely to be poor. The City has heavily invested in initiatives to increase access to education at all levels. New York City has been a national leader in universal pre-K and 3-K, expanding free, high-quality early childhood education, which is shown to be strongly associated with success later in life, including economic success.'),
                  p('At the elementary and middle-school levels, the City’s Equity and Excellence for All initiative has introduced an array of improvements and reforms. The City placed reading coaches in every elementary school and continued to expand access to bilingual and dual-language programs.'),
                  p('The City has also introduced high school-level programs to increase student access to higher education and their marketable technical skills. It launched the Computer Science for All initiative as part of its Equity and Excellence for All agenda to ensure that all City schools can provide equitable computer science learning experiences to their students. The City’s AP for All initiative similarly brings advanced placement (AP) courses to schools that offer few or no AP courses. In 2018, the City had its highest ever number of students taking and passing AP exams.'),
                  p('At the college level, CUNY’s Accelerated Study in Associate Programs (ASAP) has a proven record of helping low-income students remain in school and obtain associate degrees. Since the program’s inception, 14 CUNY ASAP cohorts have totaled 70,000 students admitted across an array of CUNY colleges. Its current three-year graduation rate is 53 percent versus 24 percent for similar students not enrolled in the program. In 2015, NYC Opportunity provided support for Accelerate, Complete, and Engage (ACE), a program similar to CUNY ASAP that supports students pursuing baccalaureate degrees.')
                ),
                box(
                  title = '2.5 | Equity',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('The data in this report, and reports issued over the past two mayoral terms, show that people of color are disproportionately likely to live in poverty and have difficulty rising out of it. The disparities are stubbornly persistent. Poverty rates fell from 2014 to 2019 for all the racial and ethnic groups regularly tracked in this report. But these declines were slow, few significant year-over-year changes exist, and significant changes only appear when measured over the longer term.'),
                  p('Even as poverty rates fell, the differences between groups remain. In any given year Hispanic poverty rates are nearly double that of rates for Whites. The average differences in rates for Blacks (nearly 65 percent higher) and Asians (just over 75 percent higher) are also notable. For this reason, racial equity is a critical part of the City’s work to reduce poverty. The City has launched a wide range of initiatives to address racial and other disparities.'),
                  p('In May 2019, the mayor signed Executive Order 45 (EO 45), which expanded the City’s focus on equity in its own operations and across New York City. EO 45 directs City agencies to identify disparities in their work based on income, race/ethnicity, gender, and other factors. Agencies are required to develop plans to address identified disparities.'),
                  p('To reduce inequity, it is important to know where it exists. To this end, the City has significantly increased the amount and quality of information available on disparities of all kinds. It has published a Social Indicators Report since 2016, which provides a snapshot of social and economic conditions across the City. In 2019, the report was redesigned as the Social Indicators and Equity Report, with significantly more data on disparities by race, gender, income, and other factors. In February 2021, the City launched EquityNYC, a website that presents the data in a highly accessible online format.'),
                  p('The City has also promoted equity by increasing its support for Minority and Women-Owned Businesses (M/WBEs). In OneNYC, the blueprint for New York City’s future, the City set a goal of awarding nearly $16 billion out of $25 billion in contracts to M/WBEs by 2020; as of mid-2020 it was running ahead of schedule.'),
                  p('In July 2020, the mayor signed an executive order to strengthen M/WBEs. He also announced new initiatives with the Taskforce on Racial Inclusion and Equity to help Black and Latinx entrepreneurs connect with business opportunities, including government contracts.'),
                  p('The City has an array of specialized programs designed to promote equity in specific areas. These include NYC Men Teach, the nation’s most ambitious effort to diversify the teaching pipeline. It has a goal of recruiting and retaining 1,000 additional men of color to teach in New York City schools, where less than 8 percent of teachers are men of color.')
                ),
                box(
                  title = '2.6 | Immigrant Assistance',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('The data in this report show that New York City’s immigrants are disproportionately likely to live in poverty. The non-citizen poverty rate fell 5 percentage points from 2014 to 2019, but remains 6 percentage points higher than the poverty rate for native-born citizens. This aligns with the wealth of evidence showing that there are strong economic benefits to obtaining citizenship status. One study sponsored by the Mayor’s Office of Immigrant Affairs (MOIA) found that with naturalization, individual annual earnings increase by an average of 8.9 percent, the employment rate rises 2.2 percentage points, and homeownership increases 6.3 percentage points.1 Starting in 2018, NYC Opportunity began to issue reports specifically analyzing poverty among immigrants in the city. The agency’s “An Economic Profile of Immigrants in New York City”2 provides data and analysis that can help City policymakers identify where poverty exists in immigrant communities and develop strategies for addressing it.'),
                  p('MOIA, the City office dedicated to supporting and empowering immigrants, offers an array of programs designed to help immigrants economically succeed. ActionNYC offers all New Yorkers free immigration legal help. It works through a network of trusted community-based organizations (CBOs), delivering its services in public schools, public health facilities, and other CBOs. It also operates a toll-free hotline where immigrants can ask questions and be connected to free and safe legal help. Another program, NYCitizenship, provides free legal help with citizenship applications at select New York Public Library branches.'),
                  p('IDNYC, the nation’s most robust municipal ID program, has been of particular help to immigrant New Yorkers. The free identification card, which is issued without regard to immigration status, helps New Yorkers access a wide variety of vital services, including banking; employment; access to public buildings, including schools; and public benefits.')
                ),
                box(
                  title = '2.7 | Health and Well-being',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('Health difficulties are a significant factor that can move people into poverty and keep them there due to the costs associated with being ill, and the fact that illness can interfere with their ability to earn. Out-of-pocket medical spending consistently adds approximately 3 percentage points to the poverty rate.'),
                  p('The City has taken a bold stand for universal health care. In January 2019, the mayor announced plans to guarantee health care for all New Yorkers. The initiative was designed to serve the 600,000 New Yorkers who lacked insurance by strengthening MetroPlus, the City’s public health insurance option. The initiative also launched NYC Care, a new program that guarantees anyone eligible for insurance, including undocumented immigrants, direct access to NYC Health + Hospitals physicians, pharmacies, and mental health and substance abuse services.'),
                  p('The City has other targeted health initiatives. In July 2018, it launched a comprehensive, four-point program to reduce maternal deaths and life-threatening complications from childbirth among women of color. These maternal mortality rates and the racial disparities within them remain an ongoing challenge. The City announced it would invest $12.8 million in the plan over the next three years, including implicit bias training for private and public health care providers, support for private and public hospitals to enhance data tracking and analysis of maternal mortality events, and other measures.'),
                  p('The City has also made mental health a priority through the ThriveNYC initiative. Connections to Care (C2C), a part of ThriveNYC, integrated mental health support into the work of CBOs that serve at-risk and low-income communities across the city. C2C CBOs work with mental health providers who train and coach staff to screen for mental health needs, and either offer clients direct support or connect them with local health care providers. A preliminary program evaluation found that most participants were from ethnic minority backgrounds, with over half reporting incomes of less than $5,000 – an indication that C2C was reaching its intended target population.')
                ),
                box(
                  title = '2.8 | Broadband Access',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('In today’s digital economy, broadband access is important to financial success. The internet is a vital tool for accessing job opportunities, pursuing education, and starting businesses. In January 2020, the City announced its NYC Internet Master Plan, a bold vision for affordable, high-speed, reliable broadband service throughout the five boroughs. The City has promoted broadband access in a variety of ways, with a particular focus on marginalized communities and low-income New Yorkers. In April 2020, the City announced it would provide tablets and internet access to 10,000 seniors in public housing. This $5 million program was designed to reduce isolation among older New Yorkers and help them access information about COVID-19.'),
                ),
                box(
                  title = '2.9 | Climate Change',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('Global climate change has a negative financial impact, particularly on economically vulnerable households. The City has launched or expanded a number of programs designed to help low-income New Yorkers handle the costs associated with rising temperatures, increased flooding, and other effects of climate change. NYC Opportunity’s poverty research team has conducted research and provided input for several climate-related projects. The team participated in a working group that explored affordable flood insurance for homeowners and renters in coastal areas. It also assisted a successful effort to increase utility company energy subsidies to low- income households, based on an updated measure of the burden of household energy costs.'),
                ),
                box(
                  title = '2.10 | COVID-19 Response',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('This year’s report covers a period before the COVID-19 pandemic. It should be noted that when COVID-19 hit New York City in early 2020, the City rapidly and forcefully responded to both the health threat and the extensive economic impact. NYC Opportunity’s poverty research team has analyzed U.S. Census Bureau Pulse Data to assess the financial impact of COVID-19. It has found widespread job and income losses in the city with some groups particularly hard hit, including workers with a high school education or less and Asian workers.3 It also found that the COVID-19 crisis was having a disproportionately large economic impact on women.'),
                  p('The City immediately implemented Get Food NYC, a free food distribution program that included grab-and-go meals at New York City schools. The program was available to all children and adults in need, and included emergency home food distribution. The City appointed a COVID-19 Food Czar to coordinate multi-agency efforts. By late September 2020, the Food Czar’s operation had distributed more than 135 million meals to hungry and food-insecure New Yorkers. At the time, it delivered approximately 400,000 meals a day through its Emergency Food Delivery program, which brought meals to homebound low-income New Yorkers. It also served an additional 450,000 grab-and-go meals daily at over 400 New York City school locations.'),
                  p('The City launched initiatives to help small businesses and their employees affected by the pandemic, including a small business relief program that made loans available to small businesses affected by COVID-19. The Open Restaurants program allowed restaurants to establish outdoor dining on public roadways and sidewalks. The City also established a Restaurant Revitalization Program, which provides funds to restaurants to pay unemployed and under-employed workers affected by the COVID-19 crisis.'),
                  p('When the COVID-19 pandemic began, the City announced a plan to protect vulnerable New Yorkers during heat waves. The plan called for providing over 74,000 air conditioners to seniors whose income was below 60 percent of the state median income and did not have air conditioning at home.'),
                  p('As part of its COVID-19 response and to help ensure an equitable recovery, the City also created the Taskforce on Racial Inclusion & Equity. The taskforce has worked on issues such as expanding access to food programs in underserved communities.')
                ),
                box(
                  title = '2.11 | The Role of NYC Opportunity',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('NYC Opportunity was created more than a decade ago with the mission of using evidence and innovation to reduce poverty and increase equity. Located within the Mayor’s Office, the agency works to improve the systems of government by advancing the use of research, data, and design in program and policy development; service delivery; and budget decisions. Its work includes analyzing existing anti-poverty approaches, developing new strategies, facilitating the sharing of data across City agencies, and rigorously assessing the impact of key initiatives. NYC Opportunity manages a discrete fund and collaboratively works with City agencies to design, test, and oversee new programs and digital products.'),
                  p('The agency manages a portfolio of initiatives it has developed with its partners and directly oversees, and it offers a variety of services to City agencies to promote data-driven, evidence-based policymaking. The office’s work ranges across five interrelated disciplines: research, service design, digital products, data integration, and programs and evaluations.'),
                  p('This poverty report, which was prepared by the NYC Opportunity poverty research team, is a central part of the agency’s research agenda. In 2013, the New York City Charter was revised to require that the mayor issue an annual report on poverty in the city. This report fulfills that mandate, employing a New York City-specific poverty measure created by the agency’s Poverty Research Unit, the NYCgov measure, which more accurately captures poverty in the city than the federal measure.'),
                  p('Many of the initiatives discussed in this chapter have been launched, funded, or overseen by NYC Opportunity in partnership with other parts of City government or on its own. The agency’s Service Design Studio and Product Team designed the ACCESS NYC digital tool and continue to operate it. It has played a significant role in CUNY ASAP, Jobs-Plus, Advance & Earn, the Restaurant Revitalization Program, Connections to Care, and Working NYC, among other programs.'),
                  p('NYC Opportunity has also worked on many other anti-poverty and equity initiatives not discussed above. Its Service Design Studio created Designing for Opportunity, a program that invites City agencies to propose collaborative projects that bring Studio designers and agency staff together to use service design methods to address poverty-related challenges. The Product team, in partnership with several City agencies, launched the Social Service Location Data initiative, which released a database of verified service delivery locations for contracted social services. It is an important tool for assessing whether the City is equitably delivering services to all communities.'),
                  p('NYC Opportunity is deeply involved in the City’s equity work. Its office, alongside the Mayor’s Office of Operations, has helped to implement EO 45, working with City agencies to identify inequities and develop plans for addressing them. It also produces the Social Indicators and Equity Report, and helped to create and maintain EquityNYC.')
                ),
                tags$strong('Past Success and Future Challenges'),
                p('This report shows that in 2019, the New York City government poverty and near poverty rates were at their lowest levels since 2005 – the first year captured by the poverty measure. These rates support the idea that the anti-poverty policies and programs put in place by the de Blasio administration have been effective in moving New Yorkers out of poverty and near poverty – and keeping them out.'),
                p('The poverty and near poverty rates reflect an earlier New York City, before COVID-19 arrived and had a devastating impact on residents’ health and economic well-being. Next year’s poverty report will be the first to show the impact of COVID-19 on poverty in New York City. Nevertheless, this year’s report offers some enduring lessons about poverty in the city, including the significant inequities that exist. It also points to strategies for combatting poverty, which remain relevant today.'),
                p('Future reports may show backsliding on poverty and near poverty as a result of the economic impact of COVID-19. They will also, however, reflect new anti-poverty measures implemented at the federal level starting in 2021, including significant financial support for children in poverty. Given the disproportionate impact of COVID-19, in the coming years the City will need to intently focus on communities that faced the brunt of pandemic-related job losses, and leverage the significant new resources from the federal government in order to return to the steady declines in poverty reflected in this year’s report.')
                )
      ),
      
      ## Report: Measuring Poverty ----
      tabItem("report_measuring",
              fluidPage(
                h1("3 | Measuring Poverty"),
                h3('The NYCgov Poverty Measure Compared to U.S. Official and U.S. Supplemental Poverty Measures'),
                box(
                  title = '3.1 | The Need for an Alternative to the U.S. Official Poverty Measure',
                  collapsible = TRUE,
                  collapsed = FALSE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('It has been over a half century since the development of the current U.S. official poverty measure. At its inception in the early 1960s, the income-based measure represented an important advancement and served as a focal point for the public’s growing concern about poverty in America. Over the following decades, as society evolved and public policy shifted, discussions about poverty increasingly included concerns about the measure’s adequacy. Still largely unchanged, the U.S. official poverty measure contains outdated definitions of resources and of the poverty threshold: Pre-tax cash income in the resource measure is compared to a threshold based only on the value of a minimal food budget. The official measure’s threshold, developed in the early 1960s, was based on the cost of the U.S. Department of Agriculture’s Economy Food Plan at the time, a diet designed for “temporary or emergency use when funds are low.” Survey data available at that juncture indicated that families typically spent a third of their income on food, so the cost of the plan was simply multiplied by three to account for other needs. The official measure’s threshold is also adjusted for family size. Since its 1963 base year, the threshold is annually updated by changes in the Consumer Price Index.', tags$sup('1')),
                  p('Over a half century later this poverty line has little justification; it does not represent contemporary spending patterns or needs. Food now accounts for less than 10 percent of spending, on average,', tags$sup('2'), ' and housing is the largest single item in a typical family’s budget.'),
                  p('The official threshold ignores differences in the cost of living across the nation, an issue of obvious importance when measuring poverty in New York City where housing costs are among the highest in the United States. The threshold also remains frozen in time. Since it only rises with the cost of living, it assumes the standard of living that defined poverty in the early 1960s remains appropriate, despite significant advances in the nation’s living standards since then.'),
                  p('The official measure’s definition of resources to be compared against the threshold is simply comprised of pre-tax cash. This resource includes wages; salaries; earnings from self-employment; income from interest, dividends, and rents; and income families receive from public programs, if they take the form of cash. Thus, payments from Unemployment Insurance, Social Security, Supplemental Security Income (SSI), and public assistance are included in the official resource measure. Given the data available and the policies in place at the time, the definition was not unreasonable. But over the years, an increasing share of government efforts to support low-income families has taken the form of tax credits (such as the Earned Income Tax Credit or EITC) and in-kind benefits (such as housing vouchers) or SNAP (Supplemental Nutrition Assistance Program) benefits. If policymakers or the public want to know how these programs affect poverty, the U.S. official measure cannot provide an answer.'),
                  # FOOTNOTES
                  hr(),
                  h6('[1] Gordon M. Fisher. “The Development and History of the Poverty Thresholds.” Social Security Bulletin, Volume 55, No. 4. Winter 1992.'),
                  h6('[2] In 2019 the American budget share for food fell to an historical low of 9.5 percent. See: ', a('link', href = 'https://www.ers.usda.gov/data-products/chart-gallery/gallery/chart-detail/?chartId=76967', target = '_blank'))
                ),
                box(
                  title = '3.2 | Alternative Measures: The National Academy of Sciences’ Recommendations and the Supplemental Poverty Measure',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  #solidHeader = TRUE,
                  p('Dissatisfaction with the U.S. official measure prompted Congress to request a study by the National Academy of Sciences (NAS), which was issued in 1995.', tags$sup('3'), ' However, no government body had adopted the NAS approach until the New York City Center for Economic Opportunity (now the Mayor’s Office for Economic Opportunity) released its initial report on poverty in New York City in August 2008.', tags$sup('4')),
                  p('Although the NAS-recommended methodology is also income-based, it is considerably different from the U.S. official poverty measure. The NAS threshold reflects the need for multiple necessities and is based on a point in the distribution of actual expenditures on food, clothing, shelter, and utilities (FCSU) incurred by a two-adult, two-child reference family. A small multiplier is applied to account for miscellaneous expenses. This threshold is annually updated to account for changes in spending and living standards. The NAS-style poverty line is also adjusted to reflect geographic differences in housing costs.'),
                  p('On the resources side, the NAS-based measure accounts for both income and in-kind benefits that can be used to meet the needs represented in the threshold. This is more inclusive than the official measure of pre-tax cash, and an important addition when accounting for family resources. The tax system and the cash equivalent value of in-kind benefits for food and housing are important additions to family resources.'),
                  p('Families also have nondiscretionary expenses that reduce the income they have available to meet needs for the FCSU necessities represented by the threshold. Nondiscretionary expenses include the cost of commuting to work, childcare, and medical care that must be paid for out of pocket. The NAS recommendations account for this spending as deductions from income because dollars spent on these items are not considered available to purchase food or shelter.'),
                  p('Since November 2011, the Census Bureau has issued an annual Supplemental Poverty Measure (SPM).', tags$sup('5'), ' The new federal measure is shaped by the NAS recommendations and an additional set of guidelines provided by an Interagency Technical Working Group in 2010.', tags$sup('6'),' The guidelines made several revisions to the 1995 NAS recommendations, the three most important being:'),
                  tags$ol(
                    tags$li('An expansion of the type of family unit whose expenditures determine the poverty threshold from two-adult families with two children to all families with two children.'),
                    tags$li('Use of a five-year rather than a three-year moving average of expenditure data to update the poverty threshold over time.'),
                    tags$li('Creation of separate thresholds based on housing status: whether the family owns its home with a mortgage; owns but is free and clear of a mortgage; or rents.'),
                  ),
                  box(
                    title = 'Measures of Poverty',
                    width = 12,
                    background = 'light-blue',
                    tags$strong('Official'),
                    p('The current U.S. offical poverty measure was developed in the early 1960s. It consists of a set of thresholds that were based on the cost of a minimum diet at that time. A family\'s pre-tax cash income is compared against the threshold to determine whether its members are poor '),
                    tags$strong('NAS'),
                    p('At the request of Congress, the National Academy of Sciences (NAS) issued a set of recommendations for an improved poverty measure in 1995. The NAS threshold represents the need for clothing, shelter, and utilities, as well as food. The NAS income measure accounts for taxation and the value of in-kind benefits.'),
                    tags$strong('SPM'),
                    p('In March 2010, the Obama administration announced that the U.S. Census Bureau, in cooperation with the Bureau of Labor Statistics, would create a Supplemental Poverty Measure (SPM) based on the NAS recommendations, subsequent research, and a set of guidelines proposed by an Interagency Working Group. The first report on poverty using this measure was issued by the Census Bureau in November 2011.'),
                    tags$strong('NYCgov'),
                    p('The Mayor\'s Office for Economic Opportunity released its first report on poverty in New York City in August 2008. The NYCgov poverty measure is largely based on the NAS recommendations, with modifications based on the guidelines from the Interagency Working Group and adopted in the SPM.')
                  ),
                  # FOOTNOTES
                  hr(),
                  h6('[3] See Constance F. Citro and Robert T. Michael (eds.), Measuring Poverty: A New Approach. Washington, DC: National Academy Press. 1995. In addition, much of the research inspired by the NAS report is available at: ', a('link', href = 'https://www.census.gov/library/publications/1995/demo/citro-01.html', target = '_blank')),
                  h6('[4] New York City Center for Economic Opportunity. “The CEO Poverty Measure: A Working Paper by the New York City Center for Economic Opportunity.” August 2008. Available at: ', a('link', href = 'https://www1.nyc.gov/assets/opportunity/pdf/08_poverty_measure_report.pdf', target = '_blank')),
                  h6('[5] The most recent SPM report, “The Supplemental Poverty Measure: 2019,” is authored by Liana Fox. U.S. Census Bureau. October 2020.', a('link', href = 'https://www.census.gov/library/publications/2020/demo/p60-272.html', target = '_blank')),
                  h6('[6] “Observations from the Interagency Technical Working Group on Developing a Supplemental Poverty Measure.” March 2010. Available at: ', a('link', href = 'https://www.census.gov/content/dam/Census/topics/income/supplemental-poverty-measure/spm-twgobservations.pdf', target = '_blank'))
                ),
                box(
                  title = '3.3 | NYC Opportunity’s Adoption of the NAS/SPM Method',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('The first estimate of the NYCgov poverty measure, released in 2008, only included data for 2006.', tags$sup('7'), ' Initial releases of the NYCgov poverty measure were based on NAS recommendations. Upon release of the SPM, the NYCgov measure was adjusted for better comparability. The first two of the three SPM revisions noted above have been incorporated into the NYCgov measure, but NYC Opportunity does not utilize the SPM’s development of thresholds that vary by housing status. Instead, the SPM poverty threshold is adjusted to account for the differential between national and New York City housing costs. In 2018, for example, the NYCgov poverty threshold of $36,262 was greater than the SPM renter threshold of $28,881.8', tags$sup('8')),
                  p('All differences in housing status are accounted for on the income side of the poverty measure, including renters at market rate, renters with means-tested housing assistance or in rent regulated units, and homeowners with and without mortgages.', tags$sup('9')),
                  p('To measure the resources available to a family to meet the needs represented by the threshold, NYC Opportunity employs the Public Use Micro Sample (PUMS) from the Census Bureau’s American Community Survey (ACS) as its principal data set. The advantages of this survey for local poverty measurement are numerous. The ACS is designed to provide measures of socioeconomic conditions on an annual basis in states and larger localities. It offers a robust sample for New York City (26,674 households in 2019) and contains essential information about household composition, family relationships, and cash income from a variety of sources.'),
                  p('As earlier noted, the NAS-recommended poverty measure greatly expands the scope of resources that must be measured in order to determine whether a family is poor.'),
                  p('The ACS unfortunately provides only some of the information needed to estimate the additional resources required by the NAS measures. Therefore, the NYCgov measure incorporates a variety of internally developed models that estimate the effect of taxation, nutritional and housing assistance, work-related expenses, and medical out-of-pocket expenditures on total family resources and poverty status. The resulting data set is referenced as the “American Community Survey Public Use Micro Sample as augmented by NYC Opportunity.” NYC Opportunity’s estimate of family resources is noted as “NYCgov Income.”'),
                  box(
                    title = 'The American Community Survey',
                    width = 12,
                    background = 'light-blue',
                    p('The American Community Survey (ACS) is conducted as a rolling sample gathered over the course of a calendar year. Approximately one-twelfth of the total sample is collected in each month. Respondents are asked to provide information on work experience and income during the 12 months prior to the time they are included in the sample. Households surveyed in January 2019, for example, reported their income for February 2018 through January 2019, and so on. Consequently, estimates for poverty rates derived from the 2019 ACS do not, strictly speaking, represent a 2019 poverty rate. Rather, it is a poverty rate derived from a survey fielded in 2018. Readers should bear in mind this difference as they interpret the findings in this report.')
                  ),
                  p('Following is a brief description of how non-pre-tax cash income items are estimated. Additional details about each procedure can be found in the report’s technical appendices.', tags$sup('10')),
                  tags$strong('Housing Adjustment'),
                  p('The high cost of housing makes New York City an expensive place to live. The NYCgov poverty threshold, as noted above, is adjusted to reflect that reality. But some New Yorkers do not need to spend as much to secure adequate housing as the higher threshold implies. Many of the city’s low-income families live in public housing or receive a housing subsidy such as a Section 8 housing voucher. A large proportion of New York City’s renters live in rent-regulated apartments. Some homeowners have paid off their mortgages and own their homes free and clear. An upward adjustment is made to these families’ incomes to reflect such advantages. For families living in rent-subsidized housing units, the adjustment equals the smaller of either: a) the difference between what they would pay for their housing if it were market rate and what they actually pay out of pocket, or b) the difference between the housing portion of the NYCgov threshold and what they pay out of pocket. The adjustment is also capped so it cannot exceed the housing portion of the NYCgov threshold. The ACS does not provide data on housing program participation. To determine which households in the ACS could be participants in rental subsidy or regulation programs, households in the Census Bureau’s New York City Housing and Vacancy Survey (HVS) are matched with household-level records in the ACS. (See Appendix C.)'),
                  tags$strong('Taxation'),
                  p('The NYC Opportunity tax model creates tax filing units within the ACS households; computes their adjusted gross income, taxable income, and tax liability; and then estimates net income taxes after nonrefundable and refundable credits are applied. The model takes into account federal, State, and City income tax programs, including all the credits designed to aid low-income filers. The model also includes the effect of the federal payroll tax for Social Security and Medicare (FICA). (See Appendix D.)'),
                  tags$strong('Nutritional Assistance'),
                  p('We estimate the value added to family resources if families receive nutritional assistance. Nutritional assistance includes SNAP; the National School Lunch program; the School Breakfast Program; and the Special Supplemental Nutrition Program for Women, Infants, and Children (WIC). To estimate SNAP benefits, NYC Opportunity makes use of New York City Human Resources Administration (HRA) SNAP records and imputes SNAP cases to potential recipient units constructed within census households. Each dollar of SNAP benefits is counted as a dollar added to family income.'),
                  p('Estimates of school meals programs have changed with City policy. The earliest releases of the NYCgov poverty measure estimated free, reduced, and full-price school meals. School breakfasts are now universally free. School lunches were either free or full price in 2016 and universally free beginning with the 2017 school year. The Census Bureau’s method for valuing income from the programs is followed by using the per-meal cost of the subsidy. WIC program participants are identified by matching enrollment in the program to population participation estimates from the New York State Department of Health. Benefits are calculated using the average benefit level per participant calculated by the U.S. Department of Agriculture. (See Appendix E.)'),
                  tags$strong('Home Energy Assistance Program'),
                  p('The Home Energy Assistance Program (HEAP) provides assistance to low-income households in order to offset their utility costs. In New York City, households that receive cash assistance, SNAP, or are composed of a single person receiving SSI benefits are automatically enrolled in the program. Other low-income households can apply for HEAP, but administrative data from the City’s HRA indicate that nearly all HEAP households enter the program through their participation in other benefit programs. HEAP- receiving households are therefore first identified by their participation in public assistance, SNAP, or SSI, then the appropriate benefit is added to their income. Beginning with the 2018 data, HEAP recipiency going back to 2013 was recalculated, adding homeowners and households receiving NYCgov-imputed SNAP benefits to consideration for receiving imputed HEAP benefits. (See Appendix F.)'),
                  tags$strong('Work-Related Expenses (Transportation and Child Care'),
                  p('Since workers generally travel to and from their jobs, the cost of that travel is treated as a nondiscretionary expense. The number of trips a worker makes per week is estimated based on their usual weekly hours. The cost per trip is calculated using information in the ACS about mode of transportation, while administrative data such as subway fares is also included. Weekly commuting costs are computed by multiplying cost per trip by the number of trips per week. Annual commuting costs equal weekly costs times the number of weeks worked over the past 12 months.'),
                  p('Families in which parents are working must often pay for the care of their young children. Like the cost of commuting, the NYCgov poverty measure treats these childcare expenses as a nondiscretionary reduction in income. Because the ACS provides no information on childcare spending, NYC Opportunity created an imputation model that matches the weekly childcare expenditures reported in the Census Bureau’s Survey of Income and Program Participation (SIPP) to working families with children in the ACS data set. Childcare costs are consistent with the percent of the year the parents worked and are capped by the earned income of the lowest earning parent. (See Appendix G.)'),
                  tags$strong('Medical Out-of-Pocket Expenditures (MOOP)'),
                  p('The cost of medical care is also treated as a nondiscretionary expense that limits the ability of families to attain the standard of living represented by the poverty threshold. MOOP includes health insurance premiums, co-pays, and deductibles, as well as the cost of medical services that are not covered by insurance. In a manner similar to that used for childcare, an imputation model matches MOOP expenditures by families included in the Agency for Healthcare Research and Quality’s Medical Expenditure Panel Survey (MEPS) to similar families in the ACS sample. (See Appendix H.)'),
                  # FOOTNOTES
                  hr(),
                  h6('[7] Until 2017, the NYCgov poverty measure was released as the “CEO Poverty Measure” under the auspices of the New York City Center for Economic Opportunity, now the Mayor’s Office for Economic Opportunity.'),
                  h6('[8] See: ', a('link', href = 'https://www.bls.gov/pir/spm/spm_thresholds_2019.htm', target = '_blank')),
                  h6('[9] See Appendix C, Housing, for more on housing adjustments.'),
                  h6('[10] See: ', a('link', href = 'https://www1.nyc.gov/site/opportunity/poverty-in-nyc/poverty-measure.page', target = '_blank'))
                ),
                box(
                  title = '3.4 | Comparing Poverty Rates',
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
                  p('The NYCgov income measure is constructed using a method conceptually similar to the SPM. Both measures differ from the official poverty measure. Table 3.1 compares the poverty rates and thresholds of the NYCgov measure to the U.S. official measure and the SPM.'),
                  h2('Table 3.1: Change in Poverty Rates and Thresholds: NYCgov, U.S. Official, and SPM, 2015–2019'),
                  p('The most significant differences between the official measure and the NAS-based alternatives are the outcomes in poverty rates by age and the distribution of poverty rates based on the ratio of incomes to the threshold, in particular, the portions of the population in extreme poverty and near poverty.'),
                  p('Table 3.2 provides 2019 poverty rates by age using the official and NAS-style measures. The poverty rates are broken out by degrees of poverty: those with resources below the poverty threshold, those with resources at no more than 50 percent of the poverty threshold, and those not in poverty but with resources at just 150 percent of the poverty threshold. In the table, these categories are labeled as poverty, deep poverty, and near poverty, respectively. Panel A of each section reports the data for the United States,', tags$sup('11'), ' while Panel B provides the data for New York City.'),
                  h2('Table 3.2: Poverty Rates by Degree and Age Group Using Different Measures, 2019'),
                  p('Differences between the official and SPM measures for the nation are comparable to differences between the official and NYCgov measures for New York City. For the total population, poverty rates that use the alternative measures exceed poverty rates that use the official measure.'),
                  tags$strong('Age'),
                  p('Given anti-poverty policy’s focus on children, differences in poverty rates by age group are a particularly important set of comparisons. One distinguishing factor between the U.S. official measure and alternative poverty measures is that despite their overall higher poverty rate, alternative measures yield child poverty rates that are below the official poverty rates. The lower child poverty rates under the NAS-style measures shed light on the effectiveness of government benefit programs – many of which are targeted toward families with children. Note that the alternative measures find fewer children in deep poverty when accounting for greater benefits and tax credits for families with children (see Table 3.2). This is further proof that government benefits which are not counted in the U.S. official poverty measure effectively reduce child poverty.'),
                  p('Poverty rates for the elderly, however, are higher under NAS-style measures than under the U.S. official measure. This is primarily a result of the alternative measures’ deduction of MOOP expenses from the income measure – an important factor when considering the higher medical costs encountered by the elderly.'),
                  tags$strong('Degrees of Poverty'),
                  p('Table 3.2 also compares deep poverty rates for the United States and New York City, by age, using the official, SPM, and NYCgov measures. A smaller fraction of the nation’s population is in deep poverty using the alternative poverty measure. Differences across age groups are similar. For the nation and the city, the largest difference between the official and alternative measures of deep poverty is in the child poverty rate, which is higher using the official measure. Differences between the measures for working age adults in deep poverty are more modest. When using alternative measures, the pattern of lower rates of deep poverty is reversed for the elderly. Historically, the alternative measures have found a higher incidence of deep poverty for persons 65 and older than the official measure.'),
                  p('The final section of Table 3.2 reports the share of the U.S. and New York City population that is near poor (living between 100 and 150 percent of their poverty threshold) in the official and NAS-based poverty measures. The SPM places a much larger share of the population in near poverty than does the U.S. official measure. The near poverty rate estimated with the NYCgov measure is higher still. One reason for this is the geographic adjustment that accounts for the relatively high cost of housing in the city. The resulting NYCgov poverty threshold is higher than the U.S.-wide SPM poverty threshold. More space exists between the poverty and the near poverty thresholds than in other measures. The resulting NYCgov rate categorizes a much larger share of the population as near poor because the income band that defines the group is higher and wider.'),
                  # FOOTNOTES
                  hr(),
                  h6('11 The U.S.-level SPM poverty rates cited in this chapter are taken from Fox, 2020.'),
                ),
              )
      ),
      
      ## Report: Appendices ----
      tabItem("report_appendices",
              fluidPage(
                h1("Appendices"),
                hr(),
                includeMarkdown('markdown/appendices.md')
              )
      ),
      
      # Data ----
      ## Data Spotlight -----
      tabItem(tabName = "data_spotlight",
              h1("Spotlight"),
              h3("New York City, 2019"),
              hr(),
              fluidRow(
                infoBox("Citizens In Poverty", format(round(8420000 * .179, 2), big.mark = ","),
                        icon = icon("file-invoice-dollar"),
                        color = "blue"),
                infoBox("Children In Poverty", format(437000, big.mark = ","),
                        icon = icon("child"),
                        color = "light-blue"),
                infoBox("Gap Amount ($ billions)", 6.5, icon = icon("piggy-bank"),
                        color = 'teal')
                ),
              hr(),
              fluidRow(
                box(
                  title = 'Poverty by Income',
                  width = 12,
                  column(width = 8,
                         plotOutput('data_spotlight_plot')),
                  column(width = 4,
                         # avoid extra tick marks in slider with css
                         tags$style(type = "text/css", ".irs-grid-pol.small {height: 0px;}"),
                         sliderInput('data_spotlight_slider', h4('Year'), sep = "",
                                     animate = TRUE, round = TRUE, step = 1,
                                     min = 2005, max = 2018, value = 2018)
                         )
                  )
                )
              ),
      ## Data Detail ----
      tabItem(tabName = 'data_detail',
              fluidPage(
                h1('Data Detail'),
                h3('How do you compare?'),
                p('Make your selections below to see what poverty in New York looks like for people like ', tags$strong('you'), ' in 2019!'),
                fluidRow(
                  box(
                    title = 'Income Distribution (2018)',
                    width = 9,
                    status = 'primary',
                    tabsetPanel(type = "tabs",
                                tabPanel("Plot", plotOutput("plot_data_detail")),
                                tabPanel("PlotAlt", plotOutput('data_detail_plot2')),
                                tabPanel("Source/Notes",
                                         tags$strong('Source:'),
                                         'American Community Survey Public Use Micro Sample as augmented by NYC Opportunity. U.S. official threshold from U.S. Census Bureau.',
                                         br(),
                                         br(),
                                         tags$strong('Notes:'),
                                         'Numbers in bold indicate a statistically significant change from prior year. U.S. official poverty rates are based on the NYCgov poverty universe and unit of analysis. See Appendix A for details.')
                    ),
                    code(textOutput("age_range"))
                  ),
                  box(
                    title = "Options",
                    width = 3,
                    status = 'primary',
                    sliderInput("data_detail_age_slider", label = "Age + 10",
                                min = 18, max = 90, value = 37),
                    # selectInput("data_detail_sex_select", label = "Sex",
                    #             c("Female" = "Female",
                    #               "Male" = "Male")
                    #               ),
                    selectInput("data_detail_famtype_select", label = "Living Situation",
                                c('Husband/Wife + child' = 'Husband/Wife + child',
                                  'Husband/Wife no child' = 'Husband/Wife no child',
                                  'Single Male + child' = 'Single Male + child',
                                  'Single Female + child' = 'Single Female + child',
                                  'Male unit head, no child' = 'Male unit head, no child',
                                  'Female unit head, no child' = 'Female unit head, no child',
                                  'Unrelated Indiv w/others' = 'Unrelated Indiv w/others',
                                  'Unrelated Indiv Alone' = 'Unrelated Indiv Alone'
                                )
                    ),
                    selectInput("select_data_detail_borough", label = "Borough",
                                c("Bronx" = "Bronx",
                                  "Brooklyn" = "Brooklyn",
                                  "Manhattan" = "Manhattan",
                                  "Queens" = "Queens",
                                  "Staten Island" = "Staten Island")
                    ),
                    selectInput("select_data_detail_education", label = "Education",
                                c("< High School" = "< High School",
                                  "High School Degree" = "High School Degree",
                                  "Some College" = "Some College",
                                  "Bachelor Degree+" = "Bachelor Degree+"),
                    )
                  )
                )
              )),
      ## Data Comparison ----
      tabItem(tabName = "data_comparison",
              fluidPage(
                h1('Data Comparison'),
                h3('Drill down into the data...'),
                p('Make your selections below to better understand what poverty looks like based on multiple parameters you can select.'),
                hr(),
                fluidRow(
                  box(
                    title = "Options",
                    width = 12,
                    status = 'primary',
                    column(4,
                           selectizeInput("checkbox_data_comparison_year", 
                                          label = "Select year(s)", 
                                          choices = c("2016" = 2016, 
                                                      "2017" = 2017, 
                                                      "2018" = 2018),
                                          selected = 2016,
                                          multiple = TRUE),
                           selectizeInput(
                             inputId = 'selectize_data_comparison_pop_characteristics',
                             label = 'Sub-Population',
                             choices = c(
                               'Age' = 'Age_Categ',
                               'Borough' = 'Boro',
                               'Disability' = 'DIS',
                               'Educational Attainment' = 'EducAttain',
                               'Ethnicity' = 'Ethnicity',
                               'Housing Status' = 'TEN',
                               'Sex' = 'SEX'
                             ),
                             selected = 'Boro',
                             multiple = TRUE
                           )
                    ),
                    
                    column(8,
                           markdown("
                                    #### Note
                                    - Grayed out rows indicate an unreliable estimate due to low sample size
                                    - `Count` is a weighted value
                                    - Click on an option and press delete to remove them from the data table
                                    - You can sort the table by any column by clicking on the header
                                    ")
                    )
                  ),
                  box(
                    title = 'NYC Poverty Data',
                    width = 12,
                    status = 'primary',
                    # Button
                    actionButton("download_comp_data", "Downloads", icon = icon("copy")),
                    # downloadButton(outputId = "download_comp_data", label = "Download"),
                    dataTableOutput("table_data_comparison_1"),
                    hr(),
                    h6(tags$strong('Source: '), 'American Community Survey Public Use Micro Sample as augmented by NYC Opportunity. U.S. official threshold from U.S. Census Bureau.')
                    )
                  )
                )
            ),
      ## Data Policy ----
      tabItem(tabName = "data_policy",
              fluidPage(
                h1('Data Policy'),
                h3('What would happen to poverty in NYC under alterntive policies?')
              )
      )
      
    )
  )
)


# SERVER ----
server <- function(input, output) {
  # set CI for plots
  plot_ci = 1.645 # 90%
  
  ## Load Data ----
  df = readRDS("data/dataset.RDS")

  profile_finances = read_csv('temp_data/monthly_spend.csv')

  output$table_jane_doe <- renderDataTable(profile_finances,
                                            options = list(
                                              pageLength = nrow(profile_finances),
                                              dom = 't',
                                              initComplete = JS(
                                                "function(settings, json) {",
                                                "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                                                "}")))
  
  output$table_john_doe <- renderDataTable(profile_finances,
                                           options = list(
                                             pageLength = nrow(profile_finances),
                                             dom = 't',
                                             initComplete = JS(
                                               "function(settings, json) {",
                                               "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                                               "}")))
  
  ## Report ----
  
  # 1.1 Create datatable
  df_1_1 <- reactive({
      df %>%
      filter(year>=input$slider_1_1[1] & year<=input$slider_1_1[2]) %>% # year range
      select(year, PWGTP, Off_Pov_Stat, NYCgov_Pov_Stat) %>%
      gather(measure, status, Off_Pov_Stat:NYCgov_Pov_Stat) %>%
      group_by(year, measure) %>%
      summarise(
        percentage = round(sum((PWGTP*status)) / sum(PWGTP) * 100, 2),
        se = (sqrt((sum((PWGTP*status)/sum(PWGTP)) * (1-sum((PWGTP*status)/sum(PWGTP)))) / (n()-1)))*100
      )
  })
  
  # 1.1 Plot
  output$plot_1_1_rate <- renderPlot({
    df_1_1() %>%
      ggplot(aes(x=year, y=percentage,
                 colour= measure,
                 fill = measure)) +
      geom_line(aes(x=year)) + geom_point() +
      geom_ribbon(aes(ymin=percentage-plot_ci*se, ymax=percentage+plot_ci*se),
                  alpha = 0.2, colour = NA) +
      scale_x_continuous(breaks=unique(df$year)) +
      labs(#title = paste0("NYCgov Poverty Rates by ", input$select_1_2_options),
        x = 'Year', y = 'Percentage (%)')   +
      scale_fill_discrete(name = "Poverty Measure", labels = c("NYCgov", "Official")) +
      scale_colour_discrete(name = "Poverty Measure", labels = c("NYCgov", "Official")) +
      theme_minimal() +
      theme(text=element_text(size=14))
    # ggplotly() this was giving some weird formatting of the legend
  })
  
  # 1.1 Table
  output$table_1_1_rate <- renderDataTable(
    df_1_1(),
    extensions = 'Buttons', 
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    )
  
  # 1.2 Create Datatable
  df_1_2 <- reactive({
    if (input$radio_1_2=='family') {
      df %>%
        filter(AGEP<65) %>% # avoid fact that official measure has two different rates for above/below 65
        filter(year>=input$slider_1_2[1] & year<=input$slider_1_2[2]) %>% # year range
        filter(NP == 4 & FamType_PU == 'Husband/Wife + child') %>%
        select(year, Off_Threshold, NYCgov_Threshold) %>%
        distinct(year, .keep_all= TRUE) %>%
        gather(threshold, amount, Off_Threshold:NYCgov_Threshold)
    }
    else{
      df %>%
        filter(AGEP<65) %>% # avoid fact that official measure has two different rates for above/below 65
        filter(year>=input$slider_1_2[1] & year<=input$slider_1_2[2]) %>% # year range
        filter(NP == 1) %>%
        select(year, Off_Threshold, NYCgov_Threshold) %>%
        distinct(year, .keep_all= TRUE) %>%
        gather(threshold, amount, Off_Threshold:NYCgov_Threshold)
    }
  })
  
  # 1.2 Plot
  output$plot_1_2_threshold <- renderPlotly({
    plot_ly(df_1_2(), x=~year, y=~amount,
            type="scatter",color=~threshold, mode="lines+markers")
  })
  
  # 1.2 Table
  output$table_1_2_threshold <- renderDataTable(
    df_1_2(),
    extensions = 'Buttons', options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
    )
  )
  
  # Section 1.2
  section_1_2_fig_3to10 = reactive({
    if (req(input$select_1_2_options) == 'ethnicity_sex'){
      df %>%
        group_by(year, SEX, Ethnicity) %>%
        summarise(
          cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat)) / sum(PWGTP) * 100, 2),
          se = (sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100
        )
    }
    else{
      df %>%
        group_by(!!!syms(append('year', input$select_1_2_options))) %>%
        summarise(
          # category percentage
          cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat)) / sum(PWGTP) * 100, 2),
          # standard error
          se = (sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100
        )
    }
  })
  
  
  # Section 1.2: 1.3-1.10 Plots
  output$plot_1_2_fig_3to10 <- renderPlot({
    if (req(input$select_1_2_options) == 'ethnicity_sex'){
      df %>%
        group_by(year, SEX, Ethnicity) %>%
        summarise(
          cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat)) / sum(PWGTP) * 100, 2),
          se = (sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100
        ) %>%
        ggplot(aes(x=year, y=cat_perc, colour=Ethnicity, fill=Ethnicity)) + 
        geom_line(aes(x=year)) + geom_point() +
        geom_ribbon(aes(ymin=cat_perc-plot_ci*se, ymax=cat_perc+plot_ci*se), alpha = 0.2, colour = NA) +
        scale_x_continuous(breaks=unique(df$year)) +
        ggtitle(paste0("Poverty Rates, Race and Ethnicity by Gender")) +
        scale_color_brewer(palette="Paired") +
        theme_minimal() +
        facet_wrap(~SEX, ncol = 1)
        
    }
    else{
      df %>%
        group_by(!!!syms(append('year', input$select_1_2_options))) %>%
        summarise(
          # category percentage
          cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat)) / sum(PWGTP) * 100, 2),
          # standard error
          se = (sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100
        ) %>%
        ggplot(aes(x=year, y=cat_perc,
                   colour=!!sym(input$select_1_2_options),
                   fill = !!sym(input$select_1_2_options))) +
        geom_line(aes(x=year)) + geom_point() +
        geom_ribbon(aes(ymin=cat_perc-plot_ci*se, ymax=cat_perc+plot_ci*se),
                    alpha = 0.2, colour = NA) +
        scale_x_continuous(breaks=unique(df$year)) +
        labs(#title = paste0("NYCgov Poverty Rates by ", input$select_1_2_options),
             x = 'Year', y = 'Percentage (%)') +
        theme_minimal() +
        theme(legend.title = element_blank(), text=element_text(size=14))
    }
  })
  
  # Section 1.2: 1.3-1.10 Tables
  output$table_1_2_fig_3to10 <- renderDataTable(
    section_1_2_fig_3to10(),
    extensions = 'Buttons', options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
    )
  )
  
  ## Data ----

  ## Data Spotlight ----
  spotlight_data = reactive({
    df %>%
      filter(year == input$data_spotlight_slider)
  })
  color_palette_blues = c('#6b76c7', '#7db0ea', '#3059c9', '#38aad6', '#9ffffd')
  ## Plot
  output$data_spotlight_plot <- renderPlot({
    ggplot(spotlight_data(), aes(x = NYCgov_Income, fill = NYCgov_Pov_Stat)) + 
    # geom_density(alpha = 0.5) +
    geom_histogram(alpha = 0.5, position = 'identity', bins = 100) +
    scale_fill_manual(name = "Status", labels = c("Not in Poverty", "In Poverty"),
                      values=color_palette_blues[1:2]) +
    scale_x_continuous(label=scales::comma, limits=c(0, 200000)) +
    labs(x = 'Income ($)', y = 'Proportion') +
    # scale_fill_discrete(name = "Status", labels = c("Not in Poverty", "In Poverty")) +
    #  scale_fill_brewer(guide="none") +
    theme_minimal() + 
    theme(axis.text.y  = element_blank())
  })
  
  ## Data Detail ----
  # Text for age slider
  output$age_range <- renderText({
    paste0(as.character(input$data_detail_age_slider), ' - ',
           as.character(input$data_detail_age_slider + 10), ' year old ',
           input$data_detail_famtype_select, ' living in ',
           input$select_data_detail_borough, ' with ', input$select_data_detail_education)
  })
  # KDE Plot
  output$plot_data_detail <- renderPlot({

    df_detail = df %>%
      filter(year == 2018) %>%
      filter(FamType_PU == input$data_detail_famtype_select) %>%
      # filter(SEX == input$data_detail_sex_select) %>%
      filter(AGEP >= input$data_detail_age_slider & AGEP <= (input$data_detail_age_slider + 10)) %>%
      filter(Boro == input$select_data_detail_borough) %>%
      filter(EducAttain == input$select_data_detail_education) 
    
    # what is the poverty threshold for this group
    # add number of kids?
    poverty = mean(df_detail$NYCgov_Threshold)
    print(poverty)
    near_poverty = poverty * 1.5
    
    incomes = df_detail %>%
      pull('NYCgov_Income')
    
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
                 size=3.5 , angle=45, fontface="bold" ) +
      theme_classic() +
      theme(axis.text.y = element_blank(), text=element_text(size=14))
  })
  
  # Alt plot
  
  
  ## Data Comparison ----
  # color palette: https://coolors.co/d9ed92-b5e48c-99d98c-76c893-52b69a-34a0a4-168aad-1a759f-1e6091-184e77
  color_palette = c('#d9ed92', '#b5e48c', '#99d98c', '#76c893', '#52b69a',
                    '34A0A4', '#168AAD', '#1A759F', '#1E6091', '#184E77')

  comparison_df = reactive({
    validate(
      need(input$checkbox_data_comparison_year, 'Select at least one year'),
      need(input$selectize_data_comparison_pop_characteristics != '', 'Choose comparison dimensions')
    )
    
    dt = filter(df, year == input$checkbox_data_comparison_year) %>%
      # this is making it take the list as var names (below)
      group_by(!!!syms(append('year', input$selectize_data_comparison_pop_characteristics))) %>%
      summarise(cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat)) / sum(PWGTP) * 100, 2),
                citywide_perc = round( (sum(PWGTP*NYCgov_Pov_Stat) / mean(population)) * 100, 2),
                n_pov_weighted = sum((PWGTP*NYCgov_Pov_Stat)),
                # n_sample = length(PWGTP),
                # n_weighted = sum(PWGTP),
                # se calc. based on binomial property for variance (p * 1-p)
                ## https://www.sapling.com/6183888/calculate-sampling-error-percentages
                # se = round((sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100, 2),
                ## coefficient of variation (https://influentialpoints.com/Training/coefficient_of_variation_of_a_mean.htm)
                cv = round((100*sd(NYCgov_Pov_Stat)) / (mean(NYCgov_Pov_Stat) * sqrt(n())), 2),
                ci90 = round(qnorm(0.95) * (sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100, 2)
      ) %>%
      drop_na()
  })
    
  comparison_dt = reactive({
    validate(
      need(input$checkbox_data_comparison_year, 'Select at least one year'),
      need(input$selectize_data_comparison_pop_characteristics != '', 'Choose comparison dimensions')
    )

    dt = filter(df, year == input$checkbox_data_comparison_year) %>%
      # this is making it take the list as var names (below)
      group_by(!!!syms(append('year', input$selectize_data_comparison_pop_characteristics))) %>%
      summarise(cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat)) / sum(PWGTP) * 100, 2),
                citywide_perc = round( (sum(PWGTP*NYCgov_Pov_Stat) / mean(population)) * 100, 2),
                n_pov_weighted = sum((PWGTP*NYCgov_Pov_Stat)),
                # n_sample = length(PWGTP),
                # n_weighted = sum(PWGTP),
                # se calc. based on binomial property for variance (p * 1-p)
                ## https://www.sapling.com/6183888/calculate-sampling-error-percentages
                # se = round((sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100, 2),
                ## coefficient of variation (https://influentialpoints.com/Training/coefficient_of_variation_of_a_mean.htm)
                cv = round((100*sd(NYCgov_Pov_Stat)) / (mean(NYCgov_Pov_Stat) * sqrt(n())), 2),
                ci90 = round(qnorm(0.95) * (sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100, 2)
      ) %>%
      drop_na() %>%
      datatable(extensions = list('Buttons'),
                options = list(
                  dom = 'Bfrtip',
                  scrollX = TRUE,
                  scrollY = "400px",
                  paging = FALSE,
                  buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                ),
                colnames = c('Year' = 'year', 'Cat. %' = 'cat_perc',
                             '95% CI' = 'ci95', 'Count' = 'n_pov_weighted',
                             'Pop. %' = 'citywide_perc', 'CV' = 'cv'
                             )
                ) 
    dt = dt %>%
      # add bars for category percentage and weighted poverty n
      formatStyle('Cat. %',
                  background = styleColorBar(range(0,50), 'lightblue'),
                  backgroundSize = '98% 88%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center') %>%
      formatStyle('Count',
                  background = styleColorBar(range(0,2e6), 'lightblue'),
                  backgroundSize = '98% 88%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center') %>%
      formatStyle('CV',
                  target = 'row',
                  backgroundColor = styleInterval(15, c('', 'gray'))) %>%
      formatStyle('Year',
                  backgroundColor = styleEqual(unique(na.omit(df$year)), brewer.pal(n = length(unique(na.omit(df$year))), name = 'Blues')))
    
    # color columns super hack style
    if ('Boro' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('boro',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$boro))), color_palette[1:length(unique(na.omit(df$boro)))]))}
    if ('AgeCateg' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('AgeCateg',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$age_categ))), color_palette[1:length(unique(na.omit(df$age_categ)))]))}
    if ('EducAttain' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('EducAttain',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$EducAttain))), color_palette[1:length(unique(na.omit(df$EducAttain)))]))}
    if ('SEX' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('SEX',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$sex))), color_palette[1:length(unique(na.omit(df$sex)))]))}
    if ('Ethnicity' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('Ethnicity',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$ethnicity))), color_palette[1:length(unique(na.omit(df$ethnicity)))]))}
    if ('DIS' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('DIS',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$dis))), color_palette[1:length(unique(na.omit(df$dis)))]))}
    if ('TEN' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('TEN',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$ten))), color_palette[1:length(unique(na.omit(df$ten)))]))}
    dt
  })
  
  output$table_data_comparison_1 <- renderDataTable(
    comparison_dt(),
    )
  
  # Downloadable files of selected dataset ----
  myModal <- function() {
    div(id = "test",
        modalDialog(downloadButton("download_comp_data_csv","CSV"),
                    downloadButton("download_comp_data_tsv","TSV"),
                    downloadButton("download_comp_data_xlsx","Excel"),
                    easyClose = TRUE, title = "Download Data")
    )
  }
  
  # open modal on button click
  observeEvent(input$download_comp_data,
               ignoreNULL = TRUE,   # Show modal on start up
               showModal(myModal())
  )
  
  output$download_comp_data_csv <- downloadHandler(
    filename = function() {
      paste('NYCgov_', str_c(input$selectize_data_comparison_pop_characteristics, collapse = '-'), '_', Sys.Date(), '.csv', sep = '') 
    },
    content = function(file) {
      write.csv(as.data.frame(comparison_df()), file, row.names = FALSE)
    }
  )
  
  output$download_comp_data_tsv <- downloadHandler(
    filename = function() {
      paste('NYCgov_', str_c(input$selectize_data_comparison_pop_characteristics, collapse = '-'), '_', Sys.Date(), '.tsv', sep = '') 
    },
    content = function(file) {
      write_tsv(as.data.frame(comparison_df()), file)
    }
  )
  
  output$download_comp_data_xlsx <- downloadHandler(
    filename = function() {
      paste('NYCgov_', str_c(input$selectize_data_comparison_pop_characteristics, collapse = '-'), '_', Sys.Date(), '.xlsx', sep = '') 
    },
    content = function(file) {
      write.xlsx(as.data.frame(comparison_df()), file, rowNames = FALSE)
    }
  )
  
    # output$downloadData <- downloadHandler(
  #   filename = function() {
  #     paste('NYCgov_', str_c(input$selectize_data_comparison_pop_characteristics, collapse = '-'), '_', Sys.Date(), '.csv', sep = '') 
  #   },
  #   content = function(file) {
  #     print(head(as.data.frame(comparison_df())))
  #     write.csv(as.data.frame(comparison_df()), file, row.names = FALSE)
  #   }
  # )
}

shinyApp(ui, server)

