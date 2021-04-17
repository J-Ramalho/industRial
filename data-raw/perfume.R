## code to prepare `perfume` dataset goes here

perfume <- readxl::read_xlsx("data-raw/perfume.xlsx")

usethis::use_data(perfume, overwrite = TRUE)
