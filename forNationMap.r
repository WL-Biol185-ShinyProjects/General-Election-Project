library(usmap)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(stringi)
library(readr)

testData <- read.csv("generalElectionSummary.csv")

testData <-select(testData, 
                  -c(X, X.1, X.2, X.3, X.4, X.5, X.6, X.7, X.8, X.9, X.10, X.11, X.12, X.13))

testData1 <- testData[testData$Year == "2016",]
view(testData1)

