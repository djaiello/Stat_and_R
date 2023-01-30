library(tidyverse)

#########################  SAMPLE VS. POPULATION DATASET  #########################

# Import used car dataset
population_table <- read.csv('used_car_data.csv',check.names = F,stringsAsFactors = F)

# Visualize the distribution of driven miles for our entire population dataset
# Import dataset into ggplot2
plt <- ggplot(population_table,aes(x=Miles_Driven))
# Visualize distribution using density plot
plt + geom_density()
# CONCLUSION:  Distribution of raw mileage is RIGHT SKEWED - a few used vehicles have 
#              more than 100,000 miles, while the majority of used vehicles have less
#              than 50,000 miles

# Visualize the distribution of "log10" of driven miles for our entire population dataset
# Import dataset into ggplot2
plt2 <- ggplot(population_table,aes(x=log10(Miles_Driven)))
# Visualize distribution using density plot
plt2 + geom_density()
# CONCLUSION:  The "log10" transformation makes our mileage data more normal and
#              thus, better for applying basic statistical analysis on.


# Create a sample dataset using dplyr's sample_n()function
# Randomly sample 50 data points
sample_table <- population_table %>% sample_n(100)
# Import dataset and Visualize distribution using density plot
ggplot(sample_table,aes(x=log10(Miles_Driven))) + geom_density()

# CONCLUSION: There are two basic ways to check that our sample data is representative
#             of the underlying population: 1.) a qualitative assessment of each 
#             density plot(ABOVE) or 2.) a quantitative statistical test such as...


################################################################################
##   Measuring statistical difference between the means of a sample datasets  ##
################################################################################

##############################   ONE-SAMPLE t-TEST  ##############################

# The one-sample t-test is used to determine whether there is a statistical difference
# between the means of a sample dataset and a hypothesized, potential population dataset.
# In other words, a one-sample t-test is used to test the following hypotheses:
  
  # H0 : There is no statistical difference between the observed sample mean and its
  #       presumed population mean.
  # Ha : There is a statistical difference between the observed sample mean and its
  #       presumed population mean.

# There are five assumptions about our input data:

# 1. The input data is numerical and continuous. This is because we are testing the 
#     distribution of two datasets.
# 2. The sample data was selected randomly from its population data.
# 3. The input data is considered to be normally distributed.
# 4. The sample size is reasonably large. Generally speaking, this means that the 
#      sample data distribution should be similar to its population data distribution.
# 5. The variance of the input data should be very similar.

# NOTE: By default, the "t.test()" function assumes a two-sided t-Test. ('alternative'
#       argument left as default)

# EXAMPLE: To test if the miles driven from our previous sample dataset is statistically 
#    different from the miles driven in our population data. Compare sample versus 
#    population means
t.test(log10(sample_table$Miles_Driven),mu=mean(log10(population_table$Miles_Driven)))

# CONCLUSION: Our p-value is above our significance level (0.05). Therefore, we DO 
#             NOT have sufficient evidence to reject the null hypothesis, and we 
#             would state that the two means are statistically similar.


##############################   TWO-SAMPLE t-TEST  ##############################

# Instead of testing whether a sample mean is statistically different from its 
# population mean, the unpaired two-sample t-Test determines whether the means of 
# two samples fro the same population are statistically different. In other words,
# a two-sample t-Test isused to test the following hypotheses:

  # H0 : There is no statistical difference between the two observed sample means.
  # Ha : There is a statistical difference between the two observed sample means.

# The same five assumptions about our input data still apply (See Above)

# NOTE: By default, the "t.test()" function assumes a 'two-sided' t-Test ('alternative'
#       argument left as default) and an 'unpaired" t-Test.


# EXAMPLE: To test whether the mean miles driven of two samples from our used car 
#    dataset are statistically different.

# Generate two samples of 50 randomly sampled data points to compare
sample_table1 <- population_table %>% sample_n(50)
sample_table2 <- population_table %>% sample_n(50)

