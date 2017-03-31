# find most popular learners in mlr
# install_github("metacran/cranlogs")
library(mlr)
library(stringi)
library(cranlogs)
library(data.table)

# obtain used packages for all learners
lrns = as.data.table(listLearners())
all.pkgs = stri_split(lrns$package, fixed = ",")

# get download numbers for all packages
all.downloads = cran_downloads(packages = unique(unlist(all.pkgs)), when = "last-month")
all.downloads = as.data.table(all.downloads)
monthly.downloads = all.downloads[, list(monthly = sum(count)), by = package]

# use minimal download number as representation
lrn.downloads = sapply(all.pkgs, function(pkgs) {
  monthly.downloads[package %in% pkgs, min(monthly)]
})

lrns$downloads = lrn.downloads
lrns = lrns[order(downloads, decreasing = TRUE),]
lrns[, .(class, name, package, downloads)]

lrns.small = lrns[, .SD[1,], by = .(name, package)]
lrns.small[, .(class, name, package, downloads)]

View(lrns[,list(learners = paste(class, collapse = ",")),by = .(package, downloads)])
