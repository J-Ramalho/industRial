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