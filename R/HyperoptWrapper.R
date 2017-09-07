#' @title Fuse learner with mlrHyperopt tuning.
#'
#' @description
#' Fuses an mlr base learner with mlrHyperopt tuning.
#' Creates a learner object, which can be used like any other learner object.
#' If the train function is called on it, \code{\link{hyperopt}} is invoked to select an optimal set of hyperparameter values.
#' Finally, a model is fitted on the complete training data with these optimal hyperparameters and returned.
#'
#' @template arg_learner
#' @template arg_parconfig
#' @template arg_hypercontrol
#' @template arg_showinfo
#' @return [\code{\link{Learner}}].
#' @export
#' @family tune
#' @family wrapper
#' @examples
#' \donttest{
#' task = makeClassifTask(data = iris, target = "Species")
#' lrn = makeLearner("classif.svm")
#' lrn = makeHyperoptWrapper(lrn)
#' mod = train(lrn, task)
#' print(getTuneResult(mod))
#' # nested resampling for evaluation
#' # we also extract tuned hyper pars in each iteration
#' r = resample(lrn, task, cv3, extract = getTuneResult)
#' getNestedTuneResultsX(r)
#' }
makeHyperoptWrapper = function(learner, par.config = NULL, hyper.control = NULL, show.info = getMlrOptions()$show.info) {
  learner = checkLearner(learner)
  id = stri_paste(learner$id, "hyperopt", sep = ".")
  # more or less just an empty dummy control
  control = mlr:::makeTuneControl(same.resampling.instance = FALSE, cl = "TuneControlHyperopt")
  x = mlr:::makeOptWrapper(id = id, learner = learner, resampling = NULL, measures = NULL, par.set = NULL, bit.names = character(0L), bits.to.features = function(){}, control = control, show.info = show.info, learner.subclass = c("HyperoptWrapper", "TuneWrapper"), model.subclass = "TuneModel")
  x$hyper.control = hyper.control
  x$par.config = par.config
  return(x)
}

#' @export
trainLearner.HyperoptWrapper = function(.learner, .task, .subset = NULL,  ...) {
  .task = subsetTask(.task, .subset)
  or = hyperopt(task = .task, learner = .learner$next.learner, par.config = .learner$par.config, hyper.control = .learner$hyper.control)
  lrn = or$learner
  or$learner = NULL
  if ("DownsampleWrapper" %in% class(.learner$next.learner) && !is.null(.learner$control$final.dw.perc) && !is.null(getHyperPars(lrn)$dw.perc) && getHyperPars(lrn)$dw.perc < 1) {
    messagef("Train model on %f on data.", .learner$control$final.dw.perc)
    lrn = setHyperPars(lrn, par.vals = list(dw.perc = .learner$control$final.dw.perc))
  }
  m = train(lrn, .task)
  x = mlr:::makeChainModel(next.model = m, cl = "TuneModel")
  x$opt.result = or
  return(x)
}