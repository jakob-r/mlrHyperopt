#' @title
#' Generates a hyperparameter tuning control object
#'
#' @description
#' Tries to automatically create a suitable hyperparameter tuning control.
#'
#' @param task [\code{Task}]
#'  Task
#' @param learner [\code{Learner}]
#'  Learner
#' @param par.config [\code{ParConfig}]
#' @return [\code{HyperControl}]
#' @export

generateHyperControl = function(task, learner, par.config) {
  assert_class(task, "Task")
  learner = checkLearner(learner)
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
  if (all(getParamTypes(par.set) %in% c("numeric", "integer", "numericvector", "integervector"))) {
    mbo.control = mlrMBO::makeMBOControl()
    mbo.control = mlrMBO::setMBOControlInfill(mbo.control, crit = mlrMBO::makeMBOInfillCriterionEI())
    mbo.control = mlrMBO::setMBOControlTermination(mbo.control, max.evals = 25)
    mbo.learner = makeLearner("regr.km", predict.type = "se", covtype = "matern5_2", optim.method = "gen", nugget.estim = TRUE, jitter = TRUE)
    mlr.control = makeTuneControlMBO(mbo.control = mbo.control, mbo.keep.result = TRUE, learner = mbo.learner)
  } else if (getParamNr(par.set) == 1) {
    mlr.control = makeTuneControlGrid(resolution = 25)
  } else if (getParamNr(par.set) == 2) {
    mlr.control = makeTuneControlGrid(resolution = 5)
  } else {
    mlr.control = makeTuneControlRandom(maxit = 25)
  }


  # determine a suitable measure
  measures = list(getDefaultMeasure(task), timetrain, timepredict)

  makeHyperControl(
    mlr.control = mlr.control,
    resampling = resampling,
    measures = measures)
}