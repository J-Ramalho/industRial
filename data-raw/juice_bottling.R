## code to prepare `juice_bottling` dataset goes here

juice_bottling <- readxl::read_excel("data-raw/juice_bottling.xlsx")

usethis::use_data(juice_bottling, overwrite = TRUE)
