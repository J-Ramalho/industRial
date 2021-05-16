library(tidyverse)
library(industRial)
library(stats)
library(broom)
filter <- dplyr::filter
select <- dplyr::select

input <- list()
input$mean1 <- 550000
input$mean2 <- 550000
input$mean3 <- 550000
input$mean4 <- 550000
input$sd1 <- 10
input$sd2 <- 10
input$sd3 <- 10
input$sd4 <- 10
input$n <- 100

measurements <- tibble(
  T160 = rnorm(mean = input$mean1, sd = input$sd1, n = input$n),
  T180 = rnorm(mean = input$mean2, sd = input$sd2, n = input$n),
  T200 = rnorm(mean = input$mean3, sd = input$sd3, n = input$n),
  T220 = rnorm(mean = input$mean3, sd = input$sd3, n = input$n)) %>% 
  pivot_longer(
    cols = everything(), 
    names_to = "group",
    values_to = "value") %>%
  group_by(group) %>%
  mutate(group_mean = mean(value))

analysis <- aov(value ~ group, measurements)
# group_pvalue <- analysis %>% tidy() %>% filter(term == "group") %>% pull(p.value)
analysis_out <- tidy(analysis)
analysis_out

if (analysis_out$p.value >= 0.05) {
  ggplot(measurements) +
    geom_point(aes(x = group, y = group_mean), color = "red", size = 4) +
    geom_boxplot(aes(x = group, y = value, fill= group)) +
    scale_fill_viridis_d(option = "D", begin = 0.5, guide = FALSE) +
    scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
    labs(
      title = "Measurement Boxplot",
      subtile = "",
      x = "",
      y = "Value"
    ) +
    theme_industRial()
  } else {
    ggplot(measurements) +
      geom_point(aes(x = group, y = group_mean), color = "red", size = 4) +
      geom_boxplot(aes(x = group, y = value, fill= group)) +
      scale_fill_viridis_d(option = "A", begin = 0.5, guide = FALSE) +
      scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
      labs(
        title = "Measurement Boxplot",
        subtile = "",
        x = "",
        y = "Value"
      ) +
      theme_industRial()
}




