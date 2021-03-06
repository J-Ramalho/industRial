## code to prepare `dial_control` dataset goes here

dial_control <- read.csv("data-raw/dial_control.csv")
pet_delivery <- read.csv("data-raw/pet_delivery.csv")

usethis::use_data(dial_control, overwrite = TRUE)
usethis::use_data(pet_delivery, overwrite = TRUE)

