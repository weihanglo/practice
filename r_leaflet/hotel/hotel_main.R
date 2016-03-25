#---------------------------------------
# 20151004 Web Crawler Practice - Main 
#---------------------------------------
library(rvest)
.env <- new.env()
source("hotel_hotel.R")

## Start new session
.env$main.session <- html_session("http://www.fun-taiwan.com/")
.env$url <- read_html(.env$main.session$url)

# Generate all counties' urls
county <- html_nodes(.env$url, ".county-box > li > a")[1:11] %>% 
              html_attr(name = "href")

# Loop for all counties
sapply(county, 
       function(county) {
           .env$main.session <- jump_to(.env$main.session, county)
           url.county <- read_html(county)

# Crawl all countries in the county
           country <- html_nodes(url.county, 
                                 "#leftContent > map#Map:first-of-type > area") %>% 
                                     html_attr(name = "href")

# Crawl all hotels in the country
           sapply(country, 
                  function(country) {
                      try({.env$session <- jump_to(.env$main.session, country)
                           .env$url <- read_html(.env$session$url)
                           crawler.hotel(country)
                          })
                  })
       })
