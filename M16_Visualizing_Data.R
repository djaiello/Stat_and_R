library(tidyverse)

#ALL FIGURES in ggplot2 are created using the same three components:
#   1. "ggplot" function — tells ggplot2 what variables to use
#   2. "geom" function — tells ggplot2 what plots to generate
#   3. formatting or theme functions — tells ggplot2 how to customize the plot

# Familiarize with the "mpg" dataset (built into R tidyverse)
head(mpg)  # OR
view(mpg)

##########################   BUILDING BAR PLOTS    ##########################

# EXAMPLE 1 - geom_bar() expects one variable and generates frequency data

# Import dataset into ggplot2
plt <- ggplot(mpg,aes(x=class))
# Generate  bar plot using "geom_bar()" function
plt + geom_bar()


# EXAMPLE 2 - geom_col()expects two variables where we provide the size of each category's bar
#             Compare number of vehicles from each manufacturer in dataset
    
# Create Summary table
mpg_summary <- mpg %>% group_by(manufacturer) %>% summarize(Vehicle_Count=n(), .groups = 'keep')
# Import dataset into ggplot2
plt2 <- ggplot(mpg_summary,aes(x=manufacturer,y=Vehicle_Count))
# Generate bar plot using "geom_col()" function
plt2 + geom_col()

# OR ALTERNATIVELY...
plt2 <- ggplot(mpg,aes(x=manufacturer))
plt2 + geom_bar() 


########################   ADD FORMATTING FUNCTIONS     ########################

# To change the titles of our x-axis and y-axis
plt2 + geom_col() + xlab("Manufacturing Company") + ylab("Number of Vehicles in Dataset") +
theme(axis.text.x=element_text(angle=45,hjust=1))  # To rotate the x-axis labels 45 degrees


##########################   BUILDING LINE PLOTS    ##########################

# Example 1 - Compare the differences in average highway fuel economy (hwy) of 
#               Toyota vehicles as a function of the different cylinder sizes

# Create summary table
mpg_summary2 <- subset(mpg,manufacturer=="toyota") %>% group_by(cyl) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep')
# Import dataset into ggplot2
plt3 <- ggplot(mpg_summary2,aes(x=cyl,y=Mean_Hwy))
# Generate line plot
plt3 + geom_line()

# Use formatting functions to  adjust the x-axis and y-axis tick values
plt3 + geom_line() + scale_x_discrete(limits=c(4,6,8)) + scale_y_continuous(breaks = c(16:30)) #add line plot with labels


##########################   BUILDING SCATTER PLOTS    ##########################

# Example 1 - Create a scatter plot to visualize the relationship between the size
#               of each car engine (displ) versus their city fuel efficiency

# Import dataset into ggplot2
plt4 <- ggplot(mpg,aes(x=displ,y=cty))
# Generate scatter plot with labels(formatting)
plt4 + geom_point() + xlab("Engine Size (L)") + ylab("City Fuel-Efficiency (MPG)")


# Example 2 - Use a scatter plot to visualize the relationship between city fuel 
#               efficiency and engine size, while grouping by Vehicle Class (color)

# Import dataset into ggplot2
plt5 <- ggplot(mpg,aes(x=displ,y=cty,color=class))
# Add scatter plot with labels 
plt5 + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", color="Vehicle Class")


# Example 3 - Use a scatter plot to visualize the relationship between city fuel 
#               efficiency and engine size, while grouping by Vehicle Class (color)
#               and Type of Drive (shape)

# Import dataset into ggplot2
plt6 <- ggplot(mpg,aes(x=displ,y=cty,color=class,shape=drv))
# Add scatter plot with multiple aesthetics
plt6 + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", 
                           color="Vehicle Class",shape="Type of Drive")


#### SKILL DRILL - Create an additional visualization that uses City Fuel-Efficiency (MPG) 
#                   to determine the size of the data point




##########################   CREATE ADVANCED BOXPLOTS    ##########################

# Example 1 - Generate a boxplot to visualize the highway fuel efficiency of mpg dataset
plt7 <- ggplot(mpg,aes(y=hwy))  # import dataset into ggplot2
plt7 + geom_boxplot()  # add boxplot


# Example 2 - Create a set of boxplots that compares highway fuel efficiency for 
#               each car manufacturer (i.e. Grouped Boxplots)
plt8 <- ggplot(mpg,aes(x=manufacturer,y=hwy))  # import dataset into ggplot2
plt8 + geom_boxplot() + theme(axis.text.x=element_text(angle=45,hjust=1)) #add boxplot and rotate x-axis labels 45 degrees


