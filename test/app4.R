if(interactive()) {
  library(shiny)
  library(leaflet)
  
  location = c(46.52433, 10.12633)
  
  ui <- fluidPage(leafletOutput("map", height = "100vh"))
  
  server <- function(input, output, session) {
    
    output$map = renderLeaflet({
      leaflet() %>% addTiles() %>%
        setView(lat = location[1],
                lng = location[2],
                zoom = 10) %>%
        addMarkers(lat = location[1],
                   lng = location[2],
                   popup = "Test")
    })
  }
  
  shinyApp(ui, server)
}



