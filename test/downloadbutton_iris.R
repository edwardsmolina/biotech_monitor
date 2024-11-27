library(shiny)
library(ggplot2)

myPlot <- function(data, x, y, ptsize, axsize) {
  
  p <- ggplot(data = data, aes(x = .data[[x]], y = .data[[y]])) +
    geom_point(size = ptsize) +
    theme_bw() + 
    theme(axis.title = element_text(size = axsize)) 
    
  
  return(p)
}

ui <- fluidPage(
  
  titlePanel("Explore the Iris Data"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("species", label = "Choose Species",
                  choices = c(unique(as.character(iris$Species)), "All_species")),
      selectInput("trait1", label = "Choose Trait1",
                  choices = colnames(iris)[1:4]),
      selectInput("trait2", label = "Choose Trait2",
                  choices = colnames(iris)[1:4]),
      sliderInput("pt_size",
                  label = "Point size", 
                  min = 0.1, max = 10,
                  value = .4),
      sliderInput("axis_sz",
                  label = "Axis title size", 
                  min =5, max = 30,
                  value = 15)
    ),
  mainPanel(
    plotOutput("myplotout"), 
    downloadButton("downloadData", "Download Plot")
)
)
)

server <- function(input, output) {
  
  myggplot <- reactive(iris)
  
  output$myplotout <- renderPlot({
    myPlot(iris, input$trait1, input$trait2, input$pt_size, input$axis_sz) 
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("myplot", Sys.Date(), ".png", sep="")
    },
    content = function(file) {
      png(file=file)
      plot(myggplot())
      dev.off()
    })
  # })
  
}

shinyApp(ui, server)