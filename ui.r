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
               
               )
)
