#---------------------------------------
# 20151004 Web Crawler Practice - Geocode
#---------------------------------------
library(rvest)
library(ggmap)

hotel <- unique(read.csv("hotel.csv", header = FALSE))
hotel$V2 <- as.character(hotel$V2)
hotel$V2[1:(min(grep("^台北", hotel$V2)) - 1)] <- hotel$V2[1:(min(grep("^台北", hotel$V2)) - 1)] %>% 
                                                    paste("臺北市", .)
hotel$V2[grep("台北", hotel$V2)] <- gsub("台北", "新北市", hotel$V2[grep("台北", hotel$V2)])

                                       
# Using output = "more" includes many information
nrow <- geocodeQueryCheck()
geocodes <- geocode(as.character(hotel$V2)[1:nrow], "more", "google")
if(nrow(geocodes) == nrow(hotel[1:nrow, ])) hotel.full <- cbind(hotel[1:nrow, ], geocodes)
save.image("hotel_geocode.RData")
