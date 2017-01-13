context("generateLearner")

test_that("generateLearner works", {
  task = iris.task

  par.set = makeParamSet(
    makeNumericParam(id = "cost",  upper = 15, lower = 0),
    makeDiscreteParam(id = "kernel", values = c("polynomial", "radial")),
    makeIntegerParam(id = "degree", default = 3L, lower = 1L, requires = quote(kernel=="polynomial")),
    makeNumericParam(id = "gamma", lower = -5, upper = 5, trafo = function(x) 2^x))

  lrn = makeLearner("classif.svm")
  lrn.okay = makeLearner("regr.svm")

  par.config.empty = makeParConfig(par.set)
  par.config.learner = makeParConfig(par.set, lrn)
  par.config.learner.okay = makeParConfig(par.set, lrn.okay)
  par.config.learner.name = makeParConfig(par.set, learner.name = getLearnerName(lrn))

  expect_error(generateLearner(task, par.config.empty), "The ParConfig does not contain informations on a specific Learner!")
  lrn1 = generateLearner(task, par.config.learner)
  expect_equal(lrn1, lrn)
  expect_warning({lrn2 = generateLearner(task, par.config.learner.okay)}, "will be changed from regr to classif")
  expect_equal(lrn1, lrn2)
  lrn3 = generateLearner(task, par.config.learner.name)
  expect_equal(lrn3, lrn2)

})