
states   <- rgdal::readOGR("states.geo.json", "OGRGeoJSON")
counties <- rgdal::readOGR("counties.json", "OGRGeoJSON")

stateNames              <- as.character(states@data$NAME)
names(stateNames)       <- as.character(states@data$STATE)
counties@data$stateName <- stateNames[as.character(counties@data$STATE)]
