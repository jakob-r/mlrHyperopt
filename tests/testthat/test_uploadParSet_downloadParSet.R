context("uploadParConfig, downloadParConfig")

test_that("uploading a ParConfig and downloading it works", {
  par.set = makeParamSet(
    makeNumericParam(id = "cost",  upper = 15, lower = 0),
    makeIntegerParam(id = "degree", default = 3L, lower = 1L, requires = quote(kernel=="polynomial")),
    makeNumericParam(id = "gamma", lower = -5, upper = 5, trafo = function(x) 2^x),
    makeDiscreteParam(id = "kernel", values = c("polynomial", "radial")))
  par.vals = list(cachesize = 100L, tolerance = 0.01)

  lrn.good = makeLearner("classif.svm")

  par.config = makeParConfig(par.set, lrn.good, par.vals)

  error = try({new.id = uploadParConfig(par.config)}, silent = TRUE)
  if (is.error(error)) {
    expect_character(error, pattern = "This exact par\\.config was already uploaded")
    par.config.downloaded = downloadParConfigs(learner.class = getLearnerClass(lrn.good))[[1]]
  } else {
    par.config.downloaded = downloadParConfig(new.id)
  }
  expect_equal(par.config, setAttribute(par.config.downloaded, "on.server", NULL))
})

test_that("Download with different methods work", {
  empty.result = downloadParConfigs(learner.class = "ABCDEFGH")
  expect_equal(empty.result, list())

  names.res = downloadParConfigs(learner.name = "randomForest")
  ids = sapply(names.res, function(x) attr(x, "on.server")$id)
  ids.res = downloadParConfigs(as.character(ids))
  expect_equal(names.res, ids.res)

  custom.res = downloadParConfigs(custom.query = list(user_email = "code@jakob-r.de"))
  expect_list(custom.res, min.len = 3)
})