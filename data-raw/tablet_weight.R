## code to prepare `tablet_weight` dataset goes here
tablet_weight <- read_csv("data-raw/tablet_weight.csv")
usethis::use_data(tablet_weight, overwrite = TRUE)
