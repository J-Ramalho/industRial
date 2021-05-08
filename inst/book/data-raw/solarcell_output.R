## code to prepare `solarcell_output` dataset goes here
solarcell_output <- readr::read_csv("data-raw/solarcell_output.csv")
usethis::use_data(solarcell_output, overwrite = TRUE)
