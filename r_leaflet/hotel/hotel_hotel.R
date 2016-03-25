#---------------------------------------
# 20151004 Web Crawler Practice - Crawler
#---------------------------------------
crawler.hotel <- function(country) {

## Decide pages/data number
    npage <- html_node(.env$url, "#houseIconViewBody > div:nth-child(1)") %>% html_text()
    npage <- gsub("[^0-9|/]", "", substr(npage, 0, regexpr("，", npage)))
    npage <- as.integer(unlist(strsplit(npage, "/")))
    cat("\n Pages:", npage[1], "  Data:", npage[2], "\n")

## Crawler 
    sapply(1:npage[1], function(iter) {
# Crawl
        sel.name <- "div#houseIconRepeatArea tr table table:first-of-type td:first-child a"
        sel.address <- "div#houseIconRepeatArea tr table table:nth-child(2) tr:nth-child(2) td:nth-child(2)" 
        sel.price <- "div#houseIconRepeatArea tr table > tr:last-child div"

# Parse
        name <- html_nodes(.env$url, sel.name) %>% html_text() %>% gsub("\t|\r|\n", "", .)
        address <- html_nodes(.env$url, sel.address) %>% html_text() %>% gsub("\t|\r|\n", "", .)
        price <- html_nodes(.env$url, sel.price) %>% html_text() %>% gsub("[^0-9]", "", .)
        cat(paste("\n", name, address, price, "\n"))

# Output
        write.table(data.frame(name, address, price), "hotel.csv", 
                    append = TRUE, sep = ",", row.names = FALSE, col.names = FALSE)

# To next page
        if (iter != npage[1]) {
            .env$session <- follow_link(.env$session, css = "#ctl00_ctl00_ctl00_cphMasterContent_cphMasterFooterContent_cphLeftSidebar_HyperLinkNext2")
            .env$url <- read_html(.env$session$url)
        }

# Sys.sleep
        print(runif(1, 2, 8)) %>% Sys.sleep()
})

}
