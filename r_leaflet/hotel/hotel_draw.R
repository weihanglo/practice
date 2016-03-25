#---------------------------------------
# 20151010 Data Visualization - ggmap
#
# Data: 20151004 web crawling data (hotels in Taiwan)
#---------------------------------------
library(ggmap)

hotel <- read.csv("hotel_geocode.csv")
# Subset hotel in Yilan
yilan_h <- subset(hotel, grepl("宜蘭", address))

# Exploratory Data Analysis
fivenum(yilan_h$price)
summary(yilan_h$price)
hist(yilan_h$price)
breaks <- quantile(yilan_h$price, na.rm = TRUE, probs = 0:5 * 2 / 10)
label <- paste(c("<", paste(breaks[2:4], "~"), ">"), breaks[1:5])
Price <- cut(yilan_h$price, breaks, labels = label)

yilan <- qmap("宜蘭", zoom = 12, maptype= "hybrid")

theme_set(theme_classic(12, "Source Han Sans TW"))
theme_update(title = element_text(size = 24),
             legend.background = element_rect("grey"),
             legend.position = c(0.1, 0.87),
             legend.title = element_text(size = 12))
             
yilan + 
    geom_point(aes(x = lon, y = lat, size = Price, color = Price), alpha = .8, data = yilan_h) +
    scale_size_discrete(range = c(2, 10)) + 
    scale_color_brewer(palette = 'YlOrRd') + 
    ggtitle("民宿在宜蘭")

