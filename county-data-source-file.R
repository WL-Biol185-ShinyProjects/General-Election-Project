library(ggplot2)
library(tidyverse)
library(lubridate)
library(stringi)
library(readr)




countyData <- read_csv("countyData.csv")
countyData <-aggregate(candidatevotes~year+state+state_po+county+party+candidate,
                       countyData, sum)

# countySumData <- aggregate(candidatevotes~year+state+state_po+county+party,
#                        countyData, sum)
# 
# countySumData <- spread(countySumData, party, candidatevotes)

# naFinder <- countySumData[!complete.cases(countySumData$year, 
#                                        countySumData$candidatevotes,
#                                         countySumData$county),]
# View(naFinder)


# countySumData$party <- "Other"
# countySumData$party[(countySumData$Democrat > countySumData$Other) & 
#                       (countySumData$Democrat > countySumData$Republican)] <- "Democrat"
# 
# countySumData$party[(countySumData$Republican > countySumData$Democrat) &
#                       (countySumData$Republican > countySumData$Other)] <- "Republican"
# 
# countySumData <- countySumData[countySumData$state_po != "AK",]

countyParty <- countyData$party
countyYear <- countyData$year
countyState <- countyData$state
county <- countyData$county
countyDataWinners <- countyData$candidate
numWinners <- length(countyDataWinners)
# for (i in 1:numWinners){
#   countySumData$winner[(countySumData$year == countyYear[i]) &&
#                          (countySumData$county == county[i]) &&
#                          (countySumData$party == countyParty[i]) &&
#                          (countySumData$state == countyState[i])] <- countyDataWinners[i]
# }



# 
# countySumData$stateID[countySumData$state_po == "AL"] <- statewideGEO@data$STATE[90]
# countySumData$stateID[countySumData$state_po == "AK"] <- statewideGEO@data$STATE[4]
# countySumData$stateID[countySumData$state_po == "AZ"] <- azSTCode
# countySumData$stateID[countySumData$state_po == "AR"] <- statewideGEO@data$STATE[10]
# countySumData$stateID[countySumData$state_po == "CA"] <- statewideGEO@data$STATE[72]
# countySumData$state[countySumData$state_po == "CO"] <- statewideGEO@data$STATE[28]
# countySumData$statecode[countySumData$state_po == "CT"] <- statewideGEO@data$STATE[38]
# countySumData$statecode[countySumData$state_po == "DE"] <- statewideGEO@data$STATE[1046]
# countySumData$statecode[countySumData$state_po == "DC"] <- statewideGEO@data$STATE[1047]
# countySumData$statecode[countySumData$state_po == "FL"] <- statewideGEO@data$STATE[40]
# countySumData$statecode[countySumData$state_po == "GA"] <- statewideGEO@data$STATE[56]
# countySumData$statecode[countySumData$state_po == "HI"] <- statewideGEO@data$STATE[208]
# countySumData$statecode[countySumData$state_po == "ID"] <- statewideGEO@data$STATE[210]
# countySumData$stateID[countySumData$state_po == "IL"] <- statewideGEO@data$STATE[119]
# countySumData$stateID[countySumData$state_po == "IN"] <- statewideGEO@data$STATE[141]
# countySumData$stateID[countySumData$state_po == "IA"] <- statewideGEO@data$STATE[174]
# countySumData$stateID[countySumData$state_po == "KS"] <- statewideGEO@data$STATE[232]
# countySumData$stateID[countySumData$state_po == "KY"] <- statewideGEO@data$STATE[233]
# countySumData$stateID[countySumData$state_po == "LA"] <- statewideGEO@data$STATE[261]
# countySumData$stateID[countySumData$state_po == "ME"] <- statewideGEO@data$STATE[412]
# countySumData$stateID[countySumData$state_po == "MD"] <- statewideGEO@data$STATE[417]
# countySumData$stateID[countySumData$state_po == "MA"] <- statewideGEO@data$STATE[427]
# countySumData$stateID[countySumData$state_po == "MI"] <- statewideGEO@data$STATE[341]
# countySumData$stateID[countySumData$state_po == "MN"] <- statewideGEO@data$STATE[367]
# countySumData$stateID[countySumData$state_po == "MS"] <- statewideGEO@data$STATE[396]
# countySumData$stateID[countySumData$state_po == "MO"] <- statewideGEO@data$STATE[509]
# countySumData$stateID[countySumData$state_po == "MT"] <- statewideGEO@data$STATE[439]
# countySumData$stateID[countySumData$state_po == "NE"] <- statewideGEO@data$STATE[445]
# countySumData$stateID[countySumData$state_po == "NV"] <- statewideGEO@data$STATE[480]
# countySumData$stateID[countySumData$state_po == "NH"] <- statewideGEO@data$STATE[484]
# countySumData$stateID[countySumData$state_po == "NJ"] <- statewideGEO@data$STATE[487]
# countySumData$stateID[countySumData$state_po == "NM"] <- statewideGEO@data$STATE[491]
# countySumData$stateID[countySumData$state_po == "NY"] <- statewideGEO@data$STATE[618]
# countySumData$stateID[countySumData$state_po == "NC"] <- statewideGEO@data$STATE[551]
# countySumData$stateID[countySumData$state_po == "ND"] <- statewideGEO@data$STATE[554]
# countySumData$stateID[countySumData$state_po == "OH"] <- statewideGEO@data$STATE[573]
# countySumData$stateID[countySumData$state_po == "OK"] <- statewideGEO@data$STATE[602]
# countySumData$stateID[countySumData$state_po == "OR"] <- statewideGEO@data$STATE[719]
# countySumData$stateID[countySumData$state_po == "PA"] <- statewideGEO@data$STATE[725]
# countySumData$stateID[countySumData$state_po == "RI"] <- statewideGEO@data$STATE[2657]
# countySumData$stateID[countySumData$state_po == "SC"] <- statewideGEO@data$STATE[654]
# countySumData$stateID[countySumData$state_po == "SD"] <- statewideGEO@data$STATE[660]
# countySumData$stateID[countySumData$state_po == "TN"] <- statewideGEO@data$STATE[682]
# countySumData$stateID[countySumData$state_po == "TX"] <- statewideGEO@data$STATE[747]
# countySumData$stateID[countySumData$state_po == "UT"] <- statewideGEO@data$STATE[811]
# countySumData$stateID[countySumData$state_po == "VT"] <- statewideGEO@data$STATE[902]
# countySumData$stateID[countySumData$state_po == "VA"] <- statewideGEO@data$STATE[906]
# countySumData$stateID[countySumData$state_po == "WA"] <- statewideGEO@data$STATE[848]
# countySumData$stateID[countySumData$state_po == "WV"] <- statewideGEO@data$STATE[852]
# countySumData$stateID[countySumData$state_po == "WI"] <- statewideGEO@data$STATE[863]
# countySumData$stateID[countySumData$state_po == "WY"] <- statewideGEO@data$STATE[889]

countySumData <- read_csv("countySumData.csv")


 for (i in 1:numWinners){
   countySumData$winner[(countySumData$year == countyYear[i]) &
                          (countySumData$county == county[i]) &
                          (countySumData$party == countyParty[i]) &
                          (countySumData$state == countyState[i])] <- countyDataWinners[i]
}


View(countyData)
View(countySumData)