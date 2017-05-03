context("generateParConfig")

test_that("generateParConfig works for all avaiable defaults", {
  task = iris.task
  def.par.set.vals = getDefaultParSetValues()
  def.names = names(def.par.set.vals)
  ind.untyped = stri_startswith(str = def.names, fixed = ".")
  def.names[ind.untyped] = paste0("classif",def.names[ind.untyped])
  def.names = stri_subset(def.names, regex = "^classif")
  for (lrn.class in def.names) {
    lrn = try(makeLearner(lrn.class), silent = TRUE) # We do not want to load all libraries here
    if (!is.error(lrn)) {
      par.config = generateParConfig(learner = lrn, task = task)
      expect_class(par.config, "ParConfig")
      expect_equal(getParConfigLearnerClass(par.config), lrn.class)
    }
  }
})
