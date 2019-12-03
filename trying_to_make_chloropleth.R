library(leaflet)
library(htmltools)
library(rgdal)
library(tidyverse)

#To create needed data frames
statesGEO  <- rgdal::readOGR("states.geo.json")

states2016 <- data.frame( 
  lat    = c( 32.806671   ,  61.370716  ,  33.729759  ,  34.969704  ,  36.116203  ,  39.059811  ,  41.597782   ,  39.318523  ,  38.897438            ,  27.766279  ,  33.040619  ,  21.094318  ,  44.240459  ,  40.349457  ,  39.849426  ,  42.011539  ,  38.526600  ,   37.668140  ,  31.169546  ,  44.693947  ,  39.063946  ,  42.230171     ,  43.326618  ,  45.694454  ,  32.741646   ,  38.456085  ,  46.921925  ,  41.125370  ,  38.313515   ,  43.452492     ,  40.298904   ,  34.840515   ,  42.165726   ,  35.630066      ,  47.528912    ,  40.388783  ,  35.565342  ,  44.572021  ,  40.590752    ,  41.680893    ,  33.856892      ,  44.299782    ,  35.747845  ,  31.054487  ,  40.150032  ,  44.045876  ,  37.769337  ,  47.400902  ,  38.491226     ,  44.268543  ,  42.755966  )
  , lon    = c(-86.791130   , -152.404419 , -111.431221 , -92.373123  , -119.681564 , -105.311104 , -72.755371   , -75.507141  , -77.026817            , -81.686783  , -83.643074  , -157.498337 , -114.478828 , -88.986137  , -86.258278  , -93.210526  , -96.726486  ,  -84.670067  , -91.867805  , -69.381927  , -76.802101  , -71.530106     , -84.536095  , -93.900192  , -89.678696   , -92.288368  , -110.454353 , -98.268082  , -117.055374  , -71.563896     , -74.521011   , -106.248482  , -74.948051   , -79.806419      , -99.784012    , -82.764915  , -96.928917  , -122.070938 , -77.209755    , -71.511780    , -80.945007      , -99.438828    , -86.692345  , -97.563461  , -111.862434 , -72.710686  , -78.169968  , -121.490494 , -80.954453     , -89.616508  , -107.302490 )
  , place  = c("Alabama"    , "Alaska"    , "Arizona"   , "Arkansas"  , "California", "Colorado"  , "Connecticut", "Delaware"  , "District of Columbia", "Florida"   , "Georgia"   , "Hawaii"    , "Idaho"     , "Illinois"  , "Indiana"   , "Iowa"      , "Kansas"    ,  "Kentucky"  , "Louisiana" , "Maine"     , "Maryland"  , "Massachusetts", "Michigan"  , "Minnesota" , "Mississippi", "Missouri"  , "Montana"   , "Nebraska"  , "Nevada"     , "New Hampshire", "New Jersey" , "New Mexico" , "New York"   , "North Carolina", "North Dakota", "Ohio"      , "Oklahoma"  , "Oregon"    , "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee" , "Texas"     , "Utah"      , "Vermont"   , "Virginia"  , "Washington", "West Virginia", "Wisconsin" , "Wyoming"   )
  , votes  = c( 9           ,  3          ,  10         ,  6          ,  55         ,  9          ,  7           ,  3          ,  3                    ,  27         ,  15         ,  4          ,  4          ,  21         ,  11         ,  7          ,  6          ,   8          ,  9          ,  4          ,  10         ,  12            ,  17         ,  10         ,  6           ,  11         ,  3          ,  5          ,  5           ,  4             ,  15          ,  5           ,  31          ,  15             ,  3            ,  20         ,  7          ,  7          ,  21           ,  4            ,  8              ,  3            ,  11         ,  34         ,  5          ,  3          ,  13         ,  11         ,  5             ,  10         ,  3          )
  , popul  = c("4,887,871"  , "737,438"   , "7,171,646" , "3,013,825" , "39,557,045", "5,695,564" , "3,572,665"  , "967,171"   , "702,455"             , "21,299,325", "10,519,475", "1,420,491" , "1,754,208" , "12,741,080", "6,691,878" , "3,156,145" , "2,911,505" ,  "4,468,402" , "4,659,978" , "1,338,404" , "6,042,718" , "6,902,149"    , "9,995,915" , "5,611,179" , "2,986,530"  , "6,126,452" , "1,062,305" , "1,929,268" , "3,034,392"  , "1,356,458"    , "8,908,520"  , "2,095,428"  , "19,542,209" , "10,383,620"    , "760,077"     , "11,689,442", "3,943,079" , "4,190,713" , "12,807,060"  , "1,057,315"	  , "5,084,127"     , "882,235"     , "6,770,010" , "28,701,845", "3,161,105" , "626,299"   , "8,517,685" , "7,535,591" , "1,805,832"    , "5,813,568" , "577,737"   )
  , party  = c("Republican" , "Republican", "Republican", "Republican", "Democratic", "Democratic", "Democratic" , "Democratic", "Democratic"          , "Republican", "Republican", "Democratic", "Republican", "Democratic", "Republican", "Republican", "Republican",  "Republican", "Republican", "Democratic", "Democratic", "Democratic"   , "Republican", "Democratic", "Republican" , "Republican", "Republican", "Republican", "Democratic" , "Democratic"   , "Democratic" , "Democratic" , "Democratic" , "Democratic"    , "Republican"  , "Republican", "Republican", "Democratic", "Republican"  , "Democratic"  , "Republican"    , "Republican"  , "Republican", "Republican", "Republican", "Democratic", "Democratic", "Democratic", "Republican"   , "Republican", "Republican")
  , stringsAsFactors = FALSE
)
states2016$popupText <- paste(strong("State:"), states2016$place, br(), 
                              strong("Winning Party:"), states2016$party, br(),
                              strong("Electoral Votes:"), states2016$votes, br(),
                              strong("Population:"), states2016$popul)
statesGEO@data <- 
  statesGEO@data %>%
  left_join(states2016, by = c("NAME" = "place"))


# To pull-up visualization of State Chloropleth Map
leaflet(statesGEO) %>%
  setView(-98.483330, 38.712046, 4) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorFactor(c("blue", "red"), statesGEO@data$party)(statesGEO@data$party),
              highlightOptions = 
                highlightOptions(
                  color = "white", 
                  weight = 2, 
                  bringToFront = TRUE),
              popup = statesGEO@data$popupText)
