#' @title
#' Gives a default ParConfig for a Learner
#'
#' @description
#' For a given Learner this method will return a useful default Parameter Set for Tuning.
#'
#' @param learner [\code{Learner}]
#'  An mlr Learner.
#' @param drop.par.vals [\code{logical(1)}]
#'  Should par.vals set in the learner be dropped if they are part of the tuning par.set?
#'  Default is \code{TRUE}.
#' @return [\code{ParConfig}]
#' @import stringi
#' @examples
#' learner = makeLearner("classif.randomForest")
#' par.config = getDefaultParConfig(learner)
#' print(par.config)
#' @export

getDefaultParConfig = function(learner, drop.par.vals = TRUE) {
  assertFlag(drop.par.vals)
  learner = checkLearner(learner)
  type = getLearnerType(learner)
  learner.class = getLearnerClass(learner)
  learner.class.typeless = stri_replace_all_fixed(learner.class, type, "")
  default.par.set.vals = getDefaultParSetValues()
  res = default.par.set.vals[[learner.class]]
  if (is.null(res)) {
    res = default.par.set.vals[[learner.class.typeless]]
  }
  if (is.null(res)) {
    down.res = downloadParConfigs(learner.class = learner.class, custom.query = list(default = TRUE))
    if (length(down.res)==0) {
      down.res = downloadParConfigs(learner.name = getLearnerName(learner), custom.query = list(default = TRUE))
    }
    if (length(down.res)!=0) {
      res = down.res[[1]]
    }
  }
  if (is.null(res)) {
    stopf("For the learner %s no default is available.", getLearnerClass(learner))
  }
  if (drop.par.vals) {
    learner.par.vals = getLearnerParVals(learner)
    learner["par.vals"] = list(NULL) # FIXME when mlr allows to reset hyper pars.
    left.par.val.names = setdiff(names(learner.par.vals), union(names(res$par.vals), getParamIds(res$par.set)))
    setHyperPars(learner, par.vals = learner.par.vals[left.par.val.names])
  }
  makeParConfig(par.set = res$par.set, learner = learner, par.vals = res$par.vals)
}