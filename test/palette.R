library(shiny)
library(leaflet)

# https://rstudio.github.io/leaflet/shiny.html
dat <- read.csv("data/spodoptera.csv")  %>% 
  sample_n(200) %>%
  mutate(damage_level=cut(OBS_numValue,
                          c(-Inf, 5, 20, 50, Inf), include.lowest = T,
                          labels = c('0-5%', '5-20%', '20-50%', '50-100%'))) %>% 
  select(OBS_numValue, damage_level, lat, lon) 

beatCol <- colorFactor(c("#006400", "#B0C900", "#FFC100", "#FF0000"), 
                       domain =  dat$damage_level)

leaflet() %>%
  addProviderTiles(providers$Stadia.StamenTonerLite,
                   options = providerTileOptions(noWrap = TRUE)
  ) %>%
  addCircleMarkers(data = dat,
             color = ~beatCol(damage_level),
             # fillColor = ~beatCol(damage_level), 
             radius = 3, 
             popup = dat$damage_level) %>% 
  addLegend("bottomright",
            title="Damage level", 
            pal = beatCol, 
            values = dat$damage_level ,
            labels = c('<5%', '5-20%', '20-50%', '50-100%'),
            opacity = 0.7)


