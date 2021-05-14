Rchart_plot <- function(data, factory){
  # adding summary statistics
  data_stats <- data %>%
    rowwise() %>%
    mutate(xbar = mean(c(m1, m2, m3, m4, m5))) %>%
    mutate(range = max(c(m1, m2, m3, m4, m5)) - min(c(m1, m2, m3, m4, m5)))
  
  nr_timepoints <- data_stats %>% nrow()
  xbar_mean <- data_stats %>% pull(xbar) %>% mean() %>% round(1)
  R_mean <- data_stats %>% pull(range) %>% mean() %>% round(1)
  # Calculating R chart limits
  D3 <- 0
  D4 <- 2.1145
  R_LCL <- round((D3 * R_mean), 1)
  R_UCL <- round((D4 * R_mean), 1)
  # Preparing labels for the plot limits
  R_labels <- tibble(
    x_position = min(data_stats$timepoint),
    y_position = c(R_UCL + 0.2, R_LCL - 0.2),
    label_value = c(glue("UCL = {R_UCL}"), glue("LCL = {R_LCL}"))
  )
  # Plotting
  data_stats %>%
    ggplot(aes(x = timepoint, y = range)) +
    geom_line() +
    geom_point() +
    geom_hline(aes(yintercept = R_LCL), color = "red") +
    geom_hline(aes(yintercept = R_UCL), color = "red") +
    geom_hline(aes(yintercept = R_mean), color = "black", linetype = "dashed") +
    scale_y_continuous(breaks = seq(round(R_LCL, 0), round(R_UCL,0), 0.5)) +
    geom_text(data = R_labels, mapping = aes(x=x_position, y=y_position, label=label_value),
              color = "#FF0000", hjust = 0) +
    theme_light() +
    labs(title = "Milk fat in dry matter (MF/DM)",
         subtitle = glue("R chart, Gruyère factory {factory}"),
         caption = "data source: Dr Heidi Lamucca, QA",
         y = "Range",
         x = "Timepoint") +
    theme(plot.caption = element_text(vjust = 1))
}