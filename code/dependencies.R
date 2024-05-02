# ---------------------------------------------------------------------------- #
# Libraries                                                                    #
# ---------------------------------------------------------------------------- #

# Data management
library(tidyverse) 
library(data.table)
library(lubridate)
library(slider)

# Plotting tools
library(ggpubr)
library(grid)
library(gridExtra)
library(RColorBrewer)

# Model fitting
library(msm)
library(lme4)
library(lmtest)
library(car)
library(merTools)

# ---------------------------------------------------------------------------- #
# Paths                                                                        #
# ---------------------------------------------------------------------------- #

path_to_data <- "~/research-collaboration/quitting_ind_differences/data_clean"

# ---------------------------------------------------------------------------- #
# Colors                                                                       #
# ---------------------------------------------------------------------------- #

colors <- c("turquoise4", "tan1", "tomato3", "grey10", "grey40", "grey70")

# ---------------------------------------------------------------------------- #
# Plotting theme                                                               #
# ---------------------------------------------------------------------------- #

plot_theme <- 
  theme_minimal() +
  theme(text = element_text(#family = "Sans",
                            color = colors[4],
                            size = 8),
        plot.title = element_blank(),
        plot.subtitle = element_blank(),
        axis.title.x = element_text(color = colors[4],
                                    #face = "bold",
                                    hjust = 0.5, 
                                    size = 12), #10
        axis.title.y = element_text(color = colors[4],
                                    #face = "bold",
                                    hjust = 0.5,
                                    size = 12), #10
        axis.text = element_text(color = colors[4],
                                 size = 10), #8
        legend.text = element_text(color = colors[4],
                                    size = 10),
        legend.title = element_text(color = colors[4],
                                     size = 10,
                                     face = "bold"),
        panel.border = element_rect(color = colors[5], 
                                    fill = NA, 
                                    linewidth = 0.5),
        strip.background = element_rect(fill = colors[6], color = colors[4]),
        strip.text = element_text(color = colors[4], size = 10),
        panel.grid.minor = element_blank()
        )
pointsize = 1.5
linesize = 1.5
alpha = 0.4

# ---------------------------------------------------------------------------- #
# Functions                                                                    #
# ---------------------------------------------------------------------------- #
export_plot <- function(plot_object, height = 600, width = 800) {
  png(filename = paste0(path_to_plots, "/", deparse(substitute(plot_object)), ".png"),
      height = height,
      width = width,
      res = 80)
  print(plot_object)
  dev.off()
}


