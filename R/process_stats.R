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
#' @importFrom rlang .data
process_stats <- function(data, part_spec_percent) {
  # establish weight specs and mean
  process_data <- data %>%
    dplyr::filter(!is.na(.data$weight_value), .data$weight_value >= 0) %>%
    dplyr::group_by(.data$weight_target_value) %>%
    dplyr::mutate(
      part_spec_percent = part_spec_percent,
      spec_min = .data$weight_target_value - .data$weight_target_value * part_spec_percent / 100,
      spec_max = .data$weight_target_value + .data$weight_target_value * part_spec_percent / 100,
      weight_mean = mean(.data$weight_value),
      weight_sd = stats::sd(.data$weight_value))
  # calculate out of specs, Cpk and Moving range
  process_data <- process_data %>%
    dplyr::mutate(
      weight_out_perc = industRial::off_spec(
        process_data$spec_max, process_data$spec_min, 
        process_data$weight_mean, process_data$weight_sd),
      Cpk = industRial::process_Cpk(
        process_data$spec_max, process_data$spec_min, 
        process_data$weight_mean, process_data$weight_sd),
      weight_MR = abs(.data$weight_value - dplyr::lag(.data$weight_value))
      )
  # calculate MR mean and max
  process_data <- process_data %>%
    dplyr::mutate(
      weight_MR_mean = mean(process_data$weight_MR, na.rm = TRUE)
      # to be modified by -1
    )
  # calculate control limits
  process_data <- process_data %>%
    dplyr::mutate(
      MR_max = 3.688 * process_data$weight_MR_mean)
  process_data <- process_data %>% 
    dplyr::mutate(
      R_out_limits = dplyr::if_else(
        condition = process_data$weight_MR > process_data$MR_max, process_data$weight_MR, NA_real_),
      I_LCL = round((process_data$weight_mean - 2.66 * process_data$weight_MR_mean), 2),
      I_UCL = round((process_data$weight_mean + 2.66 * process_data$weight_MR_mean), 2))
  process_data <- process_data %>%
    dplyr::mutate(
      weight_out_limits = dplyr::if_else(
        condition = (.data$weight_value > process_data$I_UCL | .data$weight_value < process_data$I_LCL), 
        .data$weight_value, false = NA_real_)
    )
}