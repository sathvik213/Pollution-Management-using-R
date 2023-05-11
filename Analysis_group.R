

#################################################
#Data Analysis on Pollution data 

################################################

################################################
#Necessary Libraries:
library(ggplot2) #CTRL + ENTER
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
data <- read.csv("GROUP1pollutionData209907.csv")

# View the data frame
View(data)

#summary of data set
summary(data)

# summary(data)
# ozone           |particullate_matter |carbon_monoxide |sulfure_dioxide |nitrogen_dioxide
# Min.   : 15.0   |Min.   : 15.00      |Min.   : 15.0   |Min.   : 15.0   |Min.   : 15.0   
# 1st Qu.: 78.0   |1st Qu.: 53.00      |1st Qu.: 55.0   |1st Qu.: 83.0   |1st Qu.: 82.0   
# Median :121.0   |Median : 94.00      |Median : 96.0   |Median :135.0   |Median :127.0   
# Mean   :119.9   |Mean   : 99.65      |Mean   :102.4   |Mean   :126.1   |Mean   :123.3   
# 3rd Qu.:168.0   |3rd Qu.:142.00      |3rd Qu.:147.0   |3rd Qu.:170.0   |3rd Qu.:164.0   
# Max.   :215.0   |Max.   :215.00      |Max.   :214.0   |Max.   :215.0   |Max.   :215.0   
# longitude      |latitude         |timestamp        
# Min.   :10.27   |Min.   :56.22   |Length:17568      
# 1st Qu.:10.27   |1st Qu.:56.22   |Class :character  
# Median :10.27   |Median :56.22   |Mode  :character  
# Mean   :10.27   |Mean   :56.22                     
# 3rd Qu.:10.27   |3rd Qu.:56.22                     
# Max.   :10.27   |Max.   :56.22     

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
#   $ ozone              : int  47 52 53 54 51 52 52 56 56 55 ...
# $ particullate_matter: int  61 56 61 60 56 59 63 68 66 63 ...
# $ carbon_monoxide    : int  54 52 51 50 49 49 46 41 45 48 ...
# $ sulfure_dioxide    : int  53 48 47 47 49 49 46 48 44 45 ...
# $ nitrogen_dioxide   : int  35 31 28 25 20 23 21 20 25 27 ...
# $ longitude          : num  10.3 10.3 10.3 10.3 10.3 ...
# $ latitude           : num  56.2 56.2 56.2 56.2 56.2 ...
# $ timestamp          : chr  "01/08/2014 00:05" "01/08/2014 00:10" "01/08/2014 00:15" "01/08/2014 00:20" ...

data_without_categoricals=subset(data,select = c(1:5))
#removes the categorical features in dataset

#finds the correlation values of features with eachother
correlation=cor(data_without_categoricals)

correlation=data.frame(correlation)
View(correlation)

columns_to_check <- colnames(data_without_categoricals)
detect_outliers <- function(vector, k = 1.5) {
  q1 <- quantile(vector, 0.25)
  q3 <- quantile(vector, 0.75)
  iqr <- q3 - q1
  fence_low <- q1 - k * iqr
  fence_high <- q3 + k * iqr
  outliers <- vector < fence_low | vector > fence_high
  return(outliers)
}



# Detecting outliers in the dataframe
outliers <- lapply(data_without_categoricals[columns_to_check], detect_outliers)
data_without_categoricals_cleaned <- data_without_categoricals
for (col in columns_to_check) {
  data_without_categoricals_cleaned <- data_without_categoricals[!outliers[[col]], ]
}
# dim(data_without_categoricals_cleaned)
# [1] 17568     5

#Finding distribution plots for each feature using subplot 
data_long <- data_without_categoricals_cleaned %>%
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

data_for_CO_viz=data[1:length(data['ozone'])-2000,]
data_for_CO_viz$carbon_monoxide=data_for_CO_viz$carbon_monoxide/1.0

data_for_CO_viz$timestamp=as.POSIXct(data_for_CO_viz$timestamp, format = '%Y-%m-%d %H:%M:%S')
dev.off()
plot(as.numeric(data_for_CO_viz$carbon_monoxide),type = 'l', xlab='Time',ylab='co')
