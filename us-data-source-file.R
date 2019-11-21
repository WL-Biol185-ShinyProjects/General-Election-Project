library(usmap)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(stringi)
library(readr)


# pulls in csv and outputs a table
probability_data <- read_csv("probability_data.csv")
X1976_2016_president <- read_csv("1976-2016-president.csv")
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

stateData$repWins <- 0
stateData$repWins[(stateData$republican > stateData$democrat) & 
                      (stateData$republican > stateData$other)] <- 1



#stateData$repWins <- stateData$repWins - 6


sumStateData <- aggregate(repWins~state+state_po, data = stateData, FUN = sum)
sumStateData$demWins <- 11 - sumStateData$repWins



sumStateData$color <- "Swing State"
sumStateData$color[sumStateData$repWins >= 6] <- "Republican"
sumStateData$color[sumStateData$state_po == "AZ"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "NC"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "VA"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "FL"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "OH"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "CO"] <- "Democrat"
sumStateData$color[sumStateData$state_po == "NV"] <- "Democrat"
sumStateData$color[sumStateData$state_po == "NM"] <- "Democrat"
sumStateData$color[sumStateData$repWins < 5] <- "Democrat"
sumStateData$color[sumStateData$state_po == "PA"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "WI"] <- "Swing State"
sumStateData$color[sumStateData$state_po == "MN"] <- "Swing State"



states <- sumStateData$state[sumStateData$color == "Democrat"]
states

# 
# sumStateData$changeOfWins <- sumStateData$repWins - sumStateData$demWins
# 
# sumStateData %>% 
#   ggplot(aes(x = reorder(state_po, -changeOfWins), y = changeOfWins, 
#              fill = color)) + 
#   geom_bar(stat = "identity")  +
#   ggtitle("Net Party Victories by State 
#           (Colored with most recent 2020 election predictions)") +
#   ylab("Net Victories by Party") +
#   xlab("States") +
#   scale_fill_manual(values = c("blue", "red", "grey")) +
#   theme(plot.title = element_text(hjust = 0.5, size = 24), 
#         legend.background = element_rect(fill = "white", size = 0.5, 
#                                          linetype = "solid", colour = 'black'), 
#         axis.text.x = element_text(angle = 30, hjust = 0.5, vjust = 0.8), 
#         axis.title.x = element_text(size = 18),
#         axis.title.y = element_text(size = 18)
#         ) +
#   labs(fill = "Color:")
#  


probabilityData <- probability_data

probabilityData$winner <- "none"
probabilityData$winner[probabilityData$electoralVotesNumber < 5] <- "republican"
probabilityData$winner[probabilityData$electoralVotesNumber > 20] <- "democrat"

sumProbData <- aggregate(electoralVotesNumber~winner, 
                         data = probabilityData, FUN = sum)

states <- sum(probabilityData$electoralVotesNumber[probabilityData$winner == "democrat"])
states
View(sumProbData)
View(probabilityData)
# Gets electoral votes for states up for grabs
probabilityData[which(probabilityData[,4] == "none"), 2]

