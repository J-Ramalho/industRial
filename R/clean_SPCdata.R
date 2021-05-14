#' Clean control data for Statistical Process Control Charts (SPC)
#' 
#' @description
#' This function takes a dataset consisting of consecutive measurements and
#' cleans it so that it can be used in SPC charts. 
#'
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#
#' @param data 
#'
#' @return
#' @export
#'
#' @examples
#' 
clean_SPCdata <- function(data) {
  data_zeros <- data %>%
    mutate(
      m1zero = if_else(m1 == 0, 1, 0),
      m2zero = if_else(m2 == 0, 1, 0),
      m3zero = if_else(m3 == 0, 1, 0),
      m4zero = if_else(m4 == 0, 1, 0),
      m5zero = if_else(m5 == 0, 1, 0)
    ) %>%
    mutate(nr_zeros = m1zero + m2zero + m3zero + m4zero + m5zero)
  
  zero_replaced <- data_zeros %>% pull(nr_zeros) %>% sum()
  zero_discarded <- data_zeros %>% filter(nr_zeros >= 2) %>% nrow()
  
  data_zeros_clean <- data_zeros %>%
    filter(nr_zeros < 2) %>%
    mutate(
      m1 = if_else(m1 == 0, round((m2 + m3 + m4 + m5)/4, 1), m1),
      m2 = if_else(m2 == 0, round((m1 + m3 + m4 + m5)/4, 1), m2),
      m3 = if_else(m3 == 0, round((m1 + m2 + m4 + m5)/4, 1), m3),
      m4 = if_else(m4 == 0, round((m1 + m2 + m3 + m5)/4, 1), m4),
      m5 = if_else(m5 == 0, round((m1 + m2 + m3 + m4)/4, 1), m5)) %>%
    select(-c(m1zero, m2zero, m3zero, m4zero, m5zero, nr_zeros))
  
  data_unexpected <- data_zeros_clean %>%
    mutate(
      m1un = if_else(m1 < 15 | m1 > 65, 1, 0),
      m2un = if_else(m2 < 15 | m2 > 65, 1, 0),
      m3un = if_else(m3 < 15 | m3 > 65, 1, 0),
      m4un = if_else(m4 < 15 | m4 > 65, 1, 0),
      m5un = if_else(m5 < 15 | m5 > 65, 1, 0),
      nr_unexpected = m1un + m2un + m3un + m4un + m5un)
  
  unexpected_replaced <- data_unexpected %>% pull(nr_unexpected) %>% sum()
  unexpected_discarded <- data_unexpected %>% filter(nr_unexpected >= 2) %>% nrow()
  
  data_unexpected_clean <- data_unexpected %>%
    filter(nr_unexpected < 2) %>%
    mutate(
      m1 = if_else(m1 < 15 | m1 > 65, round((m2 + m3 + m4 + m5)/4, 1), m1),
      m2 = if_else(m2 < 15 | m2 > 65, round((m1 + m3 + m4 + m5)/4, 1), m2),
      m3 = if_else(m3 < 15 | m3 > 65, round((m1 + m2 + m4 + m5)/4, 1), m3),
      m4 = if_else(m4 < 15 | m4 > 65, round((m1 + m2 + m3 + m5)/4, 1), m4),
      m5 = if_else(m5 < 15 | m5 > 65, round((m1 + m2 + m3 + m5)/4, 1), m5)
    ) %>%
    select(-c(m1un, m2un, m3un, m4un, m5un, nr_unexpected))
  
  cleaning_summary <- data.frame(
    zeros_replaced = zero_replaced,
    zeros_discarded = zero_discarded,
    unexpected_replaced = unexpected_replaced,
    unexpected_discarded = unexpected_discarded
  )
  
  output <- list()
  output$cleaning_summary <- cleaning_summary
  output$data <- data_unexpected_clean
  
  output
}