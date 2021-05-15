library(tidyverse)
library(industRial)
library(DT)
library(stats)
library(broom)
filter <- dplyr::filter
select <- dplyr::select

ui <- fluidPage(
    titlePanel("The anova sandbox"),
    sidebarLayout(
        sidebarPanel(width = 4,
            sliderInput(inputId = "mean1", "Group 1 target mean:", min = 500000, max = 700000, value = 540000),
            sliderInput(inputId = "mean2", "Group 2 target mean:", min = 500000, max = 700000, value = 575000),
            sliderInput(inputId = "mean3", "Group 3 target mean:", min = 500000, max = 700000, value = 625000),
            sliderInput(inputId = "mean4", "Group 4 target mean:", min = 500000, max = 700000, value = 700000),
            sliderInput(inputId = "sd1", "Group 1 sd:", min = 10000, max = 50000, value = 50000, step = 1000),
            sliderInput(inputId = "sd2", "Group 2 sd:", min = 10000, max = 50000, value = 30000, step = 1000),
            sliderInput(inputId = "sd3", "Group 3 sd:", min = 10000, max = 50000, value = 40000, step = 1000),
            sliderInput(inputId = "sd4", "Group 4 sd:", min = 10000, max = 50000, value = 15000, step = 1000),
            sliderInput(inputId = "n", "Group sample size n:", min = 100, max = 10000, value = 100),
        ),
        mainPanel(width = 8,
           plotOutput("boxplot"),
           DTOutput("analysis")
        )
    )
)

server <- function(input, output) {

    measurements <- reactive({
        tibble(
            group1 = rnorm(mean = input$mean1, sd = input$sd1, n = input$n),
            group2 = rnorm(mean = input$mean2, sd = input$sd2, n = input$n),
            group3 = rnorm(mean = input$mean3, sd = input$sd3, n = input$n),
            group4 = rnorm(mean = input$mean4, sd = input$sd4, n = input$n)) %>% 
        pivot_longer(
            cols = everything(), 
            names_to = "group",
            values_to = "value") %>%
            group_by(group) %>%
            mutate(group_mean = mean(value))
    })
        
    output$boxplot <- renderPlot({

        ggplot(measurements()) +
            # geom_point(aes(x = group, y = group_mean), color = "red", size = 4) +
            geom_boxplot(aes(x = group, y = value, fill = group)) +
            labs(
                title = "Measurements plot",
                subtile = "",
                x = "",
                y = "Value"
            ) +
            geom_hline(yintercept = 540000, color = "red") +
            scale_fill_viridis_d(option = "D", begin = 0.5) +
            scale_y_continuous(n.breaks = 10) +
            # coord_cartesian(ylim = c(500000, 600000)) +
            labs(title = "e-bike frame hardening process",
                 subtitle = "Raw data plot",
                 x = "Furnace Temperature [°C]",
                 y = "Cycles to failure [n]") +
            theme_industRial()
    })
    
    analysis <- reactive({
        aov(value ~ group, measurements()) %>% tidy()
    })
        
    output$analysis <- renderDT({
        analysis() %>%
            datatable() %>%
            formatRound(3:4, 1) %>%
            formatRound(5:6, 2)
    }) 
}

shinyApp(ui = ui, server = server)
