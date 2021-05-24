## code to prepare `juice_drymatter` dataset goes here
juice_drymatter <- readr::read_csv("data-raw/juice_drymatter.csv") 
usethis::use_data(juice_drymatter, overwrite = TRUE)
