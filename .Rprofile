
# Load packages:
ds_pkgs <- c(
  "tidyverse",
  "scales",
  "janitor",
  "knitr",
  "stats",
  "industRial",
  "viridis",
  "broom",
  "patchwork",
  "usethis",
  "devtools"
)
purrr::map(ds_pkgs, library, character.only = TRUE)
filter <- dplyr::filter
select <- dplyr::select

# load development packages:
dev_pkgs <- c(
  "devtools",
  "fs"
)
purrr::map(dev_pkgs, library, character.only = TRUE)

message("Hello, this R project has a startup file .Rprofile in its working folder: ")
getwd()

# Rstudio package manager address:
options(repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/latest"))
message("The RStudio Package Manager Repository has been configured specifically for this Rproject folder:")
getOption('repos')

# General options
options(
  digits = 5,
  width = 69,
  tibble.width = 69
)
message("Digits set to: ")
getOption("digits")
