## Convert ParamSet To JSON

#' @import jsonlite
#' @import stringi

# converts a ParamSet to JSON
# @param par.set [ParamSet]
# @return JSON
parSetToJSON = function(par.set) {
  pars = par.set$pars[order(names(par.set$pars))] # order parameters alphabetically for unified storage and comparable hashes
  res.list = lapply(pars, paramToJSONList)
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
  # deparse all requirements
  if (!is.null(param$requires)) {
    res.list$requires = deparse(param$requires)
  }
  # deparse all expressions
  res.list = lapply(res.list, function(x) {
    if (is.expression(x)) {
      deparse(x)
    } else {
      x
    }
  })
  # handle values for discrete param, currently not supported
  if (param$type == "discrete") {
    res.list$values = checkDiscreteJSON(param$values, param$id)
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
  toJSON(par.vals, force = TRUE)
}


## Convert JSON to ParamSet

# converts JSON to a ParamSet
# @param json [char]
# @return ParamSet
JSONtoParSet = function(json) {
  ps.list = fromJSON(json)
  param.list.and.keys = lapply(ps.list, JSONListToParam)
  param.list = extractSubList(param.list.and.keys, "param", simplify = FALSE)
  param.keys = unique(extractSubList(param.list.and.keys, "keys", simplify = TRUE))
  par.set = makeParamSet(params = param.list, keys = param.keys)
  par.set
}

# converts a list to a Param
# @param par.list [list()]
# @return Param
JSONListToParam = function(par.list) {
  type = par.list$type
  par.list$type = NULL
  # convert Requirement expression
  if (!is.null(par.list$requires)) {
    par.list$requires = convertExpressionToCall(parse(text = par.list$requires))
  }
  # parse trafo
  if (!is.null(par.list$trafo)) {
    par.list$trafo = eval(parse(text = par.list$trafo))
  }
  # parse expressions in parameter values and boundaries (actually everywhere)
  keys = NULL
  for (i in names(par.list)) {
    x = par.list[[i]]
    if (is.character(x) && stri_startswith_fixed(x, "expression(")) {
      par.list[[i]] = eval(parse(text = x))
      #fixme: dirty way to match all variable names but not the expression
      keys = c(keys, all.vars(par.list[[i]]))
    }
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
  list(param = param, keys = unique(keys))
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
