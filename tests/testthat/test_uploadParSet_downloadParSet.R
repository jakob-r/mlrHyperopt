context("uploadParConfig, downloadParConfig")

test_that("uploading a ParConfig and downloading it works", {
  par.set = makeParamSet(
    makeNumericParam(id = "cost",  upper = 15, lower = 0),
    makeDiscreteParam(id = "kernel", values = c("polynomial", "radial")),
    makeIntegerParam(id = "degree", default = 3L, lower = 1L, requires = quote(kernel=="polynomial")),
    makeNumericParam(id = "gamma", lower = -5, upper = 5, trafo = function(x) 2^x))

  par.set.ref = par.set
  par.set.ref$associated.learner.class = "classif.svm"

  lrn.wrong = makeLearner("classif.randomForest")
  lrn.good = makeLearner("classif.svm")

  expect_error(uploadParConfig(par.set), "ParConfig is not referenced to a Learner")
  expect_error(uploadParConfig(par.set, lrn.wrong), "The ParConfig contains Params that are not supported by the Learner")
  expect_error(uploadParConfig(par.set.ref, lrn.wrong), "The ParConfig is referenced to the learner classif.svm but the learner is classif.randomForest")

  new.id = uploadParConfig(par.set, lrn.good)
  par.set.downloaded = downloadParConfigs(new.id)[[1]]
  expect_equal(par.set.ref, par.set.downloaded)
})