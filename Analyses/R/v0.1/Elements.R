#### ELEMENTS #####

# Conditional Sidebar for Tab

# Facet Grid Plots
# https://stackoverflow.com/questions/20953594/barplot-in-r-ggplot-with-multiple-factors


# DIST. based on personal data
# https://stackoverflow.com/questions/34029811/fill-different-colors-for-each-quantile-in-geom-density-of-ggplot/34032611#34032611?newreg=f57a6ca873ac48e48be23f307ffa45dc

incomes = df_c %>% 
  filter(sex == 'Male') %>%
  filter(educ_attain == 'Some College') %>%
  select('nyc_gov_income')

# turn into vector
incomes = incomes[[1]]
# get rid of negative income values
incomes[incomes<0] = 0

dens <- density(incomes, from = 0)
df <- data.frame(x=dens$x, y=dens$y)
breaks <- c(0, poverty, near_poverty, Inf)
df$quant <- factor(findInterval(df$x,breaks))
ggplot(df, aes(x,y)) + 
  geom_line() + 
  geom_ribbon(aes(ymin=0, ymax=y, fill=quant)) + 
  scale_x_continuous(labels = scales::comma) + 
  scale_fill_brewer(guide="none") +
  xlab('Income') +
  ylab('Proportion') +
  theme_classic() +
  theme(axis.text.y = element_blank())

