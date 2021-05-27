#' Custom theme "qcc" for the book industRial Data Science plots  
#'
#' This theme provides a similar look and feel to the package \code{\link[qcc]{qcc}}
#' statistical process control charts (SPC) which have themselves a resemblance with 
#' Minitab charts. This theme aims at providing a layout that is familiar to readers
#' of Minitab chart to help in reducing transition to R build reports and charts.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#' 
#' @details
#' Apply this theme by adding it at the end of the code of any \code{\link[ggplot2]{ggplot}} chart.
#' It #' basically provides a grey background and some highlights to help reading key
#' process statistics such as the population mean.
#'
#' @param base_size font size, defaults to 12
#' @param base_family font family defaults to ""
#'
#' @return
#' This function returns an object of classes theme and gg from the ggplot2 package
#' @export
#'
#' @importFrom ggplot2 %+replace%
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
#'       theme_qcc()
theme_qcc <- function(base_size = 12, base_family = "") {
  
  ggplot2::theme_grey(base_size = base_size, base_family = base_family) %+replace%
    
    ggplot2::theme(
      # Specify axis options
      axis.line = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(size = base_size*0.8, color = "black", lineheight = 0.9),
      axis.text.y = ggplot2::element_text(size = base_size*0.8, color = "black", lineheight = 0.9),
      axis.ticks = ggplot2::element_line(color = "black", size  =  0.2),
      axis.title.x = ggplot2::element_text(size = base_size, color = "black", margin = ggplot2::margin(0, 10, 0, 0)),
      axis.title.y = ggplot2::element_text(size = base_size, color = "black", angle = 90, margin = ggplot2::margin(0, 10, 0, 0)),
      axis.ticks.length = ggplot2::unit(0.3, "lines"),
      # Specify legend options
      legend.background = ggplot2::element_rect(color = NA, fill = "white"),
      legend.key = ggplot2::element_rect(color = "grey80",  fill = "#ccffff"),
      legend.key.size = ggplot2::unit(1.2, "lines"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = ggplot2::element_text(size = base_size*0.8, color = "black"),
      legend.title = ggplot2::element_text(size = base_size*0.8, face = "bold", hjust = 1, color = "black"),
      legend.position = "right",
      legend.text.align = NULL,
      legend.title.align = NULL,
      legend.direction = "vertical",
      legend.box = NULL,
      # Specify panel options
      panel.background = ggplot2::element_rect(fill = "white", color  =  NA),
      panel.border = ggplot2::element_rect(fill = NA, color = "grey50"),
      panel.grid.major = ggplot2::element_line(color = NA),
      panel.grid.minor = ggplot2::element_line(color = NA),
      panel.margin = ggplot2::unit(0.5, "lines"),
      # Specify facetting options
      strip.background = ggplot2::element_rect(fill = "grey30", color = "grey10"),
      strip.text.x = ggplot2::element_text(size = base_size*0.8, color = "black"),
      strip.text.y = ggplot2::element_text(size = base_size*0.8, color = "black",angle = -90),
      # Specify plot options
      plot.background = ggplot2::element_rect(color = NA, fill = "grey90"),
      plot.title = ggplot2::element_text(size = base_size*1.2, color = "black", hjust = 0),
      # plot.margin = ggplot2::unit(rep(1, 4), "lines")
      
    )
}