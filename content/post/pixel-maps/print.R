library(tidyverse)
library(googlesheets)
library(maps)
library(here)




url <- 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQoRxmeOvIAQSqOtr2DMOBW_P4idYKzRmVtT7lpqwoH7ZWAonRwOcKR2GqE-yqUOhb5Ac_RUs4MBICe/pub?gid=903584642&single=true&output=csv'
destfile <- "locations.csv"
curl::curl_download(url, destfile)
locations <- read_csv(destfile)
tail(locations)


locations <- locations %>% 
  mutate(long_round = round(lon*2, 0)/2,
         lat_round = round(lat*2,0)/2,
         family = as.factor(family))
tail(locations)

# Generate a data frame with all dots -----------------------------------------------

lat <- data_frame(lat = seq(-90, 90, by = 0.5))
long <- data_frame(long = seq(-180, 180, by = 0.5))
dots <- lat %>% 
  merge(long, all = TRUE)

## Only include dots that are within borders. Also, exclude lakes.
dots <- dots %>% 
  mutate(country = map.where('state', long, lat),
         lakes = map.where('lakes', long, lat)) %>% 
  filter(!is.na(country) & is.na(lakes)) %>% 
  select(-lakes)

head(dots)

locations <- locations %>% 
  mutate(country = map.where('state', lon, lat),
         lakes = map.where('lakes', lon, lat)) %>% 
  filter(!is.na(country) & is.na(lakes)) %>% 
  select(-lakes)

theme <- theme_minimal() + theme_void()
  

plot <- ggplot() +   
  #base layer of map dots
  geom_point(data = dots, aes(x=long, y = lat), col = "grey80", size = 1) + 
  #plot all the places I've been to
  geom_point(data = locations, aes(x=long_round, y=lat_round, col = family), size=1) + 
  #plot all the places I lived in, using red
  geom_point(data = locations %>% filter(status == 'lived'), aes(x=long_round, y=lat_round), color="red", size=1) +
  #an extra layer of halo around the places I lived in
  geom_point(data = locations %>% filter(status == 'lived'), aes(x=long_round, y=lat_round), color="red", size=6, alpha = 0.4) +
  #adding my theme
  theme
  # scale_y_continuous(limits = c(-15, 70), expand = c(0,0)) +
  # scale_x_continuous(limits = c(-130,40), expand = c(0,0))
plot


ggsave('map_print.jpg', 
       device = 'jpg', 
       path = getwd(), 
       width = 270, 
       height = 210, 
       units = 'mm',
       dpi = 200)

  ggsave('map_wide.png', 
         device = 'png', 
         path = paste0(here(),'/static/images'),
         width = 360, 
         height = 90, 
         units = 'mm',
         dpi = 250)
