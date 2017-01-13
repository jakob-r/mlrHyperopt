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

getLearnerClass = function(learner) {
  class(learner)[[1]]
}

getLearnerName = function(learner) {
  learner.class = getLearnerClass(learner)
  learner.type = getLearnerType(learner)
  stri_replace_first_fixed(learner.class, paste0(learner.type,"."), "")
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