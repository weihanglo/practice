library(data.table)
files <- list.files("./data", "\\.csv$", full.names = TRUE)

dep <- function(file) {
    regmatches(file, regexec("\\d+(.*?).csv", file))[[1:2]]
}

yingli <- fread(files[118])[, c(2, 6:7) := NULL, with = FALSE]
header <- c("id", "name", "Admit", "Status")

names(yingli) <- header
status <- unique(yingli$Status)
oppo <- yingli[Status %in% status[-(1:4)] & id <= 62][grep("備取", Admit), name]

output <- sapply(files[-118], function(f) {
    dt <- fread(f, sep = ",")[姓名 %in% oppo]
    if (nrow(dt) != 0) dt[, DEP := dep(f)] else NULL
})

output <- rbindlist(output[!sapply(output, is.null)])
