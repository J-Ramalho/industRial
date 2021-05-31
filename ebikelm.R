ebike_narrow <- ebike_hardening %>%
  pivot_longer(
    cols = starts_with("g"),
    names_to = "observation",
    values_to = "cycles"
  ) %>%
  group_by(temperature) %>%
  mutate(cycles_mean = mean(cycles)) %>%
  ungroup()

ebike_factor <- ebike_narrow %>%
  mutate(temperature = as_factor(temperature))

ebike_lm <- lm(
  cycles ~ temperature, 
  data = ebike_narrow
)
ebike_lm_factor <- lm(
  cycles ~ temperature, 
  data = ebike_factor,
  contrasts = list(temperature = "contr.sum")
)
ebike_lm$contrasts
ebike_lm_factor$contrasts
summary(ebike_lm)
summary(ebike_lm_factor)
ebike_lm$coefficients %*% c(1, 180)
ebike_lm_factor$coefficients %*% c(1, 1, 0, 0)
ebike_new <- tibble(temperature = c(180))
predict(ebike_lm, newdata = ebike_new)
ebike_new <- data.frame(temperature = as_factor(c("180")))
predict(ebike_lm_factor, newdata = ebike_new)

library(car)
anova(ebike_lm)
Anova(ebike_lm, type = "III")
anova(ebike_lm_factor)
Anova(ebike_lm_factor, type = "III")
