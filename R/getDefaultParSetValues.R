getDefaultParSetValues = function() {
  par.sets = list(
    # random forest
    .randomForest = makeParamSet(
      makeIntegerParam("ntree", lower = 0, upper = 7, trafo = function(x) 2^x * 10),
      makeIntegerParam("nodesize", lower = 1, upper = 10)
    ),
    .ranger = makeParamSet(
      makeIntegerParam("num.trees", lower = 0, upper = 7, trafo = function(x) 2^x * 10 ),
      makeIntegerParam("min.node.size", lower = 1, upper = 10)
    ),
    ## svm
    .svm = makeParamSet(
      makeNumericParam(id = "cost",  upper = 15, lower = -15, trafo = function(x) 2^x),
      makeNumericParam(id = "gamma",  upper = 15, lower = -15, trafo = function(x) 2^x)
    ),
    .ksvm = makeParamSet(
      makeNumericParam(id = "C",  upper = 15, lower = -15, trafo = function(x) 2^x),
      makeNumericParam(id = "sigma",  upper = 15, lower = -15, trafo = function(x) 2^x)
    ),
    ## bossting
    .glmboost = makeParamSet(
      makeIntegerParam("mstop", lower = 0, upper = 9, trafo = function(x) 2^x),
      makeNumericParam("nu", lower = 0, upper = 1)
    ),
    .ada = makeParamSet(
      makeIntegerParam("iter", lower = 0, upper = 9, trafo = function(x) 2^x),
      makeIntegerParam("nu", lower = -5, upper = 5, trafo = function(x) 2^x)
    )
  )
  mkps = function(par.set, par.vals = list()) {
    list(par.set = par.set, par.vals = par.vals)
  }
  lapply(par.sets, mkps)
}
