library(shiny)
library(leaflet)

pharmacy$my_store <- 0
My_Pharmacy$my_store <- 1

all_stores <- rbind(pharmacy, My_Pharmacy)

pal <- colorFactor(
  # Use a predefined palette:
  # palette = "Dark2",
  # 
  # Or specify individual colors:
  palette = c("purple", "orange"),
  domain = all_stores$my_store
)

ui <- fluidPage(
  titlePanel("map"),
  mainPanel(
    leafletOutput(outputId = "map_pharmacy"),
    selectInput(inputId = "State",
                label = "choose a store brand",
                choices = unique(all_stores$State))
  )
)

server <- function(input, output, session) {
  
  filteredData <- reactive({
    all_stores %>%
      filter(State == input$State)
  })
  
  output$map_pharmacy <- renderLeaflet({
    leaflet(filteredData()) %>% 
      addTiles() %>%
      fitBounds(~min(Long), ~min(Lat), ~max(Long), ~max(Lat))
  })
  
  observe({
    leafletProxy("map_pharmacy", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(color = ~pal(my_store),
                 lng = ~Long,
                 lat = ~Lat,
                 weight = 10)
  })
  
}

shinyApp(ui = ui, server = server)