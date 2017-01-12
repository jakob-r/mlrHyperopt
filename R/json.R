## Convert ParamSet To JSON

#' @import jsonlite

# converts a ParamSet to JSON
# @param par.set [ParamSet]
# @return JSON
parSetToJSON = function(par.set) {
  res.list = lapply(par.set$pars, paramToJSONList)
  toJSON(res.list)
}

# converts a Param to a List
# @param param [list]
# @return list
paramToJSONList = function(param) {
  res.list = Filter(function(x) !is.null(x) && length(x) > 0, param) #remove empty list entries
  if (any(names(res.list) %in% getForbiddenParamFields())) {
    stopf("The Param fields for Param %s are currently not supported: %s", param$id, intersect(names(res.list), getForbiddenParamFields()))
  }
  res.list = res.list[names(res.list) %in% getSupportedParamFields()]
  # handle requires
  if (!is.null(param$requires)) {
    res.list$requires = deparse(param$requires)
  }
  # handle values for discrete param, currently not supported
  if (param$type == "discrete") {
    par.vals = checkDiscreteJSON(param$values, param$id)
  }
  # handle trafo
  if (!is.null(param$trafo)) {
    res.list$trafo = deparse(param$trafo)
  }
  res.list
}

# converts json to a List of parameter values
# @param par.vals [\code{list}]
# @return JSON
parValsToJSON = function(par.vals) {
  par.vals = checkDiscreteJSON(par.vals, "Values")
  toJSON(par.vals)
}


## Convert JSON to ParamSet

# converts JSON to a ParamSet
# @param json [char]
# @return ParamSet
JSONtoParSet = function(json) {
  ps.list = fromJSON(json)
  param.list = lapply(ps.list, JSONListToParam)
  par.set = do.call(makeParamSet, param.list)
  par.set
}

# converts a list to a Param
# @param par.list [list()]
# @return Param
JSONListToParam = function(par.list) {
  type = par.list$type
  par.list$type = NULL
  if (!is.null(par.list$requires)) {
    par.list$requires = convertExpressionToCall(parse(text = par.list$requires))
  }
  if (!is.null(par.list$trafo)) {
    par.list$trafo = eval(parse(text = par.list$trafo))
  }
  paramFunction = switch(type,
                         numeric = makeNumericParam,
                         numericvector = makeNumericVectorParam,
                         integer = makeIntegerParam,
                         integervector = makeIntegerVectorParam,
                         logical = makeLogicalParam,
                         logicalvector = makeLogicalVectorParam,
                         discrete = makeDiscreteParam,
                         discretevector = makeDiscreteVectorParam,
                         character = makeCharacterParam,
                         charactervector = makeCharacterVectorParam)
  supported.args = formalArgs(paramFunction)
  param = do.call(paramFunction, par.list[names(par.list) %in% supported.args], quote = TRUE)
  param
}

# converts json to a List of parameter values
# @param json [\code{character}]
# @return List
JSONtoParVals = function(json) {
  fromJSON(json)
}


## json helpers

checkDiscreteJSON = function(par.vals, param.id = character()) {
  value.classes = sapply(par.vals, class)
  if (any(value.classes %nin% getSupportedDiscreteValues())) {
    stopf("The values for Param %s contain currently unsupported types: %s", param.id, names(value.classes[value.classes %nin% getSupportedDiscreteValues()]))
  }
  par.vals
}
