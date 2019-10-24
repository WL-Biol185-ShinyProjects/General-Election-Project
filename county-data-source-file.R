#Add any necessary packages
library(ggplot2)
library(dplyr)
library(leaflet)


# Pull in raw data and name i

# Delete unwanted columns & rename dataset
countyData <- select(countypres_2000_2016, -c(office, version))


# Create other value in party column with candidates not in main 2 parties
countyData[is.na(countyData)] <- "other"
countyData$party[countyData$party=="green"] <- "other"

View(countyData)