# Compare the means of two samples
t.test(log10(sample_table$Miles_Driven),log10(sample_table2$Miles_Driven))

# CONCLUSION: The p-value is above the assumed significance level. Therefore, we 
#             would state that there is not enough evidence to reject the null
#             hypothesis and we can confirm our two samples are not statistically
#             different.


##########################   PAIRED TWO-SAMPLE t-TEST  ##########################

# In many cases, the two-sample t-test will be used to compare two samples from a 
# single population dataset. However, two-sample t-tests are flexible and can be used 
# for another purpose: to compare two samples, each from a different population. 
# This is known as a pair t-test, because we pair observations in one dataset with 
# observations in another. We use the pair t-test when:

   # 1.) Comparing measurements on the same subjects across a single span of time 
   #       (e.g., fuel efficiency before and after an oil change)
   # 2.) Comparing different methods of measurement (e.g., testing tire pressure 
   #       using two different tire pressure gauges)

# The biggest difference between paired and unpaired t-tests is how the means are 
#   calculated. In an unpaired t-test, the means are calculated by adding up all 
#   observations in a dataset, and dividing by the number of data points. In a paired
#   t-test, the means are determined from the difference between each paired observation.
#   As a result of the new mean calculations, our paired t-test hypotheses will be 
#   slightly different:
  
  # H0 : The difference between our paired observations (the true mean difference, 
  #        or "μd") is equal to zero.
  # Ha : The difference between our paired observations (the true mean difference, or 
  #       "μd") is not equal to zero.


# EXAMPLE: Is there a statistical difference in overall highway fuel efficiency  
#   between vehicles manufactured in 1999 versus 2008?

# Create two samples from different time frames
mpg_data <- read.csv('mpg_modified.csv')  # import dataset
mpg_1999 <- mpg_data %>% filter(year==1999)  # select only 1999 data points
mpg_2008 <- mpg_data %>% filter(year==2008)  # select only 2008 data points

# Compare the mean difference between two samples
t.test(mpg_1999$hwy, mpg_2008$hwy, paired = T)

# CONCLUSION: The p-value is above the assumed significance level. Therefore, we
#             would state that there is not enough evidence to reject the null 
#             hypothesis and there is no overall difference in fuel efficiency 
#             between vehicles manufactured in 1999 versus 2008.


######################   ANALYSIS OF VARIANCE (ANOVA) TEST  #####################

# When dealing with large real-world numerical data, we're often interested in 
# comparing the means across more than two samples or groups. The most straightforward
# way to do this is to use the analysis of variance (ANOVA) test, which is used to
# compare the means of a continuous numerical variable across a number of groups 
# (or factors in R).

# Depending on your dataset and questions you wish to answer, an ANOVA can be used 
#  in multiple ways. For the purposes of this course, we'll concentrate on two 
#  different types of ANOVA tests:
  
   # - A "one-way ANOVA" is used to test the means of a single dependent variable 
   #      across a single independent variable with multiple groups. (e.g., fuel 
   #      efficiency of different cars based on vehicle class).

   # - A "two-way ANOVA" does the same thing, but for two different independent 
   #      variables (e.g., vehicle braking distance based on weather conditions 
   #      and transmission type).

# Regardless of whichever type of ANOVA test we use, the statistical hypotheses of 
#    an ANOVA test are the same:
  
   # H0 : The means of all groups are equal, or µ1 = µ2 = … = µn.

   # Ha : At least one of the means is different from all other groups.


# Additionally, both ANOVA tests have assumptions about the input data that must 
#    be validated prior to using the statistical test:
  
   # 1.) The dependent variable is numerical and continuous, and the independent 
   #       variables are categorical.
   # 2.) The dependent variable is considered to be normally distributed.
   # 3.) The variance among each group should be very similar.


# EXAMPLE: Is there any statistical difference in the horsepower of a vehicle 
#          based on its engine type?

