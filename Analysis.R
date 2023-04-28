#################################################
#Data Analysis on Pollution data 

################################################

################################################
#Necessary Libraries:
library(ggplot2)
library(corrplot)
library(gridExtra)
library(dplyr)
library(tidyr)


################################################
# Get the current working directory
path <- getwd()

# Set the working directory to the "data" directory
setwd(paste0(path, "/data"))

# Read the CSV file into a data frame
data <- read.csv("pollutionData209960.csv")

# View the data frame
View(data)

#summary of data set
summary(data)

# ozone         |particullate_matter |carbon_monoxide |sulfure_dioxide |nitrogen_dioxide   |longitude    
# Min.   : 15   |Min.   : 15.0       |Min.   : 15     |Min.   : 15.0   |Min.   : 15.0      |Min.   :10.26  
# 1st Qu.: 60   |1st Qu.: 62.0       |1st Qu.: 59     |1st Qu.: 82.0   |1st Qu.: 91.0      |1st Qu.:10.26  
# Median :103   |Median : 98.0       |Median :100     |Median :145.0   |Median :134.0      |Median :10.26  
# Mean   :102   |Mean   :101.8       |Mean   :107     |Mean   :132.3   |Mean   :126.8      |Mean   :10.26  
# 3rd Qu.:135   |3rd Qu.:136.0       |3rd Qu.:155     |3rd Qu.:179.0   |3rd Qu.:170.0      |3rd Qu.:10.26  
# Max.   :214   |Max.   :214.0       |Max.   :215     |Max.   :215.0   |Max.   :215.0      |Max.   :10.26  
# latitude        |timestamp        
# Min.   :56.24   |Length:17568      
# 1st Qu.:56.24   |Class :character  
# Median :56.24   |Mode  :character  
# Mean   :56.24                     
# 3rd Qu.:56.24            
# Max.   :56.24   

#data size in bytes

size_of_data=object.size(data)
print(size_of_data)
#-->2180088 bytes

#Dimension of dataset
dimensions=dim(data)
print(dimensions)
#--> [1] 17568     8 
#means 17568 rows and 8 columns


#Checking for na values
na_rows=apply(data,1,function(data) any(is.na(data)))
print(na_rows[na_rows==TRUE])
# logical(0)
#-->After running the function to find null values we see that there are no rows with null values

#Structure of data with data types
structure_of_data=str(data)
# 'data.frame':	17568 obs. of  8 variables:
# $ ozone              : int  41 38 40 41 37 42 44 40 42 45 ...
# $ particullate_matter: int  58 56 51 51 48 43 43 47 50 54 ...
# $ carbon_monoxide    : int  98 98 100 97 96 100 96 95 99 103 ...
# $ sulfure_dioxide    : int  63 68 73 71 76 78 77 72 67 66 ...
# $ nitrogen_dioxide   : int  40 42 37 37 37 32 29 28 26 29 ...
# $ longitude          : num  10.3 10.3 10.3 10.3 10.3 ...
# $ latitude           : num  56.2 56.2 56.2 56.2 56.2 ...
# $ timestamp          : chr  "2014-08-01 00:05:00" "2014-08-01 00:10:00" "2014-08-01 00:15:00" "2014-08-01 00:20:00" .


data_without_categoricals=subset(data,select = c(1:5))
#removes the categorical features in dataset

#finds the correlation values of features with eachother
correlation=cor(data_without_categoricals)

#Finding distribution plots for each feature using subplot 
data_long <- data_without_categoricals %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value")
# create a list of ggplot objects, one for each variable
plot_list <- lapply(unique(data_long$variable), function(var) {
  ggplot(data_long %>% filter(variable == var), aes(x = value)) +
    geom_bar() +
    labs(title = var, x = var, y = "Count") +
    theme_bw()
})

# plot the ggplot objects in a grid
gridExtra::grid.arrange(grobs = plot_list, ncol = 3)
#the plot is saved manually in the directory
data_for_CO_viz=data[1:length(data['ozone'])-2000,]
data_for_CO_viz$carbon_monoxide=data_for_CO_viz$carbon_monoxide/1.0

data_for_CO_viz$timestamp=as.POSIXct(data_for_CO_viz$timestamp, format = '%Y-%m-%d %H:%M:%S')

plot(as.numeric(data_for_CO_viz$carbon_monoxide),type = 'l', xlab='Time',ylab='co')

  