clean_control_data <- function(data) {
  data_zeros <- data %>%
    mutate(
      m1zero = if_else(m1 == 0, 1, 0),
      m2zero = if_else(m2 == 0, 1, 0),
      m3zero = if_else(m3 == 0, 1, 0),
      m4zero = if_else(m4 == 0, 1, 0),
      m5zero = if_else(m5 == 0, 1, 0)
    ) %>%
    mutate(nr_zeros = m1zero + m2zero + m3zero + m4zero + m5zero)

  zero_replaced <- data_zeros %>% pull(nr_zeros) %>% sum()
  zero_discarded <- data_zeros %>% filter(nr_zeros >= 2) %>% nrow()

  data_zeros_clean <- data_zeros %>%
    filter(nr_zeros < 2) %>%
    mutate(
      m1 = if_else(m1 == 0, round((m2 + m3 + m4 + m5)/4, 1), m1),
      m2 = if_else(m2 == 0, round((m1 + m3 + m4 + m5)/4, 1), m2),
      m3 = if_else(m3 == 0, round((m1 + m2 + m4 + m5)/4, 1), m3),
      m4 = if_else(m4 == 0, round((m1 + m2 + m3 + m5)/4, 1), m4),
      m5 = if_else(m5 == 0, round((m1 + m2 + m3 + m4)/4, 1), m5)) %>%
    select(-c(m1zero, m2zero, m3zero, m4zero, m5zero, nr_zeros))

  data_unexpected <- data_zeros_clean %>%
    mutate(
      m1un = if_else(m1 < 15 | m1 > 65, 1, 0),
      m2un = if_else(m2 < 15 | m2 > 65, 1, 0),
      m3un = if_else(m3 < 15 | m3 > 65, 1, 0),
      m4un = if_else(m4 < 15 | m4 > 65, 1, 0),
      m5un = if_else(m5 < 15 | m5 > 65, 1, 0),
      nr_unexpected = m1un + m2un + m3un + m4un + m5un)

  unexpected_replaced <- data_unexpected %>% pull(nr_unexpected) %>% sum()
  unexpected_discarded <- data_unexpected %>% filter(nr_unexpected >= 2) %>% nrow()

  data_unexpected_clean <- data_unexpected %>%
    filter(nr_unexpected < 2) %>%
    mutate(
      m1 = if_else(m1 < 15 | m1 > 65, round((m2 + m3 + m4 + m5)/4, 1), m1),
      m2 = if_else(m2 < 15 | m2 > 65, round((m1 + m3 + m4 + m5)/4, 1), m2),
      m3 = if_else(m3 < 15 | m3 > 65, round((m1 + m2 + m4 + m5)/4, 1), m3),
      m4 = if_else(m4 < 15 | m4 > 65, round((m1 + m2 + m3 + m5)/4, 1), m4),
      m5 = if_else(m5 < 15 | m5 > 65, round((m1 + m2 + m3 + m5)/4, 1), m5)
    ) %>%
    select(-c(m1un, m2un, m3un, m4un, m5un, nr_unexpected))

  cleaning_summary <- data.frame(
    zeros_replaced = zero_replaced,
    zeros_discarded = zero_discarded,
    unexpected_replaced = unexpected_replaced,
    unexpected_discarded = unexpected_discarded
  )

  output <- list()
  output$cleaning_summary <- cleaning_summary
  output$data <- data_unexpected_clean

  output
}

