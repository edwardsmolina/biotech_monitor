library(shiny)
library(tidyverse)

ui <- fluidPage(
  plotOutput("myplotout"),
  downloadLink("downloadData", "Download Plot")
)

server <- function(input, output) {
  # Our dataset
  
  
  myplot <- reactive({
    ggplot(data=iris,
           mapping = aes(x=Petal.Width,y=Sepal.Width,colour=Species)) + geom_point()
  })
  output$myplotout <- renderPlot({
    myplot()
  })
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("myplot", Sys.Date(), ".png", sep="")
    },
    content = function(file) {
      png(file=file)
      plot(myplot())
      dev.off()
    }
  )
}

shinyApp(ui, server)