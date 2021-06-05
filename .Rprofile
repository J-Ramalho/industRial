
# package library
# jrlibpaths <- c("/home/joao/R/x86_64-pc-linux-gnu-library/4.0", "/usr/local/lib/R/site-library",
#                 "/usr/lib/R/site-library","/usr/lib/R/library")
# .libPaths(jrlibpaths)

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
# Startup messages
message(paste0("Digits set to: ", getOption("digits")))
message(paste0("Local library set to: ", .libPaths(jrlibpaths)[1]))
message(paste0("Consider upgrading library according to ", R.version[["version.string"]]))
