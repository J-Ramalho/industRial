# Load packages
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
  "scales",
  "janitor",
  "knitr",
  "stats",
  "usethis",
  "devtools",
  "fs"
)
purrr::map(ds_pkgs, library, character.only = TRUE)

filter <- dplyr::filter
select <- dplyr::select

# knitr options
knitr::opts_knit$set(options(digits = 5))
knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  comment = NA,
  out.width = '100%',
  theme_set(industRial::theme_industRial())
)