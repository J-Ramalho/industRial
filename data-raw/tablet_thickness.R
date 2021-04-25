## code to prepare `tablet_thickness` dataset goes here
tablet_thickness <- readxl::read_excel("data-raw/tablet_thickness.xlsx")

usethis::use_data(tablet_thickness, overwrite = TRUE)
