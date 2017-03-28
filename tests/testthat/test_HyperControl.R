context("HyperControl")

test_that("generate HyperControl", {
  tasks = list(classif = iris.task, regr = bh.task)
  learners = makeLearners(c("classif.randomForest", "regr.svm"))

  for (learner in learners) {
    task = tasks[[getLearnerType(learner)]]
    par.config = generateParConfig(learner = learner, task = task)
    hyper.control = generateHyperControl(task = task, learner = learner, par.config = par.config)
    expect_class(hyper.control, "HyperControl")
    expect_list(getHyperControlMeasures(hyper.control), types = "Measure")
    expect_class(getHyperControlMlrControl(hyper.control), class = "TuneControl")
    expect_class(getHyperControlResampling(hyper.control), class = "ResampleDesc")

    # setters work well
    hyper.control = setHyperControlMeasures(hyper.control, measures = timetrain)
    hyper.control = setHyperControlMlrControl(hyper.control, mlr.control = makeTuneControlRandom(maxit = 10))
    hyper.control = setHyperControlResampling(hyper.control, resampling = cv3)
    expect_equal(getHyperControlMeasures(hyper.control), list(timetrain))
    expect_equal(getHyperControlMlrControl(hyper.control), makeTuneControlRandom(maxit = 10))
    expect_equal(getHyperControlResampling(hyper.control), cv3)
  }
})