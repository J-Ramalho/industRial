## code to prepare `data-raw/syringe_diameter.csv` dataset goes here
syringe_diameter <- readr::read_csv("data-raw/syringe_diameter.csv")

usethis::use_data(syringe_diameter, overwrite = TRUE)
