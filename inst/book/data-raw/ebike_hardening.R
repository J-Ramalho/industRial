## code to prepare `ebike_hardening` dataset goes here
ebike_hardening <- readr::read_csv("data-raw/ebike_hardening.csv")
usethis::use_data(ebike_hardening, overwrite = TRUE)
