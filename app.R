# IMPORTS ----
library(tidyverse)
library(shiny)
library(shinydashboard)
library(DT)
library(data.table)
library(markdown) #to include markdown text
library(RColorBrewer) #for color palette
library(openxlsx) #to output excel files
library(viridis) #for color palette
library(plotly) #alternate plotting library
library(sf) #simple features access for mapping
library(geojsonsf) #simple feature convertor
library(leaflet) #interactive maps


# DASHBOARD ----
ui <- dashboardPage(
  dashboardHeader(title = "NYC Poverty Research Unit"),
  
  ## SIDEBAR----
  dashboardSidebar(
    sidebarMenu(
      ### Poverty ----
      menuItem("Background", tabName = "poverty_about", icon = icon("search-dollar")
               ),
      ### Report -----
      menuItem("Report", tabName = "report", icon = icon("file-alt"),
               menuSubItem('About', tabName = 'report_about'),
               menuSubItem('Key Findings', tabName = 'report_key_findings'),
               menuSubItem('Measuring Poverty', tabName = 'report_measuring'),
               menuSubItem('Appendices', tabName = 'report_appendices')
      ),
      ### Data -----
      menuItem("Data", tabName = "data", icon = icon("chart-bar"),
               menuSubItem('Spotlight', tabName = 'data_spotlight'),
               menuSubItem('Detail', tabName = 'data_detail'),
               menuSubItem('Comparison', tabName = 'data_comparison'),
               menuSubItem('Map', tabName = 'data_map')
      )
    )
  ),
  
  ## BODY ----
  dashboardBody(
    tags$head(tags$style("#test .modal-body {width: auto; height: auto;}"),
              #css file is saved in the `www` folder
              tags$link(rel = 'stylesheet', type = 'text/css', href = 'custom_styling.css')),
    tabItems(
      ### Poverty ----
      #### Poverty About -----
      tabItem(tabName = "poverty_about",
              fluidPage(
                h3('About Us'),
                box(
                  width = 12,
                  status = 'primary',
                  column(
                    width = 12,
                    markdown("
                             The Poverty Research Team is part of the the [New York City Mayor's Office for Economic Opportunity](http://www1.nyc.gov/site/opportunity/index.page).
                             
                             The Poverty Research Unit applies data analytics to build an accurate description of who is in poverty, identify some of the leading causes for being in poverty, and measuring how citywide programs work to offset the poverty rate.
                             
                             This data allows NYC Opportunity to better target anti-poverty initiatives and design more effect metrics in measuring success..
                             ")
                  ),
                ),
                hr(),
                h3('About the PRU Web App'),
                box(
                  width = 12,
                  status = 'primary',
                  column(
                    width = 12,
                    markdown("
                             The goal the PRU web app is to provide broader access to the annual New York City poverty report produced by the office each year.
                             
                             The app allows users to see key insights from the `Report`, as well as to dynamically interact, visualize and download the `Data` contained in the report.
                             ")
                  ),
                ),
                hr(),
                h3('About Poverty'),
                box(
                  title = "What is Poverty?",
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 12,
                  status = 'primary',
                  solidHeader = TRUE,
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
                  column(
                    width = 12,
                    hr(),
                    p('Echoes of Adam Smith\'s definition of poverty from almost 250 years ago can be found in a more recent defintion provided by ', a('The World Bank', href = 'https://www.worldbank.org/en/home', target = '_blank'), ':'),
                    p(em('Poverty is hunger. Poverty is lack of shelter. Poverty is being sick and not being able to see a doctor. Poverty is not having access to school and not knowing how to read. Poverty is not having a job, is fear for the future, living one day at a time. Poverty has many faces, changing from place to place and across time, and has been described in many ways.  Most often, poverty is a situation people want to escape. So poverty is a call to action -- for the poor and the wealthy alike -- a call to change the world so that many more may have enough to eat, adequate shelter, access to education and health, protection from violence, and a voice in what happens in their communities.', style = "font-family: 'times'; font-size: 16px")),
                    hr(),
                    p('If we agree that poverty ', tags$strong('is '), tags$em('a call to action '), ', then a natural question is what should that action be?'),
                    p('We believe that a first step is to establish a meaningful financial threshold defining poverty, and then measuring which people fall above and below  that threshold.')
                  )
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
      
      ### Report ----
      #### Report: About -----
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
      #### Report: Key Findings ----
      tabItem("report_key_findings",
              fluidPage(
                h1("Key Findings"),
                p('The New York City Government (NYCgov) poverty measure is a measure of poverty adapted to the realities of the city’s economy. The poverty threshold accounts for housing costs that are higher than the national average. The measure of family resources includes public benefits and tax credits, but also acknowledges spending on medical costs and work-related expenses such as childcare and commuting.'),
                p('The NYCgov poverty rate, threshold, and income measure are higher than those same figures in the U.S. official measure.'),
                hr(),
                fluidRow(
                  box(
                    title = '1 | Poverty in New York City, 2019',
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
                        title = textOutput('report_keyfindings_plot_1_1_title'),
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
                        title = textOutput('report_keyfindings_plot_1_2_title'),
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
                    title = '2 | Differences in New York City Rates by Demographics and Geography',
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
                    box(
                      #title = 'NYCgov Poverty Rates, 2015–2019',
                      width = 12,
                      status = 'primary',
                      h3(textOutput('report_multiplot_title')),
                      hr(),
                      column(4,
                             selectInput("report_keyfindings_multiplot_group_select1", label = "Grouping 1", 
                                         choices = list("Age" = 'AgeCateg', "Sex" = 'SEX',
                                                        "Race/Ethnicity" = 'Ethnicity',
                                                        "Citizenship Status" = 'CitizenStatus',
                                                        "Educational Attainment" = 'EducAttain',
                                                        "Work Experience" = 'FTPTWork',
                                                        "Borough" = 'Boro'
                                                        ), selected = 'AgeCateg')
                             ),
                      column(4,
                             selectInput("report_keyfindings_multiplot_group_select2", label = "Grouping 2",
                                         choices = list("-" = "None", "Age" = 'AgeCateg', "Sex" = 'SEX',
                                                        "Race/Ethnicity" = 'Ethnicity',
                                                        "Citizenship Status" = 'CitizenStatus',
                                                        "Educational Attainment" = 'EducAttain',
                                                        "Work Experience" = 'FTPTWork',
                                                        "Borough" = 'Boro'
                                         ), selected = 'None')
                             ),
                      column(4,
                             sliderInput("report_keyfindings_multiplot_year_slider", 
                                         label = "Year(s)", min = 2005, 
                                         max = 2019, value = c(2015, 2019), sep='', ticks = FALSE)
                      )
                    ),
                    fluidRow(
                      column(11,
                             tabsetPanel(type = "tabs",
                                         tabPanel("Plot", plotOutput("plot_1_2_fig_3to10")),
                                         tabPanel("Data", dataTableOutput('table_1_2_fig_3to10')),
                                         tabPanel("Source/Notes",
                                                  tags$strong('Source:'),
                                                  'American Community Survey Public Use Micro Sample as augmented by NYC Opportunity. U.S. official threshold from U.S. Census Bureau.'
                                         )
                             )
                      )
                    ),
                    #h4('Figure 1.11: Percentage of Population Below Poverty Threshold, by Neighborhood, 2015–2019'),
                    #h4('Table 1.2: Racial and Ethnic Composition of Community Districts (CDs) with Highest and Lowest Poverty Rates, 2015–2019')
                  )
                ),
                fluidRow(
                  box(
                    title = '3 | What Drives the Poverty Rate: The New York City Labor Market, Wages, and Income Supports',
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
                    title = '4 | The Distribution of Poverty and the Safety Net',
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
                    title = '5 | The NYCgov Poverty Measure',
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
      #### Report: Measuring Poverty ----
      tabItem("report_measuring",
              fluidPage(
                h1("Measuring Poverty"),
                h3('The NYCgov Poverty Measure Compared to U.S. Official and U.S. Supplemental Poverty Measures'),
                box(
                  title = '1 | The Need for an Alternative to the U.S. Official Poverty Measure',
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
                  title = '2 | Alternative Measures: The National Academy of Sciences’ Recommendations and the Supplemental Poverty Measure',
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
                  title = '3 | NYC Opportunity’s Adoption of the NAS/SPM Method',
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
                  title = '4 | Comparing Poverty Rates',
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
      
      #### Report: Appendices ----
      tabItem("report_appendices",
              fluidPage(
                h1("Appendices"),
                hr(),
                includeMarkdown('markdown/appendices.md')
              )
      ),
      
      ### Data ----
      #### Data: Spotlight -----
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
      #### Data: Detail ----
      tabItem(tabName = 'data_detail',
              fluidPage(
                h2('How do you compare?'),
                h5('Make selections below to see what poverty in New York looks like for people like ', tags$strong('you'),'...'),
                fluidRow(
                  box(
                    title = textOutput("age_range"),
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
      #### Data: Comparison ----
      tabItem(tabName = "data_comparison",
              fluidPage(
                h2('Drill down into the data...'),
                p('Make selections below to better understand what poverty looks like for different populations.'),
                hr(),
                fluidRow(
                  box(
                    title = "Options",
                    width = 12,
                    status = 'primary',
                    column(4,
                           selectizeInput("checkbox_data_comparison_year", 
                                          label = "Year(s)", 
                                          choices = c("2005" = 2005,
                                                      "2006" = 2006, 
                                                      "2007" = 2007,
                                                      "2008" = 2008, 
                                                      "2009" = 2009,
                                                      "2010" = 2010, 
                                                      "2011" = 2011,
                                                      "2012" = 2012, 
                                                      "2013" = 2013,
                                                      "2014" = 2014, 
                                                      "2015" = 2015,
                                                      "2016" = 2016, 
                                                      "2017" = 2017, 
                                                      "2018" = 2018),
                                          selected = 2018,
                                          multiple = TRUE),
                           selectizeInput(
                             inputId = 'selectize_data_comparison_pop_characteristics',
                             label = 'Grouping(s)',
                             choices = c(
                               'Age' = 'AgeCateg',
                               'Borough' = 'Boro',
                               'Disability' = 'DIS',
                               'Educational Attainment' = 'EducAttain',
                               'Ethnicity' = 'Ethnicity',
                               'Housing Status' = 'TEN',
                               'Job Sector' = 'NAICSP',
                               'Sex' = 'SEX'
                             ),
                             selected = 'Boro',
                             multiple = TRUE
                           ),
                           checkboxInput("data_comp_filter_checkbox", label = "Remove unreliable data", value = TRUE)
                    ),
                    
                    column(8,
                           markdown("
                                    #### Note
                                    - Rows with a `red background` are unreliable estimates due to low sample size
                                    - **Count** is a weighted value
                                    - Click on a selected option and press *delete* to remove them from the data table
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
      #### Data: Map ----
      tabItem(tabName = "data_map",
              fluidPage(
                box(title = 'Neighborhood Info',
                    status = 'primary',
                    width = 12,
                    column(
                      width = 12,
                      leafletOutput('data_map', height="70vh")
                    ),
                    column(
                      width = 4,
                      sliderInput("data_map_year_slider", label = "Select Year(s)",
                                  min = 2005, max = 2018,
                                  value = c(2015, 2018), sep='', ticks = FALSE)
                    )
                )
              )
      )
      
    )
  )
)


# SERVER ----
server <- function(input, output) {
  ## Set CI for plots ----
  plot_ci = 1.645 # 90%
  
  ## Load Data ----
  df = readRDS("data/dataset.RDS")

  ## Report ----
  ### Key Findings ----
  #### Poverty Rates ----
  # 1.1 Title
  output$report_keyfindings_plot_1_1_title <- renderText({
    paste0('NYCgov and Official Poverty Rates | ', as.character(input$slider_1_1[1]),
           '-', as.character(input$slider_1_1[2]))
  })
  
  # 1.1 Create datatable
  df_1_1 <- reactive({
      df %>%
      filter(year>=input$slider_1_1[1] & year<=input$slider_1_1[2]) %>% # year range
      select(year, PWGTP, Off_Pov_Stat_num, NYCgov_Pov_Stat_num) %>%
      gather(measure, status, Off_Pov_Stat_num:NYCgov_Pov_Stat_num) %>%
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
      labs(x = 'Year', y = 'Percentage (%)')   +
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
  
  #### Poverty Thresholds ----
  # 1.2 Title
  output$report_keyfindings_plot_1_2_title <- renderText({
    paste0('NYCgov and Official Poverty Thresholds | ', as.character(input$slider_1_2[1]),
           '-', as.character(input$slider_1_2[2]))
  })
 
  # 1.2 Create Datatable
  df_1_2 <- reactive({
    if (input$radio_1_2=='family') {
      df %>%
        filter(AGEP<65) %>% # avoid fact that official measure has two different rates for above/below 65
        filter(year>=input$slider_1_2[1] & year<=input$slider_1_2[2]) %>% # year range
        filter(NP == 4) %>% #limit size of poverty unit to 4
        #make sure there are 2 children 1 head, 1 spouse/partner and NO other in the poverty unit
        group_by(SERIALNO) %>%
        filter(!any(Povunit_Rel=='Other') & sum(Povunit_Rel=='Child')==2 & sum(Povunit_Rel=='Head')==1 & sum(Povunit_Rel=='Spouse/Partner')==1) %>%
        ungroup() %>%
        select(year, Off_Threshold, NYCgov_Threshold) %>%
        distinct(year, .keep_all= TRUE) %>%
        gather(threshold, amount, Off_Threshold:NYCgov_Threshold) %>%
        mutate(amount = round(amount, 0))
    }
    else{
      df %>%
        filter(AGEP<65) %>% # avoid fact that official measure has two different rates for above/below 65
        filter(year>=input$slider_1_2[1] & year<=input$slider_1_2[2]) %>% # year range
        filter(PovAdults_PU == 1 & PovKids_PU == 0) %>%
        select(year, Off_Threshold, NYCgov_Threshold) %>%
        distinct(year, .keep_all= TRUE) %>%
        gather(threshold, amount, Off_Threshold:NYCgov_Threshold) %>%
        mutate(amount = round(amount, 0))
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
  
  #### Demographics ----
  
  # Title
  output$report_multiplot_title <- renderText({
    paste0('NYCgov Poverty Rates | ', as.character(input$report_keyfindings_multiplot_year_slider[1]),
           '-', as.character(input$report_keyfindings_multiplot_year_slider[2]))
  })
  
  # Datatable
  section_1_2_fig_3to10 = reactive({
    if (req(input$report_keyfindings_multiplot_group_select2) != 'None'){
      df %>%
        filter(year>=input$report_keyfindings_multiplot_year_slider[1] & year<=input$report_keyfindings_multiplot_year_slider[1]) %>%
        group_by(!!!syms(append('year', input$report_keyfindings_multiplot_group_select1,
                                input$report_keyfindings_multiplot_group_select2))) %>%
        summarise(
          cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat_num)) / sum(PWGTP) * 100, 2),
          se = (sqrt((sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)))) / (n()-1)))*100
        ) %>%
        drop_na()
    }
    else{
      df %>%
        filter(year>=input$report_keyfindings_multiplot_year_slider[1] & year<=input$report_keyfindings_multiplot_year_slider[2]) %>%
        group_by(!!!syms(append('year', input$report_keyfindings_multiplot_group_select1))) %>%
        summarise(
          # category percentage
          cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat_num)) / sum(PWGTP) * 100, 2),
          # standard error
          se = (sqrt((sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)))) / (n()-1)))*100
        ) %>%
        drop_na()
    }
  })
  
  
  # Section 1.2: 1.3-1.10 Plots
  output$plot_1_2_fig_3to10 <- renderPlot({
    if (req(input$report_keyfindings_multiplot_group_select2) != 'None'){
      # df %>%
      #   group_by(year, SEX, Ethnicity) %>%
      #   summarise(
      #     cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat_num)) / sum(PWGTP) * 100, 2),
      #     se = (sqrt((sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)))) / (n()-1)))*100
      #   ) %>%
        ggplot(section_1_2_fig_3to10(), aes(x=year, y=cat_perc,
                                            colour=!!sym(input$report_keyfindings_multiplot_group_select1),
                                            fill=!!sym(input$report_keyfindings_multiplot_group_select1))) + 
        geom_line(aes(x=year)) + geom_point() +
        geom_ribbon(aes(ymin=cat_perc-plot_ci*se, ymax=cat_perc+plot_ci*se), alpha = 0.2, colour = NA) +
        scale_x_continuous(breaks=unique(df$year)) +
        #ggtitle(paste0("Poverty Rates, Race and Ethnicity by Gender")) +
        scale_color_brewer(palette="Paired") +
        theme_minimal() +
        facet_wrap(~!!sym(input$report_keyfindings_multiplot_group_select2), ncol = 1)
        
    }
    else{
      # df %>%
      #   group_by(!!!syms(append('year', input$report_keyfindings_multiplot_group_select1))) %>%
      #   summarise(
      #     # category percentage
      #     cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat_num)) / sum(PWGTP) * 100, 2),
      #     # standard error
      #     se = (sqrt((sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)))) / (n()-1)))*100
      #   ) %>%
      
        ggplot(section_1_2_fig_3to10(), aes(x=year, y=cat_perc,
                   colour=!!sym(input$report_keyfindings_multiplot_group_select1),
                   fill = !!sym(input$report_keyfindings_multiplot_group_select1))) +
        geom_line(aes(x=year)) + geom_point() +
        geom_ribbon(aes(ymin=cat_perc-plot_ci*se, ymax=cat_perc+plot_ci*se),
                    alpha = 0.2, colour = NA) +
        scale_x_continuous(breaks=unique(df$year)) +
        labs(title = paste0('NYCgov Poverty Rates | ', as.character(input$report_keyfindings_multiplot_year_slider[1]),
                            '-', as.character(input$report_keyfindings_multiplot_year_slider[2])),
             x = 'Year', y = 'Percentage (%)') +
        theme_minimal() +
        theme(text=element_text(size=14))
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

  ### Data Spotlight ----
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
  
  ### Data Detail ----
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
      scale_fill_brewer(guide="legend", labels = c('In Poverty', 'Near-Poverty', 'Not in Poverty')) +
      scale_x_continuous(label=scales::comma, limits=c(0, 200000)) + 
      xlab('2018 Income ($)') +
      ylab('Proportion') +
      geom_label(data=annotation, aes( x=x, y=y, label=label),
                 #color="orange", 
                 size=3.5 , angle=45, fontface="bold" ) +
      theme_classic() +
      theme(legend.position=c(0.9,0.9), legend.title = element_blank(),
            axis.text.y = element_blank(), text=element_text(size=14))
  })
  
  # Alt plot
  
  
  ### Data Comparison ----
  # color palette: https://coolors.co/d9ed92-b5e48c-99d98c-76c893-52b69a-34a0a4-168aad-1a759f-1e6091-184e77
  color_palette = c('#d9ed9285', '#b5e48c85', '#99d98c85', '#76c89385', '#52b69a85',
                    '#34A0A485', '#168AAD85', '#1A759F85', '#1E609185', '#184E7785')

  comparison_df = reactive({
    validate(
      need(input$checkbox_data_comparison_year, 'Select at least one year'),
      need(input$selectize_data_comparison_pop_characteristics != '', 'Choose comparison dimensions')
    )

    dt = filter(df, year %in% input$checkbox_data_comparison_year) %>%
      # this is making it take the list as var names (below)
      group_by(!!!syms(append('year', input$selectize_data_comparison_pop_characteristics))) %>%
      summarise(cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat_num)) / sum(PWGTP) * 100, 2),
                citywide_perc = round( (sum(PWGTP*NYCgov_Pov_Stat_num) / mean(population)) * 100, 2),
                n_pov_weighted = sum((PWGTP*NYCgov_Pov_Stat_num)),
                # n_sample = length(PWGTP),
                # n_weighted = sum(PWGTP),
                # se calc. based on binomial property for variance (p * 1-p)
                ## https://www.sapling.com/6183888/calculate-sampling-error-percentages
                # se = round((sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100, 2),
                ## coefficient of variation (https://influentialpoints.com/Training/coefficient_of_variation_of_a_mean.htm)
                CV = round((100*sd(NYCgov_Pov_Stat_num)) / (mean(NYCgov_Pov_Stat_num) * sqrt(n())), 2),
                ci90 = round(qnorm(0.95) * (sqrt((sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)))) / (n()-1)))*100, 2)
      ) %>%
      # replace CV values of 0 with 100 as they are artefacts of super small samples
      mutate(CV = ifelse(CV==0, 100, CV)) %>%
      # remove unreliable rows if CV > 15 and option is selected
      {if(input$data_comp_filter_checkbox) filter(., CV<15) else .} %>%
      drop_na()
  })
      
  comparison_dt = reactive({
    validate(
      need(input$checkbox_data_comparison_year, 'Select at least one year'),
      need(input$selectize_data_comparison_pop_characteristics != '', 'Choose comparison dimensions')
    )

    dt = filter(df, year %in% input$checkbox_data_comparison_year) %>%
      # this is making it take the list as var names (below)
      group_by(!!!syms(append('year', input$selectize_data_comparison_pop_characteristics))) %>%
      summarise(cat_perc = round(sum((PWGTP*NYCgov_Pov_Stat_num)) / sum(PWGTP) * 100, 2),
                citywide_perc = round( (sum(PWGTP*NYCgov_Pov_Stat_num) / mean(population)) * 100, 2),
                n_pov_weighted = sum((PWGTP*NYCgov_Pov_Stat_num)),
                # n_sample = length(PWGTP),
                # n_weighted = sum(PWGTP),
                # se calc. based on binomial property for variance (p * 1-p)
                ## https://www.sapling.com/6183888/calculate-sampling-error-percentages
                # se = round((sqrt((sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat)/sum(PWGTP)))) / (n()-1)))*100, 2),
                ## coefficient of variation (https://influentialpoints.com/Training/coefficient_of_variation_of_a_mean.htm)
                CV = round((100*sd(NYCgov_Pov_Stat_num)) / (mean(NYCgov_Pov_Stat_num) * sqrt(n())), 2),
                ci90 = round(qnorm(0.95) * (sqrt((sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)) * (1-sum((PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)))) / (n()-1)))*100, 2)
      ) %>%
      # replace CV values of 0 with 100 as they are artefacts of super small samples
      mutate(CV = ifelse(CV==0, 100, CV)) %>%
      # remove unreliable rows if CV > 15 and option is selected
      {if(input$data_comp_filter_checkbox) filter(., CV<15) else .} %>%
      drop_na() %>%
      datatable(extensions = list('Buttons'),
                options = list(
                  scrollX = TRUE,
                  scrollY = "400px",
                  paging = FALSE
                ),
                colnames = c('Year' = 'year', 'Cat. %' = 'cat_perc',
                             '90% CI' = 'ci90', 'Count' = 'n_pov_weighted',
                             'Pop. %' = 'citywide_perc'
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
      formatStyle('Year',
                  backgroundColor = styleEqual(unique(na.omit(df$year)), viridis(length(unique(na.omit(df$year))), alpha = 0.4)))
    
    # color columns super hack style
    if ('Boro' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('Boro',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$Boro))), color_palette[1:length(unique(na.omit(df$Boro)))]))}
    if ('AgeCateg' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('AgeCateg',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$AgeCateg))), color_palette[1:length(unique(na.omit(df$AgeCateg)))]))}
    if ('EducAttain' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('EducAttain',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$EducAttain))), color_palette[1:length(unique(na.omit(df$EducAttain)))]))}
    if ('SEX' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('SEX',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$SEX))), color_palette[1:length(unique(na.omit(df$SEX)))]))}
    if ('Ethnicity' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('Ethnicity',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$Ethnicity))), color_palette[1:length(unique(na.omit(df$Ethnicity)))]))}
    if ('DIS' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('DIS',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$DIS))), color_palette[1:length(unique(na.omit(df$DIS)))]))}
    if ('TEN' %in% input$selectize_data_comparison_pop_characteristics){
      dt = dt %>% formatStyle('TEN',
                              backgroundColor = styleEqual(sort(unique(na.omit(df$TEN))), color_palette[1:length(unique(na.omit(df$TEN)))]))}
    # indicate unreliable data based on coefficient of variation > 15
    dt = dt %>% formatStyle('CV',
                            target = 'row',
                            backgroundColor = styleInterval(15, c('', '#E4413880')))
    dt
  })
  
  output$table_data_comparison_1 <- renderDataTable(
    comparison_dt(),
    )

  #### Downloadable files of selected dataset ----
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
  
  ### Data Map ----
  
  output$data_map = renderLeaflet({
    ### NYC POVERTY DATA
    label_info = 'Ethnicity'
    
    pov_data1 = df %>%
      filter(year>=input$data_map_year_slider[1] & year<=input$data_map_year_slider[2]) %>%
      group_by(PUMA) %>%
      summarise(pov_rate = round(sum(PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)*100, 1),
                pop = sum(PWGTP)) 
    
    pov_data2 = df %>%
      filter(year>=input$data_map_year_slider[1] & year<=input$data_map_year_slider[2]) %>%
      group_by(PUMA, !!sym(label_info)) %>%
      summarise(pov_rate = round(sum(PWGTP*NYCgov_Pov_Stat_num)/sum(PWGTP)*100, 1),
                pop = sum(PWGTP)) %>%
      pivot_wider(names_from = Ethnicity, values_from = c('pov_rate', 'pop'))
    #join dfs
    pov_data = inner_join(pov_data1, pov_data2, by = 'PUMA')
    
    pov_data %>%
      select(starts_with('pop_'))/pov_data$pop * 100
    ### PUMA GEOMETRY DATA
    #downloaded from https://data.cityofnewyork.us/Housing-Development/Public-Use-Microdata-Areas-PUMA-/cwiz-gcty
    json_nyc = geojson_sf('data/maps/Public Use Microdata Areas (PUMA).geojson')
    
    ### NEIGHBORHOOD INFO
    #downloaded from  https://maps.princeton.edu/catalog/nyu-2451-34512
    neighborhoods = st_read('data/maps/nyu-2451-34512-shapefile/nyu_2451_34512.shp') %>%
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
      "<h4>%s<br/><strong>%s in Poverty</strong></h4><strong>Population by Ethnicity</strong><br/>White: %s<br/>Black: %s<br/>Asian: %s<br/>Hispanic: %s",
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
      #addProviderTiles("CartoDB.PositronNoLabels") %>%
      addPolygons(label = labels,
                  labelOptions = labelOptions(style = list(
                                                "border-color" = "rgba(0,0,0,0.5)",
                                                "background-color" = "rgba(255,255,255,0.65)"
                                              )),
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
    
  })
}

shinyApp(ui, server)

