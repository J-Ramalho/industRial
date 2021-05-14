#' Create IMR chart for statistical process control
#' 
#' @description
#' Generate a single point time series chart from a set of consecutive measurements.
#' 
#' @details
#' This type of chart is typically applied in product manufacturing to monitor
#' deviations from the target value over time. It is usually accompanied by 
#' the \code{\link{chart_RMR}}
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#'
#' @param data 
#' @param factory 
#'
#' @return
#' @export
#'
#' @examples
chart_IMR <- function(data, factory){
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
  M <- mean(data_wkly$xbar_wk_mean)
  MR_bar <- mean(data_wkly$MR, na.rm = TRUE)
  I_LCL <- round((M - 2.66 * MR_bar), 1)
  I_UCL <- round((M + 2.66 * MR_bar), 1)
  # Preparing labels for the plot limits
  I_MR_labels <- tibble(
    x_position = min(data_wkly$week),
    y_position = c(I_UCL + 0.2, I_LCL - 0.2),
    label_value = c(glue("UCL = {I_UCL}"), glue("LCL = {I_LCL}"))
  )
  # Plotting
  data_wkly %>%
    ggplot(aes(x = week, y = xbar_wk_mean)) +
    geom_line() +
    geom_point() +
    geom_hline(aes(yintercept = I_LCL), color = "red") +
    geom_hline(aes(yintercept = I_UCL), color = "red") +
    geom_hline(aes(yintercept = M), color = "black", linetype = "dashed") +
    # geom_point(data = xbar_red, aes(x = timepoint, y = xbar, color = xbar_color)) +
    scale_color_identity() +
    geom_text(data = I_MR_labels, mapping = aes(x=x_position, y=y_position, label=label_value),
              color = "#FF0000", hjust = 0) +
    scale_y_continuous(breaks = seq(round(I_LCL, 0), round(I_UCL,0), 0.5)) +
    theme_light() +
    labs(title = "Milk fat in dry matter (MF/DM)",
         subtitle = glue("xbar chart, Gruyère factory {factory}"),
         caption = "data source: Dr Heidi Lamucca, QA",
         y = "Mean",
         x = "Timepoint") +
    theme(plot.caption = element_text(vjust = 1))
}