xbar_plot <- function(data, factory) {
  # adding summary statistics
  data_stats <- data %>%
    rowwise() %>%
    mutate(xbar = mean(c(m1, m2, m3, m4, m5))) %>%
    mutate(range = max(c(m1, m2, m3, m4, m5)) - min(c(m1, m2, m3, m4, m5)))

  nr_timepoints <- data_stats %>% nrow()
  xbar_mean <- data_stats %>% pull(xbar) %>% mean() %>% round(1)
  R_mean <- data_stats %>% pull(range) %>% mean() %>% round(1)
  # Calculating R chart limits
  A2 <- 0.5768
  xbar_LCL <- round((xbar_mean - A2 * R_mean), 2)
  xbar_UCL <- round((xbar_mean + A2 * R_mean), 2)
  # Preparing labels for the plot limits
  xbar_labels <- tibble(
    x_position = min(data_stats$timepoint),
    y_position = c(xbar_UCL + 0.2, xbar_LCL - 0.2),
    label_value = c(glue("UCL = {xbar_UCL}"), glue("LCL = {xbar_LCL}"))
  )
  # Detecting rule 2 - 10 consecutive points on 1 side of the mean
  all_gte_ref_value <- function(x) all(x >= xbar_mean)
  consec_10_values_high <- slide_lgl(.x = data_stats$xbar,
                                     .f = all_gte_ref_value,
                                     .before = 9,
                                     .complete = TRUE)
  data_stats <- data_stats %>%
    as_tibble() %>%
    mutate(consec_10_values_high = consec_10_values_high)

  all_low_ref_value <- function(x) all(x <= xbar_mean)
  consec_10_values_low <- slide_lgl(.x = data_stats$xbar,
                                    .f = all_low_ref_value,
                                    .before = 9,
                                    .complete = TRUE)
  data_stats <- data_stats %>%
    as_tibble() %>%
    mutate(consec_10_values_low = consec_10_values_low)
  # Creating additional dataset with points to highlight
  xbar_red <- data_stats %>%
    # Highlighting rule 1 - 1 point above the UCL or 1 point below the LCL
    mutate(xbar_color = case_when(
      xbar > xbar_UCL | xbar < xbar_LCL ~ "red",
      # Highlighting rule 2 - 10 consecutive points on 1 side of the mean
      consec_10_values_low == TRUE ~"red",
      consec_10_values_high == TRUE ~"red",
      TRUE ~ "black"
    )) %>%
    filter(xbar_color == "red") %>%
    select(timepoint, xbar, xbar_color)

  data_stats %>%
    ggplot(aes(x = timepoint, y = xbar)) +
    geom_line() +
    geom_point() +
    geom_hline(aes(yintercept = xbar_LCL), color = "red") +
    geom_hline(aes(yintercept = xbar_UCL), color = "red") +
    geom_hline(aes(yintercept = xbar_mean), color = "black", linetype = "dashed") +
    geom_point(data = xbar_red, aes(x = timepoint, y = xbar, color = xbar_color)) +
    scale_color_identity() +
    geom_text(data = xbar_labels, mapping = aes(x=x_position, y=y_position, label=label_value),
              color = "#FF0000", hjust = 0) +
    scale_y_continuous(breaks = seq(round(xbar_LCL, 0), round(xbar_UCL,0), 0.5)) +
    theme_light() +
    labs(title = "Milk fat in dry matter (MF/DM)",
         subtitle = glue("xbar chart, Gruyère factory {factory}"),
         caption = "data source: Dr Heidi Lamucca, QA",
         y = "Mean",
         x = "Timepoint") +
    theme(plot.caption = element_text(vjust = 1))
}

Rchart_plot <- function(data, factory){
  # adding summary statistics
  data_stats <- data %>%
    rowwise() %>%
    mutate(xbar = mean(c(m1, m2, m3, m4, m5))) %>%
    mutate(range = max(c(m1, m2, m3, m4, m5)) - min(c(m1, m2, m3, m4, m5)))

  nr_timepoints <- data_stats %>% nrow()
  xbar_mean <- data_stats %>% pull(xbar) %>% mean() %>% round(1)
  R_mean <- data_stats %>% pull(range) %>% mean() %>% round(1)
  # Calculating R chart limits
  D3 <- 0
  D4 <- 2.1145
  R_LCL <- round((D3 * R_mean), 1)
  R_UCL <- round((D4 * R_mean), 1)
  # Preparing labels for the plot limits
  R_labels <- tibble(
    x_position = min(data_stats$timepoint),
    y_position = c(R_UCL + 0.2, R_LCL - 0.2),
    label_value = c(glue("UCL = {R_UCL}"), glue("LCL = {R_LCL}"))
  )
  # Plotting
  data_stats %>%
    ggplot(aes(x = timepoint, y = range)) +
    geom_line() +
    geom_point() +
    geom_hline(aes(yintercept = R_LCL), color = "red") +
    geom_hline(aes(yintercept = R_UCL), color = "red") +
    geom_hline(aes(yintercept = R_mean), color = "black", linetype = "dashed") +
    scale_y_continuous(breaks = seq(round(R_LCL, 0), round(R_UCL,0), 0.5)) +
    geom_text(data = R_labels, mapping = aes(x=x_position, y=y_position, label=label_value),
              color = "#FF0000", hjust = 0) +
    theme_light() +
    labs(title = "Milk fat in dry matter (MF/DM)",
         subtitle = glue("R chart, Gruyère factory {factory}"),
         caption = "data source: Dr Heidi Lamucca, QA",
         y = "Range",
         x = "Timepoint") +
    theme(plot.caption = element_text(vjust = 1))
}

