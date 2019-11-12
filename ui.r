library(shiny)
library(markdown)

navbarPage("title",
           tabPanel("Home"),
           tabPanel("Nationwide Election Map"),
           tabPanel("Statewide Election Map"),
           tabPanel("Swing State Summary"),
           tabPanel("Election Predictor")
           )
