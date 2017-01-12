#' @title
#' Gives a default ParConfig for a Learner
#'
#' @description
#' For a given Learner this method will return a usefull default Parameter Set for Tuning.
#'
#' @param learner [\code{Learner}]
#'  An mlr Learner.
#' @return [\code{ParConfig}]
#' @import stringi
#' @export

getDefaultParConfig = function(learner) {
  learner = checkLearner(learner)
  type = getLearnerType(learner)
  learner.class = getLearnerClass(learner)
  learner.class.typeless = stri_replace_all_fixed(learner.class, type, "")
  default.par.configs = getDefaultParConfigList()
  res = default.par.configs[[learner.class]]
  if (is.null(res)) {
    res = default.par.configs[[learner.class.typeless]]
  }
}