getDefaultParSetValues = function() {
  par.sets = list(
    ## following are set nearly accroding to caret random search spaces
    # adabag boosting: AdaBoost.M1
    .boosting = makeParamSet(
      makeDiscreteParam(id = "coeflearn", default = "Breiman", values = c("Breiman", "Freund", "Zhu")),
      makeNumericParam(id = "mfinal", default = log2(100L/10), lower = log2(1/10), upper = log2(1000/10), trafo = function(x) floor(2^x * 10)),
      makeIntegerParam(id = "maxdepth", default = 30L, lower = 1L, upper = 30L)
    ),
    # C50: C5.0
    .C50 = makeParamSet(
      makeIntegerParam(id = "trials", lower = 1L, default = 1L, upper = 100L),
      makeLogicalParam(id = "winnow", default = FALSE)
    ),
    # Regularized Random Forest (more like RFFglobal in caret)
    .RRF = makeParamSet(
      makeIntegerParam(id = "mtry", lower = 1L, default = expression(floor(p/3))),
      makeNumericParam(id = "coefReg", default = 0.8, lower = 0, upper = 1),
      keys = "p"
    ),
    # ada
    .ada = makeParamSet(
      makeNumericParam(id = "iter", default = log2(50/10), lower = log2(1/10), upper = log2(1000/10), trafo = function(x) floor(2^x * 10)),
      makeIntegerParam(id = "maxdepth", default = 10L, lower = 1L, upper = 10L), # mlr recommends 30 as default
      makeNumericParam(id = "nu", default = 0.1, lower = 0.001, upper = 0.5)
    ),
    # blackboost
    .blackboost = makeParamSet(
      makeIntegerParam(id = "maxdepth", default = 2L, lower = 1L, upper = 10L),
      makeNumericParam(id = "mstop", default = log2(100/10), lower = log2(1/10), upper = log2(1000/10), trafo = function(x) floor(2^x * 10))
    ),
    # extraTrees
    classif.extraTrees = makeParamSet(
      makeIntegerParam(id = "mtry", lower = 1L, upper = expression(p), default = expression(floor(sqrt(p)))),
      makeIntegerParam(id = "numRandomCuts", default = 1L, lower = 1L, upper = 25L),
      keys = "p"
    ),
    regr.extraTrees = makeParamSet(
      makeIntegerParam(id = "mtry", lower = 1L, upper = expression(p), default = expression(max(floor(p/3), 1))),
      makeIntegerParam(id = "numRandomCuts", default = 1L, lower = 1L, upper = 25L),
      keys = "p"
    ),
    # For ksvm caret uses kernlab::sigest() +- 0.75
    .ksvm = makeParamSet(
      makeNumericParam(id = "C",  upper = 10, lower = -5, trafo = function(x) 2^x, default = log2(1)),
      makeNumericParam(id = "sigma",  upper = 15, lower = -15, trafo = function(x) 2^x)
    ),
    # glmboost
    .glmboost = makeParamSet(
      makeNumericParam(id = "mstop", default = log2(100/10), lower = log2(1/10), upper = log2(1000/10), trafo = function(x) floor(2^x * 10)),
      makeNumericParam("nu", lower = 0, upper = 1)
    ),
    ## not compared to caret
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
    )
  )
  mkps = function(par.set, par.vals = list()) {
    list(par.set = par.set, par.vals = par.vals)
  }
  lapply(par.sets, mkps)
}
