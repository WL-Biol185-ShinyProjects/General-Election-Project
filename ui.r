# Added any needed packages
library(shiny)
library(shinydashboard)
library(lubridate)
library(leaflet)
library(tidyverse)

# Pull in required data frames
nationwideData <- read_csv("nationwideMapData.csv")
sumStateData_joined <- read_csv('state_prob_join')
sumStateData <- read_csv('state_data')
statewideElectionData <- read_csv("statewideElectionData.csv")
stateCoords <- read_csv("stateCoords.csv")
states <- statewideElectionData$state[statewideElectionData$state != "Alaska"]
states <- states[states != "District of Columbia"]

# Creates the dashboard outline for the app
dashboardPage(
  skin = "purple",
  dashboardHeader(
    title = "General Election Predictor",
    titleWidth = 300
  ),
  
  # Code for the side bar menu that is diblayed on the menu
  dashboardSidebar(
    width = 190,
    collapsed = FALSE,
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Nationwide Map", tabName = "nationMap", 
               icon = icon("map-marked")),
      menuItem("Statewide Map", tabName = "stateMap", 
               icon = icon("map-marker")),
      menuItem("State Results Summary", tabName = "srs", 
               icon = icon("bar-chart")),
      menuItem("Predictor", tabName = "predictor", icon = icon("check-circle")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  # Code that outlines what each individual tab inside the website looks like
  dashboardBody(
    tabItems(
      # Code for the home page
      tabItem(
        tabName = "home",
        fluidRow(
          column(8, allign = "center", offset = 2,
                 tags$head(tags$style(type="text/css", 
                                      ".header1_type {color: black;
                             font-size: 36px;
                             text-align: center;}"
                 )),
                 tags$u(div(class="header1_type",
                            p(strong("Background")))
                 ),
                 br(),
                 tags$head(tags$style(type="text/css", 
                                      ".pic1_type {color: black;
                             font-size: 16px;
                             text-align: center;}"
                 )),
                 tags$div(class="pic1_type",
                          img(src = "https://media4.s-nbcnews.com/i/newscms/2019_21/2868481/nbc-decision-2020-logo-front-plain_bcc56b6241dd0fc7c7fb84a185305310.png",
                              height = 200, width = 400, align = "center")
                 ),
                 br(),
                 br(),
                 tags$head(tags$style(type="text/css", 
                                      ".body1_type {color: black;
                             font-size: 16px;
                             text-align: center;}"
                 )),
                 tags$div(class="body1_type",
                          p("Our app allows users to gain knowledge and insight into the 
                    United Sates' presidential election results. First we start 
                    off by using the data linked below to create useful 
                    visualizations to help understand and intepret past 
                    presidential election results by state, county, and 
                    political party. The visuals are meant to help build context 
                    on how each factor impacts elections and set the stage
                    for our predictor"),
                          a("General election data by state for each presidential 
                    election dating back to 1976",     
                            href="https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/42MVDX",
                            target = '_blank'),
                          br(),
                          
                          a("General election data by county for each predential election
                    dating back to 2000",
                            href="https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VOQCHQ",
                            target = '_blank')
                 ),
      
                 br(),
                 br(),
                 br(),
                 
                 tags$head(tags$style(type="text/css", 
                                      ".header2_type {color: black;
                              font-size: 28px;
                              text-align: center;}"
                 )),
                 tags$u(div(class="header2_type",
                            p(strong("Presidential Election Predictor")))
                 ),
                 br(),
                 tags$head(tags$style(type="text/css", 
                                      ".pic2_type {color: black;
                             font-size: 14px;
                             text-align: center;}"
                 )),
                 tags$div(class="pic2_type",
                          img(src = "https://imageproxy.themaven.net/https%3A%2F%2Fimages.saymedia-content.com%2F.image%2FMTY1ODI0ODIxMjkxMTMxOTk3%2Fus-presidential-election---chayka1270.jpg",
                              height = 200, width = 300)
                 ),
                 
                 br(),
                 br(),
                 tags$head(tags$style(type="text/css", 
                                      ".body2_type {color: black;
                             font-size: 16px;
                             text-align: center;}"
                 )),
                 tags$div(class="body2_type",
                          p("Our predictor uses a simple and primitive algorithm to
                    predict the liklihood each of the two parties wins the 
                    presidential election. The predictor allows the user to 
                    declare states as republican, democrat, or swing and then 
                    outputs the liklihood for each party as well as the total 
                    electoral votes in each of the 3 categories in the current 
                    state set by the user. The tab is preset with likely
                    republican and democrat states for the up an coming election
                    already declared as such. With any remaining states that are
                    considered toss ups, declared as swing states."
                          )),
                 
                 br(),
                 br(),
                 p("Cover images credit to:  www.nbcnews.com and newsmaven.io")
                 
          ))),
      
      # Code for the Nationwide Map
      tabItem(
        tabName = "nationMap",
        fluidRow(
          column(2, offset = 1,
            selectInput('nationYearID', 'Choose a year:', rev(nationwideData$Year), 
                        selectize=TRUE, selected = TRUE)
          ),
          column(12,
            leafletOutput("nationwideMap", height = 600)
          ) 
        )
      ),
      
      # Code for the Statewide Map
      tabItem(
        tabName = "stateMap",
        fluidRow(
          column(2, offset = 1,
                 selectInput('stateYearID', 'Choose a year:', rev(statewideElectionData$year),
                             selectize = TRUE, selected = TRUE)
          ),
          column(2,
                 selectInput('stateID', 'Choose a state:', 
                             states, selectize = TRUE, selected = TRUE)
          ),
          column(12,
                 leafletOutput("statewideMap", height = 600)
          ) 
        )
      ),
      
      # Code for the State Summary Results page  
      tabItem(
        tabName = "srs",
        plotOutput("sumStateData"),
        
        # This code is used to find the height of the window
        tags$head(tags$script('
                              var srsHeight = 0;
                              $(document).on("shiny:connected", function(e) {
                                  srsHeight = window.innerHeight;
                                  Shiny.onInputChange("srsHeight", srsHeight);
                              });
                              $(window).resize(function(e) {
                                  srsHeight = window.innerHeight;
                                  Shiny.onInputChange("srsHeight", srsHeight);
                              });
                            '))
      ),
      
      # Code for the predictor page
      tabItem(
        tabName = "predictor",
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                "Blue States",
                checkboxGroupInput("demStates", NULL,
                                   sumStateData_joined$state,
                                   selected = sumStateData_joined$state[sumStateData_joined$color == "Democrat"]
                )),
              tabPanel(
                "Red States",
                checkboxGroupInput("repStates", NULL,
                                   sumStateData_joined$state,
                                   selected = sumStateData_joined$state[sumStateData_joined$color == "Republican"]
                )))),

        mainPanel(
          plotOutput("pieChart"),
          plotOutput("barPlot"),
          
          # This code is used to find the height of the window
          tags$head(tags$script('
                              var predictorHeight = 0;
                              $(document).on("shiny:connected", function(e) {
                                  predictorHeight = window.innerHeight;
                                  Shiny.onInputChange("predictorHeight", predictorHeight);
                              });
                              $(window).resize(function(e) {
                                  srsHeight = window.innerHeight;
                                  Shiny.onInputChange("predictorHeight", predictorHeight);
                              });
                            '))
          )
      )),
      
      # Code for the about page
      tabItem(
        tabName = "about",
        fluidRow(
          
          column(8, allign = "center", offset = 2,
                 tags$head(tags$style(type="text/css", 
                                      ".header1_type {color: black;
                             font-size: 36px;
                             text-align: center;}"
                 )),
                 tags$u(div(class="header1_type",
                            p(strong("About")))
                 ),
                 br(),
                 tags$head(tags$style(type="text/css", 
                                      ".body3_type {color: black;
                             font-size: 16px;
                             text-align: center;}"
                 )),
                 tags$div(class="body3_type",
                          p("Hi all, "),
                          br(),
                          p("Matt, Jay, and Christian would like to a 
                            moment to explain the idea behind our website. The 
                            idea was originally the brain child of Jay Roberts
                            who is one of the meta data analysts for the 2020 
                            Mock Convention cycle. Essentially, he wanted to 
                            come up with interesting ways to paint the general 
                            in a picture. After taking this idea to Matt, the 
                            two developed the idea to much of what you see here.
                             Later the two of them added Christian and the three
                             put in hours and hours of work to display what you 
                            see here."),
                          br(),
                          p("Our predictor is far from perfect but we would love
                            to hear any feedback or suggestions you might have 
                            about our website at dodsonm20@mail.wlu.edu. We will 
                            use this tab to notify you of any updates that have 
                            been made."),
                          br(),
                          p("Thanks, "),
                          br(),
                          p("Matt, Jay, and Christian"),
                          br(),
                          img(src="https://wlu.prestosports.com/sports/fball/2017-18/photos/Head_Shots/Dodson.jpg?max_width=160&max_height=210",
                              height = 200, width = 150),
                          img(src="https://generalssports.com/images/2019/9/10//jay_roberts_fball_2018_19.jpg?width=300",
                              height = 200, width = 150),
                          img(src="https://wlu.prestosports.com/sports/bsb/2017-18/photos/Headshots/Kim_Web.jpg?max_width=160&max_height=210",
                              height = 200, width = 150)
                 )
          ))
      )
    )
  )
)

