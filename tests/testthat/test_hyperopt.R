context("hyperopt")

test_that("hyperopt works", {
  mlr::configureMlr(show.info = FALSE, show.learner.output = FALSE)
  lrn = makeLearner("classif.svm")
  task = iris.task
  res = hyperopt(task = iris.task, learner = lrn)
  expect_class(res, "TuneResult")
  expect_number(res$y, lower = 0, upper = 0.1)

  # some random workflow
  hyper.control = makeHyperControl(
    mlr.control = makeTuneControlRandom(maxit = 10),
    resampling = makeResampleDesc("Holdout"),
    measures = list(auc)
  )
  par.config = generateParConfig(sonar.task, lrn)
  par.set = getParConfigParSet(par.config)
  par.set = filterParams(par.set, ids = "cost")
  par.config = setParConfigParSet(par.config, par.set)
  par.config = setParConfigParVals(par.config, par.vals = list())
  res2 = hyperopt(task = sonar.task, hyper.control = hyper.control, par.config = par.config)
  expect_number(res2$y, lower = 0.8)
  expect_true(getOptPathLength(res2$opt.path) == 10)
})