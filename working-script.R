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


#Making "green" = "other" under "party" column
countyData$party[countyData$party=="green"] <- "other"


#Playing around with data visualization using ggplot2 functions
countyData %>% 
  ggplot(aes(party, fill = state_po)) + geom_density(alpha = 0.5)

countyData %>% 
  ggplot(aes(state_po, fill = party)) + geom_density(alpha = 0.2)

countyData %>% 
  ggplot(aes(party)) + geom_density()

#Let's try a barplot
countyData %>% 
  ggplot(aes(state_po, party)) + geom_bar(stat = 'identity')


# Data Manipulation; Tuesday 10-29-2019

# I am going to try and filter the "state" categorical variables so that only east/west/central states are shown
eastCoast <- filter(countyData, state_po %in% c("ME", "NH", "MA", "RI", "CT", "NY", "NJ", "DE", "MD", "VA", "NC", "SC", "GA", "FL"))
#West Coast & Extranneous states
westCoast <- filter(countyData, state_po %in% c("CA", "OR", "WA", "AK", "HI"))
# rest of the states
otherStates <- filter(countyData, state_po %in% c("ID", "NV", "AZ", "UT", "WY", "CO", "NM", "MT", "ND", "SD", "MN", "IA", "WI", "NE", "KS", "MO", "IL", "TX", "OK", "AR", "LA", "MS", "TN", "AL", "KY", "IN", "OH", "MI", "WV", "PA", "VT"))

eastCoast %>% 
  ggplot(aes(state_po, fill = party)) + geom_density(alpha = 0.3)

# Here I try a count plot instead
eastCoast %>% 
  ggplot(aes(state_po, party)) + geom_count()

eastCoast %>% 
  ggplot(aes(state_po)) + geom_bar()