# Clean our data before we begin
mtcars_filt <- mtcars[,c("hp","cyl")]       # filter columns from mtcars dataset
mtcars_filt$cyl <- factor(mtcars_filt$cyl)  # convert numeric column to factor

# Compare means across multiple levels
aov(hp ~ cyl,data=mtcars_filt)

# Must wrap "aov()" in "summary()" function to see p-values
summary(aov(hp ~ cyl,data=mtcars_filt)) 

# RESULT: For our purposes, we are only concerned with the "Pr(>F)" column, which
#         is the same as our p-value statistic - 1.32e-08

# CONCLUSION: Our p-value is 1.32 ✕ 10^-8^, which is much smaller than our assumed
#             0.05 percent significance level. Therefore, we would state that there
#             is sufficient evidence to reject the null hypothesis and accept that 
#             there is a significant difference in horsepower between at least one
#             engine type and the others.


################################################################################
##       Measuring correlation or how strongly two variables are related      ##
################################################################################

############################   CORRELATION ANALYSIS  ###########################

# In data analytics, we'll often ask the question "is there any relationship between
# variable A and variable B?" This concept is known in statistics as correlation. 
# Correlation analysis is a statistical technique that identifies how strongly (or
# weakly) two variables are related.

# Correlation is quantified by calculating a "correlation coefficient", and the most 
# common correlation coefficient is the "Pearson correlation coefficient". The Pearson
# correlation coefficient is denoted as "r" in mathematics and is used to quantify 
# a linear relationship between two numeric variables. The Pearson correlation 
# coefficient ranges between -1 and 1, depending on the direction of the linear 
# relationship:

   # An "ideal positive correlation" where r = 1. When two variables are positively 
   #   correlated, they move in the same direction.

   # An "ideal negative correlation" where r = -1. When two variables are negatively
   #   correlated, they move in opposite directions.

   # OR ... "no correlation" where r ≈ 0. When two variables are not correlated, 
   #   their values are completely independent between one another.

# Use the "Pearson correlation coefficient" to calculate the correlation strength:

#               Absolute Value of r	   |   Strength of Correlation
#                     r < 0.3               	None or very weak
#                   0.3 ≤ r < 0.5	                 Weak
#                   0.5 ≤ r < 0.7  	             Moderate
#                     r ≥ 0.7	                    Strong


# EXAMPLE: Test whether or not horsepower (hp) is correlated with quarter-mile race 
#             time (qsec).

# Look at the "mtcars" dataset
head(mtcars)

# Plot our two variables using a scatter plot (geom_point() function)
plt <- ggplot(mtcars,aes(x=hp,y=qsec))  # import dataset into ggplot2
plt + geom_point()  # create scatter plot

# CONCLUSION: Looking at our plot, it appears that the quarter-mile time is negatively
#             correlated with horsepower. In other words, as vehicle horsepower 
#             increases, vehicle quarter-mile time decreases.

# Use "cor()" function to quantify the strength of the correlation between the 
#    plotted two variables
cor(mtcars$hp,mtcars$qsec)   # calculate correlation coefficient

# CONCLUSION: From our correlation analysis, we have determined that the r-value 
#             between horsepower and quarter-mile time is -0.71, which is a strong 
#             negative correlation.


# EXAMPLE2: Test whether or not vehicle miles driven and selling price are correlated.

# Import and examine used car data
used_cars <- read.csv('used_car_data.csv',stringsAsFactors = F)  # read in dataset
head(used_cars)

# Plot the two variables
plt <- ggplot(used_cars,aes(x=Miles_Driven,y=Selling_Price)) #import dataset into ggplot2
plt + geom_point() #create a scatter plot

# CONCLUSION: Scatter plot does not help us determine whether or not our two 
#              variables are correlated.  Lets calculate the Pearson C.C.

# Calculate correlation coefficient
cor(used_cars$Miles_Driven,used_cars$Selling_Price)  

