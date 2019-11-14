library(maps)
library(ggplot2)
usStates <- map_data("state")
head(usStates)
dim(usStates)

p <-  ggplot(data = usStates, mapping = aes(long, lat, group = group, fill = region)) 

p + geom_polygon(color = "gray90", size = 0.1) + guides(fill = FALSE)

View(usStates)