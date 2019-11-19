library(shiny)
library(markdown)

navbarPage(
 "Home",
      
 
 
 
 tabPanel("Election Predictor",
          selectizeInput(inputId = "demStates",
                         label = "Democratic States",
                         choices = sumStateData$state,
                         multiple = TRUE
                        ),
          selectizeInput(inputId = "repStates",
                         label = "Republican states",
                         choices = sumStateData$state,
                         multiple = TRUE
                        )
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


