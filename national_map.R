library(leaflet)
library(htmltools)
library(rgdal)
library(tidyverse)

# Importing required GeoSpatial data from "https://eric.clst.org/tech/usgeojson/" -> "US States 5m GeoJSON"
nationwideGEO  <- rgdal::readOGR("states.geo.json")


# Importing Excel-made data frame containing state information for each presidential election (2016-1976)
nationwideMapData <- read.csv("nationwideMapData.csv")


# Adding popupText to be displayed when a state is clicked on in chloropleth map
nationwideMapData$popupText <- paste(strong("State:"), nationwideMapData$State, br(), 
                                  strong("Electoral Votes:"), nationwideMapData$Electoral.Votes, br(),
                                  strong("Population:"), nationwideMapData$Population)


# Remove Puerto Rico from nationwideGEO
nationwideGEO@data <- nationwideGEO@data[-17,]
nationwideGEO@polygons[[17]] <- NULL


# This allows for different election years to be selected from drop-down menu to display corresponding election map
nationwideMapData <- nationwideMapData[nationwideMapData$Year == "2016",]


# Joining self-made data frame from above into nationwideGEO geospatial dataframe for leaflet to use for visualization
nationwideGEO@data <- 
  nationwideGEO@data %>%
  left_join(nationwideMapData, by = c("NAME" = "State"))


# Create final working visualization of State Chloropleth Map!
leaflet(nationwideGEO) %>%
  setView(-98.483330, 38.712046, 3) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorFactor(c("blue", "red"), nationwideGEO@data$Party)(nationwideGEO@data$Party),
              highlightOptions = 
                highlightOptions(
                  color = "white", 
                  weight = 2, 
                  bringToFront = TRUE),
              popup = nationwideGEO@data$popupText)

