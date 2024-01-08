library(shiny)
library(leaflet)
library(RColorBrewer)
library(dplyr)
library(tidyr)

dat <- read.csv("data/spodoptera.csv")  
# filter(FIELD_plantingSeason>2020)
# str(dat)
# unique(dat$trait)

function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    dat %>% 
      filter(FIELD_plantingSeason >= input$range[1] & FIELD_plantingSeason <= input$range[2]) %>% 
      filter(createdTechnology %in% input$biotech) %>% 
      filter(trait %in% input$trait)
  })
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  # colorpal <- reactive({
  #   colorNumeric(input$colors, dat$OBS_numValue)
  # })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(dat) %>% addTiles() %>%
      fitBounds(~min(lon), ~min(lat ), ~max(lon), ~max(lat))
  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    # pal <- colorpal()
    
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = ~1.1^OBS_numValue/1.1, weight = 1, 
                 fillColor = "red", color = "red",  
                 # fillColor = ~pal(OBS_numValue), 
                 fillOpacity = 0.7, popup = ~paste(OBS_numValue, createdTechnology)
      )
  })
  }

