## code to prepare `battery_charging` dataset goes here
battery_charging <- read_csv("data-raw/battery_charging.csv")
usethis::use_data(battery_charging, overwrite = TRUE)
