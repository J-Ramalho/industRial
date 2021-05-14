#' Create a capability chart for statistical process control
#' 
#' @description
#' Generate a histogram type chart from a set of consecutive measurements.
#' 
#' @details
#' This type of chart is typically applied in product manufacturing to monitor
#' deviations from the target value over time. It is usually accompanied by 
#' the statistical process control time series \code{\link{chart_I}} and 
#' \code{\link{chart_IMR}}
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
#' 
#' 
chart_Cpk <- function(data) {
  data %>%
    ggplot2::ggplot() +
    ggplot2::geom_histogram(
      ggplot2::aes(x = weight_value, y = ..density..),
      fill = "grey80",
      color = "grey20") +
    ggplot2::geom_vline(ggplot2::aes(xintercept = spec_min), color = "red", linetype = 3) +
    ggplot2::geom_vline(ggplot2::aes(xintercept = spec_max), color = "red", linetype = 3) +
    ggplot2::geom_vline(ggplot2::aes(xintercept = weight_target_value), color = "red", linetype = 2) +
    ggplot2::geom_text(ggplot2::aes(x = (1.02 * spec_min), y = 10,
                                    label = stringr::str_glue("out: {weight_out_perc}%")),
                       color = "grey80", size = 4) +
    # ggplot2::scale_x_continuous(n.breaks = 20) +
    ggplot2::coord_cartesian(ylim = c(0, 20)) +
    ggplot2::theme_light() +
    ggplot2::labs(
      title = "Weight Capability",
      subtitle = "Out of spec (% expected)",
      x = "Pod Weight [g]",
      y = "Density [%]",
      caption = "data source: pilot Line"
    ) +
    theme_qcc()
}