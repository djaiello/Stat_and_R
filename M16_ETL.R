library(tidyverse)
library(jsonlite)

# Read in .csv data file into a data frame (table) structure
demo_table <- read.csv(file='demo.csv',check.names=F,stringsAsFactors = F)
demo_table3 <- read.csv('demo2.csv',check.names = F,stringsAsFactors = F)

# Read in .json data file into a data frame (table) structure
#     "txt" parameter can be a JSON string, URL or file
demo_table2 <- fromJSON(txt='demo.json')


################  TRANSFORM DATA COLUMNS ################
# Use "mutate()" function to add two columns to original data frame
demo_table2 <- demo_table %>% mutate(Mileage_per_Year=Total_Miles/(2020-Year),IsActive=TRUE)


###################  GROUP/SUMMARIZE DATA ###################
# Group our used car data by the condition of the vehicle and
#   determine the average mileage per condition (create summary table)
summarize_demo <- demo_table2 %>% group_by(condition) %>% 
         summarize(Mean_Mileage=mean(odometer), .groups = 'keep')

# Create summary table with multiple summarized columns
summarize_demo2 <- demo_table2 %>% group_by(condition) %>% 
  summarize(Mean_Mileage=mean(odometer), Maximum_Price=max(price), Num_Vehicles=n(), .groups = 'keep') 

# .groups = "drop_last" - drops the last grouping level (default)
# .groups = "drop" - drops all grouping levels and returns a tibble
# .groups = "keep" preserves the grouping of the input
# .groups = "rowwise" turns each row into its own group


######################  RESHAPE DATA ######################
# Using "gather()" function to reshape wide format to long format
#   NOTE:  for new code we recommend switching to "pivot_longer()" function
long_table <- gather(demo_table3,key="Metric",value="Score",buying_price:popularity)
    # OR ALTERNATIVELY...
long_table <- demo_table3 %>% gather(key="Metric",value="Score",buying_price:popularity)


# Using "spread()" function to reshape long format to wide format
#   NOTE:  for new code we recommend switching to "pivot_wider()" function
wide_table <- long_table %>% spread(key="Metric",value="Score")

# Check if "wide-format table" is exactly same as original "demo_table3", 
# 1. Sort the columns of both data frames using the "order()" and 
#    "colnames()" functions
table <-demo_table3[,order(colnames(wide_table))]
# OR ALTERNATIVELY ...  sort columns using "colnames()" function only
table <- demo_table3[,(colnames(wide_table))]

# 3. Use "all.equal()" function
all.equal(demo_table3, wide_table)















