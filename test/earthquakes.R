library(shiny)
library(leaflet)

ui <- fluidPage(
  leafletOutput('map'),
  
  # Add custom CSS & Javascript;
  tags$style(type = "text/css", 'label[for="range"] {color: white;}')
  
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(quakes) %>% 
      addTiles() %>% 
      addMarkers() %>% 
      addLayersControl(
        baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
        overlayGroups = c("Quakes", "Outline"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
}

shinyApp(ui, server)
