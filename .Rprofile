message("Hi João this is the .Rprofile in /home/Documents/data_science/industRial/")

# Rstudio package manager adress:
options(repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/latest"))
message("The RStudio Package Manager Repository has been configured specifically for this Rproject folder:")
options('repos')

# Load packages
pkgs <- c(
  "tidyverse",
  "scales",
  "janitor",
  "knitr",
  "stats",
  "industRial",
  "viridis"
)
purrr::map(pkgs, library, character.only = TRUE)

filter <- dplyr::filter
select <- dplyr::select

options(
  digits = 3,
  width = 69,
  tibble.width = 69
)
