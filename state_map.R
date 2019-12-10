library(leaflet)
library(rgdal)
library(tidyverse)

# Importing required GeoSpatial data from "https://eric.clst.org/tech/usgeojson/" -> "US States 5m GeoJSON"
statewideGEO  <- rgdal::readOGR("counties.json")

# Adding the state names to the counties table
stateNames <- as.character(nationwideGEO@data$NAME)
names(stateNames) <- as.character(nationwideGEO@data$STATE)
statewideGEO@data$stateName <- stateNames[as.character(statewideGEO@data$STATE)]


# Adding city tags to the geo data for the table join
statewideGEO@data$city <- 0
statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[1857,]$NAME) &
                         (statewideGEO@data$stateName == statewideGEO@data[1857,]$stateName) &
                         (statewideGEO@data$LSAD == statewideGEO@data[1857,]$LSAD)] <- 1
statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[2223,]$NAME) &
                         (statewideGEO@data$stateName == statewideGEO@data[2223,]$stateName) &
                         (statewideGEO@data$LSAD == statewideGEO@data[2223,]$LSAD)] <- 1
statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[2910,]$NAME) &
                         (statewideGEO@data$stateName == statewideGEO@data[2910,]$stateName) &
                         (statewideGEO@data$LSAD == statewideGEO@data[2910,]$LSAD)] <- 1
statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[926,]$NAME) &
                         (statewideGEO@data$stateName == statewideGEO@data[926,]$stateName) &
                         (statewideGEO@data$LSAD == statewideGEO@data[926,]$LSAD)] <- 1
statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[2911,]$NAME) &
                         (statewideGEO@data$stateName == statewideGEO@data[2911,]$stateName) &
                         (statewideGEO@data$LSAD == statewideGEO@data[2911,]$LSAD)] <- 1
statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[2947,]$NAME) &
                         (statewideGEO@data$stateName == statewideGEO@data[2947,]$stateName) &
                         (statewideGEO@data$LSAD == statewideGEO@data[2947,]$LSAD)] <- 1
statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[937,]$NAME) &
                         (statewideGEO@data$stateName == statewideGEO@data[937,]$stateName) &
                         (statewideGEO@data$LSAD == statewideGEO@data[937,]$LSAD)] <- 1

# View(statewideGEO@data)

# pulling in a tidy county election data frame
countyElectionData <- read_csv("countySumData.csv")
countyElectionData$county[countyElectionData$county == "Desoto"] <- "DeSoto"
countyElectionData$county[countyElectionData$county == "Lac Qui Parle"] <- "Lac qui Parle"
countyElectionData$county[countyElectionData$county == "Dona Ana"] <- "Do\xf1a Ana"
countyElectionData$county[countyElectionData$county == "Oglala Lakota"] <- "Shannon"
countyElectionData$county[countyElectionData$county == "Dewitt"] <- "DeWitt"

# Adding popupText to be displayed when a county is clicked on in chloropleth map
countyElectionData$popupText <- paste(htmltools::strong("County:"), 
                                     countyElectionData$county , htmltools::br(),
                                     htmltools::strong("Winning Party: "),
                                     countyElectionData$party, htmltools::br(),
                                     htmltools::strong("Winning Candidate:"), 
                                     countyElectionData$winner, htmltools::br()
)


# specify the year
countyElectionData <- countyElectionData[countyElectionData$year == "2016",]



