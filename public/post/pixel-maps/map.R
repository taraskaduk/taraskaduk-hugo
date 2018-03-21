library(ggplot2)
library(maps)

#load us map data
states_48 <- map_data("state")

#load these after getting states in
library(jsonlite)
library(tidyverse)

#load cities
cities_all <- fromJSON("cities.json")

cities_48 <- cities_all %>% 
  filter(state != 'Alaska' & state != 'Hawaii')

cities_48 <- cities_48 %>% 
  mutate(city_state = paste(city, state, sep = ", "))

vector_cities_been <- 
  c(
    "Jacksonville, Florida", 
    "Ocala, Florida", 
    "San Diego, California", 
    "Los Angeles, California", 
    "Seattle, Washington", 
    "Portland, Oregon", 
    "Savannah, Georgia", 
    "Charleston, South Carolina"
    )

states_been <- subset(states_48, region %in% c(
  "florida", 
  "georgia", 
  'south carolina', 
  'north carolina', 
  'california',
  'oregon',
  'washington'))

states_want <- subset(states_48, region %in% c(
  'new york',
  'colorado'))

cities_been <- cities_48 %>% filter(cities_48$city_state %in% vector_cities_been)

#plot all states with ggplot

ggplot() + 
  geom_polygon(data= states_48, aes(x=long, y=lat, group = group),colour="white", fill="grey88" ) +
  geom_polygon(data = states_been, aes(x=long, y=lat, group = group),colour="white", fill="grey21" ) +
  geom_polygon(data = states_want, aes(x=long, y=lat, group = group),colour="white", fill="grey40" ) +
  geom_point(data = cities_been, aes(x = longitude, y = latitude), shape = 21, fill = "grey21", colour = "grey88",  size = 4) +
  geom_text(data = cities_been, aes(x = longitude, y = latitude, label = city), col = "red") +
  theme_void()
  
