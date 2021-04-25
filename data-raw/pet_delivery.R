## code to prepare `pet_delivery` dataset goes here

pet_delivery <- read.csv("data-raw/pet_delivery.csv")

usethis::use_data(pet_delivery, overwrite = TRUE)
