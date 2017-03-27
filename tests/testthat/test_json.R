context("json")

test_that("converting to JSON and back", {

  par.sets = list(
    svm.sample = makeParamSet(
      makeNumericParam(id = "cost",  upper = 15, lower = 0),
      makeDiscreteParam(id = "kernel", values = c("polynomial", "radial")),
      makeIntegerParam(id = "degree", default = 3L, lower = 1L, requires = quote(kernel=="polynomial")),
      makeNumericParam(id = "gamma", lower = -5, upper = 5, trafo = function(x) 2^x)),
    mixed.ParSet = makeParamSet(
      makeNumericParam(id = "x1", lower = expression(sqrt(n/2)^2), upper = 1),
      makeNumericParam(id = "x2", lower = 0, upper = Inf),
      makeNumericParam(id = "x3", allow.inf = TRUE, default = Inf),
      makeNumericVectorParam(id = "x4", lower = -1L, upper = 1, len = 2, default = expression(floor(p/2))),
      makeNumericVectorParam(id = "x5", lower = 0, upper = Inf, len = 3),
      makeIntegerParam(id = "x6", lower = -1L, upper = 1),
      makeIntegerVectorParam(id = "x7", lower = -10L, upper = 10, len = 2),
      makeDiscreteParam(id = "x8", values = list(a = "char", b = 2L, c = 2.2, "e")),
      makeDiscreteVectorParam(id = "x9", len = 2, values = list(a = "char", b = 2L, c = 2.2, "e")),
      makeLogicalParam(id = "x10"),
      makeLogicalVectorParam(id = "x11", len = 2),
      makeCharacterParam(id = "x12"),
      makeCharacterVectorParam(id = "x13", len = 2),
      keys = c("n", "p")
    ))

  json = parSetToJSON(par.sets$svm.sample)
  par.set2 = JSONtoParSet(json)
  par.set2$pars = par.set2$pars[names(par.sets$svm.sample$pars)]
  expect_equal(par.sets$svm.sample, par.set2)

  json = parSetToJSON(par.sets$mixed.ParSet)
  par.set3 = JSONtoParSet(json)
  par.set3$pars = par.set3$pars[names(par.sets$mixed.ParSet$pars)]
  expect_equal(par.sets$mixed.ParSet, par.set3)

  f = function(x) x
  unsupported.par.sets = list(
    special.vals = makeParamSet(makeNumericVectorParam(id = "x5", lower = 0, upper = Inf, len = 3, special.vals = list(-Inf))),
    discrete.unsupported = makeParamSet(makeDiscreteParam(id = "x8", values = list(a = "char", b = 2L, c = 2.2, d = f, "e")))
  )
  expect_error(parSetToJSON(unsupported.par.sets$special.vals), "currently not supported: special.vals")
  expect_error(parSetToJSON(unsupported.par.sets$discrete.unsupported), "contain currently unsupported types: d")
})