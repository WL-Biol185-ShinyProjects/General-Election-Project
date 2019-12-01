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
    sumStateData_joined$winner <- "none"
    sumStateData_joined$winner[sumStateData_joined$state == input$demStates] <- "democrat"
    sumStateData_joined$winner[sumStateData_joined$state == input$repStates] <- "republican"
  })

  output$barPlot <- renderPlot({
    # sumStateData_joined$winner <- "none"
    # sumStateData_joined$winner[sumStateData_joined$state == input$demStates] <- "democrat"
    # sumStateData_joined$winner[sumStateData_joined$state == input$repStates] <- "republican"
    
    ggplot(sumStateData_joined, aes(winner, electoralVotesNumber)) +
      geom_bar(stat = "identity")
  })


   }
  # 
  # 
  
  
  
  # 
  # 
  # setdiff(repStates,demStates)
  # output$plot <- renderPlot({
  #   plot(cars, type=input$plotType)
  # })
  # 
  # output$summary <- renderPrint({
  #   summary(cars)
  # })
  # 
  # output$table <- DT::renderDataTable({
  #   DT::datatable(cars)
  # })