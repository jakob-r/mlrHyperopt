#' @title
#' Generates a hyperparameter tuning control object
#'
#' @description
#' Tries to automatically create a suitable hyperparameter tuning control.
#'
#' @template arg_task
#' @template arg_learner
#' @template arg_parconfig
#' @param budget.evals [\code{integer}]
#'  How many function evaluations do you want to allow? Default is 25.
#' @return [\code{HyperControl}]
#' @examples
#' par.config = getDefaultParConfig("regr.randomForest")
#' hyper.control = generateHyperControl(bh.task, par.config)
#' # get what is inside
#' getHyperControlMeasures(hyper.control)
#' getHyperControlMlrControl(hyper.control)
#' getHyperControlResampling(hyper.control)
#' # change what is inside
#' hyper.control = setHyperControlMeasures(hyper.control, measures = medse)
#' hyper.control = setHyperControlMlrControl(
#'   hyper.control,
#'   mlr.control = makeTuneControlRandom(maxit = 10))
#' hyper.control = setHyperControlResampling(hyper.control, resampling = cv3)
#' hyperopt(task = bh.task, par.config = par.config, hyper.control = hyper.control)
#' @export

generateHyperControl = function(task, par.config = NULL, learner = NULL, budget.evals = 25) {
  assert_class(task, "Task")

  if (!is.null(par.config) && !is.null(learner)) {
    stopf("If you have a ParConfig it is not necessary to pass a learner.")
  }

  if (is.null(par.config)) {
    par.config = generateParConfig(learner = learner, task = task)
  }

  assert_class(par.config, "ParConfig")

  # very superficial way to determine resampling based on task size
  task.n = getTaskSize(task)
  if (task.n < 10) {
    resampling = makeResampleDesc("LOO")
  } else if (task.n < 100) {
    resampling = makeResampleDesc("RepCV")
  } else if (task.n < 500) {
    resampling = makeResampleDesc("CV")
  } else if (task.n < 1000) {
    resampling = makeResampleDesc("Bootstrap", iters = 5)
  } else {
    resampling = makeResampleDesc("Holdout")
  }

  # determine a suitable tuning method
  par.set = getParConfigParSet(par.config)
  if (getParamNr(par.set) == 1) {
    mlr.control = makeTuneControlGrid(resolution = budget.evals)
  } else if (
    all(getParamTypes(par.set) %in% c("numeric", "integer", "numericvector", "integervector")) &&
    getParamNr(par.set) * 4 < budget.evals * 0.75) {
    imputeWorst = function(x, y, opt.path, c = 2) c * max(getOptPathY(opt.path), na.rm = TRUE)
    mbo.control = mlrMBO::makeMBOControl(final.method = "best.predicted", impute.y.fun = imputeWorst)
    mbo.control = mlrMBO::setMBOControlInfill(mbo.control, crit = mlrMBO::crit.eqi)
    mbo.control = mlrMBO::setMBOControlTermination(mbo.control, max.evals = budget.evals)
    mlr.control = makeTuneControlMBO(mbo.control = mbo.control, mbo.keep.result = TRUE)
  } else if (getParamNr(par.set) == 2) {
    mlr.control = makeTuneControlGrid(resolution = floor(sqrt(budget.evals)))
  } else {
    mlr.control = makeTuneControlRandom(maxit = budget.evals)
  }


  # determine a suitable measure
  measures = list(getDefaultMeasure(task), timetrain, timepredict)

  makeHyperControl(
    mlr.control = mlr.control,
    resampling = resampling,
    measures = measures,
    par.config = par.config)
}