#' @title
#' Tune Hyperparameters for a machine learning task
#'
#' @description
#' Tunes the Hyperparameters for a given task and learner.
#' Tries to find the best parameter set to tune for the given learner.
#'
#' @param task [\code{Task}]
#'  mlr Task
#' @param par.set [\code{ParamSet}]
#'  ParamHelpers Parameter Set
#' @param par.set.id [\code{character}]
#'  Unique identifier for a Parameter Set.
#'  This will be downloaded from the mlrHyperopt servers.
#' @param control [\code{list}]
#'  This control object defines how the Hyperparameter Optimization should be conducted.
#' @export

hyperopt = function(task, learner = NULL, par.set = NULL, par.set.id = NULL, control = NULL) {
  assert_class(task, classes = "Task")

  if (!is.null(par.set) && !is.null(par.set.id)) {
    stopf("You can either specify a par.set or a par.set.id, not both!")
  } else if (!is.null(par.set)) {
    assert_class(par.set, classes = "ParamSet")
  } else if (!is.null(par.set.id)) {
    par.set = downloadParSet(ids = par.set.id)
  } else {
    par.set = generateParSet(task = task, learner = learner)
  }

  if (!is.null(learner)) {
    assert_class(learner, classes = "Learner")
  } else {
    learner = generateLearner(task = task, par.set = par.set)
  }

  if (!is.null(ctrl)) {
    assert_list(ctrl)
  } else {
    ctrl = generateCtrl(task = task, learner = learner, par.set = par.set)
  }

}