library(shiny)
library(ggplot2)
library(tidyverse)
library(scales)
library(leaflet)
library(rgdal)

nationwideData <- read_csv("nationwideMapData.csv")
sumStateData_joined <- read_csv('state_prob_join')
sumStateData <- read_csv('state_data')
statewideElectionData <- read_csv("statewideElectionData.csv")
stateCoords <- read_csv("stateCoords.csv")
statewideGEOData <- read_csv("statewideGEOData.csv")

function(input, output, session) {
  
  # Importing required GeoSpatial data from "https://eric.clst.org/tech/usgeojson/" -> "US States 5m GeoJSON"
  nationwideGEO  <- rgdal::readOGR("states.geo.json")
  
  # Reactive function for nationwide state map
  changeNationYear <- reactive({
    return(input$nationYearID)
  })
  
  # Output function for nationwide state map
  output$nationwideMap <- renderLeaflet({
    # This allows for different election years to be selected from drop-down 
    # menu to display corresponding election map
    nationwideData <- nationwideData[nationwideData$Year == changeNationYear(),]
    
    # Joining self-made data frame from above into nationwideGEO geospatial 
    # dataframe for leaflet to use for visualization
    nationwideGEO@data <- 
      nationwideGEO@data %>%
      left_join(nationwideData, by = c("NAME" = "State"))
    
    # Create final working visualization of State Chloropleth Map!
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
    print(stateLen)
    for (i in 1:stateLen){
      statewideGEO@polygons[[statePoly[i] - counter]] <- NULL
      counter <- counter + 1
    }
    counter <- 0
    statewideGEO@data <- statewideGEO@data[statewideGEO@data$stateName == changeState(),]
    statewideElectionData$city <- as.numeric(statewideElectionData$city)
    changeLevel <- levels(statewideGEO@data$NAME)
    statewideElectionData$county[statewideElectionData$county == "Do<f1>a Ana"] <- changeLevel[514]
    print(changeLevel[514])
    statewideElectionData$county <- factor(statewideElectionData$county, levels = levels(statewideGEO@data$NAME))
    
    # join the election data and the json data
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
    
    # Create final working visualization of State Chloropleth Map!
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
  
  # Here we define a plot height that will be used to dynamically 
  # set our plot height
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
  
  # Here we define a plot height that will be used to dynamically 
  # set our plot height
  predictor1PlotHeight <- reactive(0.5 * predictorPlotCount())
  
  output$barPlot <- renderPlot(height = predictor1PlotHeight, {
    
    # loads the interactive table into the range of the bar plot
    displayTable <- updateTable()
    
    # Specify the data of interest and which columns are of interest
    # We put color as the x variable and the electoral votes as the y variable
    # we also fill the bar chart based on the color(democrat, republican, swingstate)
    ggplot(displayTable, aes(color, electoralVotesNumber, fill=color)) +
      
      # specify bar chart 
      geom_bar(stat = "identity") +
      
      # specify what to color each party
      scale_fill_manual(values = c("blue", "red", "#838383")) +
      
      # give it a title
      ggtitle("Total Electoral Votes for each Party") +
      
      # give it a y-label
      ylab("Total Electoral Votes") +
      
      # give it an x label
      xlab("Declaration") + labs(fill = "Color") +
      
      # change some style features like the size of the plot and the background color
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
  
  # Here we define a plot height that will be used to dynamically 
  # set our plot height
  predictor2PlotHeight <- reactive(0.5 * predictorPlotCount())
  
  output$pieChart <- renderPlot( {
    
    # loads the interactive table into the range of the pie chart
    displayTable <- updateTable()
    
    # creates a list with a state as a key and their number of electoral votes as the value
    state_ev_list <- list(state=displayTable$state[displayTable$color == "Swing state"],
                          ev=displayTable$electoralVotesNumber[displayTable$color == "Swing state"])

    #algorithm for calculating the probability
    #count is the variable indicating which instance has electoral votes over 270
    demCount <- 0
    repCount <- 0
   
     #10000 iterations
    for (i in seq(1:10000)) {
      
      # will possibly make changes to the type of distribution n is taken from
      # where n is the number of states selected in each sampling
      number <- runif(1,min=1, max=length(state_ev_list$ev))
      as.integer(number)
      
      #code for sampling the vector of electoral votes
      sampling <- sample(state_ev_list$ev, as.integer(number))
      summation <- sum(sampling)
      
      # checks to see is the sampling has over 270 electoral votes
      if (summation > (270 - sum(displayTable$electoralVotesNumber[displayTable$color == "Republican"]))){
        
        # increments the rep count
        repCount <- repCount + 1
      }
      
    }
    
    # computes the probability the election going a certain way
    repProbability <- repCount / 10000
    
    # computes the democratic probability the election going a certain way
    demProbability <- 1 - repProbability
    
    # Creates a data frame that will fed into the pie chart
    probData <- data.frame(probs = c((demProbability*100), (repProbability*100)),
                            party = c("Democrats", "Republican"))
    
    
    # creating a new column in prob data so that we can place the percentage in the chart
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
  