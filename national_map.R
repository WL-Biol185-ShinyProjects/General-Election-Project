library(leaflet)
library(htmltools)
library(rgdal)
library(tidyverse)

#To create needed data frames
nationwideGEO  <- rgdal::readOGR("states.geo.json")

nationwideMapData <- read.csv("nationwideMapData.csv")
nationwideMapData$popupText <- paste(strong("State:"), nationwideMapData$State, br(), 
                                  strong("Electoral Votes:"), nationwideMapData$ElectoralVotes, br(),
                                  strong("Population:"), nationwideMapData$Population)

nationwideMapData <- nationwideMapData[nationwideMapData$Year == "2016",]
view(nationwideMapData)

nationwideGEO@data <- 
  nationwideGEO@data %>%
  left_join(nationwideMapData, by = c("CENSUSAREA" = "Year"))

# To pull-up visualization of State Chloropleth Map
leaflet(nationwideGEO) %>%
  setView(-98.483330, 38.712046, 3) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorFactor(c("blue", "red"), nationwideGEO@data$party)(nationwideGEO@data$party),
              highlightOptions = 
                highlightOptions(
                  color = "white", 
                  weight = 2, 
                  bringToFront = TRUE),
              popup = nationwideGEO@data$popupText)

