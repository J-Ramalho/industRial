#' Custom theme "industRial" for the book industRial Data Science plots  
#'
#' @description
#' This theme aims at optimal balance between readability and precision. It has 
#' adapted from the package {cowplot} by Claus O.Wilke and reflects the principles
#' of his book \href{https://clauswilke.com/dataviz/}{Fundamentals of Data Visualization }
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#' 
#' @details
#' Apply this theme by adding it at the end of the code of any \code{\link[ggplot2]{ggplot}} chart.
#' It basically combines the half open theme with a grid background from {cowplot}
#'
#' @param font_size defaults to 14
#' @param font_family defaults to ""
#' @param line_size defaults to 0.5
#' @param rel_small defaults to 12/14
#' @param rel_tiny defaults to 11/14
#' @param rel_large defaults to 16/14
#' @param base_size internal arguments, defaults to font_size
#' @param base_family internal arguments, defaults to font_family 
#'
#' @return
#' This function returns an object of classes theme and gg from the ggplot2 package
#' @export
#'
#' @examples
#' library(dplyr)
#' library(ggplot2)
#' 
#' pet_delivery %>% 
#'    ggplot(aes(x = A)) +
#'    geom_histogram(color = "grey", fill = "grey90") +
#'    labs(title = "PET clothing case study",
#'       subtitle = "Raw data plot",
#'       x = "Treatment",
#'       y = "Tensile strength [MPa]") +
#'       theme_industRial()
#'       
#' @importFrom ggplot2 %+replace%
theme_industRial <- function (font_size = 14, font_family = "", line_size = 0.5,
                              rel_small = 12/14, rel_tiny = 11/14, rel_large = 16/14,
                              base_size = font_size, base_family = font_family)
{
  half_line <- font_size / 2
  small_size <- rel_small * font_size
  ggplot2::theme_grey(base_size = font_size, base_family = font_family) %+replace%
    ggplot2::theme(
      line = ggplot2::element_line(
        color = "black",
        size = line_size,
        linetype = 1,
        lineend = "butt"
      ),
      rect = ggplot2::element_rect(
        fill = NA,
        color = NA,
        size = line_size,
        linetype = 1
      ),
      text = ggplot2::element_text(
        family = font_family,
        face = "plain",
        color = "black",
        size = font_size,
        hjust = 0.5,
        vjust = 0.5,
        angle = 0,
        lineheight = 0.9,
        margin = ggplot2::margin(),
        debug = FALSE
      ),
      axis.line = ggplot2::element_line(
        color = "black",
        size = line_size,
        lineend = "square"
      ),
      axis.line.x = NULL,
      axis.line.y = NULL,
      axis.text = ggplot2::element_text(color = "black",
                               size = small_size),
      axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = small_size / 4),
                                 vjust = 1),
      axis.text.x.top = ggplot2::element_text(margin = ggplot2::margin(b = small_size / 4),
                                     vjust = 0),
      axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = small_size / 4),
                                 hjust = 1),
      axis.text.y.right = ggplot2::element_text(margin = ggplot2::margin(l = small_size / 4),
                                       hjust = 0),
      axis.ticks = ggplot2::element_line(color = "black",
                                size = line_size),
      axis.ticks.length = ggplot2::unit(half_line / 2,
                               "pt"),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = half_line / 2),
                                  vjust = 1),
      axis.title.x.top = ggplot2::element_text(margin = ggplot2::margin(b = half_line / 2),
                                      vjust = 0),
      axis.title.y = ggplot2::element_text(
        angle = 90,
        margin = ggplot2::margin(r = half_line /
                          2),
        vjust = 1
      ),
      axis.title.y.right = ggplot2::element_text(
        angle = -90,
        margin = ggplot2::margin(l = half_line / 2),
        vjust = 0
      ),
      legend.background = ggplot2::element_blank(),
      legend.spacing = ggplot2::unit(font_size, "pt"),
      legend.spacing.x = NULL,
      legend.spacing.y = NULL,
      legend.margin = ggplot2::margin(0,
                             0, 0, 0),
      legend.key = ggplot2::element_blank(),
      legend.key.size = ggplot2::unit(1.1 *
                               font_size, "pt"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = ggplot2::element_text(size = ggplot2::rel(rel_small)),
      legend.text.align = NULL,
      legend.title = ggplot2::element_text(hjust = 0),
      legend.title.align = NULL,
      legend.position = "right",
      legend.direction = NULL,
      legend.justification = c("left",
                               "center"),
      legend.box = NULL,
      legend.box.margin = ggplot2::margin(0,
                                 0, 0, 0),
      legend.box.background = ggplot2::element_blank(),
      legend.box.spacing = ggplot2::unit(font_size, "pt"),
      panel.background = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      panel.grid = ggplot2::element_line(
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
      panel.spacing = ggplot2::unit(half_line, "pt"),
      panel.spacing.x = NULL,
      panel.spacing.y = NULL,
      panel.ontop = FALSE,
      strip.background = ggplot2::element_rect(fill = "grey80"),
      strip.text = ggplot2::element_text(
        size = ggplot2::rel(rel_small),
        margin = ggplot2::margin(half_line / 2, half_line /
                          2, half_line / 2,
                        half_line / 2)
      ),
      strip.text.x = NULL,
      strip.text.y = ggplot2::element_text(angle = -90),
      strip.placement = "inside",
      strip.placement.x = NULL,
      strip.placement.y = NULL,
      strip.switch.pad.grid = ggplot2::unit(half_line / 2,
                                   "pt"),
      strip.switch.pad.wrap = ggplot2::unit(half_line / 2,
                                   "pt"),
      plot.background = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(
        colour = "#38598CFF",
        face = "bold",
        size = ggplot2::rel(rel_large),
        hjust = 0,
        vjust = 1,
        margin = ggplot2::margin(b = half_line)
      ),
      plot.subtitle = ggplot2::element_text(
        size = ggplot2::rel(rel_small),
        hjust = 0,
        vjust = 1,
        margin = ggplot2::margin(b = half_line)
      ),
      plot.caption = ggplot2::element_text(
        size = ggplot2::rel(rel_tiny),
        hjust = 1,
        vjust = 1,
        margin = ggplot2::margin(t = half_line)
      ),
      plot.tag = ggplot2::element_text(
        face = "bold",
        hjust = 0,
        vjust = 0.7
      ),
      plot.tag.position = c(0, 1),
      plot.margin = ggplot2::margin(half_line,
                           half_line, half_line, half_line),
      complete = TRUE
    )
}