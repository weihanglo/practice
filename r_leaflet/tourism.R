#--------------------------------------
# 20151012 Tourism open data map
#--------------------------------------
library(jsonlite)
library(leaflet)

### Import json open data @ data.gov.tw
## Site data
site <- fromJSON("http://data.gov.tw/iisi/logaccess/2205?dataUrl=http://gis.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json&ndctype=JSON&ndcnid=7777")
# Name: site name
# Region: city or county
# Town: town
# Px, Py: longitude, latitude
# Website: website
# Tel: telephone number
# Opentime: open time
site <- site$Infos$Info


## Hotel & Hostel
#hotel <- fromJSON("http://data.gov.tw/iisi/logaccess/2211?dataUrl=http://gis.taiwan.net.tw/XMLReleaseALL_public/hotel_C_f.json&ndctype=JSON&ndcnid=7780")


### Leaflet map
map <- leaflet() %>>% 
    # Base map groups
    addTiles(group = "OSM") %>>%
    addProviderTiles("CartoDB.DarkMatter", group = "CartoDB") %>>%
    addProviderTiles("Thunderforest.TransportDark", group = "Thunderforest") %>>%
    addProviderTiles("Esri.WorldImagery", group = "Esri: World Imagery") %>>%

    # Layer groups
    addMarkers(data = site[1:1000,], ~Px, ~Py,
               clusterOptions = markerClusterOptions()) %>>%
    addMarkers(data = site[1100:3000,], ~Px, ~Py,
               clusterOptions = markerClusterOptions()) %>>%

    # Layer controller
    addLayersControl(baseGroups = c("OSM", "CartoDB", "Thunderforest", "Esri: World Imagery"),
                     overlayGroups = "") 
