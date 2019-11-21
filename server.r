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
  
  
  output$barPlot <- renderPlot({
    
    observe({
      
       input$repStates <- sumStateData$state
       updateCheckboxGroupInput(session, "repStates", selected = setdiff(input$repStates,input$demStates) )
      
    })
    
    observe({
    
      input$demStates <- sumStateData$state
      updateCheckboxGroupInput(session, "demStates", selected = setdiff(input$repStates,input$demStates))
    })
  
    
  })
    
    
   }
  
  
  
  
  
  # 
  # 
  # 
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