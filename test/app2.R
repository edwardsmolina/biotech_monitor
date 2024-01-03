# Install required packages if not already installed
# install.packages(c("shiny", "leaflet"))

# Load required libraries
library(shiny)
library(leaflet)

# Define the UI
ui <- fluidPage(
  titlePanel("Shiny App to Plot Points on a Map"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File",
                accept = c(".csv")
      )
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
)

# Define the server
server <- function(input, output) {
  
  # Read data from the uploaded CSV file
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  # Create leaflet map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(data = data(),
                 lat = ~X,
                 lng = ~Y,
                 popup = ~paste("ID: ", ID))
  })
}

# Run the Shiny app
shinyApp(ui, server)