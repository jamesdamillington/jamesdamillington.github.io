rm(list=ls())                                             #housekeeping: remove any objects existing in the current workspace so that we are starting from scratch

#change the directory path in the next line to wherever you have save the data files 
setwd("C:/Users/k1076631/Documents/Practical1")

loggerDat <- read.csv("LoggerData.csv", header = T)   	    #read the file to a data.frame
head(loggerDat)                                             #view the first part of the data (to check it read properly)
summary(loggerDat)                                          #view a summary of the data

waterDat <- read.csv("WaterLevelData.csv", header = T)     #read the file to a data.frame
head(waterDat)                                             #view the first part of the data (to check it read properly)
summary(waterDat)                                          #view a summary of the data


plot(waterDat$Pressure, waterDat$WaterLevel)                 #create a simple scatter plot 

#next line creates a nicely formatted scatter plot 
plot(waterDat$Pressure, waterDat$WaterLevel, xlim = c(0, 0.6), xlab = 
"Pressure (mV)", ylim = c(99.0, 99.4), ylab = "Water Level (m, above an arbitrary level)", main = "River Frome, Dorset")

fit <- lm(WaterLevel ~ Pressure, data = waterDat)              #fit a linear regression model to the data
summary(fit)                                                 #view a summary of the linear regression model  
summary(fit)$r.squared                                       #view the r.squared value of the fit model
abline(fit)                                                  #use the fit model to add a regression line to the last plot

PredictedWL <- predict.lm(fit, loggerDat)                    #predict water level from the pressure data using the regression model 
length(PredictedWL)                                         #view the number of values in the PredictedWL vector
head(PredictedWL)                                           #view the first few values of the PredictedWL vector
summary(PredictedWL)                                        #view a summary of the predicted data
loggerDat <- cbind(loggerDat, PredictedWL)                   #append the predicted data to the data.frame
write.csv(loggerDat, "conversion2.csv", row.names = F)       #write the data.frame to a file


loggerDat <- loggerDat[,2:9]                                 #removes the first (ID) column of the data.frame
aggLoggerDat <- aggregate(loggerDat, by = list(loggerDat$Year, loggerDat$Day), mean)   #aggregate logger data by year and day calculating the mean for the other variables in the data.frame and create a new data.frame

aggLoggerDat <- aggLoggerDat[order(aggLoggerDat$Year, aggLoggerDat$Day),]   #order aggregate logger data by year then day
aggLoggerDat <- aggLoggerDat[,3:10]                          #remove group names created by aggregate function

head(aggLoggerDat)                                           #view the head (first few lines) of the data
write.csv(aggLoggerDat, "aggLoggerdata.csv", row.names = F)  #write the data to file

plot(aggLoggerDat$PredictedWL, type = "l")                         #plot the newly aggregated predicted Water level as a line chart
plot(aggLoggerDat$PredictedWL, type = "l", xlab = "day", ylab = "Predicted Water Level (m)") #same as last plot but with nicer formatting

aggLoggerDat.2003 <- subset(aggLoggerDat, Year == 2003)     #subset the aggregated logger data to year 2003 only (creating new data set)

plot(aggLoggerDat.2003$PredictedWL, type = "l", xlab = "day", ylab = "Predicted Water Level (m)") #plot 2003 data matching day on x-axis

jpeg("aggLogger2003.jpg")                                     #write the following plot to an image file named "aggLogger2003.jpg"
plot(aggLoggerDat.2003$Day, aggLoggerDat.2003$PredictedWL, type = "l", xlab = "day", 
xlim = c(0,365), ylab = "Predicted Water Level (m)") #plot 2003 data on full annual x-axis matching day on x-axis
dev.off()                                                     #stop writing to the image file