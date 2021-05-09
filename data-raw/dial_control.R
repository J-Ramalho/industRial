## code to prepare `dial_control` dataset goes here
dial_control <- readr::read_csv("data-raw/dial_control.csv")

usethis::use_data(dial_control, overwrite = TRUE)


