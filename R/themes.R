theme_exts <- function() {
  label_font <- "Kelson Sans Normal"
  colour_font <- "#545454"

  ggplot2::theme(
    plot.title.position = "plot",
    plot.title = ggplot2::element_text(
      family = "Kalam", face = "bold", size = 24, colour = colour_font
      ),
    plot.subtitle = ggplot2::element_text(
      family = label_font, colour = colour_font
      ),
    plot.caption = ggplot2::element_text(
      family = label_font, colour = colour_font
      ),
    axis.text = ggplot2::element_text(
      family = label_font, colour = colour_font
      ),
    axis.title = ggplot2::element_text(
      family = label_font, colour = colour_font
      ),
    legend.text = ggplot2::element_text(
      family = label_font, colour = colour_font
      ),
    legend.position = "top",
    strip.background = ggplot2::element_rect(fill = NA),
    strip.text = ggplot2::element_text(
      family = "Kalam",
      face = "bold",
      size = 12,
      hjust = 0,
      colour = colour_font
    ),
    panel.grid = ggplot2::element_line(colour = "grey", size = 0.5),
    plot.margin = ggplot2::unit(c(10, 10, 10, 10), "pt")
  )
}


theme_exts_dark <- function() {
  label_font <- "Kelson Sans Normal"
  colour_font <- "#DDDDDD"

  ggplot2::theme(
    plot.title.position = "plot",
    plot.title = ggplot2::element_text(
      family = "Kalam", face = "bold", size = 24, colour = colour_font
    ),
    plot.subtitle = ggplot2::element_text(
      family = label_font, colour = colour_font
    ),
    plot.caption = ggplot2::element_text(
      family = label_font, colour = colour_font
    ),
    axis.text = ggplot2::element_text(
      family = label_font, colour = colour_font
    ),
    axis.title = ggplot2::element_text(
      family = label_font, colour = colour_font
    ),
    legend.text = ggplot2::element_text(
      family = label_font, colour = colour_font
    ),
    legend.background = element_rect(fill = NA),
    legend.position = "top",
    strip.background = ggplot2::element_rect(fill = NA),
    strip.text = ggplot2::element_text(
      family = "Kalam",
      face = "bold",
      size = 12,
      hjust = 0,
      colour = colour_font
    ),
    panel.grid = ggplot2::element_line(
      colour = "white", size = 0.5
    ),
    panel.background = element_rect(fill = "black"),
    plot.margin = ggplot2::unit(c(10, 10, 10, 10), "pt"),
    plot.background = element_rect(fill = "#000000")
  )
}

theme_fit <- function(base_size = 11,
                      base_family = "",
                      base_line_size = base_size/22,
                      base_rect_size = base_size/22) {

  theme_bw(base_size = base_size,
           base_family = base_family,
           base_line_size = base_line_size,
           base_rect_size = base_rect_size) %+replace%
    theme(axis.ticks = element_blank(),
          legend.background = element_blank(),
          legend.key = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          strip.background = element_blank(),
          # plot.background = element_blank(),
          plot.background = element_rect(
            color = "#F8F5F0", fill = "#F8F5F0"),
          complete = TRUE)
}

theme_az <- function(base_size = 12, base_family = "") {

  theme_grey(base_size = base_size, base_family = base_family) %+replace%

    theme(
      # Specify axis options
      axis.line = element_blank(),
      axis.text.x = element_text(size = base_size*0.8, color = "black", lineheight = 0.9),
      axis.text.y = element_text(size = base_size*0.8, color = "black", lineheight = 0.9),
      axis.ticks = element_line(color = "black", size  =  0.2),
      axis.title.x = element_text(size = base_size, color = "black", margin = margin(0, 10, 0, 0)),
      axis.title.y = element_text(size = base_size, color = "black", angle = 90, margin = margin(0, 10, 0, 0)),
      axis.ticks.length = unit(0.3, "lines"),
      # Specify legend options
      legend.background = element_rect(color = NA, fill = "white"),
      legend.key = element_rect(color = "grey80",  fill = "#ccffff"),
      legend.key.size = unit(1.2, "lines"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = element_text(size = base_size*0.8, color = "black"),
      legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 1, color = "black"),
      legend.position = "right",
      legend.text.align = NULL,
      legend.title.align = NULL,
      legend.direction = "vertical",
      legend.box = NULL,
      # Specify panel options
      panel.background = element_rect(fill = "#ccffff", color  =  NA),
      panel.border = element_rect(fill = NA, color = "grey50"),
      panel.grid.major = element_line(color = "grey80"),
      panel.grid.minor = element_line(color = "grey80"),
      panel.margin = unit(0.5, "lines"),
      # Specify facetting options
      strip.background = element_rect(fill = "grey30", color = "grey10"),
      strip.text.x = element_text(size = base_size*0.8, color = "black"),
      strip.text.y = element_text(size = base_size*0.8, color = "black",angle = -90),
      # Specify plot options
      plot.background = element_rect(color = NA, fill = "white"),
      plot.title = element_text(size = base_size*1.2, color = "black", hjust = 0),
      # plot.margin = unit(rep(1, 4), "lines")

    )

}
theme_qcc <- function(base_size = 12, base_family = "") {

  theme_grey(base_size = base_size, base_family = base_family) %+replace%

    theme(
      # Specify axis options
      axis.line = element_blank(),
      axis.text.x = element_text(size = base_size*0.8, color = "black", lineheight = 0.9),
      axis.text.y = element_text(size = base_size*0.8, color = "black", lineheight = 0.9),
      axis.ticks = element_line(color = "black", size  =  0.2),
      axis.title.x = element_text(size = base_size, color = "black", margin = margin(0, 10, 0, 0)),
      axis.title.y = element_text(size = base_size, color = "black", angle = 90, margin = margin(0, 10, 0, 0)),
      axis.ticks.length = unit(0.3, "lines"),
      # Specify legend options
      legend.background = element_rect(color = NA, fill = "white"),
      legend.key = element_rect(color = "grey80",  fill = "#ccffff"),
      legend.key.size = unit(1.2, "lines"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = element_text(size = base_size*0.8, color = "black"),
      legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 1, color = "black"),
      legend.position = "right",
      legend.text.align = NULL,
      legend.title.align = NULL,
      legend.direction = "vertical",
      legend.box = NULL,
      # Specify panel options
      panel.background = element_rect(fill = "white", color  =  NA),
      panel.border = element_rect(fill = NA, color = "grey50"),
      panel.grid.major = element_line(color = NA),
      panel.grid.minor = element_line(color = NA),
      panel.margin = unit(0.5, "lines"),
      # Specify facetting options
      strip.background = element_rect(fill = "grey30", color = "grey10"),
      strip.text.x = element_text(size = base_size*0.8, color = "black"),
      strip.text.y = element_text(size = base_size*0.8, color = "black",angle = -90),
      # Specify plot options
      plot.background = element_rect(color = NA, fill = "grey90"),
      plot.title = element_text(size = base_size*1.2, color = "black", hjust = 0),
      # plot.margin = unit(rep(1, 4), "lines")

    )

}
