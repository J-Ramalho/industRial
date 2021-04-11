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

#' @import ggplot2

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

theme_industRial <- function (font_size = 14, font_family = "", line_size = 0.5,
                              rel_small = 12/14, rel_tiny = 11/14, rel_large = 16/14)
{
  half_line <- font_size / 2
  small_size <- rel_small * font_size
  theme_grey(base_size = font_size, base_family = font_family) %+replace%
    theme(
      line = element_line(
        color = "black",
        size = line_size,
        linetype = 1,
        lineend = "butt"
      ),
      rect = element_rect(
        fill = NA,
        color = NA,
        size = line_size,
        linetype = 1
      ),
      text = element_text(
        family = font_family,
        face = "plain",
        color = "black",
        size = font_size,
        hjust = 0.5,
        vjust = 0.5,
        angle = 0,
        lineheight = 0.9,
        margin = margin(),
        debug = FALSE
      ),
      axis.line = element_line(
        color = "black",
        size = line_size,
        lineend = "square"
      ),
      axis.line.x = NULL,
      axis.line.y = NULL,
      axis.text = element_text(color = "black",
                               size = small_size),
      axis.text.x = element_text(margin = margin(t = small_size / 4),
                                 vjust = 1),
      axis.text.x.top = element_text(margin = margin(b = small_size / 4),
                                     vjust = 0),
      axis.text.y = element_text(margin = margin(r = small_size / 4),
                                 hjust = 1),
      axis.text.y.right = element_text(margin = margin(l = small_size / 4),
                                       hjust = 0),
      axis.ticks = element_line(color = "black",
                                size = line_size),
      axis.ticks.length = unit(half_line / 2,
                               "pt"),
      axis.title.x = element_text(margin = margin(t = half_line / 2),
                                  vjust = 1),
      axis.title.x.top = element_text(margin = margin(b = half_line / 2),
                                      vjust = 0),
      axis.title.y = element_text(
        angle = 90,
        margin = margin(r = half_line /
                          2),
        vjust = 1
      ),
      axis.title.y.right = element_text(
        angle = -90,
        margin = margin(l = half_line / 2),
        vjust = 0
      ),
      legend.background = element_blank(),
      legend.spacing = unit(font_size, "pt"),
      legend.spacing.x = NULL,
      legend.spacing.y = NULL,
      legend.margin = margin(0,
                             0, 0, 0),
      legend.key = element_blank(),
      legend.key.size = unit(1.1 *
                               font_size, "pt"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = element_text(size = rel(rel_small)),
      legend.text.align = NULL,
      legend.title = element_text(hjust = 0),
      legend.title.align = NULL,
      legend.position = "right",
      legend.direction = NULL,
      legend.justification = c("left",
                               "center"),
      legend.box = NULL,
      legend.box.margin = margin(0,
                                 0, 0, 0),
      legend.box.background = element_blank(),
      legend.box.spacing = unit(font_size, "pt"),
      panel.background = element_blank(),
      panel.border = element_blank(),
      panel.grid = element_line(
        color = "grey85",
        size = 0.5,
        linetype = 1,
        lineend = "butt"
      ),
      panel.grid.major = NULL,
      panel.grid.minor = NULL,
      panel.grid.major.x = NULL,
      panel.grid.major.y = NULL,
      panel.grid.minor.x = NULL,
      panel.grid.minor.y = NULL,
      panel.spacing = unit(half_line, "pt"),
      panel.spacing.x = NULL,
      panel.spacing.y = NULL,
      panel.ontop = FALSE,
      strip.background = element_rect(fill = "grey80"),
      strip.text = element_text(
        size = rel(rel_small),
        margin = margin(half_line / 2, half_line /
                          2, half_line / 2,
                        half_line / 2)
      ),
      strip.text.x = NULL,
      strip.text.y = element_text(angle = -90),
      strip.placement = "inside",
      strip.placement.x = NULL,
      strip.placement.y = NULL,
      strip.switch.pad.grid = unit(half_line / 2,
                                   "pt"),
      strip.switch.pad.wrap = unit(half_line / 2,
                                   "pt"),
      plot.background = element_blank(),
      plot.title = element_text(
        colour = "dodgerblue4",
        face = "bold",
        size = rel(rel_large),
        hjust = 0,
        vjust = 1,
        margin = margin(b = half_line)
      ),
      plot.subtitle = element_text(
        size = rel(rel_small),
        hjust = 0,
        vjust = 1,
        margin = margin(b = half_line)
      ),
      plot.caption = element_text(
        size = rel(rel_tiny),
        hjust = 1,
        vjust = 1,
        margin = margin(t = half_line)
      ),
      plot.tag = element_text(
        face = "bold",
        hjust = 0,
        vjust = 0.7
      ),
      plot.tag.position = c(0, 1),
      plot.margin = margin(half_line,
                           half_line, half_line, half_line),
      complete = TRUE
    )
}
