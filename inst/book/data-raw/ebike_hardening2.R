## code to prepare `ebike_hardening2` dataset goes here
ebike_hardening2 <- readr::read_csv("data-raw/ebike_hardening2.csv")
usethis::use_data(ebike_hardening2, overwrite = TRUE)
