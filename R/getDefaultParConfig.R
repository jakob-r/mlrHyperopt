#' @title
#' Gives a default ParConfig for a Learner
#'
#' @description
#' For a given Learner this method will return a useful default Parameter Set for Tuning.
#'
#' @param learner [\code{Learner}]
#'  An mlr Learner.
#' @return [\code{ParConfig}]
#' @import stringi
#' @examples
#' learner = makeLearner("classif.randomForest")
#' par.config = getDefaultParConfig(learner)
#' print(par.config)
#' @export

getDefaultParConfig = function(learner) {
  learner = checkLearner(learner)
  type = getLearnerType(learner)
  learner.class = getLearnerClass(learner)
  learner.class.typeless = stri_replace_all_fixed(learner.class, type, "")
  default.par.set.vals = getDefaultParSetValues()
  res = BBmisc::coalesce(default.par.set.vals[[learner.class]], default.par.set.vals[[learner.class.typeless]])
  if (!is.null(res)) {
    par.set = eval(res$par.set.call)
    par.vals = eval(res$par.vals.call)
    res = makeParConfig(par.set = par.set, learner = learner, par.vals =par.vals)
  } else {
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
  # small feasibility check (why here?)
  checkParamSetAndParVals(par.set = getParConfigParSet(res), par.vals = getParConfigParVals(res))
  res
}