#---------------------------------------
# 20151004 Web Crawler Practice - JSON 
#---------------------------------------
library(jsonlite)
repeat {
    tryCatch({bike <- fromJSON("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=ddb80380-f1b3-4f8e-8016-7ed9cba571d5")}, error = function(e) bike <<- e)
    if (class(bike)[1] == "list") {
        write.table(bike$result$results, 
                    paste0(format(Sys.time(),"%Y%m%d-%R"),".csv"),
                    sep = ",", row.names = FALSE)
        cat("Query succeed at", format(Sys.time(),"%Y%m%d-%R"), "\n")
    } else {
        write.table(as.character(bike), paste0(format(Sys.time(),"%Y%m%d-%R"),"_error.csv"))
        cat("Query failed at", format(Sys.time(),"%Y%m%d-%R"), "\n")
    }
    Sys.sleep(60 * 30)
}
