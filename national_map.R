library(leaflet)
#library(htmltools)
library(rgdal)
library(tidyverse)

# Importing required GeoSpatial data from "https://eric.clst.org/tech/usgeojson/" -> "US States 5m GeoJSON"
nationwideGEO  <- rgdal::readOGR("states.geo.json")


# Importing Excel-made data frame containing state information for each presidential election (2016-1976)
nationwideMapData <- read.csv("generalElectionSummary.csv")


# Adding popupText to be displayed when a state is clicked on in chloropleth map
nationwideMapData$popupText <- paste(htmltools::strong("State:"), 
                                     nationwideMapData$State, htmltools::br(),
                                     htmltools::strong("Winning Party: "),
                                     nationwideMapData$Party, htmltools::br(),
                                     htmltools::strong("Electoral Votes:"), 
                                     nationwideMapData$Electoral.Votes, htmltools::br(),
                                     htmltools::strong("Population:"), 
                                     nationwideMapData$Population, htmltools::br()
                                  )


# Remove Puerto Rico from nationwideGEO
nationwideGEO@data <- nationwideGEO@data[-17,]
nationwideGEO@polygons[[17]] <- NULL

# Save the map as a csv to use in server
write_csv(nationwideMapData, path = "nationwideMapData.csv")

# # This allows for different election years to be selected from drop-down menu to display corresponding election map
# nationwideMapData <- nationwideMapData[nationwideMapData$Year == "1984",]
# # Changing the year following the "==" above to the desired election year will create an election map for that year
# 
# 
# # Joining self-made data frame from above into nationwideGEO geospatial dataframe for leaflet to use for visualization
# nationwideGEO@data <- 
#   nationwideGEO@data %>%
#   left_join(nationwideMapData, by = c("NAME" = "State"))
# view(nationwideGEO@polygons)
# 
# # Create final working visualization of State Chloropleth Map!
# leaflet(nationwideGEO) %>%
#   setView(-98.483330, 38.712046, 3) %>%
#   addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
#               opacity = 1.0, fillOpacity = 0.5,
#               fillColor = ~colorFactor(c("blue", "red"), nationwideGEO@data$Party)(nationwideGEO@data$Party),
#               highlightOptions = 
#                 highlightOptions(
#                   color = "white", 
#                   weight = 2, 
#                   bringToFront = TRUE),
#               popup = nationwideGEO@data$popupText)

