library(shiny)
library(markdown)

tags$head(tags$style(type = 'text/css','.navbar-brand{display:none;}'))
navbarPage(
 '',
      tabPanel("Home",
        fluidRow(
          column(6, 
            includeMarkdown("test.md"))
        )),
      tabPanel("Nationwide Election Map"),
      tabPanel("Statewide Election Map"),
      tabPanel("Swing State Summary"),
      
 
 
 
 tabPanel("Election Predictor",
          
          
          selectizeInput(inputID="demStates",
                         label = "Democratic States",
                         choices = sumStatedata$state,
                         multiple = TRUE
                        ),
          selectizeInput(inputID="repStates",
                         label = "Republican states",
                         choices = sumStatedata$state,
                         multiple = TRUE
                        ),
            
          )
                         
            
            
          )
               
               

