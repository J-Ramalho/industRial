Rchart_wkly_plot <- function(data, factory){
  # adding summary statistics
  data_stats <- data %>%
    rowwise() %>%
    mutate(xbar = mean(c(m1, m2, m3, m4, m5))) %>%
    mutate(range = max(c(m1, m2, m3, m4, m5)) - min(c(m1, m2, m3, m4, m5)))
  
  nr_timepoints <- data_stats %>% nrow()
  xbar_mean <- data_stats %>% pull(xbar) %>% mean() %>% round(1)
  R_mean <- data_stats %>% pull(range) %>% mean() %>% round(1)
  
  # Aggregating data on a weekly basis
  data_wkly <- data_stats %>%
    group_by(week) %>%
    summarise(xbar_wk_mean = round(mean(xbar), 1)) %>%
    mutate(MR = abs(xbar_wk_mean - lag(xbar_wk_mean)))
  # Calculating R chart limits
  Max_MR <- max(data_wkly$MR, na.rm = TRUE)
  M <- mean(data_wkly$xbar_wk_mean)
  MR_bar <- mean(data_wkly$MR, na.rm = TRUE)
  D3 <- 0
  D4 <- 2.1145
  MR_LCL <- round((D3 * MR_bar), 1)
  MR_UCL <- round((D4 * MR_bar), 1)
  # Preparing labels for the plot limits
  R_labels <- tibble(
    x_position = min(data_stats$timepoint),
    y_position = c(MR_UCL + 0.1, MR_LCL - 0.1),
    label_value = c(glue("UCL = {MR_UCL}"), glue("LCL = {MR_LCL}"))
  )
  # Plotting
  data_wkly %>%
    ggplot(aes(x = week, y = MR)) +
    geom_line() +
    geom_point() +
    geom_hline(aes(yintercept = MR_LCL), color = "red") +
    geom_hline(aes(yintercept = MR_UCL), color = "red") +
    geom_hline(aes(yintercept = MR_bar), color = "black", linetype = "dashed") +
    # scale_y_continuous(breaks = seq(round(R_LCL, 0), round(R_UCL,0), 0.5)) +
    coord_cartesian(ylim = c(0, Max_MR)) +
    geom_text(data = R_labels, mapping = aes(x=x_position, y=y_position, label=label_value),
              color = "#FF0000", hjust = 0) +
    theme_light() +
    labs(title = "Milk fat in dry matter (MF/DM)",
         subtitle = glue("R chart, Gruyère factory {factory}"),
         caption = "data source: Dr Heidi Lamucca, QA",
         y = "Moving Range",
         x = "Timepoint") +
    theme(plot.caption = element_text(vjust = 1))
}