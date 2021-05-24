message("Hi João this is the .Rprofile in /home/Documents/data_science/industRial/")

# Rstudio package manager adress:
options(repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/latest"))
message("The RStudio Package Manager Repository has been configured specifically for this Rproject folder:")
options('repos')

# Load data science packages:
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

# general options:
options(
  digits = 3,
  width = 69,
  tibble.width = 69
)
