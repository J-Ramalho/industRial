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
  "patchwork"
)
purrr::map(ds_pkgs, library, character.only = TRUE)

filter <- dplyr::filter
select <- dplyr::select

# ggplot options
theme_set(industRial::theme_industRial())

# knitr options
knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  comment = NA,
  out.width = '100%'
)