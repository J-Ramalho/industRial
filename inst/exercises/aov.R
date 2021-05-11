library(tidyverse)
library(industRial)
library(DT)
library(stats)
library(broom)
filter <- dplyr::filter
select <- dplyr::select
# ready for push into epfl for prototype review

ui <- fluidPage(
    titlePanel("The anova sandbox"),
    sidebarLayout(
        sidebarPanel(width = 4,
            sliderInput(inputId = "mean1", "Group 1 target mean:", min = -5, max = 5, value = 0),
            sliderInput(inputId = "mean2", "Group 2 target mean:", min = -5, max = 5, value = 0),
            sliderInput(inputId = "mean3", "Group 3 targat mean:", min = -5, max = 5, value = 0),
            sliderInput(inputId = "sd1", "Group 1 sd:", min = 1, max = 20, value = 10),
            sliderInput(inputId = "sd2", "Group 2 sd:", min = 1, max = 20, value = 10),
            sliderInput(inputId = "sd3", "Group 3 sd:", min = 1, max = 20, value = 10),
            sliderInput(inputId = "n", "Group sample size n:", min = 100, max = 100, value = 50),
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
            group3 = rnorm(mean = input$mean3, sd = input$sd3, n = input$n)) %>% 
        pivot_longer(
            cols = everything(), 
            names_to = "group",
            values_to = "value") %>%
            group_by(group) %>%
            mutate(group_mean = mean(value))
    })
        
    output$boxplot <- renderPlot({

        ggplot(measurements()) +
            geom_point(aes(x = group, y = group_mean), color = "red", size = 4) +
            geom_jitter(aes(x = group, y = value), width = 0.1) +
            labs(
                title = "Measurements plot",
                subtile = "",
                x = "",
                y = "Value"
            ) +
            geom_hline(yintercept = 0, color = "blue") +
            scale_y_continuous(n.breaks = 20) +
            coord_cartesian(ylim = c(-30, 30)) +
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