# CONCLUSION: Calculated r-value is 0.02, which means that there is a negligible 
#             correlation between miles driven and selling price in this dataset.


#############################  CORRELATION MATRIX  #############################

# A correlation matrix is a lookup table where the variable names of a data frame
# are stored as rows and columns, and the intersection of each variable is the
# corresponding Pearson correlation coefficient.

# EXAMPLE: Produce a correlation matrix for our "used_cars" dataset

# Select numeric columns from our data frame &Convert data frame into numeric matrix
used_matrix <- as.matrix(used_cars[,c("Selling_Price","Present_Price","Miles_Driven")])

# Produce correlation matrix using "cor()" function
cor(used_matrix)

# CONCLUSION: If we look at the correlation matrix using either rows or columns, 
#             we can identify pairs of variables with strong correlation (such as
#             selling price versus present price), or no correlation (like our 
#             previous example of miles driven versus selling price).


################################################################################
##    Predicting future observations and measurements from a linear model     ##
################################################################################

##########################  SIMPLE LINEAR REGRESSION  ##########################

# Linear regression is a statistical model that is used to predict a continuous 
# dependent variable based on one or more independent variables fitted to the 
# equation of a line.

# The job of a linear regression analysis is to calculate the slope and y intercept
# values (also known as coefficients) that minimize the overall distance between 
# each data point from the linear model. There are two basic types:

    # "Simple linear regression" builds a linear regression model with one independent 
    #   variable.

    # "Multiple linear regression" builds a linear regression model with two or more 
    #   independent variables.

# In contrast to correlation analysis, which asks whether a relationship exists 
# between variables A and B, linear regression asks if we can predict values for 
# variable A using a linear model and values from variable B.

# To answer this question, linear regression tests the following hypotheses:

   # H0 : The slope of the linear model is zero, or m = 0

   # Ha : The slope of the linear model is not zero, or m ≠ 0

# If there is no significant linear relationship, each dependent value would be 
# determined by random chance and error. Therefore, our linear model would be a 
# flat line with a slope of 0.

# To quantify how well our linear model can be used to predict future observations,
#   our linear regression functions will calculate an r-squared value. The "r-squared"
#   (r2) value is also known as the "coefficient of determination" and represents 
#   how well the regression model approximates real-world data points. In most cases, 
#   the r-squared value will range between 0 and 1 and can be used as a probability
#   metric to determine the likelihood that future data points will fit the linear 
#   model.

# There are a few assumptions about our input data that must be met before we perform
#   our statistical analysis:

   # 1.) The input data is numerical and continuous.

   # 2.) The input data should follow a linear pattern.

   # 3.) There is variability in the independent x variable. This means that there must
   #      be more than one observation in the x-axis and they must be different values.

   # 4.) The residual error (the distance from each data point to the line) should
   #      be normally distributed.

# EXAMPLE: Using our simple linear regression model, we'll test whether or not 
#            quarter-mile race time (qsec) can be predicted using a linear model 
#            and horsepower (hp). **** Remember, Pearson correlation coefficient's
#            r-value was -0.71, which means there is a strong negative correlation
#            between our variables.

# Create linear model (Y ~ A, input data frame), where Y = Dep.Var. and A = Indep.Var.)
lm(qsec ~ hp,mtcars)

# CONCLUSION:  "lm()" function returns our y intercept (Intercept) and slope (hp) 
#               coefficients. Therefore, the linear regression model for our dataset
#               would be [qsec = -0.02hp + 20.56](y=mx+b)


# To determine our p-value and our r-squared value for a simple linear regression 
#  model, we'll use the "summary()" function:
summary(lm(qsec~hp,mtcars))   # summarize linear model

# CONCLUSION: The r-squared value is 0.50, which means that roughly 50% of all quarter
#             mile time predictions will be correct when using this linear model. 
#             Compared to the Pearson correlation coefficient between quarter-mile race
#             time and horsepower of -0.71, we can confirm our r-squared value is 
#             approximately the square of our r-value.

