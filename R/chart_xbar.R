#' Create xbar chart for statistical process control
#'
#' @description
#' Generate an means chart from a set of consecutive measurements by calculating
#' their mean on each time point.
#' 
#' @details
#' This type of chart is typically applied in product manufacturing to monitor
#' deviations from the target value over time. It is usually accompanied by 
#' the \code{\link{chart_xbarR}}
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
chart_xbar <- function(data, factory) {
  # adding summary statistics
  data_stats <- data %>%
    dplyr::rowwise() %>%
    dplyr::mutate(xbar = mean(c(m1, m2, m3, m4, m5))) %>%
    dplyr::mutate(range = max(c(m1, m2, m3, m4, m5)) - min(c(m1, m2, m3, m4, m5)))
  
  nr_timepoints <- data_stats %>% nrow()
  xbar_mean <- data_stats %>% dplyr::pull(xbar) %>% mean() %>% round(1)
  R_mean <- data_stats %>% pull(range) %>% mean() %>% round(1)
  # Calculating R chart limits
  A2 <- 0.5768
  xbar_LCL <- round((xbar_mean - A2 * R_mean), 2)
  xbar_UCL <- round((xbar_mean + A2 * R_mean), 2)
  # Preparing labels for the plot limits
  xbar_labels <- tibble(
    x_position = min(data_stats$timepoint),
    y_position = c(xbar_UCL + 0.2, xbar_LCL - 0.2),
    label_value = c(glue("UCL = {xbar_UCL}"), glue("LCL = {xbar_LCL}"))
  )
  # Detecting rule 2 - 10 consecutive points on 1 side of the mean
  all_gte_ref_value <- function(x) all(x >= xbar_mean)
  consec_10_values_high <- slide_lgl(.x = data_stats$xbar,
                                     .f = all_gte_ref_value,
                                     .before = 9,
                                     .complete = TRUE)
  data_stats <- data_stats %>%
    as_tibble() %>%
    mutate(consec_10_values_high = consec_10_values_high)
  
  all_low_ref_value <- function(x) all(x <= xbar_mean)
  consec_10_values_low <- slide_lgl(.x = data_stats$xbar,
                                    .f = all_low_ref_value,
                                    .before = 9,
                                    .complete = TRUE)
  data_stats <- data_stats %>%
    as_tibble() %>%
    mutate(consec_10_values_low = consec_10_values_low)
  # Creating additional dataset with points to highlight
  xbar_red <- data_stats %>%
    # Highlighting rule 1 - 1 point above the UCL or 1 point below the LCL
    mutate(xbar_color = case_when(
      xbar > xbar_UCL | xbar < xbar_LCL ~ "red",
      # Highlighting rule 2 - 10 consecutive points on 1 side of the mean
      consec_10_values_low == TRUE ~"red",
      consec_10_values_high == TRUE ~"red",
      TRUE ~ "black"
    )) %>%
    filter(xbar_color == "red") %>%
    select(timepoint, xbar, xbar_color)
  
  data_stats %>%
    ggplot(aes(x = timepoint, y = xbar)) +
    geom_line() +
    geom_point() +
    geom_hline(aes(yintercept = xbar_LCL), color = "red") +
    geom_hline(aes(yintercept = xbar_UCL), color = "red") +
    geom_hline(aes(yintercept = xbar_mean), color = "black", linetype = "dashed") +
    geom_point(data = xbar_red, aes(x = timepoint, y = xbar, color = xbar_color)) +
    scale_color_identity() +
    geom_text(data = xbar_labels, mapping = aes(x=x_position, y=y_position, label=label_value),
              color = "#FF0000", hjust = 0) +
    scale_y_continuous(breaks = seq(round(xbar_LCL, 0), round(xbar_UCL,0), 0.5)) +
    theme_light() +
    labs(title = "Weight",
         subtitle = glue("xbar chart, factory {factory}"),
         caption = "data source: pilot line",
         y = "Mean",
         x = "Timepoint") +
    theme(plot.caption = element_text(vjust = 1))
}