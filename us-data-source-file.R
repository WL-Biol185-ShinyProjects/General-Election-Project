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

stateData <- select(stateData, c("year", "state", "state_po", "party", 
                                 "candidatevotes"))

stateData <- aggregate(candidatevotes~year+state+party+state_po, 
                       data = stateData, FUN = sum)

stateData <- spread(stateData, party, candidatevotes)

stateData$rep_wins <- 0
stateData$rep_wins[(stateData$republican > stateData$democrat) & 
                      (stateData$republican > stateData$other)] <- 1

sumStateData <- aggregate(rep_wins~state+state_po, data = stateData, FUN = sum)

sumStateData$color <- "Swing State"
sumStateData$color[sumStateData$rep_wins >= 6] <- "Republican"
sumStateData$color[sumStateData$state_po == "AZ"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "NC"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "VA"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "FL"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "OH"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "CO"] <- "Democrats"
sumStateData$color[sumStateData$state_po == "NV"] <- "Democrats"
sumStateData$color[sumStateData$state_po == "NM"] <- "Democrats"
sumStateData$color[sumStateData$rep_wins < 5] <- "Democrats"
sumStateData$color[sumStateData$state_po == "PA"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "WI"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "MN"] <- "Swing State"


#View(sumStateData)


sumStateData %>% 
  ggplot(aes(x = reorder(state_po, -rep_wins), y = rep_wins, fill = color)) + 
  geom_bar(stat = "identity")  +
  scale_fill_manual(values = c("blue", "red", "grey"))


probabilityData <- probability_data

probabilityData$winner <- "none"
probabilityData$winner[probabilityData$electoralVotesNumber < 5] <- "republican"
probabilityData$winner[probabilityData$electoralVotesNumber > 20] <- "democrat"

sumProbData <- aggregate(electoralVotesNumber~winner, data = probabilityData, FUN = sum)

View(sumProbData)

#repVotes <
#demVotes
#freeVotes