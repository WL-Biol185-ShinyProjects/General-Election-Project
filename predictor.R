library(usmap)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(stringi)

state_ev_list <- list(state=probability_data$State, ev=probability_data$electoralVotesNumber)
x <- 0
#matrix <- as.matrix(,nrow=2^51,ncol=52)

combinations <- t(combn(state_ev_list$ev,2))

# for (i in matrix[1,]){
# for (vector in combinations) {
#   matrix[i,] <- vector
# }}
# matrix


#for (i in 0:5){
#selection <- as.matrix(combn(state_ev_list$ev,5),nrow=2^51,ncol=52)
#selection
#matrix
