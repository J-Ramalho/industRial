library(stats)
library(rsm)
library(viridis)
library(DT)
library(broom)

ui <- fluidPage(
  titlePanel("Response surface app"),
  sidebarLayout(
    sidebarPanel(width = 3,

      radioButtons(
        inputId = "selected_variables",
        label = "Select the input variables",
        choices = c("A and B" = "ab", "A and C" = "ac", "B and C" = "bc"),
        selected = "ac"
      ),
      sliderInput("theta", "Theta", min = -75, max = -20, value = -40),
      sliderInput("phi", "Phi", min = 0, max = 50, value = 20),
      sliderInput("r", "R", min = 2, max = 5, value = 5)
    ),
    mainPanel(
      fluidRow(
        column(6, plotOutput("response_surface")),
        column(6, plotOutput("interaction_plot"))
      ),
      fluidRow(
        column(6),
        column(6, 
               tags$b("Linear model summary"),
               DTOutput("linear_model"))
      )
    )
  )
)

server <- function(input, output) {
  
  model_formula <- reactive({
    if (input$selected_variables == "ab") {
      model_formula = charging_time ~ A + B + A:B
    } else if (input$selected_variables == "ac") {
      model_formula = charging_time ~ A + C + A:C
    } else if (input$selected_variables == "bc") {
      model_formula = charging_time ~ B + C + B:C
    }
  }) 
  
  model_view <- reactive({
    if (input$selected_variables == "ab") {
      model_view = A ~ B
    } else if (input$selected_variables == "ac") {
      model_view = A ~ C
    } else if (input$selected_variables == "bc") {
      model_view = B ~ C
    }
  })
    
  
  interaction_factors <- reactive({
    if (input$selected_variables == "ab") {
        interaction_factors <- list()
        interaction_factors$x.factor <- battery_charging$B
        interaction_factors$trace.factor <- battery_charging$A
        interaction_factors$xlab <- "B"
        interaction_factors$trace.label <- "A"
    } else if (input$selected_variables == "ac") {
        interaction_factors <- list()
        interaction_factors$x.factor <- battery_charging$C
        interaction_factors$trace.factor <- battery_charging$A
        interaction_factors$xlab <- "C"
        interaction_factors$trace.label <- "A"
    } else if (input$selected_variables == "bc") {
        interaction_factors <- list()
        interaction_factors$x.factor <- battery_charging$C
        interaction_factors$trace.factor <- battery_charging$B
        interaction_factors$xlab <- "C"
        interaction_factors$trace.label <- "B"
    }
    interaction_factors
  })
  
  observe({
    print("int factors")
    print(class(interaction_factors))
    print(interaction_factors())
    })
  
  model <- reactive({
    battery_lm <- lm(
      formula = model_formula(),
      data = battery_charging
    )
  })
  
  output$response_surface <- renderPlot(
    persp(
      model(),
      model_view(),
      col = viridis(12)[8],
      contours = "col",
      bounds = list(A = c(-1,1), C = c(-1,1)),
      theta = input$theta, phi = input$phi, r = input$r,
      zlab = "Charging Time",
      main = "Response surface"
    )
  )
  
  output$interaction_plot <- renderPlot(
    interaction.plot(x.factor = interaction_factors()$x.factor,
                     trace.factor = interaction_factors()$trace.factor,
                     fun = mean,
                     response = battery_charging$charging_time,
                     legend = TRUE,
                     xlab =  {interaction_factors()$xlab},
                     trace.label = {interaction_factors()$trace.label},
                     ylab = "Charging Time",
                     lwd = 2,
                     main = "Interaction plot")
  )
  
  output$linear_model <- renderDT({
    model() %>%
      tidy() %>%
      datatable(
        options = list(dom = 't')
        ) %>%
      formatRound(columns = c(2:5), digits = 2)
  })
  
}

shinyApp(ui = ui, server = server)