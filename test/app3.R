# Install required packages if not already installed
# install.packages(c("shiny", "dplyr", "ggplot2"))

# Load required libraries
library(shiny)
library(dplyr)
library(ggplot2)

# Sample data frame
data <- mtcars

# Define UI
ui <- fluidPage(
  titlePanel("Shiny App with Radio Buttons to Filter Data"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("variable_filter", "Filter by Variable:",
                   choices = names(data), selected = names(data)[1])
    ),
    mainPanel(
      plotOutput("scatter_plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Render scatter plot for filtered variable
  output$scatter_plot <- renderPlot({
    ggplot(data, aes(x = mpg, y = wt, color = data[, input$variable_filter])) +
      geom_point() +
      labs(title = paste("Scatter Plot of MPG and Weight (Filtered by", input$variable_filter, ")"),
           x = "MPG", y = "Weight")
  })
}

# Run the Shiny app
shinyApp(ui, server)
