#Add any necessary packages
library(ggplot2)
library(dplyr)
library(leaflet)


# Pull in raw data and name i

# Delete unwanted columns & rename dataset
countyData <- select(countypres_2000_2016, -c(office, version))


# Add columns
countyData[is.na(countyData)] <- "other"

View(countyData)
