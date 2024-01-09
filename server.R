library(shiny)
library(leaflet)
library(dplyr)
library(tidyr)

dat <- read.csv("data/spodoptera.csv")  
# filter(FIELD_plantingSeason>2020)
# str(dat)
# unique(dat$trait)

# first cut the continuous variable into bins these bins are now factors
dat <- dat %>%
  mutate(damage_level=cut(OBS_numValue,
                        c(-Inf, 5, 20, 50, Inf), include.lowest = T,
                        labels = c('<5%', '5-20%', '20-50%', '50-100%')))
# dat %>% select(OBS_numValue, damage_level) %>% sample_n(30)

beatCol <- colorFactor(c("#006400", "#B0C900", "#FFC100", "#FF0000"), domain = unique(dat$damage_level))

function(input, output, session) {
  
# Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    dat %>% 
      filter(FIELD_plantingSeason >= input$range[1] & FIELD_plantingSeason <= input$range[2]) %>% 
      filter(createdTechnology %in% input$biotech) %>% 
      filter(trait %in% input$trait) %>% 
      filter(OBS_numValue<101)
  })

  # Basic map
  output$map <- renderLeaflet({
    leaflet(dat) %>% 
      addTiles() %>%
      fitBounds(~min(lon), ~min(lat ), ~max(lon), ~max(lat)) %>% 
      addLegend("bottomright",
                title="Damage level", 
                pal = beatCol, 
                values = dat$damage_level ,
                labels = c('<5%', '5-20%', '20-50%', '50-100%'),
                opacity = 0.7) 
    })
  # Dinamic changes of map points based on user selection
  observe({
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      # addCircleMarkers(
      addCircles(
        color = ~beatCol(damage_level),
        # fillColor = ~beatCol(damage_level), 
        radius = 3,
        popup = ~paste(sep="",
                      "<br/>","<font size=2 color=#045FB4>","Damage: ","</font>" , OBS_numValue,
                      "<br/>","<font size=2 color=#045FB4>","Biotech: ","</font>" , createdTechnology,
                      "<br/>","<font size=2 color=#045FB4>","Hybrid: ","</font>", commercialName,
                      # "<br/>","<font size=2 color=#045FB4>","Season: ","</font>", FIELD_plantingSeason
                      "<br/>","<font size=2 color=#045FB4>","Field: ","</font>", FIELD_name
        )
        
        # addCircles(
        #   radius = ~1.1^OBS_numValue/1.1, weight = 1,
        #   # 1.1^95/1.1
        #   color = ~beatCol(damage_level),
        #   fillOpacity = 0.7, 
      )
  })
}

# dat %>% 
#   filter(FIELD_name == "DBORE_ELARANADO_SIMIONI_LATE_F22", 
#          commercialName ==  "DK7220VTPRO4")

