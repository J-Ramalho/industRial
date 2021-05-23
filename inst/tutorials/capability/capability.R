library(tidyverse)
library(stats)
library(gt)
source("theme_qcc.R")
filter <- dplyr::filter
select <- dplyr::select

ui <- fluidPage(
  titlePanel("Process Capability Study"),

    fluidRow(
      column(6, plotOutput("capability_chart")), 
      column(6, gt_output("statistics_table")
      )
      ),
    fluidRow(
      # column(3),
      column(3,
        sliderInput(
          width = 150,
          "spec_perc",
          "Specification tolerance [%]",
          min = 1,
          max = 16,
          value = 9,
          step = 1
        )
      ),
      column(3,
        sliderInput(
          width = 150,
          "spec_deviation",
          "Specification deviation [g]",
          min = -0.1,
          max = +0.2,
          value = 0.0,
          step = 0.01
        )
      )
      )
)

server <- function(input, output) {
  
  tablet_weight_clean <- reactive({
    tablet_weight %>%
      janitor::clean_names(case = "snake") %>%
      mutate(weight_target_value = weight_target_value + input$spec_deviation)
  })
  
  weight_statistics_data <- reactive({
    process_stats(
      data = tablet_weight_clean(), 
      part_spec_percent = input$spec_perc
    )
  })
  
  weight_normal <- reactive({
    stats::rnorm(
    n = 100000,
    mean = mean(weight_statistics_data() %>% pull(weight_mean)),
    sd = mean(weight_statistics_data() %>% pull(weight_sd))
    ) %>%
    as_tibble()
  })

  observe({print(weight_normal())})
  
  output$capability_chart <- renderPlot({

    chart_Cpk(weight_statistics_data()) +
    ggplot2::geom_density(
      data = weight_normal(),
      ggplot2::aes(x = value), linetype = 2
    ) +
      expand_limits(x = c(0.7, 1.1)) 
  })
  
  output$statistics_table <- render_gt({

    process_stats_table(weight_statistics_data()) %>%
      gt::fmt_number(columns = 2, decimals = 2) %>%
      gt::fmt_number(columns = 2, rows = Variable == "Sample size", decimals = 0)

  })
  
  
}
  
shinyApp(ui = ui, server = server)








