library(shiny)
library(industRial)
library(qicharts2)
ui <- fluidPage(
  titlePanel("Dial control pareto charts"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "variable",
        label = "Select variable",
        choices = c("Defect", "Location"),
        selected = "Defect",
        multiple = FALSE
      )
    ),
    mainPanel(
      plotOutput("pareto")
    )
  )
)
server <- function(input, output) {
  
  output$pareto <- renderPlot({
    d_type <- dial_control %>% pull(.data[[input$variable]]) %>% as.character()
    paretochart(
      d_type, 
      title = "Watch Dial polishing",
      subtitle = "Pareto chart", 
      ylab = "Percentage of deffects",
      xlab = "Deffect type",
      caption = "Source: Dial Production Team"
    )
  })
}
shinyApp(ui = ui, server = server)