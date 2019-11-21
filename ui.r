library(shiny)
library(markdown)
library(tidyverse)
navbarPage(
 "Home",
      
 
 
 
 tabPanel("Election Predictor",
          
          
          
          
          sidebarLayout(
            sidebarPanel(
              checkboxGroupInput("demStates", "Blue States ",
                           sumStateData$state,
                           selected = sumStateData$state[sumStateData$color == "Democrat"]
            )),
               sidebarPanel(
                  checkboxGroupInput("repStates", "Red States ",
                               sumStateData$state,
                               selected = sumStateData$state[sumStateData$color == "Republican"]
                  ))),
          mainPanel()
          # selectizeInput(inputId = "demStates",
          #                label = "Democratic States",
          #                choices = sumStateData$state[sumStateData$color == "Democrat"],
          #                multiple = TRUE
          #               ),
          # selectizeInput(inputId = "repStates",
          #                label = "Republican states",
          #                choices = sumStateData$state[sumStateData$color == "Republican"],
          #                multiple = TRUE
          #               ),
          # selectizeInput(inputId = "Swing States",
          #                label = "Swing States",
          #                choices = sumStateData$state[sumStateData$color == "Swing State"],
          #                multiple = TRUE
          #               )
          )
)
               

# tabPanel("Home",
#          fluidRow(
#            column(6, 
#                   includeMarkdown("test.md"))
#          )),
# tabPanel("Nationwide Election Map"),
# tabPanel("Statewide Election Map"),
# tabPanel("Swing State Summary"),


