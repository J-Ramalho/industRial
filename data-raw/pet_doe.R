## code to prepare `pet_doe` dataset goes here
library(DoE.base)

pet_doe <- fac.design(
  randomize = FALSE,
  factor.names = list(
    A = c("-", "+"), 
    B = c("-", "+"),
    replicate = c("I", "II", "III")
  )
)

tensile_strength <- c(
  64.4,82.8,41.4,71.3,57.5,73.6,43.7,69.0,62.1,73.6,52.9,66.7
)

pet_doe <- bind_cols(
  pet_doe,
  "tensile_strength" = tensile_strength,
)

usethis::use_data(pet_doe, overwrite = TRUE)
