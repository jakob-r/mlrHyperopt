context("uploadParSet, downloadParSet")

test_that("uploading a ParSet and downloading it works", {
  par.set = makeParamSet(
    makeNumericParam(id = "cost",  upper = 15, lower = 0),
    makeDiscreteParam(id = "kernel", values = c("polynomial", "radial")),
    makeIntegerParam(id = "degree", default = 3L, lower = 1L, requires = quote(kernel=="polynomial")),
    makeNumericParam(id = "gamma", lower = -5, upper = 5, trafo = function(x) 2^x))

  par.set.ref = par.set
  par.set.ref$ref.learner.id = "classif.svm"

  lrn.wrong = makeLearner("classif.randomForest")
  lrn.good = makeLearner("classif.svm")

  expect_error(uploadParSet(par.set), "ParamSet is not referenced to a Learner")
  expect_error(uploadParSet(par.set, lrn.wrong), "The ParamSet contains Params that are not supported by the Learner")
  expect_error(uploadParSet(par.set.ref, lrn.wrong), "The ParamSet is referenced to the learner classif.svm but the learner is classif.randomForest")

  new.id = uploadParSet(par.set, lrn.good)
  par.set.downloaded = downloadParSet(new.id)
  expect_equal(par.set.ref, par.set.downloaded)
})