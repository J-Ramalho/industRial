library(tidyverse)
library(industRial)
library(stats)
library(broom)
library(ggridges)
filter <- dplyr::filter
select <- dplyr::select

input <- list()
input$mean1 <- 10
input$mean2 <- 10.1
input$mean3 <- 10.2
input$sd1 <- 4
input$sd2 <- 4
input$sd3 <- 4
input$n1 <- 10000
input$n2 <- 10000
input$n3 <- 10000

measurements <- tibble(
  group1 = rnorm(mean = input$mean1, sd = input$sd1, n = input$n1),
  group2 = rnorm(mean = input$mean2, sd = input$sd2, n = input$n2),
  group3 = rnorm(mean = input$mean3, sd = input$sd3, n = input$n3)) %>% 
  pivot_longer(
    cols = everything(), 
    names_to = "group",
    values_to = "value")

analysis <- aov(value ~ group, measurements)
# group_pvalue <- analysis %>% tidy() %>% filter(term == "group") %>% pull(p.value)
analysis_out <- tidy(analysis)
analysis_out

ggplot() +
  geom_boxplot(data = measurements, aes(x = group, y = value)) +
  labs(
    title = "Measurement Boxplot",
    subtile = "",
    x = "",
    y = "Value"
  ) +
  theme_industRial()
# 
# ggplot(data = measurements, aes(y = value)) +
#   geom_ridgeline(stat = "identity") +
#   # facet_wrap(vars(group))
#   labs(
#     title = "Measurement Boxplot",
#     subtile = "",
#     x = "",
#     y = "Value"
#   ) +
#   theme_industRial()



