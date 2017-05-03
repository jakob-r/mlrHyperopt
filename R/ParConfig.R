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
#'  If the learner also has defined hyperparameters they will be combined using \code{link[BBmisc]{insert}} and a warning will be issued.
#' @param learner.name [\code{character(1)}]
#'  Will be overwritten if \code{learner} is passed.
#'  Can be used to associate the Parameter Configuration to a Learner without specifying if it belongs to e.g. classification or regression.
#' @param note [\code{character(1)}]
#'  The note you want to attach to the Parameter Configuration.
#'
#' @return [\code{ParConfig}]
#' @family ParConfig
#' @aliases ParConfig
#' @export

makeParConfig = function(par.set, learner = NULL, par.vals = NULL, learner.name = NULL, note = character(1L)) {
  assert_class(par.set, "ParamSet")
  assert_string(note)

  if (!is.null(learner)) {
    learner = checkLearner(learner)
    checkLearnerParSet(learner = learner, par.set = par.set)
    learner.class = getLearnerClass(learner)
    learner.type = getLearnerType(learner)
    learner.name = getLearnerName(learner)
    learner.par.vals = getLearnerParVals(learner)
    # if par.vals are given, overwrite the ones from the learner itself
    if (!is.null(par.vals) && length(learner.par.vals) > 0L) {
      par.vals = insert(getLearnerParVals(learner), par.vals)
      warning("par.vals of the learner were possibly overwritten by the users par.vals")
    }
  } else {
    learner.class = NULL
    learner.type = NULL
  }

  # check that par.vals do not conflict with par.set
  if (!is.null(par.vals)) {
    assert_list(par.vals, unique = TRUE, names = "named")
    conflict.ids = intersect(names(par.vals), getParamIds(par.set))
    if (length(conflict.ids) > 0) {
      stopf("Following par.vals are set to a specific value and conflict with the tuning par.set: %s", listToShortString(par.vals[conflict.ids]))
    }
  }

  makeS3Obj(
    classes = "ParConfig",
    par.set = par.set,
    par.vals = par.vals,
    associated.learner.class = learner.class,
    associated.learner.type = learner.type,
    associated.learner.name = learner.name,
    note = note
    )
}


## Printer ####

#' @export
print.ParConfig = function(x, ...) {
  catf("Parameter Configuration")
  if (!is.null({par.vals = getParConfigParVals(x)})) {
    catf("  Parameter Values: %s", convertToShortString(par.vals, clip.len = 32))
  }
  if (!is.null({learner.name = getParConfigLearnerName(x)})) {
    catf("  Associated Learner: %s", coalesce(getParConfigLearnerClass(x), learner.name))
  }
  catf("  Parameter Set:")
  print(getParConfigParSet(x))
}

## Getter ####

#' @title Get the ParamSet of the configuration
#' @description Get the \code{ParamSet} of the configuration. If a task is supplied the expressions will be evaluated.
#' @template arg_parconfig
#' @template arg_task
#' @return [\code{ParamSet}].
#' @export
#' @family ParConfig
getParConfigParSet = function(par.config, task = NULL) {
  if (!is.null(task)) {
    evaluateParamExpressions(par.config$par.set, dict = getTaskDictionary(task))
  } else {
    par.config$par.set
  }
}

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

#' @title Get the note
#' @description
#'  Get the note attached to a Parameter Configuration.
#' @template arg_parconfig
#' @return [\code{ParConfig}].
#' @export
#' @family ParConfig
getParConfigNote = function(par.config) {par.config$note}

## Setter ####

#' @title Set the type of the associated learner
#' @description
#'  Can be useful when you want to use Parameter Configuration on a different type of task.
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

#' @title Set a new Parameter Set
#' @description
#'  Set a new Parameter Set
#' @template arg_parconfig
#' @param par.set [\code{ParamSet}]
#'  The Parameter Set.
#' @return [\code{ParConfig}].
#' @export
#' @family ParConfig
setParConfigParSet = function(par.config, par.set) {
  assert_class(par.set, "ParamSet")
  learner.class = getParConfigLearnerClass(par.config)
  if (!is.null(learner.class)) {
    checkLearnerParSet(
      learner = makeLearner(getParConfigLearnerClass(par.config)),
      par.set = par.set)
  }
  par.config$par.set = par.set
  par.config
}

#' @title Set Parameter Values
#' @description
#'  Set Parameter Values
#' @template arg_parconfig
#' @param par.vals [\code{list}]
#'  Specific constant parameter settings.
#' @return [\code{ParConfig}].
#' @export
#' @family ParConfig
setParConfigParVals = function(par.config, par.vals) {
  assert_list(par.vals, names = "named", any.missing = FALSE)
  par.config$par.vals = par.vals
  par.config
}

#' @title Set a note
#' @description
#'  Attach note to the Parameter Configuration
#' @template arg_parconfig
#' @param note [\code{character(1)}]
#'  The note.
#' @return [\code{ParConfig}].
#' @export
#' @family ParConfig
setParConfigNote = function(par.config, note) {
  assert_string(note)
  par.config$note = note
  par.config
}