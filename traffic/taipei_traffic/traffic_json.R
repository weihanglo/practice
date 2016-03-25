#---------------------------------------
# 20151004 Web Crawler Practice - JSON 2
#---------------------------------------
library(jsonlite)
tryCatch({car <- fromJSON("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5aacba65-afda-4ad5-88f5-6026934140e6")}, error = function(e) car <<- e)
if (class(car)[1] == "list") {
    write.table(car$result$results, 
                paste0("CAR", format(Sys.time(),"%Y%m%d-%R"),".csv"),
                sep = ",", row.names = FALSE)
    cat("Query succeed at", format(Sys.time(),"%Y%m%d-%R"), "\n")
} else {
    write.table(as.character(car), paste0("CAR", format(Sys.time(),"%Y%m%d-%R"),"_error.csv"))
    cat("Query failed at", format(Sys.time(),"%Y%m%d-%R"), "\n")
}
