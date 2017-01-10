

htune = function(task, learner = NULL, par.set = NULL, ctrl = NULL) {
  assert_class(task, classes = "Task")

  if (!is.null(learner)) {
    assert_class(learner, classes = "Learner")
  } else {
    learner = generateLearner(task = task, par.set = par.set)
  }

  if (!is.null(par.set)) {
    assert_class(par.set, classes = "ParamSet")
  } else {
    par.set = generateParSet(task = task, learner = learner)
  }

  if (!is.null(ctrl)) {
    assert_list(ctrl)
  } else {
    ctrl = generateCtrl(task = task, learner = learner, par.set = par.set)
  }

}