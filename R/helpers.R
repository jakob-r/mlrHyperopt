# Convert Expressions to call (what we get from quote)
convertExpressionToCall = function(req) {
  if (is.expression(req)) {
    if (length(req) == 1) {
      return(req[[1]])
    } else {
      return(substitute(eval(x), list(x=req)))
    }
  }
  req
}

# Checks if a Param Set fits to a Learer
# @param learner [Learner]
# @param par.set [ParamSet]
# @return TRUE/FALSE and attribute "error" why FALSE
checkLearnerParSet = function(learner, par.set) {
  x = setdiff(names(par.set$pars), names(getLearnerParamSet(learner)$pars))
  if (length(x) > 0L) {
    stopf("The ParConfig contains Params that are not supported by the Learner: %s", collapse(x))
  }
  return(TRUE)
}

# Checks if Learner is valid or creates one
checkLearner = function(learner) {
  if (is.character(learner))
    learner = makeLearner(learner)
  else
    assert_class(learner, classes = "Learner")
  return(learner)
}

# All supported Values for discrete Parameters
getSupportedDiscreteValues = function() {
  c("character", "integer", "numeric", "data.frame", "matrix", "Date", "POSIXt", "factor", "complex", "raw", "logical")
}

# All arguments that can be stored as JSON, extended,
# @param extended [logical]
#   include arguments that need special treatment
getSupportedParamFields = function(extended = FALSE) {
  res = c("id", "type", "default", "upper", "lower", "values", "tunable", "allow.inf", "len")
  if (extended)
    res = c(res, "requires", "trafo")
  res
}

# All arguments that are currently not supported for ex- or import.
getForbiddenParamFields = function() {
  c("special.vals")
}

# Checks if a ParamSet and par.vals make sense together
# @param par.set - The Parameter Set
# @param par.vals - the parameter settings that complement the par.set for a given learner
# @param req.defaults - are defaults required in the param set
# @param dictionary - necessary to evaluate the bounds
checkParamSetAndParVals = function(par.set, par.vals = list(), req.defaults = TRUE, dictionary = NULL) {

  if (is.null(dictionary)) {
    dummy.task = makeClassifTask(id = "dummy", data = data.frame(a = 1:2, y = factor(1:2)), target = "y")
    dictionary = getTaskDictionary(task = dummy.task)
  }

  # all params with box constraints?
  if (!hasFiniteBoxConstraints(par.set, dict = dictionary)) {
    stop("The ParamSet has infitite box constraints unsuitable for tuning!")
  }

  # all params have defaults?
  par.set.ids = getParamIds(par.set)
  par.set.default.ids = names(getDefaults(par.set, dict = dictionary))
  no.defaults = setdiff(par.set.ids, par.set.default.ids)
  if (req.defaults && length(no.defaults) > 0) {
    stopf("The parameter(s) %s do(es) not have default values!", collapse(no.defaults))
  }

  # par.vals dont conflict with par.set?
  conflicting.par.vals = intersect(names(par.vals), par.set.ids)
  if (length(conflicting.par.vals) > 0) {
    stopf("The par.vals %s are conflicting with the parameters defined in the par.set!", collapse(conflicting.par.vals))
  }

  invisible(TRUE)
}

getURL = function() {
  #"http://mlrhyperopt.jakob-r.de/parconfigs"
  "http://62.113.241.202:3000/parconfigs"
}