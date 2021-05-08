## code to prepare `solarcell_fill` dataset goes here
solarcell_fill <- read_excel("data-raw/solarcell_fill.xlsx")
usethis::use_data(solarcell_fill, overwrite = TRUE)
