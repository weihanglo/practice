#---------------------------------------
# 20151010 Data Visualization - leaflet
#
# Data: 20151004 web crawling data (hotels in Taiwan)
#---------------------------------------
library(leaflet)
library(pipeR)
library(colorspace)
library(htmlwidgets)

hotel <- read.csv("hotel_geocode.csv")

# NA remove
# Note: NA data woulf interrupt leaflet mapping
hotel <- hotel[!is.na(hotel$lon), ]

# Exploratory Data Analysis
fivenum(hotel$price)
summary(hotel$price)

# Determine intervals for choropleth map
# Pretty interval
breaks <- 0:5 * 1000
hotel$level <- findInterval(hotel$price, breaks)

# Set popup information
popups <- sprintf('<b style="font-size:140%%">%s</b><br/>%s元起<br/>%s', 
                  hotel$name, hotel$price, hotel$address)
# Set choropleth map
Fpal <- colorFactor(rev(heat_hcl(6)), hotel$level)
labels <- paste(c("<", paste(breaks[c(-1, -6)], "~"), ">"), breaks + 1000)

# Default OpenStreetMap
map <- leaflet() %>>% 
    # Base map groups
    addTiles(group = "OSM") %>>%
    addProviderTiles("HERE.pedestrianDay", group = "HERE") %>>%
    addProviderTiles("MapBox", group = "MapBox") %>>%
    addProviderTiles("CartoDB.DarkMatter", group = "CartoDB") %>>%
    addProviderTiles("Thunderforest.TransportDark", group = "Thunderforest") %>>%
    addProviderTiles("Esri.WorldImagery", group = "Esri: World Imagery") %>>%

    # Layer groups
    addCircleMarkers(data = hotel, fillOpacity = 0.7, 
                     color = ~Fpal(level),
                     radius = (as.numeric(hotel$level) + 4) * 2.5,
                     popup = popups, clusterOptions = markerClusterOptions(),
                     group = "Hotels") %>>%
    # Layer controller
    addLayersControl(baseGroups = c("OSM", "HERE", "MapBox", "CartoDB",
                                    "Thunderforest", "Esri: World Imagery"),
                     overlayGroups = c("Hotels")) %>>%
    addLegend(color = rev(heat_hcl(6)), labels = labels, title = "Price")
# Print map
print(map)
saveWidget(map, file="map.html")