#### SKILL DRILL - Customize the boxplot to be more aesthetic by adding some color
#                    and using dotted instead of solid lines
# Use dotted lines
plt8 + geom_boxplot(linetype = 2)
# Add color to outliers
plt8 + geom_boxplot(outlier.colour = "red", outlier.shape = 1)
# Add color to plot
plt8 + geom_boxplot(fill = "white", colour = "#3366FF")


##########################   CREATE HEATMAP PLOTS    ##########################

# Example 1 - visualize the average highway fuel efficiency across the type of 
#               vehicle class from 1999 to 2008

# Create summary table
mpg_summary3 <- mpg %>% group_by(class,year) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep')
# Import dataset into ggplot2
plt9 <- ggplot(mpg_summary3, aes(x=class,y=factor(year),fill=Mean_Hwy))
# Create heatmap with labels
plt9 + geom_tile() + labs(x="Vehicle Class",y="Vehicle Year",fill="Mean Highway (MPG)")


# Example 2 - Visualize the difference in average highway fuel efficiency across each 
#             vehicle model from 1999 to 2008

# Create summary table
mpg_summary4 <- mpg %>% group_by(model,year) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep')
# Import dataset into ggplot2
plt10 <- ggplot(mpg_summary4, aes(x=model,y=factor(year),fill=Mean_Hwy))
# Create heatmap with labels and rotate x-axis labels 90 degrees
plt10 + geom_tile() + labs(x="Model",y="Vehicle Year",fill="Mean Highway (MPG)") + theme(axis.text.x = element_text(angle=90,hjust=1,vjust=.5))


##########################   ADD LAYERS TO PLOTS    ##########################

# Type 1 - Layering additional plots that use the same variables and input data 
#            as the original plot
# Example 1 - Recreate our previous boxplot example comparing the highway fuel efficiency
#               across manufacturers, add our data points using the geom_point() function

plt11 <- ggplot(mpg,aes(x=manufacturer,y=hwy)) #import dataset into ggplot2
plt11 + geom_boxplot() +  # add boxplot
    theme(axis.text.x=element_text(angle=45,hjust=1)) +  # rotate x-axis labels 45 degrees
    geom_point()  # overlay scatter plot on top


# Type 2 - Layering of additional plots that use different but complementary data 
#            to the original plot
# Example 2 - Compare average engine size for each vehicle class. Then add in SD.

# Create summary table
mpg_summary <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ), .groups = 'keep')
# Import dataset into ggplot2
plt12 <- ggplot(mpg_summary,aes(x=class,y=Mean_Engine))
# Add scatter plot
plt12 + geom_point(size=4) + labs(x="Vehicle Class",y="Mean Engine Size")


# Create summary table w/ Stand.Dev. data
mpg_summary <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ),
                                             SD_Engine=sd(displ), .groups = 'keep')
# Import dataset into ggplot2
plt13 <- ggplot(mpg_summary,aes(x=class,y=Mean_Engine))
#add scatter plot with labels
plt13 + geom_point(size=4) + labs(x="Vehicle Class",y="Mean Engine Size") + 
      geom_errorbar(aes(ymin=Mean_Engine-SD_Engine,ymax=Mean_Engine+SD_Engine)) #overlay with error bars


##############################################################################
## FACETING - The process of separating out plots for each level in ggplot2
##############################################################################

# Convert to long format
mpg_long <- mpg %>% gather(key="MPG_Type",value="Rating",c(cty,hwy))
head(mpg_long)

# Example 3 - Visualize the different vehicle fuel efficiency ratings by manufacturer
# Import dataset into ggplot2
plt14 <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type))
# Add boxplot with labels rotated 45 degrees
plt14 + geom_boxplot() + theme(axis.text.x=element_text(angle=45,hjust=1))

# Now, facet our previous example by the fuel-efficiency type
   # Import dataset into ggplot2
plt <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type))
   # Create multiple boxplots, one for each MPG type
plt + geom_boxplot() + facet_wrap(vars(MPG_Type)) +
  theme(axis.text.x=element_text(angle=45,hjust=1),legend.position = "none") + xlab("Manufacturer")


#### SKILL DRILL - 1. Create one or two additional plots using a different variable for the facet_wrap().
#                  2. Create another plot using two or more variables for thefacet_wrap(). With this data, 
#                       does adding more variables make the chart easier or harder to understand?




