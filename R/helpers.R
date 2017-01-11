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
checkLearnerParamSet = function(learner, par.set) {
  if (!is.null(par.set$ref.learner.id) && par.set$ref.learner.id != getLearnerId(learner)) {
    error = sprintf("The ParamSet is referenced to the learner %s but the learner is %s", par.set$ref.learner.id, getLearnerId(learner))
    return(setAttribute(FALSE, "error", error))
  }
  x = setdiff(names(par.set$pars), names(getParamSet(learner)$pars))
  if (length(x) > 0L) {
    error = sprintf("The ParamSet contains Params that are not supported by the Learner: %s", collapse(x))
    return(setAttribute(FALSE, "error", error))
  }
  return(TRUE)
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