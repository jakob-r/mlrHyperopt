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
# @param par.config [ParConfig]
# @return TRUE/FALSE and attribute "error" why FALSE
checkLearnerParConfig = function(learner, par.config) {
  if (!is.null(par.config$associated.learner.class) && par.config$associated.learner.class != getLearnerClass(learner)) {
    error = sprintf("The ParConfig is referenced to the learner %s but the learner is %s", par.config$associated.learner.class, getLearnerClass(learner))
    return(setAttribute(FALSE, "error", error))
  }
  x = setdiff(names(par.config$pars), names(getParConfig(learner)$pars))
  if (length(x) > 0L) {
    error = sprintf("The ParConfig contains Params that are not supported by the Learner: %s", collapse(x))
    return(setAttribute(FALSE, "error", error))
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

getLearnerClass = function(learner) {
  class(learner)[[1]]
}

# All allowed Parameter Types
getSupportedParamTypes = function() {
  c("numeric", "numericvector", "integer", "integervector", "logical", "logicalvector", "discrete", "discretevector", "character", "charactervector")
}

# All supported Values for discrete Parameters
getSupportedDiscreteValues = function() {
  c("character", "integer", "numeric", "data.frame", "matrix", "Date", "POSIXt", "factor", "complex", "raw")
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