## code to prepare `battery_charging` dataset goes here
battery_charging <- read_excel("data-raw/battery_charging.xlsx")
usethis::use_data(battery_charging, overwrite = TRUE)
