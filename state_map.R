library(leaflet)
library(rgdal)
library(tidyverse)

# Importing required GeoSpatial data from "https://eric.clst.org/tech/usgeojson/" -> "US States 5m GeoJSON"
statewideGEO  <- rgdal::readOGR("counties.json")

# Assigning the data in the json data frame to a version that is tidy
statewideGEO@data <- read_csv("statewideGEOData.csv")

# pulling in a tidy county election data frame
countyElectionData <- read_csv("countySumData.csv")

# Adding popupText to be displayed when a county is clicked on in chloropleth map
countyElectionData$popupText <- paste(htmltools::strong("County:"), 
                                     countyElectionData$county , htmltools::br(),
                                     htmltools::strong("Winning Party: "),
                                     countyElectionData$Party, htmltools::br(),
                                     htmltools::strong("Winning Candidate:"), 
                                     countyElectionData$winner, htmltools::br()
)

print(colnames(statewideGEO@data))

# specify the year
countyElectionData <- countyElectionData[countyElectionData$year == "2016",]

# join the election data and the json data
statewideGEO@data <-
  statewideGEO@data %>% 
    left_join(countyElectionData, by =c("stateID" = "stateID", "NAME" = "county"))

View(statewideGEO@data)
