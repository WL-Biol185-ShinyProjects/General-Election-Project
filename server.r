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
    ggplot(displayTable, aes(color, electoralVotesNumber)) +
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