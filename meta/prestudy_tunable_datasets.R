# Datasets from https://github.com/PhilippPro/tunability
# Backup on jakob-r/tunability
# Find OML Datasets and learners where tuning is especially furtile
load('~/dump/tunability/results.RData')
load('~/Dropbox/tunability/surrogates.RData')
library(data.table)
library(tibble)
library(ggplot2)
library(BBmisc)
library(stringi)

res.compare = lapply(names(results), function(lrn.name) {
  optimum = results[[lrn.name]][['optimum']]
  default = resultsPackageDefaults[[lrn.name]][['default']]
  data.table(
    oml.id = extractSubList(surrogates_all[[lrn.name]]$surrogates, c("task.desc","id")),
    learner = lrn.name,
    performance.opt = optimum$optimum,
    performance.def = default$result)
})
res.compare = rbindlist(res.compare)
res.compare[, performance.increase := performance.opt - performance.def]
res.compare[order(performance.increase, decreasing = TRUE)]
sort.by.ave.increase = res.compare[, list(mean.performance.increase = mean(performance.increase)), by = .(oml.id)][order(mean.performance.increase, decreasing = TRUE)]
res.compare$oml.id = factor(res.compare$oml.id, levels = sort.by.ave.increase$oml.id)

g = ggplot(res.compare, aes(x = oml.id, y = performance.increase, color = learner))
g + geom_point() + coord_flip()