stateCoords <- data.frame(
  lat    = c( 32.806671, 61.370716, 34.199759, 34.969704, 37.316203, 39.059811,
              41.497782, 39.318523, 38.897438, 28.006279, 32.840619, 20.634318,
              45.240459, 39.849457, 39.849426, 42.011539, 38.526600, 37.668140,
              31.169546, 45.293947, 38.903946, 42.230171, 44.326618, 45.994454,
              32.741646, 38.456085, 46.721925, 41.325370, 38.313515, 43.952492,
              40.098904, 34.240515, 42.565726, 35.630066, 47.528912, 40.388783,
              35.565342, 44.072021, 40.990752, 41.680893, 33.856892, 44.299782,
              35.747845, 31.054487, 39.550032, 43.845876, 37.769337, 47.400902,
              38.491226, 44.768543, 42.755966)
  , lon    = c(-86.791130, -152.404419, -111.431221, -92.373123, -119.681564,
               -105.311104, -72.755371, -75.507141, -77.026817, -82.686783,
               -83.643074, -157.498337, -114.478828, -88.986137, -86.258278,
               -93.210526, -97.726486, -84.670067, -91.867805, -69.381927,
               -77.102101, -71.530106, -85.536095, -93.900192, -89.678696,
               -92.288368, -110.454353, -99.268082, -117.055374, -71.563896,
               -74.521011, -106.248482, -74.948051, -79.806419, -99.784012,
               -82.764915, -96.928917, -120.870938, -77.709755, -71.511780,
               -80.945007, -99.738828, -86.692345, -97.563461, -111.862434,
               -72.710686  , -78.569968  , -121.490494 , -80.954453, -89.616508,
               -107.302490 )
  , zoom = c(6, 0, 6, 6, 5, 6, 8, 7, 10, 6, 6, 7, 5, 6, 6, 6, 6, 6, 6, 6, 
                    7, 7, 6, 5, 6, 6, 6, 6, 5, 7, 7, 6, 6, 6, 6, 6, 6, 6, 7, 8,
                    7, 6, 6, 5, 6, 7, 6, 6, 6, 6, 6)
  , state  = c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
               "Colorado", "Connecticut", "Delaware", "District of Columbia",
               "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana",
               "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
               "Massachusetts", "Michigan", "Minnesota", "Mississippi",
               "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
               "New Jersey", "New Mexico", "New York", "North Carolina",
               "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
               "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
               "Texas", "Utah", "Vermont", "Virginia", "Washington",
               "West Virginia", "Wisconsin", "Wyoming")
)


# View(stateCoords)


# Remove Puerto Rico & Alaska from statewideGEO


alaskaPoly <- which(statewideGEO@data$stateName != "Connecticut")
alaskaLen <- length(alaskaPoly)
# prPoly <- which(statewideGEO@data$stateName == "Puerto Rico")
# prLen <- length(prPoly)
counter <- 0

 
for (i in 1:alaskaLen){
  statewideGEO@polygons[[alaskaPoly[i] - counter]] <- NULL
  counter <- counter + 1
}

statewideGEO@data <- statewideGEO@data[statewideGEO@data$stateName == "Connecticut",]
countyElectionData$city <- as.numeric(countyElectionData$city)

countyElectionData$county <- factor(countyElectionData$county, levels = levels(statewideGEO@data$NAME))


# join the election data and the json data
statewideGEO@data <-
  statewideGEO@data %>% 
    left_join(countyElectionData, by = c("stateName" = "state", 
                                         "NAME" = "county", "city"))
currentLong <- stateCoords$lon[stateCoords$state == "Connecticut"]
currentLat <- stateCoords$lat[stateCoords$state == "Connecticut"]
currentZoom <- stateCoords$zoom[stateCoords$state == "Connecticut"]


colors <- c("red")
if (statewideGEO@data$party[1] == "Democrat"){
  colors <- c("blue")
}
if (length(unique(statewideGEO@data$party)) > 1){
  colors <- c("blue", "grey", "red")
}

# Create final working visualization of State Chloropleth Map!
leaflet(statewideGEO) %>%
  setView(currentLong, currentLat, currentZoom) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorFactor(colors, statewideGEO@data$party)(statewideGEO@data$party),
              highlightOptions =
                highlightOptions(
                  color = "white",
                  weight = 2,
                  bringToFront = TRUE),
              popup = statewideGEO@data$popupText)
