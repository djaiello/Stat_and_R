library(jsonlite)  # importing a library (no quotes)

################  DATA STRUCTURES  ################
x<-3  # declare a named value (variable) w/ value
x<-5  # reassign a named value (variable) w/ new value

   # declare a vector(array) using the "c()" function call
numlist <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)  


################  READ IN DATA  ################
# Read in .csv data file into a data frame (table) structure
demo_table <- read.csv(file='demo.csv',check.names=F,stringsAsFactors = F)

# Read in .json data file into a data frame (table) structure
#     "txt" parameter can be a JSON string, URL or file
demo_table2 <- fromJSON(txt='demo.json')


################  SELECT DATA  ################
y <- c(3,3,2,2,5,5,8,8,9)
# select the third value in numerical vector "y"
#    NOTE: indexes in R start at '1' NOT '0'
y[3]

# select the third row of Year column using bracket notation
demo_table[3,"Year"]  # OR Alternatively...
demo_table[3,3]  # as "Year" column is the 3rd one

# select "Vehicle_Class" column from data frame as a vector
demo_table$"Vehicle_Class"  # uses the '$' operator

# OR select one single value from a data frame
demo_table$"Vehicle_Class"[2]


###############  SELECT SUBSET DATA (FILTER)  ###############
# Simple filter to only have rows where vehicle price is greater than $10,000
filter_table <- demo_table2[demo_table2$price > 10000,]

# complex filter by price, drivetrain, & title status
filter_table2 <- demo_table2[(demo_table2$price > 10000) & 
                             (demo_table2$drive == "4wd") &
                             ("clean" %in% demo_table2$title_status),]

# Filter using "subset()" function call (filter by price, drivetrain, & title)
filter_table3 <- subset(demo_table2, price > 10000 & 
                          drive == "4wd" & 
                          "clean" %in% title_status)


################  SAMPLING DATA (RANDOM)  ################
# Sample a larger vector to create a smaller vector of 4 random values
rand_sample <- sample(c("cow", "deer", "pig", "chicken", "duck", "sheep", "dog"), 4)

# Sample a 2-dimensional data structure (e.g. data frame, matrix) in 3 steps
#   1. Create a numerical vector that is the same length as the number of rows 
#       in the data frame using the colon (:) operator.
num_rows <- 1:nrow(demo_table)  # declare 4 row vector
#   2. Use the sample() function to sample a list of indices from first vector.
sample_rows <- sample(num_rows, 3)
#   3. Use bracket notation to retrieve data frame rows from sample list.
demo_table_rando <- demo_table[sample_rows,]

#    OR ALTERNATIVELY all three steps in one statement...
demo_table_rando <- demo_table[sample(1:nrow(demo_table), 3),]


