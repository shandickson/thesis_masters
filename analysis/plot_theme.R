#----------------------------------------------------------------------------------------------
# CUSTOM PLOTTING THEMES 
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# In this script I create a custom plotting theme for my thesis figures. 
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
# Author: Shannon Dickson
#----------------------------------------------------------------------------------------------
library(ggplot2)
library(ggthemes)

theme_thesis <- function(base_size=14, base_family="sans") {
  library(grid)
  library(ggthemes)
  (theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1.2), hjust = 0.5, margin = margin(0,0,20,0)),
            text = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold",size = rel(1)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(), 
            axis.line.x = element_line(colour="black"),
            axis.line.y = element_line(colour="black"),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.text = element_text(size=16),
            legend.key = element_rect(colour = NA),
            legend.position = "top",
            legend.direction = "horizontal",
            legend.box = "vertical",
            legend.key.size= unit(0.5, "cm"),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(10,5,5,5),"mm"),
            strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
            strip.text = element_text(face="bold")
    ))
  
}

scale_fill_thesis <- function(...){
  library(scales)
  discrete_scale("fill","thesis",manual_pal(values = c("#386cb0","#7fc97f","#ef3b2c", "#f87f01","#fec66b","#a6cee3","#fb9a99","#984ea3","#8C591D")), ...)
  
}

scale_colour_thesis <- function(...){
  library(scales)
  discrete_scale("colour","thesis",manual_pal(values = c("#386cb0","#7fc97f","#ef3b2c","#f87f01","#fec66b","#a6cee3","#fb9a99","#984ea3","#8C591D")), ...)
  
}

# End