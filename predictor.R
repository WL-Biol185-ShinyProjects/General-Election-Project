library(usmap)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(stringi)

# creates a dictionary  of the state and its electoral vote
state_ev_list <- list(state=probability_data$State, ev=probability_data$electoralVotesNumber)

#algorithm for calculating the probability

#count is the varaible indicating qwhich instance has electoral votes over 270
count <- 0
#10000 iterations
for (i in seq(1:10000)) {
    
  #will possibly make changes to the type of distribution n is taken from
    # where n is the number of states selected in each sampling
    number <- runif(1,min=1, max=51)
    as.integer(number)
    
    #code for sampling the vector of electoral votes
    sampling <- sample(state_ev_list$ev,as.integer(number))
    summation <- sum(sampling)
    
    #checks to see is the sampling has over 270 electoral votes
    if (summation > 270){
      
      #increments the count
      count <- count + 1
    }
}

#computs the probability the election going a cetain way
probability <- count / 10000

