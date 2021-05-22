library(tidyverse)
library(stats)
library(gt)
source("theme_qcc.R")
filter <- dplyr::filter
select <- dplyr::select

ui <- fluidPage(
  titlePanel("Process Capability Study"),

    fluidPage(
      column(
        6,
        plotOutput("capability_chart"),
        numericInput(
          width = 100,
          "spec_perc",
          "Specification tolerance [%]",
          min = 1,
          max = 16,
          value = 9,
          step = 1
        ),
      ), 
      column(6, gt_output("statistics_table")
      )
    )

)

server <- function(input, output) {
  
  tablet_weight <- tablet_weight %>%
    janitor::clean_names(case = "snake")
  
  weight_statistics_data <- reactive({
    process_stats(
      data = tablet_weight, 
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

    process_stats_table(weight_statistics_data())

  })
  
  
}
  
shinyApp(ui = ui, server = server)








