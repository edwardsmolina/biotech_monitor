library(leaflet)

# Choices for drop-downs
vars <- c(
  "Daño vegetativo" = "spod_veg",
  "Daño en mazorca" = "spod_rep")
  
bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "Season", 
                            min(dat$FIELD_plantingSeason), 
                            max(dat$FIELD_plantingSeason),
                            value = range(dat$FIELD_plantingSeason), 
                            step = 1),
                
                selectInput("trait", "Trait", vars),
                
                selectInput("biotech", "Biotech", unique(dat$createdTechnology))
  )
)
