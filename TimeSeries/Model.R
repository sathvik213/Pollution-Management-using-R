#################################################
#Data Modelling on Pollution data 

################################################

################################################
#Necessary Libraries:
library(ggplot2)
library(corrplot)
library(gridExtra)
library(dplyr)
library(tidyr)
library(forecast)
library(tseries)
library(stats)

################################################
# Get the current working directory
path <- getwd()

# Set the working directory to the "data" directory
# setwd(paste0(path, "/data"))

# Read the CSV file into a data frame
data <- read.csv("pollutionData209960.csv")


#removing missing valued rows
df_clean <- data[complete.cases(data$carbon_monoxide), ]
data=df_clean

#parsing in to date and time format
data$timestamp <- as.POSIXct(data$timestamp)






#Data Splitting into train and test
set.seed(122)
train_loc <- sample(nrow(data), floor(nrow(data)*0.8))#80% for training
train_data=data[train_loc,]
test_data=data[-train_loc,]


#Dimensions of training data split
print(dim(train_data))
#[1] 14054     8
#Dimensions of testing data split
print(dim(test_data))
#[1] 3514    8

#time series plot of data
plot(as.numeric(data$carbon_monoxide),type = 'l', xlab='Time',ylab='co')


#Fitting ARIMA model 
series_data <- ts(train_data$carbon_monoxide, frequency = 288, start = c(2014, 8, 1))

# Fit an ARIMA model with (1,1,1) values of p,q,r
arima_model_1 <- arima(ts_data, order = c(1, 1, 1))

# View the model summary
summary(arima_model_1)
#MAPE=3.779252
##############################################################################

# Fit an ARIMA model with (1,2,2) values of p,q,r
arima_model_2 <- arima(ts_data, order = c(1,2,2))

# View the model summary
summary(arima_model_2)

#MAPE=3.77436 
##############################################################################

# Fit an ARIMA model with (2,1,2) values of p,q,r
arima_model_3 <- arima(ts_data, order = c(2, 1, 2))

# View the model summary
summary(arima_model_3)
#MAPE=3.779084
##############################################################################

# Fit an ARIMA model with (3,1,1) values of p,q,r
arima_model_4 <- arima(ts_data, order = c(3,1,1))

# View the model summary
summary(arima_model_4)
#MAPE=3.777577
##############################################################################

