library(usmap)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(stringi)

#pulls in csv and outputs a table
stateData <- select(X1976_2016_president, -c(office,version,writein,notes))

#changes the year column to R's year object
stateData$year <- year(as.Date(as.character(stateData$year), format = "%Y"))

#creates a function that negates the %in% function
'%notin%' <- Negate('%in%')

#changes values in party column not equal to dem or rep to other 
stateData$party[stateData$party %notin% c("democrat","republican")] <- "other"

#changes values that are NA to other 
stateData[is.na(stateData)] <- "other"

stateData <- select(stateData, c("year", "state", "state_po", "party", "candidatevotes"))

stateData <- spread(stateData, c(party, year, state), candidatevotes)

View(stateData)
