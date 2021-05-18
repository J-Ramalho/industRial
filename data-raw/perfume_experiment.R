## code to prepare `perfume` dataset goes here
perfume_experiment <- readr::read_csv("data-raw/perfume_experiment.csv")

usethis::use_data(perfume_experiment, overwrite = TRUE)
