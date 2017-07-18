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
#'  How many train-test iterations do you want to allow?
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
#' @import lhs
#' @export

generateHyperControl = function(task, par.config = NULL, learner = NULL, budget.evals = 250) {
  assertClass(task, "Task")

  if (!is.null(par.config) && !is.null(learner)) {
    stopf("If you have a ParConfig it is not necessary to pass a learner.")
  }

  if (is.null(par.config)) {
    par.config = generateParConfig(learner = learner, task = task)
  }

  assertClass(par.config, "ParConfig")

  # very superficial way to determine resampling based on task size
  task.n = getTaskSize(task)
  iter.budget = c(
    LOO = budget.evals / task.n,
    Rep100CV = budget.evals / (100*10),
    Rep10CV =  budget.evals / (10*10),
    Bootstrap30 = budget.evals / 30,
    CV10 = budget.evals / 10,
    CV5 = budget.evals / 5,
    CV3 = budget.evals / 3,
    Bootstrap2 = budget.evals / 2,
    holdout = budget.evals
  )
  resamplings = list(
    LOO = makeResampleDesc("LOO"),
    Rep100CV = makeResampleDesc("RepCV", folds = 10, reps = 100),
    Rep10CV =  makeResampleDesc("RepCV", folds = 10, reps = 10),
    Bootstrap30 = makeResampleDesc("Bootstrap", iters = 30),
    CV10 = makeResampleDesc("CV", iters = 10),
    CV5 = makeResampleDesc("CV", iters = 5),
    CV3 = makeResampleDesc("CV", iters = 3),
    Bootstrap2 = makeResampleDesc("Bootstrap", iters = 2),
    holdout = makeResampleDesc("Holdout")
  )

  par.set = getParConfigParSet(par.config)
  par.set = evaluateParamExpressions(par.set, dict = getTaskDictionary(task = task))

  # determine number of discrete levels
  factors = vnapply(par.set$pars, function(par) {
    if (is.null(par$values)) 10 * par$len else length(par$values) * par$len
  })

  # determine a suitable tuning method
  if (getParamNr(par.set) == 1) {
    det.resampling = determineResampling(desired.evals = 25, iter.budget, resamplings)
    mlr.control = makeTuneControlGrid(resolution = det.resampling$iters)
  } else if (
    all(getParamTypes(par.set) %in% c("numeric", "integer", "numericvector", "integervector")) &&
    {
      det.resampling = determineResampling(desired.evals = 20 + (getParamNr(par.set, devectorize = TRUE)-1) * 5, iter.budget, resamplings, preferability = 0.4)
      desired.init.des = getParamNr(par.set) * 4
      det.resampling$iters > 2 * desired.init.des
    }
    ) {
    imputeWorst = function(x, y, opt.path, c = 2) c * max(getOptPathY(opt.path), na.rm = TRUE)
    mbo.control = mlrMBO::makeMBOControl(final.method = "best.predicted", impute.y.fun = imputeWorst)
    mbo.control = mlrMBO::setMBOControlInfill(mbo.control, crit = mlrMBO::crit.eqi)
    mbo.control = mlrMBO::setMBOControlTermination(mbo.control, max.evals = det.resampling$iters)
    mbo.design = generateDesign(n = desired.init.des, par.set = par.set, fun = lhs::maximinLHS)
    mlr.control = makeTuneControlMBO(mbo.control = mbo.control, mbo.keep.result = TRUE, mbo.design = mbo.design)
  } else if (getParamNr(par.set) == 2) {
    det.resampling = determineResampling(desired.evals = prod(factors), iter.budget, resamplings, round.fun = identity)
    mlr.control = makeTuneControlGrid(resolution = floor(sqrt(det.resampling$iters)))
  } else {
    det.resampling = determineResampling(desired.evals = prod(factors), iter.budget, resamplings)
    mlr.control = makeTuneControlRandom(maxit = det.resampling$iters)
  }
  resampling = det.resampling$resampling

  # determine a suitable measure
  measures = list(getDefaultMeasure(task))

  makeHyperControl(
    mlr.control = mlr.control,
    resampling = resampling,
    measures = measures,
    par.config = par.config)
}

# smaller values then preferability = 0.55 lead to higher likeliness of resamplings that need a lower budget for themselfes
# accordingly more iterations will be available for tuning.
# choose a low value for preferability if you prefere more noisy resampling results in favour for more tuning iterations.
determineResampling = function(desired.evals, iter.budget, resamplings, preferability = 0.5, round.fun = floor) {
  stopifnot(all(names(iter.budget) == names(resamplings)))
  assertNumber(desired.evals)
  assertNumber(preferability)
  likeliness = function(x) {
    log(x) - preferability * x^2
  }
  chose.resampling = which.max(likeliness(iter.budget / desired.evals))
  list(iters = round.fun(iter.budget[chose.resampling]), resampling = resamplings[[chose.resampling]])
}
