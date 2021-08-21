# PRU Web App

<img src="https://changecapitalfund.org/wp-content/uploads/2015/09/NYCMOEO.png" width="20%" /><img src="https://images.squarespace-cdn.com/content/v1/59539f22e6f2e181ffc682ef/1612968994021-AO979E2LUK0F4KXBYRQ0/CIC_LogoFull_Color.png?format=1000w" width="25%" />

---
The Poverty Research Unit web app is currently a beta version of an online interactive companion to the annual [Poverty Measure report](https://www1.nyc.gov/site/opportunity/poverty-in-nyc/poverty-measure.page).

It was initially developed by [Civic Innovation Corps](https://www.codingitforward.com/corps) fellow [Daniel J Wilson](https://danieljwilson.com/) over the summer of 2021.

**The app can be viewed at [this link](https://daniel-j-wilson.shinyapps.io/2021_NYC_PRU/)**.

---
## Components
### 1. Data
The data for the app comes from two sources. 
1. A publicly available dataset from [NYC Open Data](https://opendata.cityofnewyork.us/) which contains basic demographic information and calculated indicators related to poverty developed by the Poverty Research Unit. The data is [available here from 2005](https://data.cityofnewyork.us/browse?q=nycgov+poverty+measure&sortBy=alpha&utf8=%E2%9C%93).
2. An internal dataset which is used to augment the open data with additional information, such as respondant [Public Use Microdata Areas](https://www.census.gov/programs-surveys/geography/guidance/geo-areas/pumas.html) (kind of like neighborhoods), employement sector, etc.

Most of the data used in both datasets originates from the [American Community Survey](https://www.census.gov/programs-surveys/acs).

### 2. Data Munging
The `data_cleaning.Rmd` file imports, cleans, and combines the data that is used in the `R Shiny` web app.

The columns that are to be used in the web app are initially declared in an [external Google Sheet](https://docs.google.com/spreadsheets/d/1ndZtYpCjD4CCIyGU2chJjw6yMPr4PDQY6q8OJeoYpso/edit?usp=sharing) - you can duplicate and edit this file if you wish to change the data available to the app.

The data munging process consists of the following steps (the numbers below match the sections of the `.Rmd` file):
1. File Specification
    - Set file paths for both the open and internal datasets
    - Create lists of all available files
    - Pull out years for both open and internal files and test if they match
2. Column Specification
    - Import column selections from the [Google Sheet](https://docs.google.com/spreadsheets/d/1ndZtYpCjD4CCIyGU2chJjw6yMPr4PDQY6q8OJeoYpso/edit?usp=sharing)
    - Create separate lists of columns for both the open and internal datasets 
3. Import and Aggregate Data
    - Loop through all years of the open dataset (which we treat as a "master")
    - Starting with the open dataset select the columns specified by the [Google Sheet](https://docs.google.com/spreadsheets/d/1ndZtYpCjD4CCIyGU2chJjw6yMPr4PDQY6q8OJeoYpso/edit?usp=sharing)
    - Clean any funky data and convert categorical columns to [factors](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/factor)
    - Translate indicator codings to meaningful text descriptions using the relevant data dictionary
    - Repeat for the internal dataset
    - Join the two datasets
    - Add `year` and `population` columns
    - Append the data, then start on the following year
4. Save Data
    - We're done! Save the full dataframe to an `.RDS` file (much smaller than `.csv`)

### 3. `R Shiny` Web App
The `R Shiny` web app consists of two main elements, the `ui` and the `server`.

#### UI
The `ui` ...

Description of general function

Description of project specifics

#### SERVER
The `server` ...

Description of general function

Description of project specifics

---

## About the NYC Poverty Research Unit
The Poverty Research Unit applies data analytics to build an accurate description of who is in poverty, identify some of the leading causes for being in poverty, and measuring how citywide programs work to offset the poverty rate. This data allows [NYC Opportunity](https://www1.nyc.gov/site/opportunity/index.page) to better target anti-poverty initiatives and design more effect metrics in measuring success.

The Poverty Research team produces the annual [official poverty measure](https://www1.nyc.gov/site/opportunity/poverty-in-nyc/poverty-measure.page) of the New York City government, the NYCgov Measure, that provides a more nuanced understanding of poverty in New York City than the federal rate allows. Our poverty research also informs the City's understanding of inequality and the effectiveness of policies in addressing disparities among local residents and communities.
