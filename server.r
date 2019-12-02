library(shiny)
library(tidyverse)
library(lubridate)
library(stringi)
library(readr)


function(input, output, session) {
  
  
  # output$states <- DT::renderDataTable({
  # 
  #   
  #   input$repStates <- filter(sumStateData, color == "Republican" & color == "Swing State")
  #   
  #   input$demStates <- filter(sumStateData, color == "Democrat" & color == "Swing State")
  #   
  #   
  # observe({
  #   
  #   updateCheckboxGroupInput(session, "blue", )
  #   
  # })
  # 
  observe({
    
    updateCheckboxGroupInput(session, "repStates", 
                             label = "Red States", 
                             choices = setdiff(sumStateData_joined$state, input$demStates),
                             selected = setdiff(input$repStates,input$demStates))
    
    updateCheckboxGroupInput(session, "demStates", 
                             label = "Blue States",
                             choices = setdiff(sumStateData_joined$state, input$repStates),
                             selected = setdiff(input$demStates,input$repStates))
    
  })
  
  updateTable <- reactive({
    demStates <- input$demStates
    repStates <- input$repStates
    
    numDemStates <- length(demStates)
    numRepStates <- length(repStates)
    
    sumStateData_joined$color <- "Swing state"
    for (i in 1:numRepStates){
      sumStateData_joined$color[sumStateData_joined$state == repStates[i]] <- "Republican"
    }
    for (i in 1:numDemStates){
    sumStateData_joined$color[sumStateData_joined$state == demStates[i]] <- "Democrat"
    }

    return(sumStateData_joined)
  })

  output$barPlot <- renderPlot({
    displayTable <- updateTable()
    ggplot(displayTable, aes(color, electoralVotesNumber, fill=color)) +
      geom_bar(stat = "identity")
  })

  output$pieChart <- renderPlot({
    # demStates <- input$demStates
    # repStates <- input$repStates
    # # creates a dictionary  of the state and its electoral vote
    # state_ev_list <- list(state=sumStateData_joined$state, ev=sumStateData_joined$electoralVotesNumber)
    # 
    # #algorithm for calculating the probability
    # 
    # #count is the variable indicating which instance has electoral votes over 270
    # count <- 0
    # #10000 iterations
    # for (i in seq(1:10000)) {
    # 
    #   #will possibly make changes to the type of distribution n is taken from
    #   # where n is the number of states selected in each sampling
    #   number <- runif(1,min=1, max=51)
    #   as.integer(number)
    # 
    #   #code for sampling the vector of electoral votes
    #   sampling <- sample(state_ev_list$ev,as.integer(number))
    #   summation <- sum(sampling)
    # 
    #   #checks to see is the sampling has over 270 electoral votes
    #   if (summation > 270){
    # 
    #     #increments the count
    #     count <- count + 1
    #   }
    # }
    # 
    # #computes the probability the election going a certain way
    # probability <- count / 10000

    displayTable <- updateTable()
    ggplot(displayTable, aes("", electoralVotesNumber, fill=color))+
      geom_bar(width = 1, stat = "identity") +
      coord_polar("y", start=0)

  })

  
  
  
  
  
  
  

   }
  