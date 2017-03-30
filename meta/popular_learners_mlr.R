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

lrns[order(downloads, decreasing = TRUE), .(class, name, package, downloads)]

# Take only one representative per name and package
lrns.small = lrns[order(downloads, decreasing = TRUE), .SD[1,], by = .(name, package)]
lrns.small[1:20, .(class, name, package, downloads)]
