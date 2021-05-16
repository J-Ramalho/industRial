

# write_rds(tablet_weight, here::here("inst/exercises/tablet_weight.rds"))



tablet_weight <- tablet_weight %>%
  janitor::clean_names(case = "snake")

weight_statistics_data <- process_stats(tablet_weight, 9)

process_stats_table(weight_statistics_data)

chart_I(weight_statistics_data)