#' @title
#' Tune Hyperparameters for a machine learning task
#'
#' @description
#' Tunes the Hyperparameters for a given task and learner.
#' Tries to find the best parameter set to tune for the given learner.
#'
#' @param task [\code{Task}]
#'  mlr Task
#' @param learner [\code{Learner}]
#'  The learner that is subject to the Hyperparameter Tuning.
#'  If no learner is given the learner referenced in the \code{par.config} will be used, if available.
#' @template arg_parconfig
#' @template arg_hypercontrol
#' @param show.info [\code{logical(1)}]\cr
#'   Print verbose output on console?
#'   Default is set via \code{\link{configureMlr}}.
#' @return [\code{\link[mlr]{TuneResult}}]
#' @import mlr
#' @examples
#' hyperopt(iris.task, "classif.svm")
#' @export

hyperopt = function(task, learner = NULL, par.config = NULL, hyper.control = NULL, show.info = getMlrOptions()$show.info) {
  assert_class(task, classes = "Task")

  if (!is.null(learner)) {
    learner = checkLearner(learner)
  } else {
    learner = generateLearner(task = task, par.config = par.config)
  }

  if (!is.null(par.config)) {
    assert_class(par.config, "ParConfig")
  } else {
    par.config = generateParConfig(task = task, learner = learner)
  }

  if (!is.null(hyper.control)) {
    assert_list(hyper.control)
  } else {
    hyper.control = generateHyperControl(task = task, learner = learner, par.config = par.config)
  }

  if (!is.null(getParConfigParVals(par.config))) {
    learner = setHyperPars(learner, par.vals = getParConfigParVals(par.config))
  }

  measures = getHyperControlMeasures(hyper.control)
  # for some measures the learner has to change it's type
  if ("req.prob" %in% measures[[1]]$properties) {
    learner = setPredictType(learner, "prob")
  }

  tune.res = tuneParams(
    learner = learner,
    task = task,
    resampling = getHyperControlResampling(hyper.control),
    measures = measures,
    par.set = getParConfigParSet(par.config),
    control = getHyperControlMlrControl(hyper.control),
    show.info = show.info)
  return(tune.res)
}