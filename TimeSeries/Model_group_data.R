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
setwd(paste0(path, "/data"))

# Read the CSV file into a data frame
pollution_data <- read.csv("GROUP1pollutionData209907.csv")


# For splitting the data set 
n_train <- round(nrow(pollution_data) * 0.975)
train_data <- pollution_data[1:n_train, ]
test_data <- pollution_data[(n_train+1):nrow(data), ]


# Considering only carbon_monoxide values
train_data <- train_data$carbon_monoxide
test_data <- test_data$carbon_monoxide

#setting frequency for 288 because there are 288 5-minute intervals in data
train_ts <- ts(train_data, frequency = 288)


# Fit an ARIMA model with (1,1,1) values of p,q,r
arima_model_1 <- arima(train_ts, order = c(1, 1, 1))
# Fit an ARIMA model with (1,2,2) values of p,q,r
arima_model_2 <- arima(train_ts, order = c(1,2,2))
# Fit an ARIMA model with (2,1,2) values of p,q,r
arima_model_3 <- arima(train_ts, order = c(2, 1, 2))
# Fit an ARIMA model with (3,1,1) values of p,q,r
arima_model_4 <- arima(train_ts, order = c(3,1,1))
###########################################################


sample_forecast=forecast(arima_model_1,h=length(test_data))
print(sample_forecast)
# Point Forecast    Lo 80    Hi 80    Lo 95    Hi 95
# 60.17014      100.85570 96.74076 104.9706 94.56245 107.1489
# 60.17361      100.72365 94.94513 106.5022 91.88616 109.5611
# 60.17708      100.60282 93.57274 107.6329 89.85124 111.3544
# 60.18056      100.49225 92.42589 108.5586 88.15582 112.8287
# 60.18403      100.39108 91.42667 109.3555 86.68120 114.1010
# 60.18750      100.29849 90.53435 110.0626 85.36552 115.2315
# 60.19097      100.21377 89.72426 110.7033 84.17145 116.2561


#Based on above output 4 types of Confidence Internval (CI) bounds are being tested for 4 types of Arima models
# on different (p,d,q) values

#####################################################################################
#Testing on prediction data of Confidence Interval 95%  upper bound
forecast_for_model_1_upper=forecast(arima_model_1,h=length(test_data))$upper[, "95%"]
forecast_for_model_2_upper=forecast(arima_model_2,h=length(test_data))$upper[, "95%"]
forecast_for_model_3_upper=forecast(arima_model_3,h=length(test_data))$upper[, "95%"]
forecast_for_model_4_upper=forecast(arima_model_4,h=length(test_data))$upper[, "95%"]

mape_1_upper_95=mean(abs((test_data-forecast_for_model_1_upper)/test_data)) * 100
mape_2_upper_95=mean(abs((test_data-forecast_for_model_2_upper)/test_data)) * 100
mape_3_upper_95=mean(abs((test_data-forecast_for_model_3_upper)/test_data)) * 100
mape_4_upper_95=mean(abs((test_data-forecast_for_model_4_upper)/test_data)) * 100
#####################################################################################
#Testing on prediction data of Confidence Interval 95%  lower bound
forecast_for_model_1_lower=forecast(arima_model_1,h=length(test_data))$lower[, "95%"]
forecast_for_model_2_lower=forecast(arima_model_2,h=length(test_data))$lower[, "95%"]
forecast_for_model_3_lower=forecast(arima_model_3,h=length(test_data))$lower[, "95%"]
forecast_for_model_4_lower=forecast(arima_model_4,h=length(test_data))$lower[, "95%"]

mape_1_lower_95=mean(abs((test_data-forecast_for_model_1_lower)/test_data)) * 100
mape_2_lower_95=mean(abs((test_data-forecast_for_model_2_lower)/test_data)) * 100
mape_3_lower_95=mean(abs((test_data-forecast_for_model_3_lower)/test_data)) * 100
mape_4_lower_95=mean(abs((test_data-forecast_for_model_4_lower)/test_data)) * 100

#####################################################################################
#Testing on prediction data of Confidence Interval 80%  lower bound

forecast_for_model_1_lower_80=forecast(arima_model_1,h=length(test_data))$lower[, "80%"]
forecast_for_model_2_lower_80=forecast(arima_model_2,h=length(test_data))$lower[, "80%"]
forecast_for_model_3_lower_80=forecast(arima_model_3,h=length(test_data))$lower[, "80%"]
forecast_for_model_4_lower_80=forecast(arima_model_4,h=length(test_data))$lower[, "80%"]

