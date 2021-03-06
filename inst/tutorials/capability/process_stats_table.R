#' Summary statistics table outputs for Statistical Process Control
#' 
#' @description
#' This function takes summary statistics and presents them in a easy readable 
#' table format.
#'
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#
#' @param data 
#' A data set generated by the function \code{\link{process_stats}}
#'
#' @return
#' This function returns an object with classes gt_tbl and list
#' @export
#'
#' @examples
process_stats_table <- function(data) {
  data %>%
    dplyr::group_by(weight_target_value) %>%
    dplyr::summarise(
      weight_mean = mean(weight_value) %>% round(2),
      spec_min = mean(spec_min) %>% round(2),
      spec_max = mean(spec_max) %>% round(2),
      weight_out_perc = mean(weight_out_perc) %>% round(2),
      capability_index = mean(Cpk),
      part_count = dplyr::n()
    ) %>%
    dplyr::select(
      weight_mean, weight_target_value, spec_min, spec_max, weight_out_perc, 
      capability_index, part_count) %>%
    tidyr::pivot_longer(cols = everything(),
                        names_to = "variable",
                        values_to = "Value") %>%
    dplyr::mutate(Variable = case_when(
      variable == "weight_mean" ~ "Weight mean",
      variable == "weight_target_value" ~ "Spec target",
      variable == "spec_min" ~ "Spec min",
      variable == "spec_max" ~ "Spec max",
      variable == "weight_out_perc" ~ "Out of spec",
      variable == "capability_index" ~ "Cpk",
      variable == "part_count" ~ "Sample size",
      TRUE ~ variable
    )) %>%
    dplyr::mutate(Unit = case_when(
      variable == "weight_mean" ~ "g",
      variable == "weight_target_value" ~ "g",
      variable == "spec_min" ~ "g",
      variable == "spec_max" ~ "g",
      variable == "weight_out_perc" ~ "%",
      variable == "capability_index" ~ "",
      variable == "part_count" ~ "parts",
      TRUE ~ variable
    )) %>%
    dplyr::select(Variable, Value, Unit) %>%
    gt::gt() %>%
    gt::tab_style(style = list(gt::cell_text(weight = "bold")), 
              locations = gt::cells_body(rows = c(5, 6))) %>%
    gt::fmt_number(columns = 2, rows = Variable == "Sample size", decimals = 0) %>%
    gt::tab_header(title = "Process Summary Statistics")
}