## code to prepare `juice_drymatter` dataset goes here
juice_drymatter <- read_excel("data-raw/juice_drymatter.xlsx") 
usethis::use_data(juice_drymatter, overwrite = TRUE)
