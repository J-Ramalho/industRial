#' Calculate summary statistics for Statistical Process Control
#' 
#' @description
#' This function takes process variables and calculates summary statistics and 
#' presents them in a easy readable table format.
#'
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#
#' @param data
#' This function takes the dataset tablet_thickness cleaned with the clean_names function from 
#' the {janitor} package 
#' @param part_spec_percent the process tolerance in percentage.
#'
#' @return
#' This function returns an object with class tibble (tbl_df)
#' @export
#'
#' @examples
process_stats <- function(data, part_spec_percent) {
  data %>%
    dplyr::filter(!is.na(weight_value), weight_value >= 0) %>%
    dplyr::group_by(weight_target_value) %>%
    dplyr::mutate(
      part_spec_percent = part_spec_percent,
      spec_min = weight_target_value - weight_target_value * part_spec_percent / 100,
      spec_max = weight_target_value + weight_target_value * part_spec_percent / 100,
      weight_mean = mean(weight_value),
      weight_sd = stats::sd(weight_value),
      weight_out_perc = off_spec(spec_max, spec_min, weight_mean, weight_sd),
      Cpk = process_Cpk(spec_max, spec_min, weight_mean, weight_sd),
      weight_MR = abs(weight_value - dplyr::lag(weight_value)),
      weight_MR_mean = mean(weight_MR, na.rm = TRUE),
      # to be modified by -1
      MR_max = 3.688 * weight_MR_mean,
      R_out_limits = dplyr::if_else(condition = weight_MR > MR_max, weight_MR, NA_real_),
      I_LCL = round((weight_mean - 2.66 * weight_MR_mean), 2),
      I_UCL = round((weight_mean + 2.66 * weight_MR_mean), 2),
      weight_out_limits = dplyr::if_else(
        condition = (weight_value > I_UCL | weight_value < I_LCL), 
        weight_value, false = NA_real_)
    )
}