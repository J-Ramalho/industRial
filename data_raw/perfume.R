## code to prepare `pet_delivery` dataset goes here

pet_delivery <- readxl::read_xlsx("data_raw/perfume.xlsx")

usethis::use_data(perfume, overwrite = TRUE)
