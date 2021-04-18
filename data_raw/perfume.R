## code to prepare `perfume` dataset goes here

perfume_doe <- readxl::read_xlsx("data_raw/perfume_doe.xlsx")

usethis::use_data(perfume_doe, overwrite = TRUE)
