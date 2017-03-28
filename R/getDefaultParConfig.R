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
  res = default.par.set.vals[[learner.class]]
  if (is.null(res)) {
    res = default.par.set.vals[[learner.class.typeless]]
  }
  if (is.null(res)) {
    stopf("For the learner %s no default is available.", getLearnerClass(learner))
  }
  makeParConfig(par.set = res$par.set, learner = learner, par.vals = res$par.vals)
}