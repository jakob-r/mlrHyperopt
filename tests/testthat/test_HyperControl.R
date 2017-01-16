context("HyperControl")

test_that("generate HyperControl", {
  tasks = list(classif = iris.task, regr = bh.task)
  learners = makeLearners(c("classif.randomForest", "regr.svm"))

  for (learner in learners) {
    task = tasks[[getLearnerType(learner)]]
    par.config = generateParConfig(task = task, learner = learner)
    hyper.control = generateHyperControl(task = task, learner = learner, par.config = par.config)
    expect_class(hyper.control, "HyperControl")
    expect_list(getHyperControlMeasures(hyper.control), types = "Measure")
    expect_class(getHyperControlMlrControl(hyper.control), class = "TuneControl")
    expect_class(getHyperControlResampling(hyper.control), class = "ResampleDesc")
  }
})