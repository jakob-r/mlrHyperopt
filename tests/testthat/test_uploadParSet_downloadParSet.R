context("uploadParConfig, downloadParConfig")

test_that("uploading a ParConfig and downloading it works", {
  par.set = makeParamSet(
    makeNumericParam(id = "cost",  upper = 15, lower = 0),
    makeIntegerParam(id = "degree", default = 3L, lower = 1L, requires = quote(kernel=="polynomial")),
    makeNumericParam(id = "gamma", lower = -5, upper = 5, trafo = function(x) 2^x),
    makeDiscreteParam(id = "kernel", values = c("polynomial", "radial")))
  par.vals = list(cachesize = 100L, tolerance = 0.01)

  lrn.wrong = makeLearner("classif.randomForest")
  lrn.good = makeLearner("classif.svm")

  par.config = makeParConfig(par.set, lrn.good, par.vals)

  new.id = uploadParConfig(par.config)
  par.config.downloaded = downloadParConfig(new.id)
  expect_equal(par.config, par.config.downloaded)
})