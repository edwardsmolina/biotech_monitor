library(tidyverse)
library(shiny)
library(glue)

myPlot <- function(data, x, y, ptsize, axsize) {
  
  p <- ggplot(data = data, aes(x = .data[[x]], y = .data[[y]])) +
    geom_point(size = ptsize) +
    theme(axis.title = element_text(size = axsize))
  
  return(p)
}

myText <- function(data, x, y, ptsize, axsize) {
  
  myString <- glue("ggplot(data = data, aes(x = {x}, y = {y})) +
    geom_point(size = {ptsize}) +
    theme(axis.title = element_text(size = {axsize}))")
  
  
  return(myString)
}



ui = fluidPage(
  titlePanel("Explore the Iris Data"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("species", label = "Choose Species",
                  choices = c(unique(as.character(iris$Species)), "All_species")),
      selectInput("trait1", label = "Choose Trait1",
                  choices = colnames(iris)[1:4]),
      selectInput("trait2", label = "Choose Trait2",
                  choices = colnames(iris)[1:4]),
      selectInput("theme_Choice", label = "Theme", 
                  choices = c("Default", "Classic", "Black/White")),
      sliderInput("pt_size",
                  label = "Point size", 
                  min = 0.5, max = 10,
                  value = .4),
      sliderInput("axis_sz",
                  label = "Axis title size", 
                  min = 8, max = 30,
                  value = 1)
    ),
    
    mainPanel(
      plotOutput("Species_plot"),
      verbatimTextOutput("code1"),
      verbatimTextOutput("code2")
    )
  )
  
)

server <- function(input,output) {
  
  data <- reactive(iris)
  
  output$Species_plot <- renderPlot({
    myPlot(data(), input$trait1, input$trait2, input$pt_size, input$axis_sz )
  })
  
  output$code1 <- renderPrint({
    myText(data(), input$trait1, input$trait2, input$pt_size, input$axis_sz )
  })
  
}

shinyApp(ui, server)
