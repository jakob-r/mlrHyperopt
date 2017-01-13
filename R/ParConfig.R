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
#' @param learner [\code{Learner}|\code{character(1)}]
#'  mlr Learner or string that identifies the Learner.
#' @param par.vals [\code{list}]
#'  Specific constant parameter settings.
#' @param learner.name [\code{character(1)}]
#'  Will be overwritten if \code{learner} is passed.
#'  Can be used to associate the Parameter Configuration to a Learner without specifing if it belongs to e.g. classification or regression.
#' @return [\code{ParConfig}]
#' @family ParConfig
#' @aliases ParConfig
#' @import stringi
#' @export

makeParConfig = function(par.set, learner = NULL, par.vals = NULL, learner.name = NULL) {

  if (!is.null(learner)) {
    learner = checkLearner(learner)
    checkLearnerParSet(learner = learner, par.set = par.set)
    learner.class = getLearnerClass(learner)
    learner.type = getLearnerType(learner)
    learner.name = getLearnerName(learner)
  } else {
    learner.class = NULL
    learner.type = NULL
  }
  #FIXME check not pass learner and learner.class!
  makeS3Obj(
    classes = "ParConfig",
    par.set = par.set,
    par.vals = par.vals,
    associated.learner.class = learner.class,
    associated.learner.type = learner.type,
    associated.learner.name = learner.name
    )
}

## Getter

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
#' @description
#'  Get the class of the associated learner
#'  Can be \code{NULL} when no concrete learner is specified
#' @template arg_parconfig
#' @return [\code{character(1)}|NULL].
#' @export
#' @family ParConfig
getParConfigLearnerClass = function(par.config) par.config$associated.learner.class

#' @title Get the type of the associated learner
#' @description
#'  Get the type of the associated learner.
#'  Can be \code{NULL} when no type is specified
#' @template arg_parconfig
#' @return [\code{character(1)}|NULL].
#' @export
#' @family ParConfig
getParConfigLearnerType = function(par.config) par.config$associated.learner.type

#' @title Get the name of the associated learner
#' @description
#'  Get the name of the associated learner.
#'  Can be \code{NULL} when no learner is specified
#' @template arg_parconfig
#' @return [\code{character(1)}|NULL].
#' @export
#' @family ParConfig
getParConfigLearnerName = function(par.config) par.config$associated.learner.name

## Setter

#' @title Set the type of the associated learner
#' @description
#'  Can be usefull when you want to use Parameter Configuration on a different type of task.
#' @template arg_parconfig
#' @param type [\code{character(1)}]
#' @return [\code{ParConfig}].
#' @export
#' @family ParConfig
setParConfigLearnerType = function(par.config, type) {
  assert_string(type)
  # just change the type if it is different
  old.type = getParConfigLearnerType(par.config)
  if (is.null(old.type) || old.type != type) {
    par.config$associated.learner.type = type
    # change the learner class if we can
    if (!is.null(getParConfigLearnerName(par.config))) {
      learner = makeLearner(paste0(type,".",getParConfigLearnerName(par.config)))
      checkLearnerParSet(learner, getParConfigParSet(par.config))
      par.config$associated.learner.class = getLearnerClass(learner)
      par.config$associated.learner.name = getLearnerName(learner)
    }
  }
  par.config
}

#' @title Set an associated Learner
#' @description
#'  Associate the Param Configuration with a specific learner
#' @template arg_parconfig
#' @param learner [\code{Learner}]
#' @return [\code{ParConfig}].
#' @export
#' @family ParConfig
setParConfigLearner = function(par.config, learner) {
  learner = checkLearner(learner)
  checkLearnerParSet(learner, getParConfigParSet(par.config))
  par.config$associated.learner.class = getLearnerClass(learner)
  par.config$associated.learner.name = getLearnerName(learner)
  par.config$associated.learner.type = getLearnerType(learner)
  par.config
}