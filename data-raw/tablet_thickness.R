## code to prepare `tablet_thickness` dataset goes here
tablet_thickness <- readr::read_csv("data-raw/tablet_thickness.csv")

usethis::use_data(tablet_thickness, overwrite = TRUE)
