## code to prepare `perfume` dataset goes here
perfume_experiment <- readxl::read_xlsx("data-raw/perfume_experiment.xlsx")

usethis::use_data(perfume_experiment, overwrite = TRUE)