#             In addition, the p-value of our linear regression analysis is 5.77 x 10-6,
#             which is much smaller than our assumed significance level of 0.05%. 
#             Therefore, we can state that there is sufficient evidence to reject our
#             null hypothesis, which means that the slope of our linear model is not
#             zero.

# NOW WE CAN visualize the fitted line against our dataset using ggplot2.
  # Calculate the data points to use for our line plot
model <- lm(qsec ~ hp,mtcars)  # create linear model

  # Determine y-axis values from linear model
yvals <- model$coefficients['hp']*mtcars$hp + model$coefficients['(Intercept)']

  # Plot linear model over our scatter plot
plt <- ggplot(mtcars,aes(x=hp,y=qsec))  # import dataset into ggplot2
plt + geom_point() + geom_line(aes(y=yvals), color = "red") # plot scatter and linear model

# CONCLUSION: Using our visualization in combination with our calculated p-value 
#             and r-squared value, we have determined that there is a significant 
#             relationship between horsepower and quarter-mile time.

#             Although the relationship between both variables is statistically 
#             significant, this linear model is not ideal. According to the 
#             calculated r-squared value, using only quarter-mile time to predict
#             horsepower is roughly as accurate as guessing using a coin toss


##########################  MULTIPLE LINEAR REGRESSION  ##########################

# Multiple linear regression is a statistical model that extends the scope and 
#   flexibility of a simple linear regression model. Instead of using a single independent
#   variable to account for all variability observed in the dependent variable, a 
#   multiple linear regression uses multiple independent variables to account for 
#   parts of the total variance observed in the dependent variable.

# As a result, the linear regression equation is no longer y = mx + b. Instead, 
#  the multiple linear regression equation becomes y = m1x1 + m2x2 + … + mnxn + b,
#  for all independent x variables and their m coefficients.

# In actuality, a multiple linear regression is a simple linear regression in 
#  disguise—all of the assumptions, hypotheses, and outputs are the same. The only
#  difference between multiple linear regression and simple linear regression is 
# how we will evaluate the outputs.


# EXAMPLE: From our last example, we determined that quarter-mile time was not 
#           adequately predicted from just horsepower. To better predict the 
#           quarter-mile time (qsec) dependent variable, we can add other variables
#           of interest such as fuel efficiency (mpg), engine size (disp), rear 
#           axle ratio (drat), vehicle weight (wt), and horsepower (hp) as 
#           independent variables to our multiple linear regression model.

# Generate multiple linear regression model
lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars)

# CONCLUSION: The output of multiple linear regression using the lm() function 
#             produces the coefficients for each variable in the linear equation
#             Therefore, the multiple linear regression model for our dataset
#             would be [qsec = 0.11(mpg) + -0.01(disp) + -).58(drat) + 1.79(wt) +
#                                -0.02(hp) + 16.54]

# NOTE: Because multiple linear regression models use multiple variables and 
#       dimensions, they are almost impossible to plot and visualize.

#  To obtain our statistical metrics use the "summary()" function (summary statistics)
summary(lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars))

# CONCLUSION: In the summary output, each Pr(>|t|) value represents the probability
#             that each coefficient contributes a random amount of variance to the 
#             linear model. According to our results, vehicle weight and horsepower
#             (as well as intercept) are statistically unlikely to provide random 
#             amounts of variance to the linear model. In other words the vehicle 
#             weight and horsepower have a significant impact on quarter-mile race 
#             time. When an intercept is statistically significant, it means there 
#             are other variables and factors that contribute to the variation in 
#             quarter-mile time that have not been included in our model. These 
#             variables may or may not be within our dataset and may still need 
#             to be collected or observed.

#             Despite the number of significant variables, the multiple linear 
#             regression model outperformed the simple linear regression. According
#             to the summary output, the r-squared value has increased from 0.50 
#             in the simple linear regression model to 0.71 in our multiple linear
#             regression model while the p-value remained significant.


