# Data Manipulation; Thursday 10-24-2019

#From Matt's Push at 12:34PM:
library(ggplot2)
library(dplyr)
library(leaflet)


# Pull in raw data and name i

# Delete unwanted columns & rename dataset
countyData <- select(countypres_2000_2016, -c(office, version))


# Add columns
countyData[is.na(countyData)] <- "other"

View(countyData)
<<<<<<< HEAD


#Making "green" = "other" under "party" column
countyData$party[countyData$party=="green"] <- "other"
=======
>>>>>>> 164cbe50ca4af52e0225d1807737b82239eaecda
