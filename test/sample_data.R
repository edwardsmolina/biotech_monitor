library(sf)
library(leaflet)
input <- data.frame(ID = 1:10, 
                    latitude = rnorm(10, -36, 1),
                    longitude = rnorm(10, -61, 1.5)) 

leaflet() %>%
  addTiles() %>%
  addMarkers(data = input,
             lat = ~latitude,
             lng = ~longitude,
             popup = ~paste("ID: ", ID))

input <- st_as_sf(input, coords = c("latitude", "longitude")) 
st_write(input, "output.csv", 
         layer_options = c("GEOMETRY=AS_XY","OVERWRITE=true"),
         append=FALSE)

rm(list=ls())
read.csv("output.csv") %>% 
  leaflet() %>%
  addTiles() %>%
  addMarkers(lat = ~X,
             lng = ~Y,
             popup = ~paste("ID: ", ID))