mape_1_lower_80=mean(abs((test_data-forecast_for_model_1_lower_80)/test_data)) * 100
mape_2_lower_80=mean(abs((test_data-forecast_for_model_2_lower_80)/test_data)) * 100
mape_3_lower_80=mean(abs((test_data-forecast_for_model_3_lower_80)/test_data)) * 100
mape_4_lower_80=mean(abs((test_data-forecast_for_model_4_lower_80)/test_data)) * 100
#####################################################################################
#Testing on prediction data of Confidence Interval 80%  upper bound

forecast_for_model_1_upper_80=forecast(arima_model_1,h=length(test_data))$upper[, "80%"]
forecast_for_model_2_upper_80=forecast(arima_model_2,h=length(test_data))$upper[, "80%"]
forecast_for_model_3_upper_80=forecast(arima_model_3,h=length(test_data))$upper[, "80%"]
forecast_for_model_4_upper_80=forecast(arima_model_4,h=length(test_data))$upper[, "80%"]

mape_1_upper_80=mean(abs((test_data-forecast_for_model_1_upper_80)/test_data)) * 100
mape_2_upper_80=mean(abs((test_data-forecast_for_model_2_upper_80)/test_data)) * 100
mape_3_upper_80=mean(abs((test_data-forecast_for_model_3_upper_80)/test_data)) * 100
mape_4_upper_80=mean(abs((test_data-forecast_for_model_4_upper_80)/test_data)) * 100
#####################################################################################
c(mape_1_upper_95,mape_2_upper_95,mape_3_upper_95,mape_4_upper_95)
c(mape_1_lower_95,mape_2_lower_95,mape_3_lower_95,mape_4_lower_95)
c(mape_1_lower_80,mape_2_lower_80,mape_3_lower_80,mape_4_lower_80)
c(mape_1_upper_80,mape_2_upper_80,mape_3_upper_80,mape_4_upper_80)
# The MAPE values calculated on different bounds of different models

#   mape_1_upper_95    mape_2_upper_95     mape_3_upper_95   mape_4_upper_95
#   83.91132           85.21272            78.94170          82.01402

#   mape_1_lower_95    mape_2_lower_95     mape_3_lower_95   mape_4_lower_95
#   159.0611           160.8884            153.4077          156.8468

#   mape_1_upper_80    mape_2_upper_80     mape_3_upper_80   mape_4_upper_80
#   117.0144           118.2974            113.2227          115.5175

#   mape_1_lower_80    mape_2_lower_80     mape_3_lower_80   mape_4_lower_80
#   48.32091           48.76700            46.46770          47.58496


#so lower 80 bounds performed well,in lower 80 bound 
#the model  3 performed well with (p,d,q) values-->(2, 1, 2)

#to save all plots into 'plots' folder
setwd(paste0(path,'/plots'))
#####################################################################################
all_models_lower_95= c(mape_1_lower_95,mape_2_lower_95,mape_3_lower_95,mape_4_lower_95)

l95<- data.frame(x = 1:length(all_models_lower_95), y = unlist(all_models_lower_95))

img_l95=ggplot(l95, aes(x, y)) + 
  geom_line(color = "blue") +
  ggtitle("MAPE value visualisation for lower 95% CI bound for 4 different models")

ggsave('group_lower_95.png',img_l95,width = 10, height = 4, dpi = 300)

#####################################################################################
all_models_upper_95= c(mape_1_upper_95,mape_2_upper_95,mape_3_upper_95,mape_4_upper_95)

u95<- data.frame(x = 1:length(all_models_upper_95), y = unlist(all_models_upper_95))

img_u95=ggplot(u95, aes(x, y)) + 
  geom_line(color = "red") +
  ggtitle("MAPE value visualisation for upper 95% CI bound for 4 different models")
ggsave('group_upper_95.png',img_u95,,width = 10, height = 4, dpi = 300)

#####################################################################################
all_models_lower_80= c(mape_1_lower_80,mape_2_lower_80,mape_3_lower_80,mape_4_lower_80)

l80<- data.frame(x = 1:length(all_models_lower_80), y = unlist(all_models_lower_80))

img_l80=ggplot(l80, aes(x, y)) + 
  geom_line(color = "black") +
  ggtitle("MAPE value visualisation for lower 80% CI bound for 4 different models")
ggsave('group_lower_80.png',img_l80,,width = 10, height = 4, dpi = 300)

#####################################################################################
all_models_upper_80= c(mape_1_upper_80,mape_2_upper_80,mape_3_upper_80,mape_4_upper_80)

u80<- data.frame(x = 1:length(all_models_upper_80), y = unlist(all_models_upper_80))

img_u80=ggplot(u80, aes(x, y)) + 
  geom_line(color = "green") +
  ggtitle("MAPE value visualisation for upper 80% CI bound for 4 different models")
ggsave('group_upper_80.png',img_u80,,width = 10, height = 4, dpi = 300)

