#---------------------------------------
# 20151011 Data visualization with ggmap & animation
#
# Data: 2015.10.06~08 youbike data @ data.taipei
#---------------------------------------

# Already convert from json to csv
# library(jsonlite)

library(ggmap)
library(animation)
setwd("youbike_data")
files <- list.files(pattern="\\d\\.csv$")

# Set theme
theme <- theme(axis.line=element_blank(),
               axis.text.x=element_blank(),
               axis.text.y=element_blank(),
               axis.ticks=element_blank(),
               axis.title.x=element_blank(),
               axis.title.y=element_blank(),
               legend.position="none",
               panel.background=element_blank(),
               panel.border=element_blank(),
               panel.grid.major=element_blank(),
               panel.grid.minor=element_blank(),
               plot.background=element_blank())            
# Mapping
taipei <- get_map("Taipei", zoom = 13)

# Animation 
saveGIF({
    for (i in files) {
        bike <- read.csv(i)
        basemap <- ggmap(taipei, darken = c(0, "black"))
        pts <- geom_point(aes(x = lng, y = lat, 
                              size = rev(sbi / tot), 
                              color = rev(sbi / tot), 
                              alpha = sbi / tot),
                          data = bike)

        map <- basemap + pts + theme + 
               scale_size_continuous(range = c(4, 15)) + 
               scale_alpha_continuous(range = c(0.4, 0.95)) + 
               scale_color_gradient2(low = "red", mid = "khaki", high = "lawngreen", midpoint = 0.5)
        print(map)
    }
}, interval = 0.1, ani.width = 600, ani.height = 600)