I_MR_plot <- function(data, factory){
  # adding summary statistics
  data_stats <- data %>%
    rowwise() %>%
    mutate(xbar = mean(c(m1, m2, m3, m4, m5))) %>%
    mutate(range = max(c(m1, m2, m3, m4, m5)) - min(c(m1, m2, m3, m4, m5)))

  nr_timepoints <- data_stats %>% nrow()
  xbar_mean <- data_stats %>% pull(xbar) %>% mean() %>% round(1)
  R_mean <- data_stats %>% pull(range) %>% mean() %>% round(1)

  # Aggregating data on a weekly basis
  data_wkly <- data_stats %>%
    group_by(week) %>%
    summarise(xbar_wk_mean = round(mean(xbar), 1)) %>%
    mutate(MR = abs(xbar_wk_mean - lag(xbar_wk_mean)))

  # Calculating R chart limits
  M <- mean(data_wkly$xbar_wk_mean)
  MR_bar <- mean(data_wkly$MR, na.rm = TRUE)
  I_LCL <- round((M - 2.66 * MR_bar), 1)
  I_UCL <- round((M + 2.66 * MR_bar), 1)
  # Preparing labels for the plot limits
  I_MR_labels <- tibble(
    x_position = min(data_wkly$week),
    y_position = c(I_UCL + 0.2, I_LCL - 0.2),
    label_value = c(glue("UCL = {I_UCL}"), glue("LCL = {I_LCL}"))
  )
  # Plotting
  data_wkly %>%
    ggplot(aes(x = week, y = xbar_wk_mean)) +
    geom_line() +
    geom_point() +
    geom_hline(aes(yintercept = I_LCL), color = "red") +
    geom_hline(aes(yintercept = I_UCL), color = "red") +
    geom_hline(aes(yintercept = M), color = "black", linetype = "dashed") +
    # geom_point(data = xbar_red, aes(x = timepoint, y = xbar, color = xbar_color)) +
    scale_color_identity() +
    geom_text(data = I_MR_labels, mapping = aes(x=x_position, y=y_position, label=label_value),
              color = "#FF0000", hjust = 0) +
    scale_y_continuous(breaks = seq(round(I_LCL, 0), round(I_UCL,0), 0.5)) +
    theme_light() +
    labs(title = "Milk fat in dry matter (MF/DM)",
         subtitle = glue("xbar chart, Gruyère factory {factory}"),
         caption = "data source: Dr Heidi Lamucca, QA",
         y = "Mean",
         x = "Timepoint") +
    theme(plot.caption = element_text(vjust = 1))
}

Rchart_wkly_plot <- function(data, factory){
  # adding summary statistics
  data_stats <- data %>%
    rowwise() %>%
    mutate(xbar = mean(c(m1, m2, m3, m4, m5))) %>%
    mutate(range = max(c(m1, m2, m3, m4, m5)) - min(c(m1, m2, m3, m4, m5)))

  nr_timepoints <- data_stats %>% nrow()
  xbar_mean <- data_stats %>% pull(xbar) %>% mean() %>% round(1)
  R_mean <- data_stats %>% pull(range) %>% mean() %>% round(1)

  # Aggregating data on a weekly basis
  data_wkly <- data_stats %>%
    group_by(week) %>%
    summarise(xbar_wk_mean = round(mean(xbar), 1)) %>%
    mutate(MR = abs(xbar_wk_mean - lag(xbar_wk_mean)))
  # Calculating R chart limits
  Max_MR <- max(data_wkly$MR, na.rm = TRUE)
  M <- mean(data_wkly$xbar_wk_mean)
  MR_bar <- mean(data_wkly$MR, na.rm = TRUE)
  D3 <- 0
  D4 <- 2.1145
  MR_LCL <- round((D3 * MR_bar), 1)
  MR_UCL <- round((D4 * MR_bar), 1)
  # Preparing labels for the plot limits
  R_labels <- tibble(
    x_position = min(data_stats$timepoint),
    y_position = c(MR_UCL + 0.1, MR_LCL - 0.1),
    label_value = c(glue("UCL = {MR_UCL}"), glue("LCL = {MR_LCL}"))
  )
  # Plotting
  data_wkly %>%
    ggplot(aes(x = week, y = MR)) +
    geom_line() +
    geom_point() +
    geom_hline(aes(yintercept = MR_LCL), color = "red") +
    geom_hline(aes(yintercept = MR_UCL), color = "red") +
    geom_hline(aes(yintercept = MR_bar), color = "black", linetype = "dashed") +
    # scale_y_continuous(breaks = seq(round(R_LCL, 0), round(R_UCL,0), 0.5)) +
    coord_cartesian(ylim = c(0, Max_MR)) +
    geom_text(data = R_labels, mapping = aes(x=x_position, y=y_position, label=label_value),
              color = "#FF0000", hjust = 0) +
    theme_light() +
    labs(title = "Milk fat in dry matter (MF/DM)",
         subtitle = glue("R chart, Gruyère factory {factory}"),
         caption = "data source: Dr Heidi Lamucca, QA",
         y = "Moving Range",
         x = "Timepoint") +
    theme(plot.caption = element_text(vjust = 1))
}
