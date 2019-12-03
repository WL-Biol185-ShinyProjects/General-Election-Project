library(shiny)
library(ggplot2)
library(tidyverse)
library(scales)

function(input, output, session) {
  
  
  # This code takes the window height from the ui code and saves it as numeric
  plotCount <- reactive({
    req(input$srsHeight)
    as.numeric(input$srsHeight)
  })
  
  # Here we define a plot height that will be used to dynamically 
  # set our plot height
  plotHeight <- reactive(0.85 * plotCount())
  
  # The ouput plot for the party victories summary tab

  
  output$sumStateData <- renderPlot(height = plotHeight, {
 
    sumStateData %>% 
      ggplot(aes(x = reorder(state_po, -changeOfWins), y = changeOfWins, 
                 fill = color)) + 
      geom_bar(stat = "identity")  +
      ggtitle("        Net Party Victories by State since 1976
          (Colored with most recent 2020 election predictions)") +
      ylab("Net Victories by Party") +
      xlab("States") +
      scale_fill_manual(values = c("blue", "red", "grey")) +
      theme(plot.title = element_text(hjust = 0.5, size = 24), 
            legend.background = element_rect(fill = "white", size = 0.5, 
                                             linetype = "solid", 
                                             color = 'black'),
            legend.text = element_text(size = 16),
            legend.title = element_text(size = 18),
            axis.text.x = element_text(angle = 40, hjust = 0.5, vjust = 0.8,
                                       size = 14), 
            axis.title.x = element_text(size = 18),
            axis.title.y = element_text(size = 18)
      ) +
      labs(fill = "Color:") 
  })
  
  observe({
    
    updateCheckboxGroupInput(session, "repStates", 
                             label = " ", 
                             choices = setdiff(sumStateData_joined$state, input$demStates),
                             selected = setdiff(input$repStates,input$demStates))
    
    updateCheckboxGroupInput(session, "demStates", 
                             label = " ",
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
    displayTable <- updateTable()
    # print(displayTable)
    # demStates <- input$demStates
    # repStates <- input$repStates
    
    # creates a dictionary  of the state and its electoral vote
    # swingStates <- 51 - length(demStates) - length(repStates)
    # state_ev_list <- list()
    # for (i in 1:length(swingStates)){
    state_ev_list <- list(state=displayTable$state[displayTable$color == "Swing state"],
                          ev=displayTable$electoralVotesNumber[displayTable$color == "Swing state"])
    # }
    # print(state_ev_list)
    #algorithm for calculating the probability
    
    #count is the variable indicating which instance has electoral votes over 270
    demCount <- 0
    repCount <- 0
    #10000 iterations
    for (i in seq(1:10000)) {
      
      # will possibly make changes to the type of distribution n is taken from
      # where n is the number of states selected in each sampling
      number <- runif(1,min=1, max=length(state_ev_list$ev))
      as.integer(number)
      
      #code for sampling the vector of electoral votes
      sampling <- sample(state_ev_list$ev, as.integer(number))
      summation <- sum(sampling)
      
      # checks to see is the sampling has over 270 electoral votes
      if (summation > (270 - sum(displayTable$electoralVotesNumber[displayTable$color == "Republican"]))){
        
        # increments the count
        repCount <- repCount + 1
      }
      
    }
    
    # computes the probability the election going a certain way
    repProbability <- repCount / 10000
    
    # computes the probability the election going a certain way
    demProbability <- 1 - repProbability
    
    # Code to create and format the pie chart
    probData <- data.frame(probs = c((demProbability*100), (repProbability*100)),
                            Party = c("Democrats", "Republican"))
    
    probData <- probData %>%
                arrange(desc(Party)) %>%
                mutate(lab.ypos = cumsum(probs) - 0.5*probs)
    
    mycols <-c("#0000FF", "#FF0000")
    
    ggplot(probData, aes(x="", y = probs, fill=Party)) +
      geom_bar(width = 1, stat = 'identity', color = "white") + 
      coord_polar("y", start = 0) +
      geom_text(aes(y = lab.ypos, label = paste0(round(probs), "%")), 
                                                 color = "white", size = 16) +
      scale_fill_manual(values = mycols) +
      ggtitle("The Probability Either Party Wins") +
      theme(axis.line = element_blank(), axis.text = element_blank(),
            axis.ticks = element_blank(), panel.grid = element_blank(),
            axis.title.x = element_blank(), axis.title.y = element_blank(),
            # plot.background = element_rect(inherit.blank = TRUE),
            plot.title = element_text(hjust = 0.5, size = 24)) 
    
    
  })
  
}
  