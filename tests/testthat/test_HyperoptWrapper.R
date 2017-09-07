context("HyperoptWrapper")

test_that("hyperoptWrapper works", {
  mlr::configureMlr(show.info = FALSE, show.learner.output = FALSE)
  lrn = makeLearner("classif.svm")
  lrn2 = makeHyperoptWrapper(lrn)
  task = iris.task
  res = resample(learner = lrn2, task = task, resampling = cv2, extract = getTuneResult)
  expect_class(res$extract[[1]], "TuneResult")
  expect_data_frame(getNestedTuneResultsX(res))
  expect_data_frame(getNestedTuneResultsOptPathDf(res))

  # some random workflow
  # triggers Random Search
  hyper.control = makeHyperControl(
    mlr.control = makeTuneControlRandom(maxit = 10),
    resampling = makeResampleDesc("Holdout"),
    measures = list(auc)
  )
  par.config = generateParConfig(lrn, sonar.task)
  par.set = getParConfigParSet(par.config)
  par.set = filterParams(par.set, ids = "cost")
  par.config = setParConfigParSet(par.config, par.set)
  par.config = setParConfigParVals(par.config, par.vals = list())
  lrn2 = makeHyperoptWrapper(learner = lrn, par.config = par.config, hyper.control = hyper.control)
  res = resample(learner = lrn2, task = sonar.task, resampling = cv2, extract = getTuneResult)
  expect_class(res$extract[[1]], "TuneResult")
  expect_data_frame(getNestedTuneResultsX(res))
  expect_data_frame(getNestedTuneResultsOptPathDf(res))
})