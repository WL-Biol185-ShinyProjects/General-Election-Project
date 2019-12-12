# Added any needed packages
library(shiny)
library(ggplot2)
library(tidyverse)
library(scales)
library(leaflet)
library(rgdal)

# Pull in required data frames
nationwideData <- read_csv("nationwideMapData.csv")
sumStateData_joined <- read_csv('state_prob_join')
sumStateData <- read_csv('state_data')
statewideElectionData <- read_csv("statewideElectionData.csv")
stateCoords <- read_csv("stateCoords.csv")

function(input, output, session) {
  
  # Importing required GeoSpatial data
  nationwideGEO  <- rgdal::readOGR("states.geo.json")
  
  # Reactive function for changing the year
  changeNationYear <- reactive({
    return(input$nationYearID)
  })
  
  # Output function for nationwide state map
  output$nationwideMap <- renderLeaflet({
    
    # Selecting the election data based on user input
    nationwideData <- nationwideData[nationwideData$Year == changeNationYear(),]
    
    # Joining elction data and json data
    nationwideGEO@data <- 
      nationwideGEO@data %>%
      left_join(nationwideData, by = c("NAME" = "State"))
    
    # Create final leaflet visualization
    leaflet(data = nationwideGEO) %>%
      setView(-103.483330, 38.712046, 4) %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.5,
                  fillColor = ~colorFactor(c("blue", "red"), nationwideGEO@data$Party)(nationwideGEO@data$Party),
                  highlightOptions = 
                    highlightOptions(
                      color = "white", 
                      weight = 2, 
                      bringToFront = TRUE),
                  popup = nationwideGEO@data$popupText)
  })
  
  # Reactive functions for statewide county map
  changeStateYear <- reactive({

    return(input$stateYearID)
  })
  
  changeState <- reactive({
    return(input$stateID)
  })
  
  # Output function for statewide county map
  output$statewideMap <- renderLeaflet({
    
    # Importing geo spatial data for statewide county map
    statewideGEO <- rgdal::readOGR("counties.json")
    
    # Adding the state names to the counties table
    stateNames <- as.character(nationwideGEO@data$NAME)
    names(stateNames) <- as.character(nationwideGEO@data$STATE)
    statewideGEO@data$stateName <- stateNames[as.character(statewideGEO@data$STATE)]
    
    # Adding city tags to the geo data for the table join
    statewideGEO@data$city <- 0
    statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[1857,]$NAME) &
                             (statewideGEO@data$stateName == statewideGEO@data[1857,]$stateName) &
                             (statewideGEO@data$LSAD == statewideGEO@data[1857,]$LSAD)] <- 1
    statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[2223,]$NAME) &
                             (statewideGEO@data$stateName == statewideGEO@data[2223,]$stateName) &
                             (statewideGEO@data$LSAD == statewideGEO@data[2223,]$LSAD)] <- 1
    statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[2910,]$NAME) &
                             (statewideGEO@data$stateName == statewideGEO@data[2910,]$stateName) &
                             (statewideGEO@data$LSAD == statewideGEO@data[2910,]$LSAD)] <- 1
    statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[926,]$NAME) &
                             (statewideGEO@data$stateName == statewideGEO@data[926,]$stateName) &
                             (statewideGEO@data$LSAD == statewideGEO@data[926,]$LSAD)] <- 1
    statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[2911,]$NAME) &
                             (statewideGEO@data$stateName == statewideGEO@data[2911,]$stateName) &
                             (statewideGEO@data$LSAD == statewideGEO@data[2911,]$LSAD)] <- 1
    statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[2947,]$NAME) &
                             (statewideGEO@data$stateName == statewideGEO@data[2947,]$stateName) &
                             (statewideGEO@data$LSAD == statewideGEO@data[2947,]$LSAD)] <- 1
    statewideGEO@data$city[(statewideGEO@data$NAME == statewideGEO@data[937,]$NAME) &
                             (statewideGEO@data$stateName == statewideGEO@data[937,]$stateName) &
                             (statewideGEO@data$LSAD == statewideGEO@data[937,]$LSAD)] <- 1

    # Specify the year
    statewideElectionData <- statewideElectionData[statewideElectionData$year == changeStateYear(),]
    
    # Selects the state specified by user
    statePoly <- which(statewideGEO@data$stateName != changeState())
    stateLen <- length(statePoly)
    counter <- 0
    
    # Filter out polygons of other states
    for (i in 1:stateLen){
      statewideGEO@polygons[[statePoly[i] - counter]] <- NULL
      counter <- counter + 1
    }
    counter <- 0
    
    # Last couple data manipulations before join
    statewideGEO@data <- statewideGEO@data[statewideGEO@data$stateName == changeState(),]
    statewideElectionData$city <- as.numeric(statewideElectionData$city)
    changeLevel <- levels(statewideGEO@data$NAME)
    statewideElectionData$county[statewideElectionData$county == "Do<f1>a Ana"] <- changeLevel[514]
    statewideElectionData$county <- factor(statewideElectionData$county, levels = levels(statewideGEO@data$NAME))
    
    # Join the election data and the json data
    statewideGEO@data <-
      statewideGEO@data %>% 
      left_join(statewideElectionData, by = c("stateName" = "state", 
                                           "NAME" = "county", "city"))
    
    # Grab state specific values for setview
    currentLong <- stateCoords$lon[stateCoords$state == changeState()]
    currentLat <- stateCoords$lat[stateCoords$state == changeState()]
    currentZoom <- stateCoords$zoom[stateCoords$state == changeState()]
    
    # Organize the color
    colors <- c("red")
    if (statewideGEO@data$party[1] == "Democrat"){
      colors <- c("blue")
    }
    if (length(unique(statewideGEO@data$party)) > 1){
      colors <- c("blue", "grey", "red")
    }
    
    # Create final leaflet visualization
    leaflet(statewideGEO) %>%
      setView(currentLong, currentLat, currentZoom) %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.5,
                  fillColor = ~colorFactor(colors, statewideGEO@data$party)(statewideGEO@data$party),
                  highlightOptions =
                    highlightOptions(
                      color = "white",
                      weight = 2,
                      bringToFront = TRUE),
                  popup = statewideGEO@data$popupText)
    
  })
  
  # This code takes the window height from the ui code and saves it as numeric
  srsPlotCount <- reactive({
    req(input$srsHeight)
    as.numeric(input$srsHeight)
  })
  
  # Here we define a plot height for the plot
  srsPlotHeight <- reactive(0.85 * srsPlotCount())
  
  # The ouput plot for the party victories summary tab
  output$sumStateData <- renderPlot(height = srsPlotHeight, {
 
    sumStateData %>% 
      ggplot(aes(x = reorder(state_po, -changeOfWins), y = changeOfWins, 
                 fill = color)) + 
      geom_bar(stat = "identity")  +
      ggtitle("        Net Party Victories by State since 1976
          (Colored with most recent 2020 election predictions)") +
      ylab("Net Victories by Party") +
      xlab("States") +
      scale_fill_manual(values = c("blue", "red", "#838383")) +
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
      labs(fill = "Color ")
  })
  
  # Code to change the values of check boxes for predictor page
  observe({
    
    updateCheckboxGroupInput(session, "repStates", 
                             label = NULL, 
                             choices = setdiff(sumStateData_joined$state, input$demStates),
                             selected = setdiff(input$repStates,input$demStates))
    
    updateCheckboxGroupInput(session, "demStates", 
                             label = NULL,
                             choices = setdiff(sumStateData_joined$state, input$repStates),
                             selected = setdiff(input$demStates,input$repStates))
    
  })
  
  # Code to update the democrat and republican states based on user input
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
  
  # This code takes the window height from the ui code and saves it as numeric
  predictorPlotCount <- reactive({
    req(input$predictorHeight)
    as.numeric(input$predictorHeight)
  })
  
  # Here we define a plot height for the plot
  predictor1PlotHeight <- reactive(0.5 * predictorPlotCount())
  
  # Code for the predictor bar plot
  output$barPlot <- renderPlot(height = predictor1PlotHeight, {
    
    # Loads the interactive table into the range of the bar plot
    displayTable <- updateTable()
    
    # Code for the ggplot that makes the visualization
    ggplot(displayTable, aes(color, electoralVotesNumber, fill=color)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = c("blue", "red", "#838383")) +
      ggtitle("Total Electoral Votes for each Party") +
      ylab("Total Electoral Votes") +
      xlab("Declaration") + labs(fill = "Color") +
      theme(plot.title = element_text(hjust = 0.5, size = 24), 
          legend.background = element_rect(fill = "white", size = 0.5, 
                                           linetype = "solid", 
                                           color = 'black'),
          legend.text = element_text(size = 16), 
          legend.title = element_text(size = 20),
          axis.title.x = element_text(size = 18),
          axis.title.y = element_text(size = 18),
          axis.text.x = element_text(size = 14),
          axis.text.y = element_text(size = 14)
      ) + scale_y_continuous(breaks = c(0, 30, 60, 90, 120, 150, 180, 210, 
                                        240, 270)) +
      coord_cartesian(ylim = c(0, 280))
  })
  
  output$pieChart <- renderPlot( {
    
    # loads the interactive table into the range of the pie chart
    displayTable <- updateTable()
    
    # creates a list with a state as a key and their number of electoral votes as the value
    state_ev_list <- list(state=displayTable$state[displayTable$color == "Swing state"],
                          ev=displayTable$electoralVotesNumber[displayTable$color == "Swing state"])

    #algorithm for calculating the probability
    demCount <- 0
    repCount <- 0
   
    for (i in seq(1:10000)) {

      number <- runif(1,min=1, max=length(state_ev_list$ev))
      as.integer(number)

      sampling <- sample(state_ev_list$ev, as.integer(number))
      summation <- sum(sampling)
      
      if (summation > (270 - sum(displayTable$electoralVotesNumber[displayTable$color == "Republican"]))){
        repCount <- repCount + 1
      }
      
    }
    
    # computes the two probabilities
    repProbability <- repCount / 10000
    demProbability <- 1 - repProbability
    
    # Code to create the pie chart
    probData <- data.frame(probs = c((demProbability*100), (repProbability*100)),
                            party = c("Democrats", "Republican"))
    probData <- probData %>%
                arrange(desc(party)) %>%
                mutate(lab.ypos = cumsum(probs) - 0.5*probs)
    
    mycols <-c("#0000FF", "#FF0000")
    
    ggplot(probData, aes(x="", y = probs, fill=party)) +
      geom_bar(width = 1, stat = 'identity', color = "white") + 
      coord_polar("y", start = 0) +
      geom_text(aes(y = lab.ypos, label = paste0(round(probs), "%")), 
                                                 color = "white", size = 16) +
      scale_fill_manual(values = mycols) +
      ggtitle("The Probability Either Party Wins") +
      theme(axis.line = element_blank(), axis.text = element_blank(),
            axis.ticks = element_blank(), panel.grid = element_blank(),
            axis.title.x = element_blank(), axis.title.y = element_blank(),
            legend.background = element_rect(fill = "white", size = 0.5, 
                                           linetype = "solid", 
                                           color = 'black'),
            legend.text = element_text(size = 16), 
            legend.title = element_text(size = 20),
            plot.title = element_text(hjust = 0.5, size = 24),
            ) + labs(fill = "Party")
  })
  
}
  