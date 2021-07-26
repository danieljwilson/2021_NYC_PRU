library(tidyverse)
library(shinydashboard)
library(plotly)
library(shiny)
library(DT)
library(data.table)

ui <- dashboardPage(
  dashboardHeader(title = "PRU Web App Mockup"),
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
               menuSubItem('Key Findings', tabName = 'report_key_findings'),
               menuSubItem('Policy and Path', tabName = 'report_policy_path'),
               menuSubItem('Measuring Poverty', tabName = 'report_measuring'),
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
    tabItems(
      # Poverty ----
      ## Poverty About -----
      tabItem(tabName = "poverty_about",
              h1('What is Poverty?'),
              p(a('The World Bank', href = 'https://www.worldbank.org/en/home', target = '_blank'), ' describes poverty as:'),
              p(em('Poverty is hunger. Poverty is lack of shelter. Poverty is being sick and not being able to see a doctor. Poverty is not having access to school and not knowing how to read. Poverty is not having a job, is fear for the future, living one day at a time. Poverty has many faces, changing from place to place and across time, and has been described in many ways.  Most often, poverty is a situation people want to escape. So poverty is a call to action -- for the poor and the wealthy alike -- a call to change the world so that many more may have enough to eat, adequate shelter, access to education and health, protection from violence, and a voice in what happens in their communities.', style = "font-family: 'times'; font-size: 16px")),
              hr(),
              p(a('The Office of the Assistant Secretary for Planning and Evaluation', href = 'https://aspe.hhs.gov/topics/poverty-economic-mobility/poverty-estimates-trends-analysis', target = '_blank'), 'defines poverty more succinctly:'),
              p(em('People and families are considered poor when they lack the economic resources necessary to experience a minimal living standard.', style = "font-family: 'times'; font-size: 16px")),
              hr(),
              h2('Measuring Poverty'),
              p('If we have the goal of reducing poverty it is important that we have some way to measure it. The World Bank sets a threshold of extreme poverty as those people who live on $1.90 per day or less.'),
              fluidRow(
                box(
                  title = "Poverty headcount ratio at $1.90 a day (2011 PPP) (% of population)",
                  width = 10,
                  plotlyOutput("plot_poverty1")
                )
              ),
              p('This plot using the World Bank\'s extreme poverty threshold, as you can see, is not very useful if we want to learn about the state of poverty in the US.'),
              p('In the ', strong('Results'), ' section we explain how our poverty threshold for New York City is calculated to take into account the specific living conditions of the city.'),
              hr()
      ),
      
      ## Poverty Profiles -----

      tabItem(tabName = "poverty_profiles_jane_doe",
              h1("Profiles"),
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
      ## Report - Key Findings ----
      tabItem("report_key_findings",
              fluidPage(
                h1("Key Findings"),
                p('The New York City Government (NYCgov) poverty measure is a measure of poverty adapted to the realities of the city’s economy. The poverty threshold accounts for housing costs that are higher than the national average. The measure of family resources includes public benefits and tax credits, but also acknowledges spending on medical costs and work-related expenses such as childcare and commuting.'),
                p('The NYCgov poverty rate, threshold, and income measure are higher than those same figures in the U.S. official measure.'),
                hr(),
                fluidRow(
                  box(
                    title = '1.1 Poverty in New York City, 2019',
                    collapsible = TRUE,
                    collapsed = FALSE,
                    width = 12,
                    tags$strong('The NYCgov poverty rate for 2019 is 17.9 percent'),
                    p('This is a statistically significant 1.4 percentage point change from 2018 when the rate was 19.3 percent.1 The 2019 rate is the lowest NYCgov poverty rate since the series began with 2005 data. The decline in the poverty rate primarily is due to increases in income and employment during the last year of the economic expansion that followed the Great Recession. The decline in poverty over the five-year period 2015 to 2019 also was statistically significant, resulting in a poverty rate that fell from 19.6 to 17.9 percent.'),
                    p('The NYCgov poverty rate is historically higher than the U.S. official poverty rate. The official rate is derived only from pre-tax cash income and a poverty threshold that is three times the nationwide cost of a minimal food budget. The NYCgov rate responds to changes in multiple sources of income (including income supplements), medical and work-related expenses, and changes in average living standards over time, including local housing costs. Table 1.1 and Figure 1.1 illustrate these differences.'),
                    tags$strong('The NYCgov near poverty rate for 2019 is 40.8 percent.'),
                    p('This is a statistically significant decline from the 41.9 percent near poverty rate in 2018. The term “near poverty,” as utilized in this report, includes the share of the population living under 150 percent of the NYCgov poverty threshold. It includes all people in poverty and those above the threshold but at risk of falling into poverty. The decline in near poverty, from 45.4 percent in 2015 to 40.8 percent in 2019, also is statistically significant (see Figure 1.2).'),
                    hr(),
                    fluidRow(
                      box(
                        title = 'NYCgov and U.S. Official Poverty Rates 2005–2019',
                        width = 9,
                        status = 'primary',
                        solidHeader = TRUE,
                        tabsetPanel(type = "tabs",
                                    tabPanel("Plot", plotlyOutput("plot_1_1_rate")),
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
                        solidHeader = TRUE,
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
                                    max = 2019, value = c(2005, 2019), sep='', ticks = FALSE)
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
                    p('The data in Section 1.1 showed citywide rates of poverty. When the city population is decomposed into demographic or geographic subgroups, different patterns of poverty can emerge. This section shows poverty rates for New Yorkers in various groupings: family type; work experience; educational attainment: race, gender, and ethnicity; borough; and community district. Poverty rates are shown for the years 2015 to 2019 to illustrate trends in the data. In the case of community districts, where sample sizes typically are small, we average five years of data and present one poverty rate for the years 2015 to 2019. Year-over-year changes in poverty rates are often significant but somewhat volatile. The more meaningful five-year trend shows that many groups have experienced significant declines in poverty rates over the 2015 to 2019 period, including:'),
                    tags$ul(
                      tags$li('Males and females'),
                      tags$li('Working age adults'),
                      tags$li('Working age adults at all levels of educational attainment'),
                      tags$li('One- and two-parent families'),
                      tags$li('Full time, year-round workers and less than full-time, year-round workers'),
                      tags$li('Hispanics, Non-Hispanic Blacks, and Non-Hispanic Whites (no significant change for Non-Hispanic Asians)'),
                      tags$li('Citizens by birth, naturalized citizens, and non-citizens')
                    )
                  )
                ),
                fluidRow(
                  box(
                    title = '1.3 What Drives the Poverty Rate: The New York City Labor Market, Wages, and Income Supports',
                    collapsible = TRUE,
                    collapsed = TRUE,
                    width = 12,
                    p('Poverty rates are influenced by the economic environment. The number of people working and the income they earn are key factors in building household resources. The 2019 data mark the post-recession peak in employment and income, both of which continued to improve from the prior year. The employment/population ratio steadily has increased since the end of the Great Recession, reaching pre-recession levels by 2016. By 2019, nearly three-quarters of working age adults engaged in at least some hours of employment. The share of workers employed full time also surpassed pre-recession levels, with corresponding declines in both part-time workers and those who worked no weeks in 2019 (see Figures 1.12 and 1.13).'),
                    h2('Figure 1.12: Employment/Population Ratios, 2015–2019'),
                    h2('Figure 1.13: Weeks Worked in Prior 12 Months, 2015–2019'),
                    p('Strong earnings growth among the lowest income workers coincided with an expanding economy and increases in the minimum wage. In 2014, the hourly minimum wage in New York City was $8, a 75-cents-an-hour increase from the previous year. The minimum wage increased each year after that until it reached $15 in calendar year 2019. Panel A of Table 1.3 shows the distribution of wage increases among the lowest 50 percent of wage earners. The greatest wage growth occurred in the bottom deciles of the wage distribution where less than full- time workers and minimum wage earners make up most of the population. But wages are only one component of NYCgov Income – a measure that includes a wider range of resources. Additional income supports such as tax credits and food assistance are included in income while work-related expenditures are deducted. (See Section 1.4 for more on NYCgov Income components.)'),
                    p('Panel B of Table 1.3 shows growth over time of the fuller resource measure, NYCgov Income. NYCgov Income increases at a slower pace than wages. The interactions of its components are complicated. For many non- elderly families, including those in poverty, wages are the largest component of NYCgov Income. The other income components interact with wage income; for example, childcare costs may increase with work hours. For low-income families, rising earnings can involve tradeoffs or benefit cliffs. Eligibility for some income supports, such as the Supplemental Nutrition Assistance Program (SNAP), tapers off as earnings rise. The Earned Income Tax Credit (EITC) increases with earnings and then phases out. The mix of a family’s income components is not constant over time, but shifts with wages and benefit eligibility standards.'),
                    p('Panel A of Table 1.3 shows how the economic well-being of low-income New Yorkers improved with economic expansion and rising wages. But safety net benefits still play an important role in keeping families above the poverty threshold. Figure 1.14 shows the effect of programs in reducing the poverty rate. Conversely, the inclusion of nondiscretionary expenditures in NYC Income (medical spending and work-related costs) allows for measuring the effect of these expenditures in increasing the poverty rate.'),
                    p('In Figure 1.14, elements that lower the poverty rate are found to the left of zero and those that raise it are found to the right. Each bar shows the effect of the absence of a specific income component on the poverty rate. For example, in the absence of an income adjustment to account for housing supports, the 2019 poverty rate would be 5.6 percentage points higher, or 23.5 percent. In the absence of medical expenditures, the poverty rate would be 3 percentage points lower, or 14.9 percent.'),
                    h2('Table 1.3: Nominal Wages and Incomes at Select Percentiles of Distribution, 2015–2019'),
                    h2('Figure 1.14: Marginal Effects of Selected Sources of Income on the NYCgov Poverty Rate, 2019')
                    )
                ),
                fluidRow(
                  box(
                    title = '1.4 The Distribution of Poverty and the Safety Net',
                    collapsible = TRUE,
                    collapsed = TRUE,
                    width = 12,
                    p('Poverty rates, while useful, simply mark the difference between those with resources above or below the poverty threshold. The data discussed above show that the potential for being in poverty differs across groups and by location. But not all poverty is alike. Some families are living quite close to their poverty threshold, with a small gap in the resources necessary to cross that line. Other families are living far below their poverty threshold, with less than half the resources they need to move out of poverty. All of these families are classified as “poor” because the poverty rate is simply a headcount of those living below the threshold. However, the further from the threshold the more intense the experience of poverty. Resources for basic needs are scarcer, stress levels can be higher, and it is more difficult to acquire the resources needed to escape poverty.'),
                    p('Table 1.4 shows shares of the population at selected distances above and below the poverty threshold for the years 2015 to 2019. The light blue band denotes shares of the population in poverty. The dark blue band denotes those families with resources from 100 to 200 percent above their threshold – not in poverty, but uncomfortably close to the threshold.'),
                    h2('Table 1.4: Distribution of the Population by Degrees of Poverty, 2015–2019'),
                    p('For those in poverty, the distance below the threshold is known as the poverty gap. It is the amount of resources2 they need to cross the threshold and move out of poverty. The amount can differ for each family. The poverty gap for New York City in 2019 was $6.5 billion. This figure is the sum of the poverty gap for all families in poverty and represents the total amount needed to lift all New Yorkers above their poverty threshold. Figure 1.15 shows that the poverty gap is not equally distributed across the population but varies by family status: the size and composition of the family. Breaking out the data by family status illustrates the impact of income supports that often are tied to the presence of children in the family.'),
                    h2('Figure 1.15: NYC Poverty Gap in Billions: 2019'),
                    p('Those living above their threshold (the dark blue band in Table 1.4) have a “poverty surplus” – the amount of resources available beyond what is needed to meet the family’s poverty threshold. Figure 1.16 shows the poverty surplus for this population, and breaks out the surplus for families with children and for single adults.3 The surplus is indicative of the risk of falling into poverty. It is the cushion available to keep families from falling into poverty in the event of an unexpected shock.'),
                    p('In Figure 1.14, elements that lower the poverty rate are found to the left of zero and those that raise it are found to the right. Each bar shows the effect of the absence of a specific income component on the poverty rate. For example, in the absence of an income adjustment to account for housing supports, the 2019 poverty rate would be 5.6 percentage points higher, or 23.5 percent. In the absence of medical expenditures, the poverty rate would be 3 percentage points lower, or 14.9 percent.'),
                    h2('Figure 1.16: Average Resource Surplus Among Low-Income Families, 2015–2019'),
                    p('The likelihood of falling into poverty and the intensity of that poverty is not equally distributed across the population. One potential remedy is the safety net of public benefits. Figure 1.14 shows the importance of these benefits in lowering the poverty rate among the population. The safety net is effective at lowering poverty but its resources are not equally distributed – a key source of differences in the poverty gap. Figure 1.17 shows how the combined impact of government assistance programs differs by family type. In particular, families with children receive the largest offset to their poverty rate. This is intentional, as many programs are specifically designed to give the greater share of benefits to families with children. The programs succeed in this goal. The NYCgov and other alternative poverty measures have repeatedly shown the importance of public programs in lowering the poverty rate, especially the child poverty rate.4 Similar but less generous benefits exist for the elderly. Childless working-age adults receive minimal relief from benefit programs as their incomes mostly consist of earned income, scant tax credits, and minimal other benefits.')
                  )
                )
                )
             ),
      ## Report: Policy & Path ----
      tabItem("report_policy_path",
              fluidPage(
                h1("Policy & Path"),
                p('This is the final poverty report issued by the de Blasio administration. As such, it provides an opportunity to look back on the poverty policy of two mayoral terms and its impact. This year’s report shows a decline in poverty and near poverty. The New York City Government (NYCgov) poverty rate fell from 20.2 percent to 17.9 percent from 2014 to 2019, a statistically significant change. The rate for 2019 is the lowest since the start of the de Blasio administration and, in fact, the lowest rate going back to 2005 – the first year captured by the poverty measure. As of 2019, there were 521,000 fewer people in poverty or near poverty than if rates had remained at their 2013 levels. The decline reflects how increases in the minimum wage, rising labor market participation, and the many policies implemented during the de Blasio administration improved the economic well-being of low-income New Yorkers.'),
                p('This year’s report represents a snapshot of poverty and near poverty in New York City before the COVID-19 pandemic arrived in early 2020, so it must be viewed within that context. It nevertheless contains important lessons about the current state of poverty. The report also considers how, as conditions improve and the City reopens (with an infusion of federal help from the American Rescue Plan Act of 2021 that includes significant aid to city governments), it can recover from the negative economic impact of COVID-19.')
                )
      ),
      
      ## Report: Measuring Poverty ----
      tabItem("report_measuring",
              fluidPage(
                h1("Measuring Poverty")
              )
      ),
      
      ## Report: Appendices ----
      tabItem("report_appendices",
              fluidPage(
                h1("Appendices")
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
                        color = "yellow"),
                infoBox("Children In Poverty", format(437000, big.mark = ","),
                        icon = icon("child"),
                        color = "red"),
                infoBox("Gap Amount ($ billions)", 6.5, icon = icon("piggy-bank"))
                ),
              hr(),
              fluidRow(
                box(
                  title = '1 | Geography',
                  collapsible = TRUE,
                  collapsed = FALSE,
                  width = 12,
                  fluidRow(
                    box(
                      title = 'Poverty Rates by Bourough and Community District',
                      width = 9,
                      tabsetPanel(type = "tabs",
                                  tabPanel("Map", img(src = "map.jpg", width="100%")),
                                  tabPanel("Data"),
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
                      title = "Options",
                      width = 3,
                      sliderInput("slider_data_1_1", label = "Select Year(s)", min = 2005, 
                                max = 2019, value = c(2019,2019), sep='', ticks = FALSE),
                      radioButtons("radio_data_1_1", label = "Measure",
                                 choices = list("Average" = 1, "Change" = 2),
                                 selected = 1),
                      radioButtons("radio_data_1_2", label = "Geographic Unit",
                                   choices = list("Borough" = 1, "Community District" = 2),
                                   selected = 1)
                      )
                    )
                  )
                ),
                fluidRow(
                  box(
                    title = '2 | Demographics',
                    collapsible = TRUE,
                    collapsed = TRUE,
                    width = 12,
                    # nabvar info: https://shiny.rstudio.com/reference/shiny/1.0.5/navbarPage.html
                    navbarPage("",
                               tabPanel("Age",
                                        fluidRow(
                                          box(
                                            title = 'NYCgov Poverty Rates by Age',
                                            width = 9,
                                            tabsetPanel(type = "tabs",
                                                        tabPanel("Plot", img(src = "poverty_age.jpg", width="100%")),
                                                        tabPanel("Data"),
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
                                            title = "Options",
                                            width = 3,
                                            sliderInput("slider_data_1_1", label = "Select Year(s)", min = 2005, 
                                                        max = 2019, value = c(2019,2019), sep='', ticks = FALSE),
                                            radioButtons("radio_data_1_1", label = "Measure",
                                                         choices = list("Average" = 1, "Change" = 2),
                                                         selected = 1),
                                            radioButtons("radio_data_1_2", label = "Geographic Unit",
                                                         choices = list("Borough" = 1, "Community District" = 2),
                                                         selected = 1)
                                          )
                                        )),
                               tabPanel("Sex",
                                        fluidRow(
                                          box(
                                            title = 'NYCgov Poverty Rates by Sex',
                                            width = 9,
                                            tabsetPanel(type = "tabs",
                                                        tabPanel("Plot", img(src = "poverty_sex.jpg", width="100%")),
                                                        tabPanel("Data"),
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
                                            title = "Options",
                                            width = 3,
                                            sliderInput("slider_data_1_1", label = "Select Year(s)", min = 2005, 
                                                        max = 2019, value = c(2019,2019), sep='', ticks = FALSE),
                                            radioButtons("radio_data_1_1", label = "Measure",
                                                         choices = list("Average" = 1, "Change" = 2),
                                                         selected = 1),
                                            radioButtons("radio_data_1_2", label = "Geographic Unit",
                                                         choices = list("Borough" = 1, "Community District" = 2),
                                                         selected = 1)
                                          )
                                        )),
                               tabPanel("Race/Ethnicity",
                                        fluidRow(
                                          box(
                                            title = 'NYCgov Poverty Rates by Race/Ethnicity',
                                            width = 9,
                                            tabsetPanel(type = "tabs",
                                                        tabPanel("Plot", img(src = "poverty_race.jpg", width="100%")),
                                                        tabPanel("Data"),
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
                                            title = "Options",
                                            width = 3,
                                            sliderInput("slider_data_1_1", label = "Select Year(s)", min = 2005, 
                                                        max = 2019, value = c(2019,2019), sep='', ticks = FALSE),
                                            radioButtons("radio_data_1_1", label = "Measure",
                                                         choices = list("Average" = 1, "Change" = 2),
                                                         selected = 1),
                                            radioButtons("radio_data_1_2", label = "Geographic Unit",
                                                         choices = list("Borough" = 1, "Community District" = 2),
                                                         selected = 1)
                                          )
                                        )
                                        ),
                               tabPanel("Citizenship"),
                               tabPanel("Education"),
                               tabPanel("Work")
                               
                    )
                  )
                ),
                fluidRow(
                  box(
                    title = '3 | Other Category?',
                    collapsible = TRUE,
                    collapsed = TRUE,
                    width = 12,
                    p('Poverty rates are influenced by the economic environment. The number of people working and the income they earn are key factors in building household resources. The 2019 data mark the post-recession peak in employment and income, both of which continued to improve from the prior year. The employment/population ratio steadily has increased since the end of the Great Recession, reaching pre-recession levels by 2016. By 2019, nearly three-quarters of working age adults engaged in at least some hours of employment. The share of workers employed full time also surpassed pre-recession levels, with corresponding declines in both part-time workers and those who worked no weeks in 2019 (see Figures 1.12 and 1.13).'),
                    h2('Table 1.3: Nominal Wages and Incomes at Select Percentiles of Distribution, 2015–2019'),
                    h2('Figure 1.14: Marginal Effects of Selected Sources of Income on the NYCgov Poverty Rate, 2019')
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
                    title = 'Income Distribution (2019)',
                    width = 9,
                    tabsetPanel(type = "tabs",
                                tabPanel("Plot", plotOutput("plot_data_detail")),
                                tabPanel("Data"),
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
                    title = "Options",
                    width = 3,
                    selectInput("select_data_detail_sex", label = "Sex",
                                c("Female" = "Female",
                                  "Male" = "Male")
                                  ),
                    selectInput("select_data_detail_age", label = "Age",
                                c("Under 18" = "Under 18",
                                  "18-64" = "18-64",
                                  "65+" = "65+")
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
                code('Note that you are limited to a minimum sample size so all combinations are not possible.'),
                hr(),
                fluidRow(
                  box(
                    title = "Options",
                    width = 12,
                    
                    column(4,
                           selectizeInput("checkbox_data_comparison_year", 
                                          label = "Select year(s)", 
                                          choices = c("2013" = 2013, 
                                                      "2014" = 2014, 
                                                      "2015" = 2015,
                                                      "2016" = 2016, 
                                                      "2017" = 2017, 
                                                      "2018" = 2018),
                                          selected = 2016,
                                          multiple = TRUE)
                    ),
                    
                    column(4,
                      selectizeInput(
                        inputId = 'selectize_data_comparison_pop_characteristics',
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
                      )
                    ),
                    column(4,
                           helpText(
                             h4('Note'),
                             helpText('You must select at least ',
                                      tags$strong('one year '),
                                      'and ',
                                      tags$strong('one sub-population'),
                                      ' in order to create a data table.')
                           ))
                  ),
                  box(
                    title = 'NYC Poverty Data',
                    width = 12,
                    tabsetPanel(type = "tabs",
                                tabPanel("Data", dataTableOutput("table_data_comparison_1")),
                                tabPanel("Source/Notes",
                                         tags$strong('Source:'),
                                         'American Community Survey Public Use Micro Sample as augmented by NYC Opportunity. U.S. official threshold from U.S. Census Bureau.',
                                         br(),
                                         br(),
                                         tags$strong('Notes:'),
                                         'Numbers in bold indicate a statistically significant change from prior year. U.S. official poverty rates are based on the NYCgov poverty universe and unit of analysis. See Appendix A for details.')
                    )
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
  ## Poverty ----
  global_poverty_rate = read_csv('temp_data/world_bank_poverty.csv')
  # load cleaned data from clean_data.R (maybe source?)
  df = read_csv("../../../Data/NYCgov_Poverty_Measure_Data_cleaned.csv")
  
  output$plot_poverty1 <- renderPlotly({
    global_poverty_rate %>%
      filter(Country != "North America") %>%
      filter(`Indicator Name` == "Poverty headcount ratio at $1.90 a day (2011 PPP) (% of population)") %>%
      gather(Year, Percentage, `1960`:`2018`, factor_key = TRUE) %>%
      plot_ly(x=~Year, y=~Percentage,
              type="scatter",color=~Country, mode="lines+markers") %>%
      layout(annotations = 
               list(x = 1.25, y = -0.2, text = "Source: https://data.worldbank.org/topic/poverty", 
                    showarrow = F, xref='paper', yref='paper', 
                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                    font=list(size=10)))
  })
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
  
  # 1.1 Plot
  poverty_rates = read_csv('temp_data/poverty_numbers.csv') %>%
    gather(Year, Value, `2005`:`2019`) #make long
  
  poverty_rates[poverty_rates$Measure=='NYCGov Threshold',]$Value = poverty_rates[poverty_rates$Measure=='Official Threshold',]$Value * (rnorm(nrow(poverty_rates[poverty_rates$Measure=='Official Threshold',]), 0, 0.02) + 1.376163)
  
  output$plot_1_1_rate <- renderPlotly({
    poverty_rates %>%
      filter(Year>=input$slider_1_1[1] & Year<=input$slider_1_1[2]) %>%
      filter(Measure == 'NYCGov Poverty' | Measure == 'NYCGov Near Poverty' | Measure == 'Official Poverty') %>%
      
      plot_ly(x=~Year, y=~Value,
              type="scatter",color=~Measure, mode="lines+markers")
  })
  
  # 1.1 Table
  output$table_1_1_rate <- renderDataTable(
    poverty_rates %>%
      filter(Year>=input$slider_1_1[1] & Year<=input$slider_1_1[2]) %>%
      filter(Measure == 'NYCGov Poverty' | Measure == 'NYCGov Near Poverty' | Measure == 'Official Poverty'),
    extensions = 'Buttons', options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
    )
    )
  
  # 1.2 Plot
  poverty_rates = read_csv('temp_data/poverty_numbers.csv') %>%
    gather(Year, Value, `2005`:`2019`) #make long
  
  poverty_rates[poverty_rates$Measure=='NYCGov Threshold',]$Value = poverty_rates[poverty_rates$Measure=='Official Threshold',]$Value * (rnorm(nrow(poverty_rates[poverty_rates$Measure=='Official Threshold',]), 0, 0.02) + 1.376163)
  
  output$plot_1_2_threshold <- renderPlotly({
    poverty_rates %>%
      filter(Year>=input$slider_1_2[1] & Year<=input$slider_1_2[2]) %>%
      filter(Measure == 'NYCGov Threshold' | Measure == 'Official Threshold') %>%
      
      plot_ly(x=~Year, y=~Value,
              type="scatter",color=~Measure, mode="lines+markers")
  })
  
  # 1.2 Table
  output$table_1_2_threshold <- renderDataTable(
    poverty_rates %>%
      filter(Year>=input$slider_1_2[1] & Year<=input$slider_1_2[2]) %>%
      filter(Measure == 'NYCGov Threshold' | Measure == 'Official Threshold'),
    extensions = 'Buttons', options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
    )
  )
  
  ## Data ----
  
  ## Data Detail ----
  output$plot_data_detail <- renderPlot({
    incomes = df %>%
      filter(sex == input$select_data_detail_sex) %>%
      filter(age_categ == input$select_data_detail_age) %>%
      filter(boro == input$select_data_detail_borough) %>%
      filter(educ_attain == input$select_data_detail_education) %>%
      select('nyc_gov_income')
    
    # turn into vector
    incomes = incomes[[1]]
    # get rid of negative income values
    incomes[incomes<0] = 0
    
    dens <- density(incomes, from = 0)
    df_dens <- data.frame(x=dens$x, y=dens$y)
    breaks <- c(0, poverty, near_poverty, Inf)
    df_dens$quant <- factor(findInterval(df$x,breaks))
    ggplot(df_dens, aes(x,y)) + 
      geom_line() + 
      geom_ribbon(aes(ymin=0, ymax=y, fill=quant)) + 
      scale_x_continuous(labels = scales::comma) + 
      scale_fill_brewer(guide="none") +
      scale_x_continuous(label=scales::comma, limits=c(0, 200000)) + 
      xlab('Income') +
      ylab('Proportion') +
      theme_classic() +
      theme(axis.text.y = element_blank())
  })
  
  ## Data Comparison ----

  df %>%
    filter(year == 2016) %>%
    group_by(year, age_categ, boro) %>%
    summarise(citywide_perc=round(sum((pwgtp*nyc_gov_in_pov)/nyc_pop)*100, 2),
              cat_perc=round(sum((pwgtp*nyc_gov_in_pov)/sum(pwgtp))*100, 2),
              n_sample = length(pwgtp)
    )
    
  selections = reactive({
    validate(
      need(input$checkbox_data_comparison_year, 'Select at least one year'),
      need(input$selectize_data_comparison_pop_characteristics != '', 'Choose comparison dimensions')
    )
    req(input$checkbox_data_comparison_year)
    req(input$selectize_data_comparison_pop_characteristics)
    filter(df, year == input$checkbox_data_comparison_year) %>%
      # this is making it take the list as var names (below)
      group_by(!!!syms(append('year', input$selectize_data_comparison_pop_characteristics))) %>%
      summarise(cat_perc = round(sum((pwgtp*nyc_gov_in_pov)) / sum(pwgtp) * 100, 2),
                citywide_perc = round( (sum(pwgtp*nyc_gov_in_pov) / mean(population)) * 100, 2),
                n_pov_weighted = sum((pwgtp*nyc_gov_in_pov)),
                # n_sample = length(pwgtp),
                # n_weighted = sum(pwgtp),
                # se calc. based on binomial property for variance (p * 1-p)
                ## https://www.sapling.com/6183888/calculate-sampling-error-percentages
                # se = round((sqrt((sum((pwgtp*nyc_gov_in_pov)/sum(pwgtp)) * (1-sum((pwgtp*nyc_gov_in_pov)/sum(pwgtp)))) / (n()-1)))*100, 2),
                ## coefficient of variation (https://influentialpoints.com/Training/coefficient_of_variation_of_a_mean.htm)
                cv = round((100*sd(nyc_gov_in_pov)) / (mean(nyc_gov_in_pov) * sqrt(n())), 2),
                ci95 = round(qnorm(0.975) * (sqrt((sum((pwgtp*nyc_gov_in_pov)/sum(pwgtp)) * (1-sum((pwgtp*nyc_gov_in_pov)/sum(pwgtp)))) / (n()-1)))*100, 2)
      ) %>%
      datatable(extensions = list('Buttons'),
                options = list(
                  dom = 'Bfrtip',
                  buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                  scrollX = TRUE,
                  scrollY = "400px",
                  paging = FALSE
                )) %>%
      formatStyle('cat_perc',
                  background = styleColorBar(range(0,50), 'lightblue'),
                  backgroundSize = '98% 88%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center') %>%
      formatStyle('n_pov_weighted',
                  background = styleColorBar(range(0,2e6), 'lightblue'),
                  backgroundSize = '98% 88%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center') %>%
      # color palette: https://coolors.co/d9ed92-b5e48c-99d98c-76c893-52b69a-34a0a4-168aad-1a759f-1e6091-184e77
      formatStyle('age_categ',
                  backgroundColor = styleEqual(c('Under 18', '18-64', '65+'),
                                               c('#d9ed92', '#b5e48c', '#99d98c'))
      )%>%
      formatStyle('boro',
                  backgroundColor = styleEqual(c('Bronx', 'Brooklyn', 'Manhattan', 'Queens', 'Staten Island'),
                                               c('#d9ed92', '#b5e48c', '#99d98c', '#76c893', '#52b69a'))
      )%>%
      formatStyle('cv',
                  target = 'row',
                  backgroundColor = styleInterval(15, c('', 'gray'))
      )
    
  })
  
output$table_data_comparison_1 <- renderDataTable(
  selections()#,
  # extensions = list('Buttons',
  #                   'FixedHeader'),
  # options = list(
  #   dom = 'Bfrtip',
  #   buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
  #   scrollX = TRUE,
  #   paging = FALSE,
  #   fixedHeader = TRUE
  # )
)
  
  
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

shinyApp(ui, server)