################################################################################
##    Comparing distribution of frequencies(categorical data) across groups   ##
################################################################################

##############################  CHI-SQUARED TEST   ##############################

# The chi-squared test is used to compare the distribution of frequencies across
# two groups and tests the following hypotheses:

  # H0 : There is no difference in frequency distribution between both groups.

  # Ha : There is a difference in frequency distribution between both groups

# In data science, we'll often compare frequency data across another dichotomous
#  factor such as gender, A/B groups, member/non-member, and so on. In these cases,
#  we may ask ourselves, "Is there a difference in frequency between our first and
#  second groups?" To test this question, we can perform a chi-squared test.

# Before we can perform our chi-squared analysis, we must ensure that our dataset
#   meets the assumptions of the statistical test:
  
   # 1.) Each subject within a group contributes to only one frequency. In other
   #       words, the sum of all frequencies equals the total number of subjects 
   #       in a dataset.
   # 2.) Each unique value has an equal probability of being observed.
   # 3.) There is a minimum of five observed instances for every unique value for 
   #       a 2x2 chi-squared table.
   # 4.) For a larger chi-squared table, there is at least one observation for every
   #       unique value and at least 80% of all unique values have five or more 
   #       observations.

# The most straightforward implementation of "chisq.test()" function is passing 
#  the function to a "contingency table". A contingency table is another name for
#  a frequency table produced using R's table() function. R's table() function does
#  all the heavy lifting for us by calculating frequencies across factors.


# EXAMPLE:  If we want to test whether there is a statistical difference in the 
#           distributions of vehicle class across 1999 and 2008 from our mpg 
#           dataset, we would first need to build our contingency table as follows:

# Generate contingency table
tbl <- table(mpg$class,mpg$year)
table(mpg$class,mpg$year) # printed to the console

# Compare categorical distributions
chisq.test(tbl) 

# CONCLUSION: The p-value is above the assumed significance level. Therefore, we
#             would state that there is not enough evidence to reject the null 
#             hypothesis, and there is no difference in the distribution of vehicle
#             class across 1999 and 2008 from the mpg dataset.

#             The chi-squared warning message is due to the small sample size. 
#             Because the p-value is so large, we are not too concerned that our 
#             interpretation may be incorrect.

# Despite having no quantitative input, the chi-squared test enables data scientists
#  to quantify the distribution of categorical variables. Although this test can be 
#  applied to more groups and larger datasets, it does have a limit. Increasing the
#  number of groups also increases the likelihood that insignificant changes will 
#  incorrectly be considered significant. Therefore, it's important to keep the number
#  of unique values and groups relatively low. A good rule of thumb is to keep the 
#  number of unique values and groups lower than 20, which means the degrees of 
#  freedom (df in the output) is less than or equal to 19.





################################  A/B TESTING   ################################

# "A/B testing" is a randomized controlled experiment that uses a control (unchanged)
# and experimental (changed) group to test potential changes using a success metric.
# A/B testing is used to test whether or not the distribution of the success metric
# increases in the experiment group instead of the control group; we would not want 
# to make changes to the product that would cause a decrease in the success metric.

# For our purposes, we can apply the following logic to determine the most 
#   appropriate statistical test:

   # If the success metric is numerical and the sample size is small, a "z-score 
   #    summary statistic" can be sufficient to compare the mean and variability of
   #    both groups.

   # If the success metric is numerical and the sample size is large, a "two-sample
   #    t-test" should be used to compare the distribution of both groups.

   # If the success metric is categorical, you may use a "chi-squared test" to 
   #    compare the distribution of categorical values between both groups.


# After determining the testing conditions and statistical test, the next 
#  consideration in A/B testing is sample size. It's important to collect 
#  a sufficient number of data points for each group to ensure that the A/B test
#  results are meaningful.




