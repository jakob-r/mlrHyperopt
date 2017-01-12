#' @title
#' Make a Parameter Configuration
#'
#' @description
#' Defines a Parameter Configuration consisting of a \code{ParamSet} that defines the search range for the Hyperparameter Optimization.
#' Additionally you might want to specify some hard Parameters that are not supposed to be optimized but are necessary to be specified.
#' You might want to pass a Learner to associate the \code{ParConfig} to a special Learner.
#'
#' @param par.set [\code{ParamSet}]
#'  The Parameter Set.
#' @param par.vals [\code{list}]
#'  Specific constant parameter settings.
#' @param learner [\code{Learner}]
#'  mlr Learner.
#' @param learner.class [\code{character(1)}]
#' @return [\code{ParConfig}]
#' @family ParConfig
#' @aliases ParConfig
#' @export

makeParConfig = function(par.set, par.vals = NULL, learner = NULL, learner.class = NULL) {
  learner = checkLearner(learner)
  if (is.null(learner.class))
    learner.class = getLearnerClass(learner)
  #FIXME check not pass learner and learner.class!
  makeS3Obj(
    classes = "ParConfig",
    par.set = par.set,
    par.vals = par.vals,
    associated.learner.class = learner.class)
}

#' @title Get the \code{ParamSet} of the configuration
#' @description Get the \code{ParamSet} of the configuration
#' @template arg_parconfig
#' @return [\code{ParamSet}].
#' @export
#' @family ParConfig
getParConfigParSet = function(par.config) par.config$par.set

#' @title Get the constant parameter settings of the configuration
#' @description Get the constant parameter settings of the configuration
#' @template arg_parconfig
#' @return [\code{list}].
#' @export
#' @family ParConfig
getParConfigParVals = function(par.config) par.config$par.vals

#' @title Get the class of the associated learner
#' @description Get the class of the associated learner
#' @template arg_parconfig
#' @return [\code{character(1)}].
#' @export
#' @family ParConfig
getParConfigLearnerClass = function(par.config) par.config$associated.learner.class