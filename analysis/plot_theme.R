#----------------------------------------------------------------------------------------------
# CUSTOM PLOTTING THEMES 
#----------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
# In this script I create a custom plotting theme for my thesis figures. 
# It uses and extends the functionality of ggplot2, and ggthemes
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
# Author: Shannon Dickson
#--------------------------------------------------------------------------------------------------------------
# Libraries required:
library(ggplot2)
library(grid)
library(ggthemes)
#
theme_thesis <- function(base_size = 14, base_family = "sans") {

  
  # Define the theme using theme_foundation from ggthemes package
  # Customize various theme elements using element_text and element_rect
  # Set specific styles for plot title, text, panel, axis, legend, etc.
  # Adjust margins, grid lines, and other visual elements
  
  (theme_foundation(base_size = base_size, base_family = base_family)
    + theme(plot.title       = element_text(face = "bold", size = rel(1.2), hjust = 0.5, margin = margin(0, 0, 20, 0)),
            text             = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background  = element_rect(colour = NA),
            panel.border     = element_rect(colour = NA),
            axis.title       = element_text(face   = "bold", size = rel(1)),
            axis.title.y     = element_text(angle  = 90, vjust = 2),
            axis.title.x     = element_text(vjust  = -0.2),
            axis.text        = element_text(), 
            axis.line.x      = element_line(colour = "black"),
            axis.line.y      = element_line(colour = "black"),
            axis.ticks       = element_line(),
            panel.grid.major = element_line(colour = "#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.text      = element_text(size   = 16),
            legend.key       = element_rect(colour = NA),
            legend.position  = "top",
            legend.direction = "horizontal",
            legend.box       = "vertical",
            legend.key.size  = unit(0.5, "cm"),
            legend.title     = element_text(face   = "italic"),
            plot.margin      = unit(c(10, 5, 5, 5), "mm"),
            strip.background = element_rect(colour = "#f0f0f0", fill = "#f0f0f0"),
            strip.text       = element_text(face   = "bold")
    ))
  
}

# Load the scales package for data scaling and color mapping
# Define a discrete color scale for fill using manual_pal from scales package
# Assign custom color values for each level of the scale
scale_fill_thesis <- function(...){
  
  library(scales)
  
  discrete_scale("fill", "thesis", manual_pal(values = c("#386cb0","#7fc97f","#ef3b2c", "#f87f01","#fec66b","#a6cee3","#fb9a99","#984ea3","#8C591D")), ...)
  
}

# Load the scales package for data scaling and color mapping
# Define a discrete color scale for color using manual_pal from scales package
# Assign custom color values for each level of the scale
scale_colour_thesis <- function(...){
  
  library(scales) 
  
  discrete_scale("colour", "thesis", manual_pal(values = c("#386cb0","#7fc97f","#ef3b2c","#f87f01","#fec66b","#a6cee3","#fb9a99","#984ea3","#8C591D")), ...)
  
}

# EoF
#--------------------------------------------------------------------------------------------------------------

