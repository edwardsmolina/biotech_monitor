# Install required packages if not already installed
# install.packages(c("shiny", "dplyr", "ggplot2"))

# Load required libraries
library(shiny)
library(dplyr)
library(ggplot2)

# Sample data frame
data <- iris

# Define UI
ui <- fluidPage(
  titlePanel("Shiny App with Tabs and Filter for Iris Dataset"),
  sidebarLayout(
    sidebarPanel(
      selectInput("species_filter", "Filter by Species:",
                  choices = unique(data$Species), selected = unique(data$Species)[1])
    ),
    mainPanel(
      tabsetPanel(
        lapply(names(data[, -5]), function(var) {
          tabPanel(var,
                   plotOutput(paste0("histogram_", var))
          )
        })
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Render histogram for filtered species for each variable
  lapply(names(data[, -5]), function(var) {
    output[[paste0("histogram_", var)]] <- renderPlot({
      filtered_data <- data %>%
        filter(Species == input$species_filter)
      
      ggplot(filtered_data, aes_string(x = var, fill = "Species")) +
        geom_histogram(binwidth = 0.2, position = "identity", alpha = 0.7) +
        labs(title = paste("Histogram of", var, "(Filtered by", input$species_filter, ")"),
             x = var, y = "Frequency") +
        theme_minimal()
    })
  })
}

# Run the Shiny app
shinyApp(ui, server)


